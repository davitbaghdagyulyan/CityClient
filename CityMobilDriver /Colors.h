//
//  Colors.h
//  CityMobilDriver
//
//  Created by Intern on 10/30/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@protocol Colors
@end

@interface Colors : JSONModel
@property(nonatomic,assign,getter=getId) NSInteger id;
@property(nonatomic,strong, getter=getColor) NSString* color;
@property(nonatomic,strong) NSString* rgb;
@end