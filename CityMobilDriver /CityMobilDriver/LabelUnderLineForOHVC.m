//
//  LabelUnderLineForOHVC.m
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 11/21/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "LabelUnderLineForOHVC.h"

@implementation LabelUnderLineForOHVC

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1.0f); // RGBA
    CGContextSetLineWidth(ctx, 1.0f);
    CGContextMoveToPoint(ctx, 0, self.bounds.size.height);
    CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height);
    CGContextStrokePath(ctx);
    [super drawRect:rect];

}



@end
