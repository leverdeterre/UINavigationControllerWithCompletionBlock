//
//  UINavigationController+CompletionBlock.m
//  UINavigationControllerWithBlocks
//
//  Created by Jerome Morissard on 4/26/14.
//  Copyright (c) 2014 Jerome Morissard. All rights reserved.
//

#import "UINavigationController+CompletionBlock.h"
#import "JRSwizzle.h"
#import <objc/runtime.h>

/**
 *  UINavigationControllerState is an internal state of the NavigationController
 */
typedef NS_ENUM(NSUInteger, UINavigationControllerState) {
    /**
     *  Default state, nothing is in progress
     */
    UINavigationControllerStateNeutral,
    /**
     *  Push in progress
     */
    UINavigationControllerStatePushInProgress,
    /**
     *  Pop in progress
     */
    UINavigationControllerStatePopInProgress,
    /**
     *  Pop to root in progress
     */
    UINavigationControllerStatePopToRootInProgress
};

@implementation UINavigationController (CompletionBlock)

#pragma mark - Swizzling methods

+ (void)activateSwizzling
{
    [self activateSwizzlingWithOptions:(UINavigationControllerSwizzlingOptionDelegate |
                                        UINavigationControllerSwizzlingOptionOriginalPush |
                                        UINavigationControllerSwizzlingOptionOriginalPop)];
}

+ (void)activateSwizzlingWithOptions:(UINavigationControllerSwizzlingOption)options
{
    UINavigationControllerSwizzlingOption previousOption = [self swizzlingOption];
    
    //Inactivate previous options
    if (previousOption & UINavigationControllerSwizzlingOptionDelegate) {
        [UINavigationController jr_swizzleMethod:@selector(setDelegate:)
                                      withMethod:@selector(_swizzleSetDelegate:) error:nil];
    }
    
    if (previousOption & UINavigationControllerSwizzlingOptionOriginalPush) {
        [UINavigationController jr_swizzleMethod:@selector(pushViewController:animated:)
                                      withMethod:@selector(_swizzlePushViewController:animated:) error:nil];
    }
    
    if (previousOption & UINavigationControllerSwizzlingOptionOriginalPop) {
        [UINavigationController jr_swizzleMethod:@selector(popViewControllerAnimated:)
                                      withMethod:@selector(_swizzlePopViewControllerAnimated:) error:nil];
    }
    
    [self setSwizzlingOption:options];
    
    //Activate new options
    if (options & UINavigationControllerSwizzlingOptionDelegate) {
        [UINavigationController jr_swizzleMethod:@selector(setDelegate:)
                                      withMethod:@selector(_swizzleSetDelegate:) error:nil];
    }
    
    if (options & UINavigationControllerSwizzlingOptionOriginalPush) {
        [UINavigationController jr_swizzleMethod:@selector(pushViewController:animated:)
                                      withMethod:@selector(_swizzlePushViewController:animated:) error:nil];
    }
    
    if (options & UINavigationControllerSwizzlingOptionOriginalPop) {
        [UINavigationController jr_swizzleMethod:@selector(popViewControllerAnimated:)
                                      withMethod:@selector(_swizzlePopViewControllerAnimated:) error:nil];
    }
}

- (void)_swizzleSetDelegate:(id<UINavigationControllerDelegate>)delegate
{
    if (self != delegate) {
        [self setNextDelegate:delegate];
    }
    
    if ([self.class swizzlingOption] & UINavigationControllerSwizzlingOptionDelegate) {
        [UINavigationController jr_swizzleMethod:@selector(setDelegate:) withMethod:@selector(_swizzleSetDelegate:) error:nil];
    }
    
    [self setDelegate:self];
    
    if ([self.class swizzlingOption] & UINavigationControllerSwizzlingOptionDelegate) {
        [UINavigationController jr_swizzleMethod:@selector(setDelegate:) withMethod:@selector(_swizzleSetDelegate:) error:nil];
    }
}

- (void)_swizzlePushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self pushViewController:viewController animated:animated withCompletionBlock:NULL];
}

- (void)_unSwizzleAndCallNativePushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.class swizzlingOption] & UINavigationControllerSwizzlingOptionOriginalPush) {
        [UINavigationController jr_swizzleMethod:@selector(pushViewController:animated:)
                                      withMethod:@selector(_swizzlePushViewController:animated:) error:nil];
    }
    
    [self pushViewController:viewController animated:animated];
    
    if ([self.class swizzlingOption] & UINavigationControllerSwizzlingOptionOriginalPush) {
        [UINavigationController jr_swizzleMethod:@selector(pushViewController:animated:)
                                      withMethod:@selector(_swizzlePushViewController:animated:) error:nil];
    }
}

- (UIViewController *)_swizzlePopViewControllerAnimated:(BOOL)animated
{
    UIViewController *vc = [self popViewControllerAnimated:animated withCompletionBlock:NULL];
    return vc;
}

- (UIViewController *)_unSwizzleAndCallNativePopViewControllerAnimated:(BOOL)animated
{
    if ([self.class swizzlingOption] & UINavigationControllerSwizzlingOptionOriginalPop) {
        [UINavigationController jr_swizzleMethod:@selector(popViewControllerAnimated:)
                                      withMethod:@selector(_swizzlePopViewControllerAnimated:) error:nil];
    }
    
    UIViewController *vc = [self popViewControllerAnimated:animated];
    
    if ([self.class swizzlingOption] & UINavigationControllerSwizzlingOptionOriginalPop) {
        [UINavigationController jr_swizzleMethod:@selector(popViewControllerAnimated:)
                                      withMethod:@selector(_swizzlePopViewControllerAnimated:) error:nil];
    }
    
    return vc;
}

#pragma mark - accessories

+ (UINavigationControllerSwizzlingOption)swizzlingOption
{
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

+ (void)setSwizzlingOption:(UINavigationControllerSwizzlingOption)swizzlingOption
{
    objc_setAssociatedObject(self, @selector(swizzlingOption),@(swizzlingOption), OBJC_ASSOCIATION_RETAIN);
}

- (id<UINavigationControllerDelegate>)nextDelegate
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNextDelegate:(id<UINavigationControllerDelegate>)nextDelegate
{
    objc_setAssociatedObject(self, @selector(nextDelegate),nextDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (NSArray *)jmoActionsQueue
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJmoActionsQueue:(NSArray *)actions
{
    objc_setAssociatedObject(self, @selector(jmoActionsQueue),actions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UINavigationControllerState)jmoCurrentAction
{
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

- (void)setJmoCurrentAction:(UINavigationControllerState)action
{
    if (action == UINavigationControllerStateNeutral) {
        [self setJmoTargetedViewController:nil];
    }
    objc_setAssociatedObject(self, @selector(jmoCurrentAction), @(action), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JMONavCompletionBlock)jmoCompletionBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJmoCompletionBlock:(JMONavCompletionBlock)completionBlock
{
    objc_setAssociatedObject(self, @selector(jmoCompletionBlock), completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIViewController *)jmoTargetedViewController
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJmoTargetedViewController:(UIViewController *)vc
{
    objc_setAssociatedObject(self, @selector(jmoTargetedViewController), vc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - UINavigationController delegate

// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //Call nextDelegate
    if([[self nextDelegate] respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [[self nextDelegate] navigationController:navigationController willShowViewController:viewController animated:animated];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == [self jmoTargetedViewController]) {
        //if we are poping to root, continue
        if ([self jmoCurrentAction] == UINavigationControllerStatePopToRootInProgress) {
            [self popViewControllerAnimated:animated withCompletionBlock:NULL];
        } else {
            
            //if we have push or pop something, use completionBlock and finish
            [self consumeCompletionBlock];
            [self setJmoCurrentAction:UINavigationControllerStateNeutral];

            //nextAction
            [self performNextActionInQueue];
        }
    }
    
    //Call nextDelegate
    if([[self nextDelegate] respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [[self nextDelegate] navigationController:navigationController didShowViewController:viewController animated:animated];
    }
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    //Call nextDelegate
    if([[self nextDelegate] respondsToSelector:@selector(navigationController:interactionControllerForAnimationController:)]) {
        return [[self nextDelegate] navigationController:navigationController
             interactionControllerForAnimationController:animationController];
    }
    
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    //Call nextDelegate
    if ([[self nextDelegate] respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]) {
        return [[self nextDelegate] navigationController:navigationController
                         animationControllerForOperation:operation
                                      fromViewController:fromVC
                                        toViewController:toVC];
    }
    
    return nil;
}

#pragma mark - New API

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock
{
    if (nil == self.delegate) {
        self.delegate = self;
    }
    
    if ([self jmoCurrentAction] == UINavigationControllerStatePushInProgress) {
        JMONavigationAction *action = [JMONavigationAction actionTye:JMONavigationActionTypePush completionBlock:completionBlock animated:animated viewController:viewController];
        [self addActionToQueue:action];
    } else {
        [self setJmoCompletionBlock:completionBlock];
        [self setJmoCurrentAction:UINavigationControllerStatePushInProgress];
        [self setJmoTargetedViewController:viewController];
        [self _unSwizzleAndCallNativePushViewController:viewController animated:animated];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock
{
    if (nil == self.delegate) {
        self.delegate = self;
    }
    
    if ([self jmoCurrentAction] == UINavigationControllerStatePopInProgress) {
        JMONavigationAction *action = [JMONavigationAction actionTye:JMONavigationActionTypePop completionBlock:completionBlock animated:animated];
        [self addActionToQueue:action];
        return nil;
    } else if ([self jmoCurrentAction] != UINavigationControllerStatePopToRootInProgress){
        [self setJmoCurrentAction:UINavigationControllerStatePopInProgress];
        [self setJmoCompletionBlock:completionBlock];
    } else {
        //We are UINavigationControllerPopToRootInProgress, we keep the final completionBlock
    }
    
    UIViewController *targetedVc = [self estimateTargetedViewController];
    if (nil != targetedVc) { //There is a controller before the current
        [self setJmoTargetedViewController:targetedVc];
        [self _unSwizzleAndCallNativePopViewControllerAnimated:animated];
        
    } else {
        //Nothing to pop, execute completion block and finish
        [self consumeCompletionBlock];
        [self setJmoCurrentAction:UINavigationControllerStateNeutral];
    }
    
    return targetedVc;
}

- (void)popToRootViewControllerAnimated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock
{
    if (nil == self.delegate) {
        self.delegate = self;
    }
    
    [self setJmoCurrentAction:UINavigationControllerStatePopToRootInProgress];
    [self setJmoCompletionBlock:completionBlock];
    [self popViewControllerAnimated:animated withCompletionBlock:NULL];
}

#pragma mark - Manage actions queue

- (JMONavigationAction *)nextAction
{
    NSArray *actions = [self jmoActionsQueue];
    if(actions.count > 0) {
        return [actions firstObject];
    }
    return nil;
}

- (void)removActionToQueue:(JMONavigationAction *)action
{
    NSMutableArray *actions = [[self jmoActionsQueue] mutableCopy];
    [actions removeObject:action];
    [self setJmoActionsQueue:actions];
}

- (void)addActionToQueue:(JMONavigationAction *)action
{
    NSMutableArray *actions = [[self jmoActionsQueue] mutableCopy];
    if(nil == actions) {
        actions = [NSMutableArray new];
    }
        
    [actions addObject:action];
    [self setJmoActionsQueue:actions];
}

#pragma mark - Helpers

- (UIViewController *)estimateTargetedViewController
{
    NSInteger nbControllers = self.viewControllers.count;
    if ((nbControllers-2) >= 0) {
        return self.viewControllers[nbControllers-2];
    } else {
        return nil;
    }
}

- (void)performNextActionInQueue
{
    JMONavigationAction *nextAction = [self nextAction];
    if (nil != nextAction) {
        [self removActionToQueue:nextAction];
        [self setJmoCurrentAction:UINavigationControllerStateNeutral];
        if (nextAction.type == JMONavigationActionTypePop) {
            [self popViewControllerAnimated:nextAction.animated withCompletionBlock:nextAction.completionBlock];
        } else {
            [self pushViewController:nextAction.viewController animated:nextAction.animated withCompletionBlock:nextAction.completionBlock];
        }
    }
}

- (void)consumeCompletionBlock
{
    if ([self jmoCompletionBlock]) {
        JMONavCompletionBlock block = [self jmoCompletionBlock];
        block();
        [self setJmoCompletionBlock:NULL];
    }
}

@end
