//
//  JMOViewController.m
//  NavigationControllerWithBlocks
//
//  Created by Jerome Morissard on 4/26/14.
//  Copyright (c) 2014 Jerome Morissard. All rights reserved.
//

#import "JMOViewController.h"
#import "UINavigationController+CompletionBlock.h"

@interface JMOViewController ()
@end

@implementation JMOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (self.navigationController) {
        [self.navigationController activateCompletionBlock];
    }
    if (self.title.length == 0) {
        self.title = @"controller_first";
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%@ viewDidAppear",self.title);
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"%@ viewDidDisappear",self.title);
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    NSLog(@"%@ dealloc",self.title);
}

#pragma mark - IBActions

- (IBAction)push:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"Main" bundle:[NSBundle mainBundle]];
    JMOViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"JMOViewController"];
    vc.title = [NSString stringWithFormat:@"controller_%d",self.navigationController.viewControllers.count];
    [self.navigationController pushViewController:vc animated:YES withCompletionBlock:^(BOOL successful) {
        NSLog(@"Hi ! Push done !");
    }];
}

- (IBAction)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES withCompletionBlock:^(BOOL successful) {
        NSLog(@"Hi ! Pop done !");
    }];
}

- (IBAction)popToRootAnimated:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES withCompletionBlock:^(BOOL successful) {
        NSLog(@"popToRoot done!");
    }];
}

- (IBAction)triplepPopBug:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES withCompletionBlock:^(BOOL successful) {
        NSLog(@"Hi ! Pop1 done !");
    }];
    [self.navigationController popViewControllerAnimated:YES withCompletionBlock:^(BOOL successful) {
        NSLog(@"Hi ! Pop2 done !");
    }];
    [self.navigationController popViewControllerAnimated:YES withCompletionBlock:^(BOOL successful) {
        NSLog(@"Hi ! Pop3 done !");
    }];
}

@end
