//
//  RegisterResponse.h
//  CityMobilDriver
//
//  Created by Intern on 11/6/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface RegisterResponse : JSONModel
@property(nonatomic,assign) NSInteger result;
@property(nonatomic,assign) NSInteger isRegistered;
@property(nonatomic,strong) NSString* bankid;
@property(nonatomic,strong) NSString* password;
@property(nonatomic,assign) NSInteger driver_pass;

@property (nonatomic,strong) NSString* code;
@property (nonatomic,strong) NSString* text;
@end