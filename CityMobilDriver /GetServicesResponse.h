//
//  GetServicesResponse.h
//  CityMobilDriver
//
//  Created by Intern on 12/5/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "ServicesResponseArray.h"

@interface GetServicesResponse : JSONModel
@property (nonatomic,strong) NSArray<ServicesResponseArray>* responseArray;
@end
