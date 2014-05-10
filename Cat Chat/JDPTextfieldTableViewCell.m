//
//  JDPTextfieldTableViewCell.m
//  Cat Chat
//
//  Created by Joel Parsons on 10/05/2014.
//  Copyright (c) 2014 Joel Parsons. All rights reserved.
//

#import "JDPTextfieldTableViewCell.h"
#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>

@interface JDPTextfieldTableViewCell ()
@property (nonatomic, weak) IBOutlet JVFloatLabeledTextField * textField;
@end

@implementation JDPTextfieldTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setErrored:(BOOL)errored{
    [self setErrored:errored animated:NO];
}

-(void)setErrored:(BOOL)errored animated:(BOOL)animated{
    if (_errored == errored) {
        return;
    }
    _errored = errored;
    dispatch_block_t setColor = ^{
        UIColor * color = [UIColor whiteColor];
        if (errored) {
            color = [UIColor catChatLightErrorColor];
        }
        self.backgroundColor = color;
    };
    if (animated) {
        [UIView animateWithDuration:0.4
                         animations:setColor];
    }
    else{
        setColor();
    }
}

@end
