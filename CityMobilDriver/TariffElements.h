//
//  TariffElements.h
//  CityMobilDriver
//
//  Created by Intern on 11/3/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

@protocol TariffElements @end

#import "JSONModel.h"
#import "DescriptionClass.h"
#import "NameClass.h"
#import "IdClass.h"

@interface TariffElements : JSONModel

@property(nonatomic,strong)NSString*text;
@property(nonatomic,strong)DescriptionClass*Description;
@property(nonatomic,strong)NameClass*Name;
@property(nonatomic,strong)IdClass*Id;
@end
