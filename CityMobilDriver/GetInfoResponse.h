//
//  GetInfoResponse.h
//  CityMobilDriver
//
//  Created by Intern on 10/29/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "InfoElements.h"

@interface GetInfoResponse : JSONModel

@property(assign,nonatomic)NSInteger balance;
@property(strong,nonatomic)NSString*credit_limit;
@property(strong,nonatomic)NSString*bankid;
@property(strong,nonatomic)NSMutableArray<InfoElements>*info;

@property(nonatomic,strong)NSString*code;
@property(strong,nonatomic)NSString*text;

@end
