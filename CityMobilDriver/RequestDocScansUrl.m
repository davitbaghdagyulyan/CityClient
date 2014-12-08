//
//  RequestDocScansUrl.m
//  CityMobilDriver
//
//  Created by Intern on 10/22/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "RequestDocScansUrl.h"

@implementation RequestDocScansUrl
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.method = @"getDocScansUrl";
        self.ipass = @"o3XOFR7xpv";
        self.ilog = @"cm-api";
        self.locale = @"en";
        self.version = @"1.0.2";
    }
    return self;
}
@end
