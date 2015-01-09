//
//  SetDriverPaymentResponse.h
//  CityMobilDriver
//
//  Created by Intern on 1/9/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface SetDriverPaymentResponse : JSONModel

@property(nonatomic,strong)NSString*message;
@property(nonatomic,strong)NSString*result;

@property(nonatomic,strong)NSString*code;
@property(strong,nonatomic)NSString*text;

@end
