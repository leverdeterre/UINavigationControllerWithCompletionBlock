//
//  UINavigationController+CompletionBlock.h
//  NavigationControllerWithBlocks
//
//  Created by Jerome Morissard on 4/26/14.
//  Copyright (c) 2014 Jerome Morissard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMONavigationAction.h"


typedef NS_ENUM(NSUInteger, UINavigationControllerState) {
    UINavigationControllerStateNeutral,
    UINavigationControllerStatePushInProgress,
    UINavigationControllerStatePopInProgress,
    UINavigationControllerStatePopToRootInProgress
};

@interface UINavigationController (CompletionBlock) <UINavigationControllerDelegate>

- (void)activateCompletionBlock;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock;
- (void)popViewControllerAnimated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock;
- (void)popToRootViewControllerAnimated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock;

@end
