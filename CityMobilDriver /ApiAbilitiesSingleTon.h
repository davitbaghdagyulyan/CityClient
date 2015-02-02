//
//  ApiAbilitiesSingleTon.h
//  CityMobilDriver
//
//  Created by Intern on 1/30/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiAbilitiesSingleTon : NSObject

@property(nonatomic,assign)NSInteger api_registration_enabled;
@property(nonatomic,assign)NSInteger messages_enabled;
@property(nonatomic,assign)NSInteger managers_calling_enabled;
@property(nonatomic,assign)NSInteger autoassignment_enabled;
@property(nonatomic,assign)NSInteger yandex_enabled;
@property(nonatomic,assign)NSInteger new_order_notification_enabled;
@property(nonatomic,assign)NSInteger statistics_enabled;
@property(nonatomic,assign)NSInteger calculate_wait_time_enabled;

+(ApiAbilitiesSingleTon*)sharedApiAbilities;
@end
