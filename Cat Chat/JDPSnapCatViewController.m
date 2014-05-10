//
//  JDPSnapCatViewController.m
//  Cat Chat
//
//  Created by Joel Parsons on 05/05/2014.
//  Copyright (c) 2014 Joel Parsons. All rights reserved.
//

#import "JDPSnapCatViewController.h"

@interface JDPSnapCatViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBarButtonItem;

@end

@implementation JDPSnapCatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - target action

- (IBAction)longPressGestureRecognized:(UILongPressGestureRecognizer *)sender {
}

@end
