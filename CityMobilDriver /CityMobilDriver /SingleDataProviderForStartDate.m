//
//  SingleDataProviderForStartDate.m
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 11/7/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "SingleDataProviderForStartDate.h"

@implementation SingleDataProviderForStartDate
+(SingleDataProviderForStartDate*)sharedStartDate

{
    static SingleDataProviderForStartDate* obj = nil;
    if (obj == nil)
    {
        obj = [[super alloc] init];
        
    }
    return obj;
}

@end
