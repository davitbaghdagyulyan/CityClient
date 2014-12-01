//
//  StatisticsViewController.h
//  CityMobilDriver
//
//  Created by Intern on 10/29/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetInfoJson.h"
#import "GetInfoResponse.h"

@interface StatisticsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *statisticsScrollView;
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
- (IBAction)back:(id)sender;
@property (nonatomic,weak) IBOutlet UIButton* yandexButton;
@property (nonatomic,weak) IBOutlet UIButton* cityButton;
@end
