//
//  RequestStandart.m
//  CityMobilDriver
//
//  Created by Intern on 10/31/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "RequestStandart.h"
#import "SingleDataProvider.h"

@implementation RequestStandart
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.ipass = @"o3XOFR7xpv";
        self.ilog = @"cm-api";
        self.locale = @"ru";
        self.version = @"1.0.2";
        self.key = [SingleDataProvider sharedKey].key;
    }
    return self;
}
@end
