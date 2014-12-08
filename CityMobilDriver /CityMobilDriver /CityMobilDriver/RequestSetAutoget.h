//
//  RequestSetAutoget.h
//  CityMobilDriver
//
//  Created by Intern on 11/5/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface RequestSetAutoget : JSONModel
@property(nonatomic,strong) NSString* ipass;
@property(nonatomic,strong) NSString* ilog;
@property(nonatomic,strong) NSString* locale;
@property(nonatomic,assign) NSInteger state;
@property(nonatomic,strong) NSString* method;
@property(nonatomic,strong) NSString* key;
@property(nonatomic,strong) NSString* version;
@end