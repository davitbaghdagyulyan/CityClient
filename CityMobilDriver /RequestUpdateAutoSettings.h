//
//  RequestUpdateAutoSettings.h
//  CityMobilDriver
//
//  Created by Intern on 11/19/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONModel.h"
#import "Settings.h"

@interface RequestUpdateAutoSettings : JSONModel
@property (nonatomic,strong) NSDictionary* versions;

@property(nonatomic,strong) NSString* ipass;
@property(nonatomic,strong) NSString* ilog;

@property (nonatomic,strong) Settings* settings;

@property(nonatomic,strong) NSString* locale;
@property(nonatomic,strong) NSString* method;
@property(nonatomic,strong) NSString* key;
@property(nonatomic,strong) NSString* version;



@property (nonatomic,strong) NSString* code;
@property (nonatomic,strong) NSString* text;
@end

/*
 {

 },
 "ipass": "o3XOFR7xpv",
 "ilog": "cm-api",
 "settings": "{\"animal\":0,\"conditioner\":0,\"radius\":5,\"smoking\":1,\"child_seat\":[3,7],\"collminute\":30,\"tariffs\":[\"2\",\"13\",\"1\",\"112\",\"110\"],\"has_card\":1,\"has_check\":0,\"has_wifi\":1,\"max_collminute\":0,\"max_radius\":0,\"possible_tariffs\":null}",
 "locale": "ru",
 "method": "UpdateAutoSettings",
 "key": "e4a14102b8a81aa148180af983656f27",
 "version": "1.0.2"
 }
*/