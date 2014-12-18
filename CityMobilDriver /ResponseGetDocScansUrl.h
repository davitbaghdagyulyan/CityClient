//
//  ResponseGetDocScansUrl.h
//  CityMobilDriver
//
//  Created by Intern on 10/22/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface ResponseGetDocScansUrl : JSONModel
@property(nonatomic,strong) NSString* doc_scans_url;
@property(nonatomic,strong) NSString* text;
@property(nonatomic,strong) NSString* code;
@end
