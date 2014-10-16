//
//  UserInformationProvider.m
//  CityMobilDriver
//
//  Created by Intern on 10/10/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "UserInformationProvider.h"

@implementation UserInformationProvider
+(UserInformationProvider*)sharedInformation
{
    static UserInformationProvider* obj = nil;
    if (obj == nil)
    {
        obj = [[super alloc] init];
        
    }
    return obj;
}
@end
