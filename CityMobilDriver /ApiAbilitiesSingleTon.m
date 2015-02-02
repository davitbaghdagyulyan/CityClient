//
//  ApiAbilitiesSingleTon.m
//  CityMobilDriver
//
//  Created by Intern on 1/30/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import "ApiAbilitiesSingleTon.h"

@implementation ApiAbilitiesSingleTon
+(ApiAbilitiesSingleTon*)sharedApiAbilities
{
    static ApiAbilitiesSingleTon* obj = nil;
    if (obj == nil)
    {
        
        obj = [[super alloc] init];
        
        obj.api_registration_enabled=(NSInteger)[[NSUserDefaults standardUserDefaults]valueForKey:@"api_registration_enabled"];
        obj.messages_enabled=(NSInteger)[[NSUserDefaults standardUserDefaults]valueForKey:@"messages_enabled"];
        obj.managers_calling_enabled=(NSInteger)[[NSUserDefaults standardUserDefaults]stringForKey:@"managers_calling_enabled"];
        obj.autoassignment_enabled=(NSInteger)[[NSUserDefaults standardUserDefaults]stringForKey:@"autoassignment_enabled"];
        obj.yandex_enabled=(NSInteger)[[NSUserDefaults standardUserDefaults]stringForKey:@"yandex_enabled"];
        obj.new_order_notification_enabled=(NSInteger)[[NSUserDefaults standardUserDefaults]stringForKey:@"new_order_notification_enabled"];
        obj.statistics_enabled=(NSInteger)[[NSUserDefaults standardUserDefaults]stringForKey:@"statistics_enabled"];
        obj.calculate_wait_time_enabled=(NSInteger)[[NSUserDefaults standardUserDefaults]stringForKey:@"statistics_enabled"];

    }
    
    return obj;
}

@end
