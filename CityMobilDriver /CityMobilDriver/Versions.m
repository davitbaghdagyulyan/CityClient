//
//  Versions.m
//  CityMobilDriver
//
//  Created by Intern on 12/25/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "Versions.h"

@implementation Versions
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.versionCode=@19;
        self.versionName=@"2.9";
        self.sdkVersion=@17;
    }
    return self;
}
@end
