//
//  ResponseSetBill.h
//  CityMobilDriver
//
//  Created by Intern on 12/9/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import <Foundation/Foundation.h>

@interface ResponseSetBill : JSONModel
@property(nonatomic,strong) NSString* result;
@property(nonatomic,strong) NSString* creditlimit;
@property(nonatomic,strong) NSString* commision;
@property(nonatomic,strong) NSString* balance;


@property(nonatomic,strong) NSString* code;
@property(nonatomic,strong) NSString* text;
@end