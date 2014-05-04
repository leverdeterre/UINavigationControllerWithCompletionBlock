//
//  UINavigationController+CompletionBlock.h
//  UINavigationControllerWithBlocks
//
//  Created by Jerome Morissard on 4/26/14.
//  Copyright (c) 2014 Jerome Morissard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMONavigationAction.h"

/**
 *  Swizzling option
 */
typedef NS_OPTIONS(NSUInteger, UINavigationControllerSwizzlingOption) {
    /**
     *  If you want to call the custom setDelegate before the navigationController native method
     */
    UINavigationControllerSwizzlingOptionDelegate       = 1 << 0,
    /**
     *  If you want to enhance the native Push method
     */
    UINavigationControllerSwizzlingOptionOriginalPush   = 1 << 1,
    /**
     *  If you want to enhance the native Pop method
     */
    UINavigationControllerSwizzlingOptionOriginalPop    = 1 << 2
};

@interface UINavigationController (CompletionBlock) <UINavigationControllerDelegate>

/**
 *  activateSwizzling will activate swizzling for default methods (setDelegate, push, pop)
 */
+ (void)activateSwizzling;

/**
 *
 *  activateSwizzling will activate swizzling for options parameter
 *  @param options a bitmasking of swizzling options
 */
+ (void)activateSwizzlingWithOptions:(UINavigationControllerSwizzlingOption)options;

/**
 *  pushViewController:animated:withCompletionBlock: improves native push API
 *
 *  @param viewController  UIViewController
 *  @param animated        boolean value
 *  @param completionBlock completionBlock to be executed when the push action is finished
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock;

/**
 *  popViewControllerAnimated:withCompletionBlock: improves native pop API
 *
 *  @param animated        boolean value
 *  @param completionBlock completionBlock to be executed when the pop action is finished
 *
 *  @return the popped controller
 */
- (UIViewController *)popViewControllerAnimated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock;

/**
 *  popToRootViewControllerAnimated:withCompletionBlock: improves native pop API
 *
 *  @param animated        boolean value
 *  @param completionBlock completionBlock to be executed when the popToRoot action is finished
 */
- (void)popToRootViewControllerAnimated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock;

@end
