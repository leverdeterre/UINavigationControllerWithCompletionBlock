//
//  JMONavigationControllerAction.m
//  NavigationControllerWithBlocks
//
//  Created by Jerome Morissard on 4/26/14.
//  Copyright (c) 2014 Jerome Morissard. All rights reserved.
//

#import "JMONavigationAction.h"

@interface JMONavigationAction ()
@end

@implementation JMONavigationAction

+ (instancetype)actionTye:(JMONavigationActionType)type completionBlock:(JMONavCompletionBlock)block animated:(BOOL)animated
{
    JMONavigationAction *action = [JMONavigationAction new];
    action.type = type;
    action.completionBlock = block;
    action.animated = animated;
    return action;
}

+ (instancetype)actionTye:(JMONavigationActionType)type completionBlock:(JMONavCompletionBlock)block animated:(BOOL)animated viewController:(UIViewController *)viewController
{
    JMONavigationAction *action = [self actionTye:type completionBlock:block animated:animated];
    action.viewController = viewController;
    return action;
}

@end
