//
//  CustomView2.m
//  CityMobilDriver
//
//  Created by Intern on 1/8/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import "CustomView2.h"

@implementation CustomView2


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    self.arrowImageView.userInteractionEnabled=NO;
//}


- (IBAction)replenishmentAction:(UIButton *)sender
{
    [self.delegate setDriverPayment];
}
@end
