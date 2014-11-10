//
//  RequestGetCarInfo.m
//  CityMobilDriver
//
//  Created by Intern on 10/31/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "RequestGetCarInfo.h"

@implementation RequestGetCarInfo
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.method = @"getCarInfo";
        self.ipass = @"o3XOFR7xpv";
        self.ilog = @"cm-api";
        self.locale = @"ru";
        self.version = @"1.0.2";
    }
    return self;
}
@end