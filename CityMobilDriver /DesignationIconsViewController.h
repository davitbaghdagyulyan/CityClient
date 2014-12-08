//
//  DesignationIconsViewController.h
//  CityMobilDriver
//
//  Created by Intern on 11/7/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DesignationIconsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *designationTableView;
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
- (IBAction)back:(id)sender;
@property (nonatomic,weak) IBOutlet UIButton* yandexButton;
@property (nonatomic,weak) IBOutlet UIButton* cityButton;
- (IBAction)openMap:(UIButton*)sender;
@end
