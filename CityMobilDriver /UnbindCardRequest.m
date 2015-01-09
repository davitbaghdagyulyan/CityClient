//
//  UnbindCardRequest.m
//  CityMobilDriver
//
//  Created by Intern on 1/9/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import "UnbindCardRequest.h"

@implementation UnbindCardRequest
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.key = [SingleDataProvider sharedKey].key;
        self.method = @"unbindcard";
        self.ipass = @"o3XOFR7xpv";
        self.ilog = @"cm-api";
        self.locale = @"en";
        self.version = @"1.0.2";
    }
    return self;
}
@end
