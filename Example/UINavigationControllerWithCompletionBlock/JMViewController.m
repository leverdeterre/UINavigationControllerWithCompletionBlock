//
//  JMViewController.m
//  UINavigationControllerWithCompletionBlock
//
//  Created by Jerome Morissard on 08/10/2015.
//  Copyright (c) 2015 Jerome Morissard. All rights reserved.
//

#import "JMViewController.h"
#import "UINavigationController+CompletionBlock.h"

@interface JMViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *swizzDelegateSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *swizzPushPopSwitch;
@end

@implementation JMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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
    [self activateSwizzlingDependingOnSwitchStatus];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"Main" bundle:[NSBundle mainBundle]];
    JMViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"JMViewController"];
    vc.title = [NSString stringWithFormat:@"controller_%lu",(unsigned long)self.navigationController.viewControllers.count];
    [self.navigationController pushViewController:vc animated:YES withCompletionBlock:^() {
        NSLog(@"Hi ! Push done !");
    }];
}

- (IBAction)pop:(id)sender
{
    [self activateSwizzlingDependingOnSwitchStatus];
    
    [self.navigationController popViewControllerAnimated:YES withCompletionBlock:^() {
        NSLog(@"Hi ! Pop done !");
    }];
}

- (IBAction)popToRootAnimated:(id)sender
{
    [self activateSwizzlingDependingOnSwitchStatus];
    
    [self.navigationController popToRootViewControllerAnimated:YES withCompletionBlock:^() {
        NSLog(@"popToRoot done!");
    }];
}

- (IBAction)triplepPopBug:(id)sender
{
    [self activateSwizzlingDependingOnSwitchStatus];
    
    [self.navigationController popViewControllerAnimated:YES withCompletionBlock:^() {
        NSLog(@"Hi ! Pop1 done !");
    }];
    [self.navigationController popViewControllerAnimated:YES withCompletionBlock:^() {
        NSLog(@"Hi ! Pop2 done !");
    }];
    [self.navigationController popViewControllerAnimated:YES withCompletionBlock:^() {
        NSLog(@"Hi ! Pop3 done !");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"last pop done" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma mark - IBActions old APi

- (IBAction)pushOld:(id)sender
{
    [self activateSwizzlingDependingOnSwitchStatus];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"Main" bundle:[NSBundle mainBundle]];
    JMViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"JMViewController"];
    vc.title = [NSString stringWithFormat:@"controller_%d",self.navigationController.viewControllers.count];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)popOld:(id)sender
{
    [self activateSwizzlingDependingOnSwitchStatus];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)triplepPopOldApi:(id)sender
{
    [self activateSwizzlingDependingOnSwitchStatus];
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helpers

- (void)activateSwizzlingDependingOnSwitchStatus
{
    if (self.swizzDelegateSwitch.isOn && self.swizzPushPopSwitch.isOn) {
        [UINavigationController activateSwizzlingWithOptions:(UINavigationControllerSwizzlingOptionDelegate|
                                                              UINavigationControllerSwizzlingOptionOriginalPush|
                                                              UINavigationControllerSwizzlingOptionOriginalPop)];
    } else if (self.swizzPushPopSwitch.isOn) {
        [UINavigationController activateSwizzlingWithOptions:(UINavigationControllerSwizzlingOptionOriginalPush|
                                                              UINavigationControllerSwizzlingOptionOriginalPop)];
    } else if (self.swizzDelegateSwitch.isOn) {
        [UINavigationController activateSwizzlingWithOptions:(UINavigationControllerSwizzlingOptionDelegate)];
    }
}

@end
