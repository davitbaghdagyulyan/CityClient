//
//  ReplenishmentViewController.h
//  CityMobilDriver
//
//  Created by Intern on 10/20/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenu.h"
#import "CustomView.h"

@interface ReplenishmentViewController : UIViewController<UIWebViewDelegate,view1Delegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)replenishmentSegmentedControl:(UISegmentedControl *)sender;
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
@end
