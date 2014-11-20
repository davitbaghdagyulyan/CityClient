//
//  DriverAllInfoResponse.m
//  CityMobilDriver
//
//  Created by Intern on 10/23/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "DriverAllInfoResponse.h"

@implementation DriverAllInfoResponse
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

//-(void)dealloc{
//    if (self.code) {
//        UIAlertView* errorAlert = [[UIAlertView alloc]initWithTitle:nil message:self.text delegate:self.delegate cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [errorAlert show];
//    }
//}
@end
