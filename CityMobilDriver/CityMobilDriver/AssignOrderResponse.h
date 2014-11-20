//
//  AssignOrderResponse.h
//  CityMobilDriver
//
//  Created by Intern on 11/13/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface AssignOrderResponse : JSONModel
@property(nonatomic,strong)NSString*code;
@property(strong,nonatomic)NSString*text;
@property(strong,nonatomic)NSNumber*result;
@end
