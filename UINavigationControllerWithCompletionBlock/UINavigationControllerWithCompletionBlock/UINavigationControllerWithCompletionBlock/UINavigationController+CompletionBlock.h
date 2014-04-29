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

typedef NS_OPTIONS(NSUInteger, UINavigationControllerSwizzlingOption) {
    UINavigationControllerSwizzlingOptionDelegate       = 1 << 0,
    UINavigationControllerSwizzlingOptionOriginalPush   = 1 << 1,
    UINavigationControllerSwizzlingOptionOriginalPop    = 1 << 2
};

@interface UINavigationController (CompletionBlock) <UINavigationControllerDelegate>

+ (void)activateSwizzling;
+ (void)activateSwizzlingWithOptions:(UINavigationControllerSwizzlingOption)options;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock;
- (UIViewController *)popViewControllerAnimated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock;
- (void)popToRootViewControllerAnimated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock;

@end
