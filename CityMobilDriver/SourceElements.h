//
//  SourceElements.h
//  CityMobilDriver
//
//  Created by Intern on 11/3/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

@protocol SourceElements @end

#import "JSONModel.h"

@interface SourceElements : JSONModel

@property(nonatomic,strong)NSString*text;
@property(nonatomic,strong)NSString*type;
@property(nonatomic,strong)NSString*name;


@end
