//
//  UINavigationController+shouldAutorotate.h
//  TaxiMeterN
//
//  Created by Intern on 9/11/14.
//  Copyright (c) 2014 Intern. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (shouldAutorotate)
-(BOOL) shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;
@end
