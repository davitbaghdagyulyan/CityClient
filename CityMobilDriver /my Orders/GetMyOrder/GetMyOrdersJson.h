//
//  GetMyOrdersJson.h
//  CityMobilDriver
//
//  Created by Intern on 11/26/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//
#import "Versions.h"
#import "JSONModel.h"

@interface GetMyOrdersJson : JSONModel
@property(nonatomic,strong)NSString*ipass;
@property(nonatomic,strong)NSString*key;
@property(nonatomic,strong)NSString*ilog;
@property(nonatomic,strong)NSString*locale;
@property(nonatomic,strong)NSString*method;
@property(nonatomic,strong)NSString*version;
@property(nonatomic,strong)NSMutableArray<Versions>*versions;

@end
