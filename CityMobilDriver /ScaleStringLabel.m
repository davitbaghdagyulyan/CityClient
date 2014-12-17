//
//  ScaleStringLabel.m
//  CityMobilDriver
//
//  Created by Intern on 12/16/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "ScaleStringLabel.h"

@implementation ScaleStringLabel


- (void)drawRect:(CGRect)rect {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    float spacing = 0.1f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;
    [super drawRect:rect];
}

@end
