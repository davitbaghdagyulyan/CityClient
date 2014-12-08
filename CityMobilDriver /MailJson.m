//
//  MailJson.m
//  CityMobilDriver
//
//  Created by Intern on 10/7/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "MailJson.h"
#import "SingleDataProvider.h"
@implementation MailJson
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.ipass=@"o3XOFR7xpv";
        self.ilog=@"cm-api";
        self.locale=@"en";
        self.method=@"GetMail";
        self.version=@"1.0.2";
        self.key=[[SingleDataProvider sharedKey]key];
    }
    return self;
}

@end
