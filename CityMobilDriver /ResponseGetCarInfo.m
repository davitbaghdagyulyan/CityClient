//
//  ResponseGetCarInfo.m
//  CityMobilDriver
//
//  Created by Intern on 11/4/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "ResponseGetCarInfo.h"

@implementation ResponseGetCarInfo
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.id_car = @"";
        self.id_mark = @"";
        self.mark = @"";
        self.id_model = @"";
        self.model = @"";
        self.year = @"";
        self.id_color = @"";
        self.color = @"";
        self.rgb = @"";
        self.VIN = @"";
        self.car_license_pref = @"";
        self.car_license_number = @"";
        self.reg_num = @"";
    }
    return self;
}
@end