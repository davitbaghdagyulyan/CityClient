//
//  UINavigationController+shouldAutorotate.m
//  TaxiMeterN
//
//  Created by Intern on 9/11/14.
//  Copyright (c) 2014 Intern. All rights reserved.
//

#import "UINavigationController+shouldAutorotate.h"

@implementation UINavigationController(shouldAutorotate)
-(BOOL) shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end
