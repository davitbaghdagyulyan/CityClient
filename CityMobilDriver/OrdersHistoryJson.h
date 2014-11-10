//
//  OrdersHistoryJson.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 11/7/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface OrdersHistoryJson : JSONModel
@property(nonatomic,strong)NSMutableDictionary * versions;
@property(nonatomic,strong)NSString * ipass;
@property(nonatomic,strong)NSString * start;
@property(nonatomic,strong)NSString * ilog;
@property(nonatomic,strong)NSString * locale;
@property(nonatomic,strong)NSString * method;
@property(nonatomic,strong)NSString * end;
@property(nonatomic,strong)NSString * key;
@property(nonatomic,strong)NSString * version;


@end
