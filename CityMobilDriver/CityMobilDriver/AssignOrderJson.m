//
//  AssignOrderJson.m
//  CityMobilDriver
//
//  Created by Intern on 11/13/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "AssignOrderJson.h"
#import "SingleDataProvider.h"
@implementation AssignOrderJson
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.ipass=@"o3XOFR7xpv";
        self.ilog=@"cm-api";
        self.locale=@"ru";
        self.method=@"AssignOrder";
        self.version=@"1.0.2";
        self.key=[[SingleDataProvider sharedKey]key];
    }
    return self;
}
@end
