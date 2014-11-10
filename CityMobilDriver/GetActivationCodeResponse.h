//
//  GetActivationCodeResponse.h
//  CityMobilDriver
//
//  Created by Intern on 11/5/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface GetActivationCodeResponse : JSONModel
//@property (nonatomic,strong) NSString* bankid;
@property (nonatomic,strong) NSString* pincode;
@property (nonatomic,assign) NSInteger result;
@property (nonatomic,strong) NSString* code;
@property (nonatomic,strong) NSString* text;
@end