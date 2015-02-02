//
//  ResponseGetApiAbilities.h
//  CityMobilDriver
//
//  Created by Intern on 1/30/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface ResponseGetApiAbilities : JSONModel

@property(strong,nonatomic)NSNumber* api_registration_enabled;
@property(strong,nonatomic)NSNumber* messages_enabled;
@property(strong,nonatomic)NSNumber* managers_calling_enabled;
@property(strong,nonatomic)NSNumber* autoassignment_enabled;
@property(strong,nonatomic)NSNumber* yandex_enabled;
@property(strong,nonatomic,getter=getNew_order_notification_enabled)NSNumber* new_order_notification_enabled;
@property(strong,nonatomic)NSNumber* statistics_enabled;
@property(strong,nonatomic)NSNumber* calculate_wait_time_enabled;

@property(nonatomic,strong) NSString* text;
@property(nonatomic,strong) NSString* code;

@end
