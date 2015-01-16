//
//  GetNewMailJson.m
//  CityMobilDriver
//
//  Created by Intern on 1/16/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import "GetNewMailJson.h"

@implementation GetNewMailJson
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.ipass=@"o3XOFR7xpv";
        self.ilog=@"cm-api";
        self.locale=@"ru";
        self.method=@"GetNewMail";
        self.version=@"1.0.2";
        self.key=[[SingleDataProvider sharedKey]key];
    }
    return self;
}
@end
