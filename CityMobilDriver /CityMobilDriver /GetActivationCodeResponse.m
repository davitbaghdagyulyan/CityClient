//
//  GetActivationCodeResponse.m
//  CityMobilDriver
//
//  Created by Intern on 11/5/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "GetActivationCodeResponse.h"

@implementation GetActivationCodeResponse
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(void)dealloc{
    if (self.code) {
        UIAlertView* errorAlert = [[UIAlertView alloc]initWithTitle:nil message:self.text delegate:self.delegate cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }
}

@end
