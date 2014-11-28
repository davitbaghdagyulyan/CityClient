//
//  CommonOverPriceClass.h
//  CityMobilDriver
//
//  Created by Intern on 11/3/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "UnitElements.h"

@interface CommonOverPriceClass : JSONModel

@property(nonatomic,strong)NSMutableArray<UnitElements>*Unit;
@property(nonatomic,strong)NSString*text;

@end
