//
//  UIStoryboard+Cat_Chat.m
//  Cat Chat
//
//  Created by Joel Parsons on 05/05/2014.
//  Copyright (c) 2014 Joel Parsons. All rights reserved.
//

#import "UIStoryboard+Cat_Chat.h"

@implementation UIStoryboard (Cat_Chat)

+(instancetype)catChatStoryboard{
    return [UIStoryboard storyboardWithName:@"Main"
                                     bundle:[NSBundle mainBundle]];
}

@end
