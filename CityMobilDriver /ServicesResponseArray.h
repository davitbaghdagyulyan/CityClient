//
//  ServicesResponseArray.h
//  CityMobilDriver
//
//  Created by Intern on 12/5/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "IntervalsArray.h"
#import "ServicesArray.h"

@protocol ServicesResponseArray @end

@interface ServicesResponseArray : JSONModel
@property (nonatomic,strong) NSArray<IntervalsArray>* intervals;
@property (nonatomic,strong) NSArray<ServicesArray>* services;//
@end
