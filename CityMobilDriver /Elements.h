//
//  Elements.h
//  CityMobilDriver
//
//  Created by Intern on 11/28/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
@protocol Elements @end

@interface Elements : JSONModel
@property (nonatomic,strong, getter=getID) NSString* id;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* price;
@property (nonatomic,assign) NSInteger step;
@property (nonatomic,strong,getter=getValue) NSString* value;
@end