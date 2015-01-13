//
//  CardView.m
//  CityMobilDriver
//
//  Created by Intern on 1/9/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import "CardView.h"

@implementation CardView

- (void)drawRect:(CGRect)rect
{
//    [self.layer setCornerRadius:30.0f];
//    
//    // border
//    [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//    [self.layer setBorderWidth:1.5f];
//    
//    // drop shadow
//    [self.layer setShadowColor:[UIColor blackColor].CGColor];
//    [self.layer setShadowOpacity:0.8];
//    [self.layer setShadowRadius:3.0];
//    [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
//    

    self.bgView.layer.cornerRadius = 8.0;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.borderWidth = 1.0;
    
}




- (IBAction)deleteCard:(UIButton *)sender {
}
@end
