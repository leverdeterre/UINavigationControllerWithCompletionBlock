//
//  JMONavigationControllerAction.m
//  NavigationControllerWithBlocks
//
//  Created by Jerome Morissard on 4/26/14.
//  Copyright (c) 2014 Jerome Morissard. All rights reserved.
//

#import "JMONavigationControllerAction.h"

@interface JMONavigationControllerAction ()
@end

@implementation JMONavigationControllerAction

+ (instancetype)actionTye:(JMONavigationControllerActionType)type completionBlock:(JMONavCompletionBlock)block animated:(BOOL)animated
{
    JMONavigationControllerAction *action = [JMONavigationControllerAction new];
    action.type = type;
    action.completionBlock = block;
    action.animated = animated;
    return action;
}

@end
