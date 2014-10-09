//
//  SingleDataProvider.h
//  CityMobilDriver
//
//  Created by Intern on 10/8/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleDataProvider : NSObject
@property(nonatomic,strong) NSString* key;
+(SingleDataProvider*)sharedKey;

@end
