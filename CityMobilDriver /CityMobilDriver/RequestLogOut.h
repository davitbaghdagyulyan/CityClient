//
//  RequestLogOut.h
//  CityMobilDriver
//
//  Created by Intern on 2/3/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface RequestLogOut : JSONModel
@property(nonatomic,strong)NSString*ipass;
@property(nonatomic,strong)NSString*key;
@property(nonatomic,strong)NSString*ilog;
@property(nonatomic,strong)NSString*locale;
@property(nonatomic,strong)NSString*method;
@property(nonatomic,strong)NSString*version;
@end
