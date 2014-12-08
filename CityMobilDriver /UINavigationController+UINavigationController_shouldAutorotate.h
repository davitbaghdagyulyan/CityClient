//
//  UINavigationController+UINavigationController_shouldAutorotate.h
//  CityMobilDriver
//
//  Created by Intern on 9/24/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (UINavigationController_shouldAutorotate)
-(BOOL) shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;
@end
