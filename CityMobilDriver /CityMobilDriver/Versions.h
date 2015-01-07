//
//  Versions.h
//  CityMobilDriver
//
//  Created by Intern on 12/25/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//
@protocol Versions @end
#import "JSONModel.h"

@interface Versions : JSONModel
@property(nonatomic,assign)NSNumber*versionCode;
@property(nonatomic,assign)NSNumber*sdkVersion;
@property(nonatomic,strong)NSString*versionName;
@end
