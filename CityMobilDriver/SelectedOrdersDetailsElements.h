//
//  SelectedOrdersDetailsElements.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 10/13/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

@protocol SelectedOrdersDetailsElements @end
#import "JSONModel.h"

@interface SelectedOrdersDetailsElements : JSONModel
@property(nonatomic,strong,getter=getShortname)NSString*shortname;
@property(nonatomic,strong,getter= getCollMetroName)NSString*CollMetroName;
@property(nonatomic,strong,getter=getDeliveryMetroName)NSString*DeliveryMetroName;
@property(nonatomic,strong,getter=getCollDateText)NSString*CollDateText;
@property(nonatomic,strong,getter= getPercent)NSString * percent;
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







@end
