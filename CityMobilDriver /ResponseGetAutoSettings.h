//
//  ResponseGetAutoSettings.h
//  CityMobilDriver
//
//  Created by Intern on 11/17/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "Tariffs.h"

@interface ResponseGetAutoSettings : JSONModel
@property (nonatomic,assign) BOOL smoking;
@property (nonatomic,assign) BOOL conditioner;
@property (nonatomic,assign) BOOL animal;
@property (nonatomic,assign) BOOL has_check;
@property (nonatomic,assign) BOOL has_wifi;
@property (nonatomic,assign) BOOL has_card;//nsstring

@property (nonatomic, strong) NSArray* child_seat;

@property (nonatomic,assign) NSInteger radius;
@property (nonatomic,assign) NSInteger collminute;

@property (nonatomic, strong) NSArray* tariffs;

@property (nonatomic,assign) NSInteger max_radius;
@property (nonatomic,assign) NSInteger max_collminute;


@property (nonatomic,strong) NSArray<Tariffs>* possible_tariffs;

@property(nonatomic,strong) NSString* code;
@property(nonatomic,strong) NSString* text;

@end