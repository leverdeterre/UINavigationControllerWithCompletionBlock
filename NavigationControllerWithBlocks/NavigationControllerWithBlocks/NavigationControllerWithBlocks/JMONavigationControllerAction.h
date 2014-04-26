//
//  JMONavigationControllerAction.h
//  NavigationControllerWithBlocks
//
//  Created by Jerome Morissard on 4/26/14.
//  Copyright (c) 2014 Jerome Morissard. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JMONavCompletionBlock)(BOOL successful);

typedef NS_ENUM(NSUInteger, JMONavigationControllerActionType) {
    JMONavigationControllerActionPush,
    JMONavigationControllerActionPop
};

@interface JMONavigationControllerAction : NSObject

@property (assign, nonatomic) JMONavigationControllerActionType type;
@property (copy, nonatomic) JMONavCompletionBlock completionBlock;
@property (assign, nonatomic) BOOL animated;

+ (instancetype)actionTye:(JMONavigationControllerActionType)type completionBlock:(JMONavCompletionBlock)block animated:(BOOL)animated;

@end
