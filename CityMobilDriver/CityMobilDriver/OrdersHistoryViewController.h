//
//  OrdersHistoryViewController.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 11/6/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersHistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>



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

@end
