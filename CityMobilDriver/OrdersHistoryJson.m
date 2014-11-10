//
//  OrdersHistoryJson.m
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 11/7/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "OrdersHistoryJson.h"
#import "SingleDataProvider.h"
#import "SingleDataProviderForEndDate.h"
#import "SingleDataProviderForStartDate.h"

@implementation OrdersHistoryJson
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        NSMutableDictionary * versionsDic =[[NSMutableDictionary alloc]init];
        [versionsDic setObject:@"19" forKey:@"versionCode"];
        [versionsDic setObject:@"17" forKey:@"sdkVersion "];
        [versionsDic setObject:@"2.9" forKey:@"versionName"];
        self.versions = versionsDic;
        self.ipass = @"o3XOFR7xpv";
        self.start=[[SingleDataProviderForStartDate sharedStartDate]startDate];
        self.ilog=@"cm-api";
        self.locale = @"ru";
        self.method= @"GetCompleteOrders";
        self.end =[[SingleDataProviderForEndDate sharedEndDate]endDate];
        self.key =[[SingleDataProvider sharedKey]key];
        self.version = @"1.0.2";
    }
    return self;
}
@end
