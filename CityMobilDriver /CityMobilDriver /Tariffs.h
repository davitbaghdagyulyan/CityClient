//
//  Tariffs.h
//  CityMobilDriver
//
//  Created by Intern on 11/19/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
@protocol Tariffs @end
@interface Tariffs : JSONModel
@property (nonatomic, strong,getter=getId) NSString* id;
@property (nonatomic, strong) NSString* name;
@end
