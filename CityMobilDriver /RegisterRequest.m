//
//  RegisterRequest.m
//  CityMobilDriver
//
//  Created by Intern on 11/6/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "RegisterRequest.h"
#import "SingleDataProvider.h"

@implementation RegisterRequest
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.method = @"Register";
        self.ipass = @"o3XOFR7xpv";
        self.ilog = @"cm-api";
        self.locale = @"en";
        self.version = @"1.0.2";
        self.key = [SingleDataProvider sharedKey].key;
    }
    return self;
}
@end
