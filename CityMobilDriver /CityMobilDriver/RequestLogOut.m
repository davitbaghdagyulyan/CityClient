//
//  RequestLogOut.m
//  CityMobilDriver
//
//  Created by Intern on 2/3/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import "RequestLogOut.h"

@implementation RequestLogOut
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.ipass=@"o3XOFR7xpv";
        self.ilog=@"cm-api";
        self.locale=@"ru";
        self.method=@"logout";
        self.version=@"1.0.2";
        self.key=[[SingleDataProvider sharedKey]key];
    }
    return self;
}
@end
