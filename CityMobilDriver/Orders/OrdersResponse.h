//
//  OrdersResponse.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 10/8/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "OrdersElements.h"
@interface OrdersResponse : JSONModel
@property (nonatomic,strong)NSMutableArray<OrdersElements>*categories;
@property(nonatomic,strong)NSString*code;
@property(nonatomic,strong)NSString* text;
@end
