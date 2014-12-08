//
//  UINavigationController+UINavigationController_shouldAutorotate.m
//  CityMobilDriver
//
//  Created by Intern on 9/24/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "UINavigationController+UINavigationController_shouldAutorotate.h"

@implementation UINavigationController (UINavigationController_shouldAutorotate)

-(BOOL) shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


@end
