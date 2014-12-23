//
//  ResponseGetCarInfo.h
//  CityMobilDriver
//
//  Created by Intern on 11/4/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface ResponseGetCarInfo : JSONModel
@property(nonatomic,strong) NSString* id_car;
@property(nonatomic,strong) NSString* id_mark;
@property(nonatomic,strong) NSString* mark;
@property(nonatomic,strong) NSString* id_model;
@property(nonatomic,strong) NSString* model;
@property(nonatomic,strong) NSString* year;
@property(nonatomic,strong) NSString* id_color;
@property(nonatomic,strong) NSString* color;
@property(nonatomic,strong) NSString* rgb;
@property(nonatomic,strong) NSString* VIN;
@property(nonatomic,strong) NSString* car_license_pref;
@property(nonatomic,strong) NSString* car_license_number;
@property(nonatomic,strong) NSString* reg_num;


@property(nonatomic,strong) NSString* text;
@property(nonatomic,strong) NSString* code;
@end