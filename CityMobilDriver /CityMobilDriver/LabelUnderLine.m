//
//  LabelUnderLine.m
//  CityMobilDriver
//
//  Created by Intern on 11/17/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "LabelUnderLine.h"

@implementation LabelUnderLine

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(ctx, 0, 0, 1, 1.0f); // RGBA
    CGContextSetLineWidth(ctx, 1.0f);
    
    CGContextMoveToPoint(ctx, 0, self.bounds.size.height - 6);
    CGContextAddLineToPoint(ctx, self.bounds.size.width-10, self.bounds.size.height - 6);
    
    CGContextStrokePath(ctx);
    
    [super drawRect:rect];
}

@end
