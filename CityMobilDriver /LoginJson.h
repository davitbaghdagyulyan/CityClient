//
//  LoginJson.h
//  RequestForLogin
//
//  Created by Intern on 9/30/14.
//  Copyright (c) 2014 1. All rights reserved.
//

#import "JSONModel.h"

@interface LoginJson : JSONModel
@property(nonatomic,strong)NSString*ipass;
@property(nonatomic,strong)NSString*bankid;
@property(nonatomic,strong)NSString*ilog;
@property(nonatomic,strong)NSString*locale;
@property(nonatomic,strong)NSString*method;
@property(nonatomic,strong)NSString*pass;
@property(nonatomic,strong)NSString*version;
@property(nonatomic,strong)NSDictionary*versions;
@end
