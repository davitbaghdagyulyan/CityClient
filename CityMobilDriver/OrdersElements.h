//
//  OrdersElements.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 10/8/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//



@protocol OrdersElements @end
#import "JSONModel.h"

@interface OrdersElements : JSONModel
@property(nonatomic,strong,getter=getName)NSString*name;
@property(nonatomic,strong,getter= getCount)NSString*count;
@property(nonatomic,strong,getter=getFilter)NSMutableDictionary * filter;

@end
