//
//  ResponseSetCarInfo.h
//  CityMobilDriver
//
//  Created by Intern on 10/31/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface ResponseSetCarInfo : JSONModel
@property(nonatomic,strong) NSString* msg;
@property(nonatomic,strong) NSString* result;
@end
