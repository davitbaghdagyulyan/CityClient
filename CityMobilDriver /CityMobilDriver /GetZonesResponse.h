//
//  GetZonesResponse.h
//  CityMobilDriver
//
//  Created by Intern on 11/7/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "Sities.h"

@interface GetZonesResponse : JSONModel
@property (nonatomic,strong) NSArray<Sities>* zones;


@end
