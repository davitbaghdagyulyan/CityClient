//
//  BuyDeliveryAddressJson.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 11/5/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface BuyDeliveryAddressJson : JSONModel
@property(nonatomic,strong)NSString*ipass;
@property(nonatomic,strong)NSString*ilog;
@property(nonatomic,strong)NSString*key;
@property(nonatomic,strong)NSString*method;
@property(nonatomic,strong)NSString*version;
@property(nonatomic,strong)NSString * versionCode;
@property(nonatomic,strong)NSString * idhash;
@end
