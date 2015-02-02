//
//  RequestGetApiAbilities.h
//  CityMobilDriver
//
//  Created by Intern on 1/30/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface RequestGetApiAbilities : JSONModel
@property(nonatomic,strong) NSString* method;
@property(nonatomic,strong) NSString* key;
@property(nonatomic,strong) NSString* ipass;
@property(nonatomic,strong) NSString* ilog;
@property(nonatomic,strong) NSString* locale;
@property(nonatomic,strong) NSString* version;
@end
