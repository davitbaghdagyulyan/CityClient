//
//  BindCardResponse.h
//  CityMobilDriver
//
//  Created by Intern on 10/22/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface BindCardResponse : JSONModel
@property(nonatomic,strong)NSString*code;
@property(strong,nonatomic)NSString*text;
@property(strong,nonatomic)NSString*link;
@end
