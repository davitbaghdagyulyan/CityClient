//
//  MyOrdersViewController.h
//  CityMobilDriver
//
//  Created by Intern on 11/20/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenu.h"
#import "SelectedOrdersTableViewHandler.h"
#import "GetLastKnownLocationJson.h"
#import "GetLastKnownLocationResponse.h"
@interface MyOrdersViewController : UIViewController
@property (weak, nonatomic) IBOutlet GPSIcon *gpsButton;
@property (strong, nonatomic) IBOutlet UITableView *myOrdersTableView;

- (IBAction)back:(id)sender;
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
-(void)setIndexOfCell:(NSUInteger)indexOf;
-(void)setUnderView:(UIView*)under;
-(void)collMap;
-(void)deliveryMapp;
-(void)close;
-(void)openYandexMap;
-(void)openGoogleMap;
-(void)closeOrderAction;
-(void)toOrderAction;
@property (nonatomic,weak) IBOutlet UIButton* yandexButton;
@property (nonatomic,weak) IBOutlet UIButton* cityButton;
- (IBAction)openMap:(UIButton*)sender;
@end
