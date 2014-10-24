//
//  DriverAllInfoResponse.h
//  CityMobilDriver
//
//  Created by Intern on 10/23/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface DriverAllInfoResponse : JSONModel
@property(nonatomic,strong) NSString* bankid;
@property(nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSString* last_name;
@property(nonatomic,strong) NSString* middle_name;
@property(nonatomic,strong) NSString* passport_ser;
@property(nonatomic,strong) NSString* passport_num;
@property(nonatomic,strong) NSString* passport_who;
@property(nonatomic,strong) NSString* passport_date;
@property(nonatomic,strong) NSString* passport_address;
@property(nonatomic,strong) NSString* date_register;
@property(nonatomic,strong) NSString* percenttocharge;
@property(nonatomic,strong) NSString* driver_license_class;
@property(nonatomic,strong) NSString* driver_license_serial;
@property(nonatomic,strong) NSString* driver_license_number;
@property(nonatomic,strong) NSString* phone_text;
@property(nonatomic,strong) NSString* photo;
@end