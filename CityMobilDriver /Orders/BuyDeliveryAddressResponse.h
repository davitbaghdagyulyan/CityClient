//
//  BuyDeliveryAddressResponse.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 11/5/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
@interface BuyDeliveryAddressResponse : JSONModel
@property(nonatomic,strong)NSString*result;
@property(nonatomic,strong)NSString*code;
@property(nonatomic,strong)NSString *text;
@end
