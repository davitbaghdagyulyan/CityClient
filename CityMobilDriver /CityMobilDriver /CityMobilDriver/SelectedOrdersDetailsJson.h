//
//  SelectedOrdersDetailsJson.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 10/13/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface SelectedOrdersDetailsJson : JSONModel
@property(nonatomic,strong)NSString*ipass;
@property(nonatomic,strong)NSString*key;
@property(nonatomic,strong)NSString*ilog;
@property(nonatomic,strong)NSString*method;
@property(nonatomic,strong)NSString*version;
@property(nonatomic,strong)NSDictionary * filter;
@property(nonatomic,strong)NSString * versionCode;
@end
