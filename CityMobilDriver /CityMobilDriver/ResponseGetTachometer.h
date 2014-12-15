//
//  ResponseGetTachometer.h
//  CityMobilDriver
//
//  Created by Intern on 11/28/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "Elements.h"
#import "Services.h"
@interface ResponseGetTachometer : JSONModel
@property (nonatomic,strong) NSArray<Services>* services;
@property (nonatomic,strong) NSArray<Elements>* elements;


@property (nonatomic,assign) NSInteger waitTime;
@property (nonatomic,assign) float distance;
@property (nonatomic,assign) NSInteger tripTime;
@property (nonatomic,assign) NSInteger wayPrice;
@property (nonatomic,assign) NSInteger addPrice;
@property (nonatomic,assign) NSString* km_price;
@property (nonatomic,assign) NSInteger calcOrderPrice;
@property (nonatomic,assign) NSString* ReadyForCollection;
@property (nonatomic,assign) NSString* ClientCollected;
@property (nonatomic,assign) NSString* GoodArrived;


@property (nonatomic,strong) NSString* text;
@property (nonatomic,strong) NSString* code;
@end




