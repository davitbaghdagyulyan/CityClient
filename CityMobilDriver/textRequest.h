//
//  textRequest.h
//  CityMobilDriver
//
//  Created by Intern on 10/7/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface textRequest : JSONModel
@property(nonatomic,strong)NSDictionary* versions;
@property(nonatomic,strong)NSString* method;//
@property(nonatomic,strong)NSString* ipass;//
@property(nonatomic,strong)NSString* ilog;//
@property(nonatomic,strong)NSString* key;//
@property(nonatomic,strong)NSString* locale;//
@property(nonatomic,strong)NSString* version;//
@property(nonatomic,strong)NSString* id_mail;//
@end