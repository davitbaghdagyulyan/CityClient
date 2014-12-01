//
//  ResponseGetMarkList.h
//  CityMobilDriver
//
//  Created by Intern on 10/29/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "Mark.h"

@interface ResponseGetMarkList : JSONModel
@property(nonatomic,strong) NSArray<Mark>* marks;
@end
