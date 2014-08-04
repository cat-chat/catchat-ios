//
//  JDPItentificationViewController.m
//  Cat Chat
//
//  Created by Joel Parsons on 05/05/2014.
//  Copyright (c) 2014 Joel Parsons. All rights reserved.
//

#import "JDPIdentificationViewController.h"
//view
#import "JDPStoryboardIdentifiers.h"
#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>

@interface JDPIdentificationViewController ()
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITableViewCell *actionCell;

@end

@implementation JDPIdentificationViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    switch (self.identificationMode) {
        case JDPIdentificationModeLogin:
            self.title = NSLocalizedString(@"Login Title", @"navigation bar title");
            self.actionCell.textLabel.text = NSLocalizedString(@"Login cell", @"login button on identity controller");
            self.actionCell.contentView.backgroundColor = [UIColor catChatDarkGreenColor];
            break;
        case JDPIdentificationModeSignUp:
        default:
            self.title = NSLocalizedString(@"Signup Title", @"navigation bar title");
            self.actionCell.textLabel.text = NSLocalizedString(@"Sign Up cell", @"sign up button on idetity contrller");
            self.actionCell.contentView.backgroundColor = [UIColor catChatLightOrangeColor];
            break;
    }

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSArray * controllers = self.navigationController.viewControllers;
    if (! [controllers containsObject:self]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)login{
    NSString * email = self.emailAddressTextField.text;
    NSString * password = self.passwordTextField.text;

    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

    [PFUser logInWithUsernameInBackground:email
                                 password:password
                                    block:^(PFUser *user, NSError *error) {
                                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];

                                        if (user) {
                                            [self performSegueWithIdentifier:JDPAuthenticationSuccessSegue
                                                                      sender:self];
                                        }
                                        else {
                                            
                                        }
                                    }];
}

-(void)signup{
    NSString * email = self.emailAddressTextField.text;
    NSString * password = self.passwordTextField.text;

    PFUser * user = [PFUser user];
    user.username = email;
    user.email = email;
    user.password = password;

    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];

        if (succeeded) {
            [self performSegueWithIdentifier:JDPAuthenticationSuccessSegue
                                      sender:self];
        }
        else{
            //handle errors
        }
    }];
}

#pragma mark - UITableViewDelegate

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return nil;
    }
    return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (self.identificationMode) {
        case JDPIdentificationModeLogin:
            [self login];
            break;
        case JDPIdentificationModeSignUp:
        default:
            [self signup];
            break;
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.emailAddressTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else{
        [textField resignFirstResponder];
    }

    return YES;
}

@end
