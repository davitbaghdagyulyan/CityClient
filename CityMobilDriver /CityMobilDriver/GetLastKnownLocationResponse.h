//
//  GetLastKnownLocationResponse.h
//  CityMobilDriver
//
//  Created by Intern on 12/4/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface GetLastKnownLocationResponse : JSONModel
@property(nonatomic,strong)NSNumber*latitude;
@property(nonatomic,strong)NSNumber*longitude;
@property(nonatomic,strong)NSNumber*gps_time;

@property(nonatomic,strong)NSString*code;
@property(nonatomic,strong)NSString*text;
@end
