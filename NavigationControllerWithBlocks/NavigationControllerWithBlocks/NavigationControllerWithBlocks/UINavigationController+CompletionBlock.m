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

#pragma marl - accessories

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

- (BOOL)popToRootInProgress
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setPopToRootInProgress:(BOOL)popToRootInProgressBool
{
    objc_setAssociatedObject(self, @selector(popToRootInProgress), @(popToRootInProgressBool), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma marl - UINavigationController delegate

// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //NSLog(@"%s",__PRETTY_FUNCTION__);
    if (viewController == [self targetedViewController]) {
        if ([self popToRootInProgress]) {
            [self popViewControllerAnimated:animated withCompletionBlock:NULL];
        } else {
            if ([self completionBlock]) {
                JMONavCompletionBlock block = [self completionBlock];
                block(YES);
                [self setCompletionBlock:NULL];
            }
            [self setTargetedViewController:nil];
        }
    }
}

#pragma marl - 

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock
{
    [self setCompletionBlock:completionBlock];
    [self setTargetedViewController:viewController];
    [self pushViewController:viewController animated:animated];
}

- (void)popViewControllerAnimated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock
{
    if ([self popToRootInProgress]) {
        //keep the old completionBlock
    } else {
        [self setCompletionBlock:completionBlock];
    }
    
    NSInteger nbControllers = self.viewControllers.count;
    if ((nbControllers -2) >= 0) {
        [self setTargetedViewController:self.viewControllers[nbControllers -2]];
        [self popViewControllerAnimated:animated];
    } else {
        if ([self completionBlock]) {
            JMONavCompletionBlock block = [self completionBlock];
            block(YES);
            [self setCompletionBlock:NULL];
        }
        [self setPopToRootInProgress:NO];
    }
}

- (void)popToRootViewControllerAnimated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock
{
    [self setPopToRootInProgress:YES];
    [self setCompletionBlock:completionBlock];
    [self popViewControllerAnimated:animated withCompletionBlock:NULL];
}

@end
