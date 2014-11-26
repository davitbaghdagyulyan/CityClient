//
//  MyOrdersViewController.h
//  CityMobilDriver
//
//  Created by Intern on 11/20/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenu.h"
@interface MyOrdersViewController : UIViewController
- (IBAction)back:(id)sender;
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
-(void)setIndexOfCell:(NSUInteger)indexOf;
-(void)collMap;
-(void)deliveryMapp;
-(void)close;
-(void)openYandexMap;
-(void)openGoogleMap;
-(void)toTakeAction;
@end
