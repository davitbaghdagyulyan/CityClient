//
//  CardsElements.h
//  CityMobilDriver
//
//  Created by Intern on 10/23/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//
@protocol CardsElements @end

#import "JSONModel.h"

@interface CardsElements : JSONModel

@property(strong,nonatomic,getter=getMyCardId)NSString*id;
@property(strong,nonatomic,getter=getPan)NSString*pan;
@property(strong,nonatomic)NSString*cardholder;
@property(strong,nonatomic)NSString*expiration;

@end
