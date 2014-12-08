//
//  IconsColorSingltone.m
//  CityMobilDriver
//
//  Created by Intern on 11/24/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "IconsColorSingltone.h"

@implementation IconsColorSingltone
+(IconsColorSingltone*)sharedColor
{
    static IconsColorSingltone* obj = nil;
    if (obj == nil)
    {
        obj = [[super alloc] init];
        
    }
    return obj;
}
@end
