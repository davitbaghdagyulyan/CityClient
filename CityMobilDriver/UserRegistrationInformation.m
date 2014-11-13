//
//  UserRegistrationInformation.m
//  CityMobilDriver
//
//  Created by Intern on 11/11/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "UserRegistrationInformation.h"

@implementation UserRegistrationInformation
+(UserRegistrationInformation*)sharedInformation

{
    static UserRegistrationInformation* obj = nil;
    if (obj == nil)
    {
        obj = [[super alloc] init];
    }
    return obj;
}
@end
