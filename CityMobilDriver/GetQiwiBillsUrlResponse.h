//
//  GetQiwiBillsUrlResponse.h
//  CityMobilDriver
//
//  Created by Intern on 10/21/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface GetQiwiBillsUrlResponse : JSONModel
@property(nonatomic,strong)NSString*qiwi_bills_url;
@property(nonatomic,strong)NSString*code;
@property(strong,nonatomic)NSString*text;
@end
