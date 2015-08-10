//
//  JMONavigationAction.h
//  NavigationControllerWithBlocks
//
//  Created by Jerome Morissard on 4/26/14.
//  Copyright (c) 2014 Jerome Morissard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^JMONavCompletionBlock)();

typedef NS_ENUM(NSUInteger, JMONavigationActionType) {
    JMONavigationActionTypePush,
    JMONavigationActionTypePop
};

@interface JMONavigationAction : NSObject

@property (assign, nonatomic) JMONavigationActionType type;
@property (assign, nonatomic) BOOL animated;
@property (copy, nonatomic) JMONavCompletionBlock completionBlock;
@property (strong, nonatomic) UIViewController *viewController;

+ (instancetype)actionTye:(JMONavigationActionType)type completionBlock:(JMONavCompletionBlock)block animated:(BOOL)animated;
+ (instancetype)actionTye:(JMONavigationActionType)type completionBlock:(JMONavCompletionBlock)block animated:(BOOL)animated viewController:(UIViewController *)viewController;

@end
