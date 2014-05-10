//
//  JDPTextfieldTableViewCell.h
//  Cat Chat
//
//  Created by Joel Parsons on 10/05/2014.
//  Copyright (c) 2014 Joel Parsons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDPTextfieldTableViewCell : UITableViewCell
@property (nonatomic, weak, readonly) UITextField * textField;

@property (nonatomic, getter = isErrored) BOOL errored;
-(void)setErrored:(BOOL)errored animated:(BOOL)animated;

@end
