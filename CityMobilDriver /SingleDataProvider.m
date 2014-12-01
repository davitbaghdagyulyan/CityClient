//
//  SingleDataProvider.m
//  CityMobilDriver
//
//  Created by Intern on 10/8/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "SingleDataProvider.h"

@implementation SingleDataProvider
+(SingleDataProvider*)sharedKey
{
    static SingleDataProvider* obj = nil;
    if (obj == nil)
    {
        obj = [[super alloc] init];
        
    }
    return obj;
}
@end
