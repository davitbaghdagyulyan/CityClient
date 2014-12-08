//
//  NSDictionary+BVJSONString.h
//  CityMobilDriver
//
//  Created by Intern on 10/31/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (BVJSONString)
-(NSString*)bv_jsonStringWithPrettyPrint:(BOOL)prettyPrint;
@end