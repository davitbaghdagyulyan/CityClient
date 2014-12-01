//
//  SingleDataProviderForEndDate.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 11/7/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleDataProviderForEndDate : NSObject
@property(nonatomic,strong) NSString* endDate;
+(SingleDataProviderForEndDate*)sharedEndDate;
@end
