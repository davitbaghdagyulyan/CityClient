//
//  OrdersHistoryViewController.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 11/6/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersHistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet GPSIcon *gpsButton;



@property (nonatomic,weak) IBOutlet UIButton* yandexButton;
@property (nonatomic,weak) IBOutlet UIButton* cityButton;
- (IBAction)actionGPS:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelC;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelPo;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonFind;
- (IBAction)pickFromDate:(id)sender;
- (IBAction)pickToDate:(id)sender;
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonDatePicker;
@property (weak, nonatomic) IBOutlet
UIButton *buttonIntervalTableView;
@property (weak, nonatomic) IBOutlet UILabel *labelInterval;
@property (weak, nonatomic) IBOutlet UILabel *labelSelectedDate;
- (IBAction)findOrdersFromInterval:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *GreyView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOrdersHistory;
- (IBAction)openMap:(UIButton*)sender;

@end
