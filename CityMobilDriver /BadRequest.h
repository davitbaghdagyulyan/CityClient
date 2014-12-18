//
//  BadRequest.h
//  CityMobilDriver
//
//  Created by Intern on 12/18/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BadRequest : NSObject
-(void) showErrorAlertMessage:(NSString*)message code:(NSString*)code;
@property (nonatomic,weak) UIViewController* delegate;

@end
