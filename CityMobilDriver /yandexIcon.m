//
//  yandexIcon.m
//  CityMobilDriver
//
//  Created by Intern on 11/24/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "yandexIcon.h"
#import "IconsColorSingltone.h"

@implementation yandexIcon

- (void)drawRect:(CGRect)rect {    
    if([IconsColorSingltone sharedColor].yandexColor == 0){
        [self setImage:[UIImage imageNamed:@"ya@2x"] forState:UIControlStateNormal];
        [self setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    }
    if ([IconsColorSingltone sharedColor].yandexColor == 1) {
        [self setImage:[UIImage imageNamed:@"ya_green.png"] forState:UIControlStateNormal];
        [self setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    }
}

 
-(void)setImageForState:(BOOL)isRed{
    if (isRed) {
        [self setImage:[UIImage imageNamed:@"ya@2x"] forState:UIControlStateNormal];
        [self setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    }
    else{
        [self setImage:[UIImage imageNamed:@"ya_green.png"] forState:UIControlStateNormal];
        [self setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    }
}


@end
