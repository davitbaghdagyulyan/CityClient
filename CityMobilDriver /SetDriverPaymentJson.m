//
//  SetDriverPaymentJson.m
//  CityMobilDriver
//
//  Created by Intern on 1/9/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import "SetDriverPaymentJson.h"

@implementation SetDriverPaymentJson
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.ipass=@"o3XOFR7xpv";
        self.ilog=@"cm-api";
        self.locale=@"ru";
        self.method=@"setDriverPayment";
        self.version=@"1.0.2";
        self.key=[[SingleDataProvider sharedKey]key];
    }
    return self;
}
@end
