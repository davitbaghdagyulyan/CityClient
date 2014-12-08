//
//  SingleDataProviderForFilter.m
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 10/13/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "SingleDataProviderForFilter.h"

@implementation SingleDataProviderForFilter
+(SingleDataProviderForFilter*)sharedFilter

{
    static SingleDataProviderForFilter* obj = nil;
    if (obj == nil)
    {
        obj = [[super alloc] init];
        
    }
    return obj;
}
@end
