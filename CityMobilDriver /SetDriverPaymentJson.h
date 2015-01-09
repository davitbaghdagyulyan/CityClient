//
//  SetDriverPaymentJson.h
//  CityMobilDriver
//
//  Created by Intern on 1/9/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface SetDriverPaymentJson : JSONModel
@property(nonatomic,strong)NSString*ipass;
@property(nonatomic,strong)NSString*key;
@property(nonatomic,strong)NSString*ilog;
@property(nonatomic,strong)NSString*locale;
@property(nonatomic,strong)NSString*method;
@property(nonatomic,strong)NSString*version;

@property(nonatomic,strong)NSString*sum;
@property(nonatomic,strong)NSString*id_card;

@end
