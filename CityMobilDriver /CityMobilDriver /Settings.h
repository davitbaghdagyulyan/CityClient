//
//  Settings.h
//  CityMobilDriver
//
//  Created by Intern on 11/19/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "Tariffs.h"
@interface Settings : JSONModel
@property (nonatomic,assign) BOOL animal;
@property (nonatomic,assign) BOOL conditioner;
@property (nonatomic,assign) NSInteger radius;
@property (nonatomic,assign) BOOL smoking;
@property (nonatomic, strong) NSArray* child_seat;
@property (nonatomic,assign) NSInteger collminute;
@property (nonatomic, strong) NSArray* tariffs;
@property (nonatomic,assign) BOOL has_card;
@property (nonatomic,assign) BOOL has_check;
@property (nonatomic,assign) BOOL has_wifi;
@property (nonatomic,assign) NSInteger max_collminute;
@property (nonatomic,assign) NSInteger max_radius;
@property (nonatomic,strong) NSArray* possible_tariffs;

@end


/*
"settings": "{\"animal\":0,\"conditioner\":0,\"radius\":5,\"smoking\":1,\"child_seat\":[3,7],\"collminute\":30,\"tariffs\":[\"2\",\"13\",\"1\",\"112\",\"110\"],\"has_card\":1,\"has_check\":0,\"has_wifi\":1,\"max_collminute\":0,\"max_radius\":0,\"possible_tariffs\":null}"
*/