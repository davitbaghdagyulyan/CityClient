//
//  textResponse.h
//  CityMobilDriver
//
//  Created by Intern on 10/7/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "messages.h"
@interface textResponse : JSONModel
@property(nonatomic,strong) NSArray<messages>* messages;
@property(nonatomic,assign) NSInteger can_answer;


@property(nonatomic,strong) NSString* text;
@property(nonatomic,strong) NSString* code;
@end
