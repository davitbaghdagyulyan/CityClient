//
//  IntervalClass.h
//  CityMobilDriver
//
//  Created by Intern on 11/3/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface IntervalClass : JSONModel

@property(nonatomic,strong)NSString*start;
@property(nonatomic,strong)NSString*end;
@property(nonatomic,strong)NSString*text;

@end
