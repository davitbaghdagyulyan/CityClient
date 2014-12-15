//
//  Services.h
//  CityMobilDriver
//
//  Created by Intern on 12/3/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
@protocol Services
@end

@interface Services : JSONModel
@property (nonatomic,strong,getter=getID) NSString* id;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* prices;
@end