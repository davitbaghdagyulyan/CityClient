//
//  InfoElements.h
//  CityMobilDriver
//
//  Created by Intern on 10/29/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//
@protocol  InfoElements @end

#import "JSONModel.h"

@interface InfoElements : JSONModel

@property(nonatomic,strong,getter=getTitle)NSString*title;
@property(nonatomic,strong)NSMutableArray*texts;

@end
