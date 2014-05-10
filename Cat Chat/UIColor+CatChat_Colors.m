//
//  UIColor+CatChat_Colors.m
//  Cat Chat
//
//  Created by Joel Parsons on 05/05/2014.
//  Copyright (c) 2014 Joel Parsons. All rights reserved.
//

#import "UIColor+CatChat_Colors.h"

@implementation UIColor (CatChat_Colors)

+(instancetype)catChatDarkGreenColor{
    return [UIColor colorWithRed:0.2 green:0.7 blue:0.56 alpha:1];
}

+(instancetype)catChatGreenColor{
    return [UIColor colorWithRed:0.38 green:0.84 blue:0.72 alpha:1];
}

+(instancetype)catChatOrangeColor{
    return [UIColor colorWithRed:0.99 green:0.52 blue:0.27 alpha:1];
}

+(instancetype)catChatLightOrangeColor{
    return [UIColor colorWithRed:0.99 green:0.64 blue:0.44 alpha:1];
}

+(instancetype)catChatLightErrorColor{
    return [UIColor colorWithRed:1 green:0.65 blue:0.62 alpha:1];
}

@end
