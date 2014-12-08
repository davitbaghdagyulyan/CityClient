//
//  DescriptionClass.h
//  CityMobilDriver
//
//  Created by Intern on 11/3/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "IntervalElements.h"
#import "CommonOverPriceClass.h"

@interface DescriptionClass : JSONModel

@property(nonatomic,strong)CommonOverPriceClass*CommonOverPrice;
@property(nonatomic,strong)NSString*text;
@property(nonatomic,strong)NSMutableArray<IntervalElements>*Interval;

@end
