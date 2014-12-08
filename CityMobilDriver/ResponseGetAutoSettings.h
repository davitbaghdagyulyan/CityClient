//
//  ResponseGetAutoSettings.h
//  CityMobilDriver
//
//  Created by Intern on 11/17/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "Tariffs.h"

@interface ResponseGetAutoSettings : JSONModel
@property (nonatomic,assign) BOOL smoking;
@property (nonatomic,assign) BOOL conditioner;
@property (nonatomic,assign) BOOL animal;
@property (nonatomic,assign) BOOL has_check;
@property (nonatomic,assign) BOOL has_wifi;
@property (nonatomic,assign) BOOL has_card;//nsstring

@property (nonatomic, strong) NSArray* child_seat;

@property (nonatomic,assign) NSInteger radius;
@property (nonatomic,assign) NSInteger collminute;

@property (nonatomic, strong) NSArray* tariffs;

@property (nonatomic,assign) NSInteger max_radius;
@property (nonatomic,assign) NSInteger max_collminute;


@property (nonatomic,strong) NSArray<Tariffs>* possible_tariffs;

@end
/*
 {
 "smoking": 0,
 "conditioner": 1,
 "animal": 1,
 "has_check": "1",
 "has_wifi": 1,
 "has_card": "1",
 "child_seat": [
 1,
 2,
 3,
 4,
 5,
 6,
 7,
 8,
 9,
 10
 ],
 "radius": 5,
 "collminute": 30,
 "tariffs": [],
 "max_radius": 5,
 "max_collminute": 60,
 "possible_tariffs": []
 
 
 
 "possible_tariffs": [
 {
 "id": "2",
 "name": "Комфорт от 249 руб."
 },
 {
 "id": "13",
 "name": "Эконом от 199 руб"
 },
 {
 "id": "1",
 "name": "Трезвый водитель"
 },
 {
 "id": "112",
 "name": "Комфорт Яндекс"
 },
 {
 "id": "110",
 "name": "Эконом Яндекс"
 }
 ]
 
 
 
 
 
 }
 
 
 
 
 
 

*/