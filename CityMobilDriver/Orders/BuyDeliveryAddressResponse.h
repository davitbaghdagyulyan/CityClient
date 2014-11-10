//
//  BuyDeliveryAddressResponse.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 11/5/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "BuyDeliveryAddressElements.h"

@interface BuyDeliveryAddressResponse : JSONModel
//@property (nonatomic,strong)NSMutableArray<BuyDeliveryAddressElements>*lalala;
@property(nonatomic,strong)NSString*code;
@end
