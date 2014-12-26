//
//  TariffsYandexViewController.h
//  CityMobilDriver
//
//  Created by Intern on 11/7/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TariffsYandexViewController : UIViewController
@property (weak, nonatomic) IBOutlet GPSIcon *gpsButton;
@property (weak, nonatomic) IBOutlet UIScrollView *tarifsYandexScrollView;
@property (nonatomic,weak) IBOutlet UIButton* yandexButton;
@property (nonatomic,weak) IBOutlet UIButton* cityButton;
- (IBAction)back:(id)sender;
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
- (IBAction)openMap:(UIButton*)sender;
@end
