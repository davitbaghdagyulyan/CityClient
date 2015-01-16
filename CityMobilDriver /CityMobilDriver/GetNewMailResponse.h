//
//  GetNewMailResponse.h
//  CityMobilDriver
//
//  Created by Intern on 1/16/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface GetNewMailResponse : JSONModel
@property(strong,nonatomic)NSString*count;
@property(strong,nonatomic)NSNumber*result;
@property(strong,nonatomic)NSString*code;
@property(strong,nonatomic)NSString*text;

@end
