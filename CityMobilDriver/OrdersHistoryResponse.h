//
//  OrdersHistoryResponse.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 11/7/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "OrdersHistoryElements.h"

@interface OrdersHistoryResponse : JSONModel
@property (nonatomic,strong)NSMutableArray<OrdersHistoryElements>*orders;
@property(nonatomic,strong)NSString*code;

@end
