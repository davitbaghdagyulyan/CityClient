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
        self.ilog=@"cm-api";
        self.key=[[SingleDataProvider sharedKey]key];
        self.method=@"BuyDeliveryAddress";
        self.version=@"1.0.2";
        self.versionCode=@"17";
        //self.idhash=;
    }
    return self;
}

@end
