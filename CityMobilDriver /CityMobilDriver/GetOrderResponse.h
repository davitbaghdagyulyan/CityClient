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


////// Karen change //////
@property(nonatomic,strong) NSString* CollMetroName;
@property(nonatomic,strong) NSString* DeliveryMetroName;
@property(nonatomic,strong) NSString* DeliveryComment;
@property(nonatomic,strong) NSString* shortname;
@property(nonatomic,strong) NSString* CollComment;
@property(nonatomic,strong) NSString* OurComment;
@property(nonatomic,strong) NSString* collDate;
@property(nonatomic,strong) NSString* tariff;



@property (nonatomic,strong) NSString* payment_method;
@property (nonatomic,strong) NSString* useBonus;


////// end change //////
@end



