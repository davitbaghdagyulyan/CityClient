//
//  ResponseLogOut.h
//  CityMobilDriver
//
//  Created by Intern on 2/3/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface ResponseLogOut : JSONModel

@property(strong,nonatomic)NSString*result;
@property(strong,nonatomic)NSString*code;
@property(strong,nonatomic)NSString*text;

@end
