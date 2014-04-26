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

- (IBAction)push:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"Main" bundle:[NSBundle mainBundle]];
    JMOViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"JMOViewController"];
    vc.title = [NSString stringWithFormat:@"controller_%d",self.navigationController.viewControllers.count];
    [self.navigationController pushViewController:vc animated:YES withCompletionBlock:^(BOOL successful) {
        NSLog(@"Hiihihi je push et je déclanche ça aprés viewDidAppear");
    }];
}

- (IBAction)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES withCompletionBlock:^(BOOL successful) {
        NSLog(@"Hiihihi je pop et je déclanche ça aprés viewDidAppear");
    }];
}


@end
