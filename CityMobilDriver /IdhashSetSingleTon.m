//
//  IdhashSetSingleTon.m
//  CityMobilDriver
//
//  Created by Intern on 2/3/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import "IdhashSetSingleTon.h"

static NSMutableSet*idhashSet;

@implementation IdhashSetSingleTon

+(void)setIdHashSet:(NSMutableSet*)set
{
    idhashSet=set;
}

+(NSMutableSet*)getIdHashSet
{
    return idhashSet;
}

@end
