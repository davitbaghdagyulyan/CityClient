//
//  getQiwiBillsUrlJson.m
//  CityMobilDriver
//
//  Created by Intern on 10/21/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "getQiwiBillsUrlJson.h"
#import "SingleDataProvider.h"

@implementation GetQiwiBillsUrlJson
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.ipass=@"o3XOFR7xpv";
        self.ilog=@"cm-api";
        self.locale=@"en";
        self.method=@"getQiwiBillsUrl";
        self.version=@"1.0.2";
        self.key=[[SingleDataProvider sharedKey]key];
    }
    return self;
}
@end
