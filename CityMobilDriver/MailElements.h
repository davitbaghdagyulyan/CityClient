//
//  MailElements.h
//  CityMobilDriver
//
//  Created by Intern on 10/7/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//
@protocol MailElements @end
#import "JSONModel.h"

@interface MailElements : JSONModel
@property(nonatomic,strong)NSString*id;
@property(nonatomic,strong,getter=getDate)NSString*date;
@property(nonatomic,strong,getter=getTitle)NSString*title;
@property(nonatomic,strong)NSString*check;

@end
