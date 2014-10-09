//
//  LoginResponse.h
//  RequestForLogin
//
//  Created by Intern on 9/30/14.
//  Copyright (c) 2014 1. All rights reserved.
//

#import "JSONModel.h"

@interface LoginResponse : JSONModel
@property (nonatomic,strong)NSString*key;
@property (nonatomic,strong)NSString*code;
@end
