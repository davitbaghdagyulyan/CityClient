//
//  CustomView.m
//  CityMobilDriver
//
//  Created by Intern on 10/20/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView



- (IBAction)actionAdd:(UIButton *)sender
{
    [self.delegate requestBindCard];
}
@end
