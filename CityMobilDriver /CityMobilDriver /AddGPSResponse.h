//
//  AddGPSResponse.h
//  CityMobilDriver
//
//  Created by Intern on 12/4/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface AddGPSResponse : JSONModel

@property(nonatomic,strong)NSString*result;
@property(nonatomic,strong)NSString*autoget;
@property(nonatomic,strong)NSString*y_autoget;
@property(nonatomic,strong)NSString*sleep;
@property(nonatomic,strong)NSString*sleep_text;
@property(nonatomic,strong)NSString*balance;
@property(nonatomic,strong)NSString*code;
@property(nonatomic,strong)NSString*text;

@end
