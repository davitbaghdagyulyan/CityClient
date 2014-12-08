//
//  SpanClass.h
//  CityMobilDriver
//
//  Created by Intern on 11/3/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "WeekdayElements.h"
#import "IntervalClass.h"

@interface SpanClass : JSONModel

@property(nonatomic,strong)NSMutableArray<WeekdayElements>* Weekday;
@property(nonatomic,strong)NSString*text;
@property(nonatomic,strong)IntervalClass*Interval;

@end
