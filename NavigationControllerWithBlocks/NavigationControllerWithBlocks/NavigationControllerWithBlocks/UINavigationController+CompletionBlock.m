//
//  UINavigationController+CompletionBlock.m
//  NavigationControllerWithBlocks
//
//  Created by Jerome Morissard on 4/26/14.
//  Copyright (c) 2014 Jerome Morissard. All rights reserved.
//

#import "UINavigationController+CompletionBlock.h"
#import <objc/runtime.h>

@implementation UINavigationController (CompletionBlock)

- (void)activateCompletionBlock
{
    self.delegate = self;
}

#pragma mark - accessories

- (NSArray *)actionsQueue
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setActionsQueue:(NSArray *)actions
{
    objc_setAssociatedObject(self, @selector(actionsQueue),actions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UINavigationControllerState)currentAction
{
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

- (void)setCurrentAction:(UINavigationControllerState)action
{
    if (action == UINavigationControllerStateNeutral) {
        [self setTargetedViewController:nil];
    }
    objc_setAssociatedObject(self, @selector(currentAction), @(action), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JMONavCompletionBlock)completionBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCompletionBlock:(JMONavCompletionBlock)completionBlock
{
    objc_setAssociatedObject(self, @selector(completionBlock), completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIViewController *)targetedViewController
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTargetedViewController:(UIViewController *)vc
{
    objc_setAssociatedObject(self, @selector(targetedViewController), vc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - UINavigationController delegate

// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //NSLog(@"%s",__PRETTY_FUNCTION__);
    if (viewController == [self targetedViewController]) {
        //if we are poping to root, continue
        if ([self currentAction] == UINavigationControllerStatePopToRootInProgress) {
            [self popViewControllerAnimated:animated withCompletionBlock:NULL];
        } else {
            
            //if we have push or pop something, use completionBlock and finish
            [self consumeCompletionBlock];
            [self setCurrentAction:UINavigationControllerStateNeutral];

            //nextAction
            [self performNextActionInQueue];
        }
    }
}

#pragma mark -

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock
{
    if ([self currentAction] == UINavigationControllerStatePushInProgress) {
        JMONavigationAction *action = [JMONavigationAction actionTye:JMONavigationActionTypePush completionBlock:completionBlock animated:animated viewController:viewController];
        [self addActionToQueue:action];
    } else {
        [self setCompletionBlock:completionBlock];
        [self setCurrentAction:UINavigationControllerStatePushInProgress];
        [self setTargetedViewController:viewController];
        [self pushViewController:viewController animated:animated];
    }
}

- (void)popViewControllerAnimated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock
{
    if ([self currentAction] == UINavigationControllerStatePopInProgress) {
        JMONavigationAction *action = [JMONavigationAction actionTye:JMONavigationActionTypePop completionBlock:completionBlock animated:animated];
        [self addActionToQueue:action];
        return;
    } else if ([self currentAction] != UINavigationControllerStatePopToRootInProgress){
        [self setCurrentAction:UINavigationControllerStatePopInProgress];
        [self setCompletionBlock:completionBlock];
    } else {
        //We are UINavigationControllerPopToRootInProgress, we keep the final completionBlock
    }
    
    UIViewController *targetedVc = [self estimateTargetedViewController];
    if (nil != targetedVc) { //There is a controller before the current
        [self setTargetedViewController:targetedVc];
        [self popViewControllerAnimated:animated];
    } else {
        //Nothing to pop, execute completion block and finish
        [self consumeCompletionBlock];
        [self setCurrentAction:UINavigationControllerStateNeutral];
    }
}

- (void)popToRootViewControllerAnimated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock
{
    [self setCurrentAction:UINavigationControllerStatePopToRootInProgress];
    [self setCompletionBlock:completionBlock];
    [self popViewControllerAnimated:animated withCompletionBlock:NULL];
}

#pragma mark - Manage actions queue

- (JMONavigationAction *)nextAction
{
    NSArray *actions = [self actionsQueue];
    if(actions.count > 0) {
        return [actions firstObject];
    }
    return nil;
}

- (void)removActionToQueue:(JMONavigationAction *)action
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSMutableArray *actions = [[self actionsQueue] mutableCopy];
    [actions removeObject:action];
    [self setActionsQueue:actions];
}

- (void)addActionToQueue:(JMONavigationAction *)action
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSMutableArray *actions = [[self actionsQueue] mutableCopy];
    if(nil == actions) {
        actions = [NSMutableArray new];
    }
        
    [actions addObject:action];
    [self setActionsQueue:actions];
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
        [self setCurrentAction:UINavigationControllerStateNeutral];
        if (nextAction.type == JMONavigationActionTypePop) {
            [self popViewControllerAnimated:nextAction.animated withCompletionBlock:nextAction.completionBlock];
        } else {
            [self pushViewController:nextAction.viewController animated:nextAction.animated withCompletionBlock:nextAction.completionBlock];
        }
    }
}

- (void)consumeCompletionBlock
{
    if ([self completionBlock]) {
        JMONavCompletionBlock block = [self completionBlock];
        block();
        [self setCompletionBlock:NULL];
    }
}

@end
