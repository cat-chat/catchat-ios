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
#import "JDPTextfieldTableViewCell.h"

@interface JDPIdentificationViewController ()
<UITextFieldDelegate, UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet JDPTextfieldTableViewCell *emailAddressCell;
@property (weak, nonatomic) IBOutlet JDPTextfieldTableViewCell *passwordCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *actionCell;

@property (nonatomic) NSUInteger invalidLoginAttempts;

@end

static NSUInteger const JDPMinPasswordLength = 8;

typedef NS_ENUM(NSUInteger, JDPAlertViewType) {
    JDPAlertViewTypeNone            = 0,
    JDPAlertViewTypeLogin,
    JDPAlertViewTypePasswordReset
};

@implementation JDPIdentificationViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self configureViewForMode:self.identificationMode];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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

-(void)configureViewForMode:(JDPIdentificationMode)mode{
    self.emailAddressCell.textField.placeholder = NSLocalizedString(@"textfield.placeholder.email", @"email placeholder");
    self.passwordCell.textField.placeholder = NSLocalizedString(@"textfield.placeholder.password", @"password placeholder");

    switch (mode) {
        case JDPIdentificationModeLogin:
            self.title = NSLocalizedString(@"Login Title", @"navigation bar title");
            self.actionCell.textLabel.text = NSLocalizedString(@"Login cell", @"login button on identity controller");
            self.actionCell.backgroundColor = [UIColor catChatDarkGreenColor];
            break;
        case JDPIdentificationModeSignUp:
        default:
            self.title = NSLocalizedString(@"Signup Title", @"navigation bar title");
            self.actionCell.textLabel.text = NSLocalizedString(@"Sign Up cell", @"sign up button on idetity contrller");
            self.actionCell.backgroundColor = [UIColor catChatLightOrangeColor];
            break;
    }
}

#pragma mark - JDPIdentifiactionViewController

-(void)setIdentificationMode:(JDPIdentificationMode)identificationMode{
    _identificationMode = identificationMode;
    [self configureViewForMode:identificationMode];
}

-(BOOL)validateFormInputsAndPasswordLength:(BOOL)passwordLength{
    NSString * email = self.emailAddressCell.textField.text;
    NSString * password = self.passwordCell.textField.text;

    if (! email || [email isEqualToString:@""]) {
        [self.emailAddressCell setErrored:YES animated:YES];
        return NO;
    }

    if (! password || [password isEqualToString:@""]) {
        [self.passwordCell setErrored:YES animated:YES];
        return NO;
    }
    if (passwordLength && password.length < JDPMinPasswordLength) {
        [self.passwordCell setErrored:YES animated:YES];
        [self.passwordCell.textField setPlaceholder:NSLocalizedString(@"textfield.placeholder.makeLongerPassword", @"suggest the user makes a longer password")];
        return NO;
    }

    return YES;
}

-(void)login{
    NSString * email = self.emailAddressCell.textField.text;
    NSString * password = self.passwordCell.textField.text;

    if (! [self validateFormInputsAndPasswordLength:NO]) {
        return;
    }

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
                                            [self handleError:error];
                                        }
                                    }];
}

-(void)signup{
    NSString * email = self.emailAddressCell.textField.text;
    NSString * password = self.passwordCell.textField.text;

    if (! [self validateFormInputsAndPasswordLength:YES]) {
        return;
    }

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
            [self handleError:error];
        }
    }];
}

-(void)handleError:(NSError *)error{
    //TODO: hmm find the parse error domain symbol somewhere
    if (! [error.domain isEqualToString:@"Parse"]) {
        [self displayError:error];
    }
    if (error.code == kPFErrorUsernameMissing) {
        [self.emailAddressCell setErrored:YES animated:YES];
    }
    if (error.code == kPFErrorUsernameTaken) {
        //ask user if they would like to log in instead
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert.title.userExists", @"the user already exists")
                                                         message:NSLocalizedString(@"alert.text.login?", @"try logging in?")
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"alert.button.editDetails", @"option goes back to form")
                                               otherButtonTitles:NSLocalizedString(@"alert.button.login", @"option logs in user"), nil];
        alert.tag = JDPAlertViewTypeLogin;
        [alert show];
    }
    if (error.code == kPFErrorObjectNotFound) {
        self.invalidLoginAttempts ++;
        if (self.invalidLoginAttempts >= 3) {
            [self suggesPasswordReset];
        }else{
            [self.emailAddressCell setErrored:YES animated:YES];
            [self.passwordCell setErrored:YES animated:YES];
        }
    }
}

-(void)suggesPasswordReset{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert.title.passwordReset", @"hit the invalid login limit")
                                                     message:NSLocalizedString(@"alert.text.resetpw?", @"send reset password email?")
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"alert.button.nothanks", @"No thanks")
                                           otherButtonTitles:NSLocalizedString(@"alert.button.send", @"sends a password reset email"), nil];
    alert.tag = JDPAlertViewTypePasswordReset;
    [alert show];
}

-(void)resetPassword{
    [PFUser requestPasswordResetForEmailInBackground:self.emailAddressCell.textField.text
                                               block:
     ^(BOOL succeeded, NSError *error) {
         if (succeeded) {
             [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert.title.reset", @"password reset sent")
                                         message:NSLocalizedString(@"alert.text.resetsent", @"password reset sent")
                                        delegate:nil
                               cancelButtonTitle:NSLocalizedString(@"alert.button.ok", @"OK")
                               otherButtonTitles:nil] show];
         }
         else{
             [self handleError:error];
         }
     }];
}

-(void)displayError:(NSError *)error{
    [[[UIAlertView alloc] initWithTitle:error.localizedDescription
                                message:error.localizedFailureReason
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"alert.button.ok", @"OK")
                      otherButtonTitles:nil] show];
}

-(void)performAuthenticationAction{
    [self.tableView endEditing:YES];
    [self.emailAddressCell setErrored:NO animated:YES];
    [self.passwordCell setErrored:NO animated:YES];

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

#pragma mark - UITableViewDelegate

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return nil;
    }
    return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performAuthenticationAction];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.emailAddressCell.textField == textField) {
        [self.emailAddressCell setErrored:NO animated:YES];
    }
    else{
        [self.passwordCell setErrored:NO animated:YES];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.passwordCell.textField) {
        if (textField.text.length >= JDPMinPasswordLength) {
            textField.placeholder = NSLocalizedString(@"textfield.placeholder.password", @"password placeholder");
        }
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.emailAddressCell.textField) {
        [self.passwordCell.textField becomeFirstResponder];
    }
    else{
        [self performAuthenticationAction];
    }

    return YES;
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag == JDPAlertViewTypeLogin && buttonIndex == alertView.firstOtherButtonIndex) {
        self.identificationMode = JDPIdentificationModeLogin;
        [self login];
    }
    if (alertView.tag == JDPAlertViewTypePasswordReset && buttonIndex == alertView.firstOtherButtonIndex) {
        [self resetPassword];
    }
}

@end
