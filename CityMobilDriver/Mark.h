//
//  Mark.h
//  CityMobilDriver
//
//  Created by Intern on 10/29/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
@protocol Mark
@end

@interface Mark : JSONModel
@property(nonatomic,assign,getter=getId) NSInteger id;
@property(nonatomic,strong) NSString* mark;
@end