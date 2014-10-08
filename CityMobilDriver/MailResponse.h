//
//  MailResponse.h
//  CityMobilDriver
//
//  Created by Intern on 10/7/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "MailElements.h"

@interface MailResponse : JSONModel

@property (nonatomic,strong)NSMutableArray<MailElements>*mail;
@property(nonatomic,strong)NSString*code;

@end
