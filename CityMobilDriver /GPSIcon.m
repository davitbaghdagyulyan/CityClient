//
//  GPSIcon.m
//  CityMobilDriver
//
//  Created by Intern on 12/25/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "GPSIcon.h"
#import <CoreLocation/CoreLocation.h>
@implementation GPSIcon


- (void)drawRect:(CGRect)rect {
    
    if ([CLLocationManager locationServicesEnabled])
    {
        [self setImage:[UIImage imageNamed:@"gps_green.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self setImage:[UIImage imageNamed:@"gps.png"] forState:UIControlStateNormal];
    }
}


@end
