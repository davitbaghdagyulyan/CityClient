//
//  ResponseGetModelList.h
//  CityMobilDriver
//
//  Created by Intern on 10/29/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "Models.h"

@interface ResponseGetModelList : JSONModel
@property(nonatomic,strong) NSArray<Models>* models;

@property(nonatomic,strong) NSString* text;
@property(nonatomic,strong) NSString* code;
@end
