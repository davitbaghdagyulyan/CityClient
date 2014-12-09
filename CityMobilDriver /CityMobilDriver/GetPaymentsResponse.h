//
//  GetPaymentsResponse.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 12/3/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "GetPaymentElements.h"

@interface GetPaymentsResponse : JSONModel
@property(nonatomic,strong)NSMutableArray <GetPaymentElements>*result;
@property(nonatomic,copy)NSString* text;
@property(nonatomic,copy)NSString*code;
@end
