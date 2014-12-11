//
//  SetStatusResponse.h
//  CityMobilDriver
//
//  Created by Intern on 11/19/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface SetStatusResponse : JSONModel
@property(nonatomic,strong)NSString*code;
@property(nonatomic,strong)NSString*text;
@property(nonatomic,strong)NSString*result;

@property(nonatomic,strong)NSString*message;
@property(nonatomic,strong)NSArray*statuses;


@end
