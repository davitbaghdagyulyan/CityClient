//
//  RequestSetDriverInfo.h
//  CityMobilDriver
//
//  Created by Intern on 10/22/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface RequestSetDriverInfo : JSONModel
@property(nonatomic,strong) NSString* driver_license_class;
@property(nonatomic,strong) NSString* passport_date;
@property(nonatomic,strong) NSString* bankid;
@property(nonatomic,strong) NSString* ilog;
@property(nonatomic,strong) NSString* middle_name;
@property(nonatomic,strong) NSString* locale;
@property(nonatomic,strong) NSString* passport_address;
@property(nonatomic,strong) NSString* driver_license_number;
@property(nonatomic,strong) NSString* passport_num;
@property(nonatomic,strong) NSString* version;
@property(nonatomic,strong) NSString* driver_license_serial;
@property(nonatomic,strong) NSString* ipass;
@property(nonatomic,strong) NSString* passport_ser;
@property(nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSString* last_name;
@property(nonatomic,strong) NSString* method;
@property(nonatomic,strong) NSString* passport_who;
@property(nonatomic,strong) NSString* key;
@property(nonatomic,strong) NSMutableDictionary* versions;
@end


