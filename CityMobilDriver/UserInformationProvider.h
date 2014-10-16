//
//  UserInformationProvider.h
//  CityMobilDriver
//
//  Created by Intern on 10/10/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInformationProvider : NSObject
@property(nonatomic,strong) NSString* balance;
@property(nonatomic,strong) NSString* credit_limit;
@property(nonatomic,strong) NSString* bankid;
+(UserInformationProvider*)sharedInformation;
@end