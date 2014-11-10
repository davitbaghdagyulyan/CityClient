//
//  RegisterRequest.h
//  CityMobilDriver
//
//  Created by Intern on 11/6/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface RegisterRequest : JSONModel
@property(nonatomic,strong) NSString* ipass;
@property(nonatomic,strong) NSString* ilog;
@property(nonatomic,strong) NSString* locale;
@property(nonatomic,strong) NSString* method;
@property(nonatomic,strong) NSString* key;
@property(nonatomic,strong) NSString* version;
@property(nonatomic,strong) NSString* phone;
@property(nonatomic,strong) NSString* code;
@end