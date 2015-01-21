//
//  Order.h
//  CityMobilDriver
//
//  Created by Intern on 1/19/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface Order : JSONModel

@property(nonatomic,strong)NSString*idhash;
@property(nonatomic,strong)NSString*shortname;
@property(nonatomic,strong)NSString*CollTime;
@property(nonatomic,strong)NSString*CollAddressText;
@property(nonatomic,strong)NSString*DeliveryAddressText;

@property(nonatomic,strong)NSString*OrderComment;
@property(nonatomic,strong)NSString*canReject;
@property(nonatomic,strong)NSString*isYandexOrder;

@end
