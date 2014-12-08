//
//  DestinationElements.h
//  CityMobilDriver
//
//  Created by Intern on 11/3/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//
@protocol DestinationElements @end

#import "JSONModel.h"
#import "SourceElements.h"

@interface DestinationElements : JSONModel

@property(nonatomic,strong)NSString*type;
@property(nonatomic,strong)NSString*name;
@property(nonatomic,strong)NSString*text;
@property(nonatomic,strong)NSMutableArray<SourceElements,Ignore>*Source;


@end
