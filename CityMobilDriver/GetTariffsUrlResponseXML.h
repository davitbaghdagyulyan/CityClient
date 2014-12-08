//
//  GetTariffsUrlResponseXML.h
//  CityMobilDriver
//
//  Created by Intern on 10/31/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "TariffsClass.h"

@interface GetTariffsUrlResponseXML : JSONModel
@property(nonatomic,strong)TariffsClass*Tariffs;
@end
