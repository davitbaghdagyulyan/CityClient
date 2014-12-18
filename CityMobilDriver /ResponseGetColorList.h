//
//  ResponseGetColorList.h
//  CityMobilDriver
//
//  Created by Intern on 10/30/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "Colors.h"

@interface ResponseGetColorList : JSONModel
@property(nonatomic,strong) NSArray<Colors>* colors;


@property(nonatomic,strong) NSString* text;
@property(nonatomic,strong) NSString* code;
@end
