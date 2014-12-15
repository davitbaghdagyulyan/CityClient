//
//  ServicesArray.h
//  CityMobilDriver
//
//  Created by Intern on 12/5/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@protocol ServicesArray @end

@interface ServicesArray : JSONModel
@property (nonatomic,strong) NSString* title;
@property (nonatomic,strong) NSString* price;
@property (nonatomic,strong, getter=getID) NSString* id;
@end
