//
//  RecallResponse.h
//  CityMobilDriver
//
//  Created by Intern on 10/9/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface RecallResponse : JSONModel
@property(strong,nonatomic)NSString*text;
@property(strong,nonatomic)NSNumber*result;
@property(strong,nonatomic)NSString*code;
@end
