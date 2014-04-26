//
//  UINavigationController+CompletionBlock.h
//  NavigationControllerWithBlocks
//
//  Created by Jerome Morissard on 4/26/14.
//  Copyright (c) 2014 Jerome Morissard. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^JMONavCompletionBlock)(BOOL successful);

@interface UINavigationController (CompletionBlock) <UINavigationControllerDelegate>

- (void)activateCompletionBlock;

- (JMONavCompletionBlock)completionBlock;
- (void)setCompletionBlock:(JMONavCompletionBlock)completionBlock;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock;
- (void)popViewControllerAnimated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock;
- (void)popToRootViewControllerAnimated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock;

@end
