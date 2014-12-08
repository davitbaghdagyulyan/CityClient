//
//  ScheduleClass.h
//  CityMobilDriver
//
//  Created by Intern on 11/3/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "SpanClass.h"

@interface ScheduleClass : JSONModel

@property(nonatomic,strong)SpanClass*Span;
@property(nonatomic,strong)NSString*text;
@end
