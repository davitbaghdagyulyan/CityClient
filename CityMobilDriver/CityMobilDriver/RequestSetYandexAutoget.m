//
//  RequestSetYandexAutoget.m
//  CityMobilDriver
//
//  Created by Intern on 11/5/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "RequestSetYandexAutoget.h"
#import "SingleDataProvider.h"

@implementation RequestSetYandexAutoget
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.method = @"setAutoget";
        self.ipass = @"o3XOFR7xpv";
        self.ilog = @"cm-api";
        self.locale = @"en";
        self.version = @"1.0.2";
        self.key = [SingleDataProvider sharedKey].key;
    }
    return self;
}
@end