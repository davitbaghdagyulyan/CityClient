//
//  ServicesViewController.h
//  CityMobilDriver
//
//  Created by Intern on 12/4/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ServicesViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet GPSIcon *gpsButton;

@property (nonatomic,strong) NSString* idHash;
@property (nonatomic,strong) NSArray* selectedID;

@property (weak, nonatomic) IBOutlet UITableView *servicesTable;
- (IBAction)okAction:(UIButton *)sender;

@property (nonatomic,strong) NSString* tariff;


/// left Menu ////
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
- (IBAction)back:(id)sender;
@property (nonatomic,weak) IBOutlet UIButton* yandexButton;
@property (nonatomic,weak) IBOutlet UIButton* cityButton;
- (IBAction)openMap:(UIButton*)sender;

@end
