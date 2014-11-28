//
//  UnitElements.h
//  CityMobilDriver
//
//  Created by Intern on 11/3/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//
@protocol UnitElements @end

#import "JSONModel.h"

@interface UnitElements : JSONModel

@property(nonatomic,strong)NSString*id_type;
@property(nonatomic,strong,getter=getId)NSString*id;
@property(nonatomic,strong)NSString*sync_name;
@property(nonatomic,strong)NSString*name;
@property(nonatomic,strong)NSString*text;

@end
