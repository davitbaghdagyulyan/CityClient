//
//  UnbidCardResponse.h
//  CityMobilDriver
//
//  Created by Intern on 1/9/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface UnbidCardResponse : JSONModel
@property(nonatomic,strong) NSString* text;
@property(nonatomic,strong) NSString* code;
@property(nonatomic,strong) NSString* result;
@end
