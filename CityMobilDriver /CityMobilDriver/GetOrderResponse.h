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
@property(nonatomic,strong)NSString*CollDate;
@property(nonatomic,strong)NSString*shortname;

////// Karen change //////
@property(nonatomic,strong) NSString* CollMetroName;
@property(nonatomic,strong) NSString* DeliveryMetroName;
@property(nonatomic,strong) NSString* DeliveryComment;

@property(nonatomic,strong) NSString* CollComment;
@property(nonatomic,strong) NSString* OurComment;
@property(nonatomic,strong) NSString* tariff;

@property(nonatomic,strong)NSString* CollAddressText;
@property(nonatomic,strong)NSString* DeliveryAddressText;

@property(nonatomic,strong)NSString * name;

@property(nonatomic,strong,getter=getCollDateText)NSString*CollDateText;

@property(nonatomic,assign)NSInteger percent;
@property(nonatomic,strong)NSString * DeliveryAddrTypeMenu;
@property(nonatomic,strong)NSString * CollAddrTypeMenu;
@property(nonatomic,strong)NSString * CanBuyDeliveryAddress;
@property(nonatomic,strong,getter=getNoSmoking)NSString * NoSmoking;
@property(nonatomic,strong,getter=getG_width)NSString * g_width;
@property(nonatomic,strong,getter=getPayment_method)NSString * payment_method;
@property(nonatomic,strong,getter =getConditioner)NSString * conditioner;
@property(nonatomic,strong,getter = getAnimal)NSString * animal;
@property(nonatomic,strong,getter=getBaby_seat)NSString *baby_seat;
@property(nonatomic,strong,getter=getLuggage)NSString * luggage;
@property(nonatomic,strong,getter=getUseBonus)NSString * useBonus;
@property(nonatomic,strong,getter=getNeed_wifi)NSString *need_wifi;
@property(nonatomic,strong,getter=getYellow_reg_num)NSString * yellow_reg_num;
////// end change //////






@end



