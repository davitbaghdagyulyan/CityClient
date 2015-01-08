//
//  PaymentLabel.m
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 1/8/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import "PaymentLabel.h"

@implementation PaymentLabel
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        
    }
    return self;
}
-(void)drawTextInRect:(CGRect)rect

{
    UIEdgeInsets insets = {0, 5, 0,5 };
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}
@end
