//
//  succeedResponse.h
//  CityMobilDriver
//
//  Created by Intern on 11/5/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface SucceedResponse : JSONModel
@property(nonatomic,assign) NSInteger result;

@property(nonatomic,strong)NSString* text;
@property(nonatomic,strong)NSString* code;
@end
