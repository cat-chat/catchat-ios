//
//  JDPCatThumbnailCell.m
//  Cat Chat
//
//  Created by Joel Parsons on 05/05/2014.
//  Copyright (c) 2014 Joel Parsons. All rights reserved.
//

#import "JDPCatThumbnailCell.h"

@implementation JDPCatThumbnailCell

-(UIImage *)randomLoadingImage{
    NSUInteger randomNumber = arc4random_uniform(5);
    NSString * loadingImageName = [NSString stringWithFormat:@"loading%d",randomNumber];
    return [UIImage imageNamed:loadingImageName];
}

-(void)awakeFromNib{
    self.imageView.image = [self randomLoadingImage];
}

-(void)prepareForReuse{
    self.imageView.image = [self randomLoadingImage];
}

@end
