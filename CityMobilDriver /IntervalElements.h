//
//  IntervalElements.h
//  CityMobilDriver
//
//  Created by Intern on 11/3/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

@protocol IntervalElements @end

#import "JSONModel.h"
#import "SuburbClass.h"
#import "TransferClass.h"
#import "ScheduleClass.h"
#import "SpecialClass.h"
#import "CityClass.h"

@interface IntervalElements : JSONModel

@property(nonatomic,strong)NSString*text;
@property(nonatomic,strong)SpecialClass*Special;
@property(nonatomic,strong)NSString*name;
@property(nonatomic,strong)ScheduleClass*Schedule;
@property(nonatomic,strong)CityClass*City;
@property(nonatomic,strong)TransferClass*Transfer;
@property(nonatomic,strong)SuburbClass*Suburb;

@end
