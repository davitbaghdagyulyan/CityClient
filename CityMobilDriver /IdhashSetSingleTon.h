//
//  IdhashSetSingleTon.h
//  CityMobilDriver
//
//  Created by Intern on 2/3/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdhashSetSingleTon : NSObject
+(void)setIdHashSet:(NSMutableSet*)set;
+(NSMutableSet*)getIdHashSet;
@end
