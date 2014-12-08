//
//  RequestSetCarInfo.h
//  CityMobilDriver
//
//  Created by Intern on 10/30/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface RequestSetCarInfo : JSONModel
@property(nonatomic,strong) NSString* method;
@property(nonatomic,strong) NSString* ipass;
@property(nonatomic,strong) NSString* ilog;
@property(nonatomic,strong) NSString* key;
@property(nonatomic,strong) NSString* locale;
@property(nonatomic,strong) NSString* version;

@property(nonatomic,strong) NSString* VIN;
@property(nonatomic,strong) NSString* car_license_pref;
@property(nonatomic,strong) NSString* car_license_number;
@property(nonatomic,strong) NSString* id_mark;
@property(nonatomic,strong) NSString* id_model;
@property(nonatomic,strong) NSString* reg_num;
@property(nonatomic,strong) NSString* year;
@property(nonatomic,strong) NSString* id_color;
@property(nonatomic,strong) NSString* id_car;
@end




