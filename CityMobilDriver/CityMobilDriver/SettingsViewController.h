//
//  SettingsViewController.h
//  CityMobilDriver
//
//  Created by Intern on 10/10/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "UserInformationProvider.h"
#import "CustomTableViewCell.h"
#import "LeftMenu.h"
#import "RequestSetAutoget.h"
#import "RequestSetYandexAutoget.h"
@interface SettingsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scrolView;

@property (weak, nonatomic) IBOutlet UILabel *callsign;
@property (weak, nonatomic) IBOutlet UILabel *balance;

@property (weak, nonatomic) IBOutlet UILabel *limit;

- (IBAction)nightModeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *nightMode;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;






@property (weak, nonatomic) IBOutlet UIButton *required;
- (IBAction)requiredAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *notRequired;
- (IBAction)notRequiredAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *off;
- (IBAction)offAction:(id)sender;



@property (weak, nonatomic) IBOutlet UIButton *on;
- (IBAction)onAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *yandexOff;
- (IBAction)yandexOffAction:(id)sender;



@property (weak, nonatomic) IBOutlet UILabel *settings;

@property (weak, nonatomic) IBOutlet UILabel *yandexSettings;


- (IBAction)fontSize:(id)sender;
- (IBAction)stileIcon:(id)sender;
- (IBAction)selectLanguage:(id)sender;



- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;

@end
