//
//  DriverInfoResponse.h
//  CityMobilDriver
//
//  Created by Intern on 10/22/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface DriverInfoResponse : JSONModel
@property(nonatomic,strong) NSString* msg;
@property(nonatomic,strong) NSString* result;//not required
@property(nonatomic,strong) NSString* code;
@property(nonatomic,strong) NSString* text;
@end
