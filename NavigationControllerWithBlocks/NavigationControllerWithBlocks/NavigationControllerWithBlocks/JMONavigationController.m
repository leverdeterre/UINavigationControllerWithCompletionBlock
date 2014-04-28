//
//  JMONavigationController.m
//  NavigationControllerWithBlocks
//
//  Created by Jerome Morissard on 4/26/14.
//  Copyright (c) 2014 Jerome Morissard. All rights reserved.
//

#import "JMONavigationController.h"
#import "UINavigationController+CompletionBlock.h"

@interface JMONavigationController ()
@end

@implementation JMONavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self activateCompletionBlock];
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // Custom initialization
        [self activateCompletionBlock];
    }
    return self;
}

#pragma mark -

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self pushViewController:viewController animated:animated withCompletionBlock:NULL];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self popViewControllerAnimated:animated withCompletionBlock:NULL];
    return nil;
}

#pragma mark -

- (void)superPushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)superPopViewControllerAnimated:(BOOL)animated
{
    return [super popViewControllerAnimated:animated];
}


@end
