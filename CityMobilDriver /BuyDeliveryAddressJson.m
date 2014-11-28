//
//  BuyDeliveryAddressJson.m
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 11/5/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "BuyDeliveryAddressJson.h"
#import "SingleDataProvider.h"

@implementation BuyDeliveryAddressJson
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.ipass=@"o3XOFR7xpv";
        self.key=[[SingleDataProvider sharedKey]key];
        self.ilog=@"cm-api";
        self.method=@"GetOrderCategories";
        self.version=@"1.0.2";
        self.versionCode=@"17";
    }
    return self;
}

@end
