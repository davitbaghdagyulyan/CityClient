//
//  GetMyOrdersJson.m
//  CityMobilDriver
//
//  Created by Intern on 11/26/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "GetMyOrdersJson.h"
#import "SingleDataProvider.h"

@implementation GetMyOrdersJson
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.ipass=@"o3XOFR7xpv";
        self.ilog=@"cm-api";
        self.locale=@"ru";
        self.method=@"GetMyOrders";
        self.version=@"1.0.2";
        self.key=[[SingleDataProvider sharedKey]key];
    }
    return self;
}
@end
