//
//  LoginJson.m
//  RequestForLogin
//
//  Created by Intern on 9/30/14.
//  Copyright (c) 2014 1. All rights reserved.
//

#import "LoginJson.h"
#import "JSONModelLib.h"

@implementation LoginJson

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    
    return YES;
    
}

-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.ipass=@"o3XOFR7xpv";
        self.ilog=@"cm-api";
        self.locale=@"ru";
        self.method=@"login";
        self.version=@"1.0.2";
        self.versionCode = @"17";
    }
    return self;
}
@end
