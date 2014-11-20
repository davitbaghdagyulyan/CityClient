//
//  RequestUpdateAutoSettings.m
//  CityMobilDriver
//
//  Created by Intern on 11/19/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "RequestUpdateAutoSettings.h"
#import "SingleDataProvider.h"

@implementation RequestUpdateAutoSettings
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.settings = [[Settings alloc]init];
        
        self.versions = [[NSDictionary alloc]initWithObjects:@[@"versionCode",@"sdkVersion",@"versionName"] forKeys:@[@"19",@"17",@"2.9"]];
        
        self.method = @"UpdateAutoSettings";
        self.ipass = @"o3XOFR7xpv";
        self.ilog = @"cm-api";
        self.locale = @"ru";
        self.version = @"1.0.2";
        self.key = [SingleDataProvider sharedKey].key;
    }
    return self;
}

@end



