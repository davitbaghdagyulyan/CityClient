//
//  RequestGetCarInfo.m
//  CityMobilDriver
//
//  Created by Intern on 10/29/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "RequestGetMarkList.h"

@implementation RequestGetMarkList
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.method = @"getMarkList";
        self.ipass = @"o3XOFR7xpv";
        self.ilog = @"cm-api";
        self.locale = @"ru";
        self.version = @"1.0.2";
    }
    return self;
}
@end


