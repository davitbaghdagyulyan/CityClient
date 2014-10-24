//
//  WriteLetterJson.m
//  CityMobilDriver
//
//  Created by Intern on 10/17/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "WriteLetterJson.h"
#import "SingleDataProvider.h"
@implementation WriteLetterJson
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.ipass=@"o3XOFR7xpv";
        self.ilog=@"cm-api";
        self.locale=@"ru";
        self.method=@"WriteLetter";
        self.version=@"1.0.2";
        self.id_mail=@"0";
        self.key=[[SingleDataProvider sharedKey]key];
       
    }
    return self;
}
@end
