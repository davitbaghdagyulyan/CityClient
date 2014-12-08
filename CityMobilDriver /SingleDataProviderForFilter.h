//
//  SingleDataProviderForFilter.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 10/13/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleDataProviderForFilter : NSObject
@property(nonatomic,strong) NSDictionary* filter;
+(SingleDataProviderForFilter*)sharedFilter;

@end