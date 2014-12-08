//
//  AddGPSJson.h
//  CityMobilDriver
//
//  Created by Intern on 12/4/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface AddGPSJson : JSONModel
@property(nonatomic,strong)NSString*ipass;
@property(nonatomic,strong)NSString*key;
@property(nonatomic,strong)NSString*ilog;
@property(nonatomic,strong)NSString*locale;
@property(nonatomic,strong)NSString*method;
@property(nonatomic,strong)NSString*version;
@property(nonatomic,strong)NSString*lon;
@property(nonatomic,strong)NSString*speed;
@property(nonatomic,strong)NSString*direction;
@property(nonatomic,strong)NSString*time;
@property(nonatomic,strong)NSString*lat;
@end
