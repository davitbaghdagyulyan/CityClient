//
//  AddGPSJson.m
//  CityMobilDriver
//
//  Created by Intern on 12/4/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "AddGPSJson.h"
#import "SingleDataProvider.h"
@implementation AddGPSJson
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.ipass=@"o3XOFR7xpv";
        self.ilog=@"cm-api";
        self.locale=@"ru";
        self.method=@"getOrder";
        self.version=@"1.0.2";
        self.method=@"addgps";
        self.key=[[SingleDataProvider sharedKey]key];
    }
    return self;
}

@end
