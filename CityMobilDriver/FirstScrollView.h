//
//  FirstScrollView.h
//  CityMobilDriver
//
//  Created by Intern on 10/24/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfilViewController.h"
@interface FirstScrollView : UIScrollView
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
@property(nonatomic,strong)ProfilViewController*curentViewController;
@end
