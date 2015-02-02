//
//  RequestGetApiAbilities.m
//  CityMobilDriver
//
//  Created by Intern on 1/30/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import "RequestGetApiAbilities.h"

@implementation RequestGetApiAbilities
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.ipass=@"o3XOFR7xpv";
        self.ilog=@"cm-api";
        self.locale=@"ru";
        self.method=@"getApiAbilities";
        self.version=@"1.0.2";
        self.key = [SingleDataProvider sharedKey].key;
    }
    return self;
}
@end
