//
//  JDPItentificationViewController.h
//  Cat Chat
//
//  Created by Joel Parsons on 05/05/2014.
//  Copyright (c) 2014 Joel Parsons. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JDPIdentificationMode) {
    JDPIdentificationModeSignUp,
    JDPIdentificationModeLogin
};

@interface JDPIdentificationViewController : UITableViewController

@property (nonatomic) JDPIdentificationMode identificationMode;

@end
