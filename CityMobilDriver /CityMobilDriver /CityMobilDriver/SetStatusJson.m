//
//  SetStatusJson.m
//  CityMobilDriver
//
//  Created by Intern on 11/19/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "SetStatusJson.h"
#import "SingleDataProvider.h"

@implementation SetStatusJson

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
        self.method=@"SetStatus";
        self.key=[[SingleDataProvider sharedKey]key];
    }
    return self;
}

@end
