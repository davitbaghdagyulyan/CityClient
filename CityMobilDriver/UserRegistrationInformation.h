//
//  UserRegistrationInformation.h
//  CityMobilDriver
//
//  Created by Intern on 11/11/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserRegistrationInformation : NSObject
@property(nonatomic,strong) NSString* bankId;
@property(nonatomic,strong) NSString* password;
+(UserRegistrationInformation*)sharedInformation;
@end
