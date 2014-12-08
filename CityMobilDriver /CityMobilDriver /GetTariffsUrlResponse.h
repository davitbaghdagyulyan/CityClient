//
//  GetTariffsUrlResponse.h
//  CityMobilDriver
//
//  Created by Intern on 10/31/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface GetTariffsUrlResponse : JSONModel

@property(nonatomic,strong)NSString*tariffs_url;
@property(nonatomic,strong)NSString*yandex_tariffs_url;

@property(nonatomic,strong)NSString*code;
@property(strong,nonatomic)NSString*text;

@end
