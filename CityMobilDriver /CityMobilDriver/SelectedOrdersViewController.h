//
//  SelectedOrdersViewController.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 10/9/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SelectedOrdersTableViewHandler.h"


@interface SelectedOrdersViewController : UIViewController<UIAlertViewDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet SelectedOrdersTableViewHandler *tableViewOrdersDetails;
@property(nonatomic,strong)NSString * titleString;
@property(strong,nonatomic)NSString * stringForSrochno;
- (IBAction)actionGPS:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
- (IBAction)back:(id)sender;
-(void)collMap;
-(void)deliveryMapp;
-(void)close;
-(void)openYandexMap;
-(void)openGoogleMap;
-(void)toTakeAction;
-(void)setIndexOfCell:(NSUInteger)indexOf;
-(void)setUnderView:(UIView*)under;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(copy,nonatomic)NSString * idhash;
@property (nonatomic,weak) IBOutlet UIButton* yandexButton;
@property (nonatomic,weak) IBOutlet UIButton* cityButton;

@end
