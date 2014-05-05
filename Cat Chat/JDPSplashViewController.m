//
//  JDPSplashViewController.m
//  Cat Chat
//
//  Created by Joel Parsons on 05/05/2014.
//  Copyright (c) 2014 Joel Parsons. All rights reserved.
//

#import "JDPSplashViewController.h"
//view
#import "JDPStoryboardIdentifiers.h"
//controller
#import "JDPIdentificationViewController.h"

@interface JDPSplashViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@end

@implementation JDPSplashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    JDPIdentificationViewController * controller = segue.destinationViewController;

    if ([segue.identifier isEqualToString:JDPLoginSegue]) {
        controller.identificationMode = JDPIdentificationModeLogin;
    }
    if ([segue.identifier isEqualToString:JDPSignupSegue]) {
        controller.identificationMode = JDPIdentificationModeSignUp;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedFacebookButton:(UIButton *)sender {
    NSArray * readPermissions = @[@"email"];
    [PFFacebookUtils logInWithPermissions:readPermissions
                                    block:^(PFUser *user, NSError *error) {
                                        NSLog(@"hooray");
                                    }];
}

@end
