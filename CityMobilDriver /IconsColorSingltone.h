//
//  IconsColorSingltone.h
//  CityMobilDriver
//
//  Created by Intern on 11/24/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IconsColorSingltone : NSObject
@property(nonatomic,assign) NSInteger yandexColor;
@property(nonatomic,assign) NSInteger cityMobilColor;
+(IconsColorSingltone*)sharedColor;
@end
