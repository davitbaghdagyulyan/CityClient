//
//  CityClass.h
//  CityMobilDriver
//
//  Created by Intern on 11/3/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "IncludedClass.h"
#import "OtherCityClass.h"
#import "CurrencyClass.h"
#import "MinPriceClass.h"

@interface CityClass : JSONModel

@property(nonatomic,strong)NSString*text;
@property(nonatomic,strong)IncludedClass*Included;
@property(nonatomic,strong)OtherCityClass*Other;
@property(nonatomic,strong)CurrencyClass*Currency;
@property(nonatomic,strong)MinPriceClass*MinPrice;

@end
