//
//  GetOrderJson.m
//  CityMobilDriver
//
//  Created by Intern on 11/13/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "GetOrderJson.h"
#import "SingleDataProvider.h"
@implementation GetOrderJson
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.ipass=@"o3XOFR7xpv";
        self.ilog=@"cm-api";
        self.locale=@"ru";
        self.method=@"GetOrder";
        self.version=@"1.0.2";
        self.key=[[SingleDataProvider sharedKey]key];
        
    }
    return self;
}
@end
