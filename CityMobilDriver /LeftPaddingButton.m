//
//  LeftPaddingButton.m
//  CityMobilDriver
//
//  Created by Intern on 12/16/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "LeftPaddingButton.h"

@implementation LeftPaddingButton
-(void)drawRect:(CGRect)rect{
    self.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
    [super drawRect:rect];
}

@end
