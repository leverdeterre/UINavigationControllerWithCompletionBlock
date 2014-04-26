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

- (UINavigationControllerAction)currentAction
{
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

- (void)setCurrentAction:(UINavigationControllerAction)action
{
    if (action == UINavigationControllerNone) {
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
        if ([self currentAction] == UINavigationControllerPopToRootInProgress) {
            [self popViewControllerAnimated:animated withCompletionBlock:NULL];
        } else {
            if ([self completionBlock]) {
                JMONavCompletionBlock block = [self completionBlock];
                block(YES);
                [self setCompletionBlock:NULL];
            }
        
            [self setCurrentAction:UINavigationControllerNone];

            //nextActions ?
            JMONavigationControllerAction *nextAction = [self nextAction];
            if (nil != nextAction) {
                [self removActionToQueue:nextAction];
                [self setCurrentAction:UINavigationControllerNone];
                [self popViewControllerAnimated:nextAction.animated withCompletionBlock:nextAction.completionBlock];
            }
        }
    }
}

#pragma mark -

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock
{
    [self setCompletionBlock:completionBlock];
    [self setCurrentAction:UINavigationControllerPushInProgress];
    [self setTargetedViewController:viewController];
    [self pushViewController:viewController animated:animated];
}

- (void)popViewControllerAnimated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock
{
    if ([self currentAction] == UINavigationControllerPopToRootInProgress) {
        //keep the old completionBlock
    } else if ([self currentAction] == UINavigationControllerPopInProgress) {
        JMONavigationControllerAction *action = [JMONavigationControllerAction actionTye:JMONavigationControllerActionPop completionBlock:completionBlock animated:animated];
        [self addActionToQueue:action];
        return;
    } else {
        [self setCurrentAction:UINavigationControllerPopInProgress];
        [self setCompletionBlock:completionBlock];
    }
    
    UIViewController *targetedVc = [self targetedViewControllerAtIndex:1];
    if (nil != targetedVc) {
        [self setTargetedViewController:targetedVc];
        [self popViewControllerAnimated:animated];
    } else {
        if ([self completionBlock]) {
            JMONavCompletionBlock block = [self completionBlock];
            block(YES);
            [self setCompletionBlock:NULL];
        }
        
        [self setCurrentAction:UINavigationControllerNone];
    }
}

- (void)popToRootViewControllerAnimated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock
{
    [self setCurrentAction:UINavigationControllerPopToRootInProgress];
    [self setCompletionBlock:completionBlock];
    [self popViewControllerAnimated:animated withCompletionBlock:NULL];
}

#pragma mark - Manage actions queue

- (JMONavigationControllerAction *)nextAction
{
    NSArray *actions = [self actionsQueue];
    if(actions.count > 0) {
        return [actions firstObject];
    }
    return nil;
}

- (void)removActionToQueue:(JMONavigationControllerAction *)action
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSMutableArray *actions = [[self actionsQueue] mutableCopy];
    [actions removeObject:action];
    [self setActionsQueue:actions];
}

- (void)addActionToQueue:(JMONavigationControllerAction *)action
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSMutableArray *actions = [[self actionsQueue] mutableCopy];
    if(nil == actions) {
        actions = [NSMutableArray new];
    }
        
    [actions addObject:action];
    [self setActionsQueue:actions];
}

- (UIViewController *)targetedViewControllerAtIndex:(NSInteger)index
{
    NSInteger nbControllers = self.viewControllers.count;
    if ((nbControllers -(index)-1) >= 0) {
        return self.viewControllers[(nbControllers -(index)-1)];
    } else {
        return nil;
    }
}

@end
