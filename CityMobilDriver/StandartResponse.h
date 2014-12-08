//
//  StandartResponse.h
//  CityMobilDriver
//
//  Created by Intern on 11/19/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONModel.h"

@interface StandartResponse : JSONModel
@property (nonatomic,strong) NSString* code;
@property (nonatomic,strong) NSString* text;
@end
