//
//  RequestGetTaximeter.m
//  CityMobilDriver
//
//  Created by Intern on 11/27/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "RequestGetTaximeter.h"
#import "SingleDataProvider.h"

@implementation RequestGetTaximeter
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.idhash = @"9fd8d79078b835b82c6b3c388def167a";
        self.method = @"GetTaximeter";
        self.ipass = @"o3XOFR7xpv";
        self.ilog = @"cm-api";
        self.locale = @"ru";
        self.version = @"1.0.2";
        self.elements = -1;
        self.key = [SingleDataProvider sharedKey].key;
    }
    return self;
}
@end







