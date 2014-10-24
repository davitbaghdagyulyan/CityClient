//
//  WriteLetterJson.h
//  CityMobilDriver
//
//  Created by Intern on 10/17/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface WriteLetterJson : JSONModel
@property(nonatomic,strong)NSString*text;
@property(nonatomic,strong)NSString*title;
@property(nonatomic,strong)NSString*ipass;
@property(nonatomic,strong)NSString*ilog;
@property(nonatomic,strong)NSString*id_mail;
@property(nonatomic,strong)NSString*method;
@property(nonatomic,strong)NSString*key;
@property(nonatomic,strong)NSString*version;
@property(nonatomic,strong)NSString*locale;



@end
