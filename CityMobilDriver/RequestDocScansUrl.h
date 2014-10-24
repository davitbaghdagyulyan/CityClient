//
//  RequestDocScansUrl.h
//  CityMobilDriver
//
//  Created by Intern on 10/22/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface RequestDocScansUrl : JSONModel
@property(nonatomic,strong)NSString* method;//
@property(nonatomic,strong)NSString* ipass;//
@property(nonatomic,strong)NSString* ilog;//
@property(nonatomic,strong)NSString* key;//
@property(nonatomic,strong)NSString* locale;//
@property(nonatomic,strong)NSString* version;//
@end