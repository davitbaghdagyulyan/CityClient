//
//  GetOrderResponse.h
//  CityMobilDriver
//
//  Created by Intern on 11/13/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface GetOrderResponse : JSONModel

@property(nonatomic,strong)NSString*code;
@property(nonatomic,strong)NSString*text;

@property(nonatomic,strong)NSString*ClientPhone;
@property(nonatomic,strong)NSString*ClientFullName;
@property(nonatomic,strong)NSString*ClientStars;
@property(nonatomic,strong)NSString*ClientPhoneAdditional;
@property(nonatomic,strong)NSString*status;
@property(nonatomic,strong)NSMutableArray*PossibleStatuses;

@property(nonatomic,strong)NSString*latitude;
@property(nonatomic,strong)NSString*del_latitude;
@property(nonatomic,strong)NSString*longitude;
@property(nonatomic,strong)NSString*del_longitude;
@property(nonatomic,strong)NSString*idhash;
@end
