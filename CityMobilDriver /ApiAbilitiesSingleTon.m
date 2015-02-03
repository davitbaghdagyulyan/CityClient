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
        
        obj.api_registration_enabled=[[NSUserDefaults standardUserDefaults]integerForKey:@"api_registration_enabled"];
        obj.messages_enabled=[[NSUserDefaults standardUserDefaults]integerForKey:@"messages_enabled"];
        obj.managers_calling_enabled=[[NSUserDefaults standardUserDefaults]integerForKey:@"managers_calling_enabled"];
        obj.autoassignment_enabled=[[NSUserDefaults standardUserDefaults]integerForKey:@"autoassignment_enabled"];
        obj.yandex_enabled=[[NSUserDefaults standardUserDefaults]integerForKey:@"yandex_enabled"];
        obj.new_order_notification_enabled=[[NSUserDefaults standardUserDefaults]integerForKey:@"new_order_notification_enabled"];
        obj.statistics_enabled=[[NSUserDefaults standardUserDefaults]integerForKey:@"statistics_enabled"];
        obj.calculate_wait_time_enabled=[[NSUserDefaults standardUserDefaults]integerForKey:@"calculate_wait_time_enabled"];

    }
    
    return obj;
}

@end
