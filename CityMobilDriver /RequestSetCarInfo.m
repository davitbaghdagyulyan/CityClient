//
//  RequestSetCarInfo.m
//  CityMobilDriver
//
//  Created by Intern on 10/30/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "RequestSetCarInfo.h"

@implementation RequestSetCarInfo
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.method = @"setCarInfo";
        self.ipass = @"o3XOFR7xpv";
        self.ilog = @"cm-api";
        self.locale = @"ru";
        self.version = @"1.0.2";
    }
    return self;
}
@end
