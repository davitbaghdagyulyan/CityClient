//
//  Sities.h
//  CityMobilDriver
//
//  Created by Intern on 11/7/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
@protocol Sities @end
@interface Sities : JSONModel
@property (nonatomic,assign,getter=getId) int id;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* country;
@property (nonatomic,strong) NSString* phone;

@property (nonatomic,assign) float latitude;
@property (nonatomic,assign) float longitude;

@property (nonatomic,assign,getter=getRadius) float radius;
@property (nonatomic,strong) NSString* gmt;
@property (nonatomic,strong) NSString* api_url;
//@property (nonatomic,strong) NSString* application_behavior;
//@property (nonatomic,strong) NSString* sound_notification_on_new_order;
@end