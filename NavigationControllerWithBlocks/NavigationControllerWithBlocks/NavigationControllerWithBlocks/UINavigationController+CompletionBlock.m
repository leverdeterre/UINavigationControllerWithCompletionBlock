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

- (void)setTargetedViewController:(UIViewController *)vc
{
    objc_setAssociatedObject(self, @selector(targetedViewController), vc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)targetedViewController
{
    return objc_getAssociatedObject(self, _cmd);
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
        if ([self completionBlock]) {
            JMONavCompletionBlock block = [self completionBlock];
            block(YES);
            [self setCompletionBlock:NULL];
        }
        
        [self setTargetedViewController:nil];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock
{
    [self setCompletionBlock:completionBlock];
    [self setTargetedViewController:viewController];
    [self pushViewController:viewController animated:animated];
}

- (void)popViewControllerAnimated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock
{
    [self setCompletionBlock:completionBlock];
    NSInteger nbControllers = self.viewControllers.count;
    if ((nbControllers -2) >= 0) {
        [self setTargetedViewController:self.viewControllers[nbControllers -2]];
    }
    [self popViewControllerAnimated:YES];
}

@end
