//
//  CityMobilIcon.m
//  CityMobilDriver
//
//  Created by Intern on 11/24/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "CityMobilIcon.h"
#import "IconsColorSingltone.h"

@implementation CityMobilIcon
- (void)drawRect:(CGRect)rect {
    if([IconsColorSingltone sharedColor].cityMobilColor == 0){
        [self setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
    }
    if ([IconsColorSingltone sharedColor].cityMobilColor == 1) {
        [self setImage:[UIImage imageNamed:@"set3_orange.png"] forState:UIControlStateNormal];
    }
    if ([IconsColorSingltone sharedColor].cityMobilColor == 2) {
        [self setImage:[UIImage imageNamed:@"icon_green.png"] forState:UIControlStateNormal];
    }
}

@end