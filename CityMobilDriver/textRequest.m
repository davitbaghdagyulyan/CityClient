//
//  textRequest.m
//  CityMobilDriver
//
//  Created by Intern on 10/7/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "textRequest.h"

@implementation textRequest
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.versions = [[NSDictionary alloc]initWithObjects:@[@"versionCode",@"sdkVersion",@"versionName"] forKeys:@[@"18",@"17",@"2.8"]];
        self.method = @"GetMailTree";
        self.ipass = @"o3XOFR7xpv";
        self.ilog = @"cm-api";
        self.locale = @"en";
        self.version = @"1.0.2";
    }
    return self;
}
@end





