//
//  Models.h
//  CityMobilDriver
//
//  Created by Intern on 10/29/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@protocol Models @end

@interface Models : JSONModel
//@property(nonatomic,assign) NSInteger id;
//@property(nonatomic,strong) NSString* model;
//@property(nonatomic,strong) NSString* class;
//@property(nonatomic,assign) NSInteger count;


@property(nonatomic,assign,getter=getId) NSInteger id;
@property(nonatomic,strong) NSString* model;
@property(nonatomic,strong,getter=getClass) NSString* class;
@property(nonatomic,assign) NSString* count;
@end