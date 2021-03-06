//
//  RobotSettingsViewController.h
//  CityMobilDriver
//
//  Created by Intern on 11/17/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RobotSettingsViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet GPSIcon *gpsButton;

@property (nonatomic,weak) IBOutlet UIButton* yandexButton;
@property (nonatomic,weak) IBOutlet UIButton* cityButton;


- (IBAction)checkBoxAction:(UIButton *)sender;
- (IBAction)okChildYear:(UIButton *)sender;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *checkBoxes;



///**** left Menu ****///
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
- (IBAction)back:(id)sender;
- (IBAction)openMap:(UIButton*)sender;
@end
