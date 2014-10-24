//
//  SelectedOrdersViewController.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 10/9/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedOrdersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableDictionary * selectedFilter;
@property(nonatomic,strong)NSString * titleString;

@property (weak, nonatomic) IBOutlet UITableView *tableViewOrdersDetails;
@property(strong,nonatomic)NSString * stringForSrochno;
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;


- (IBAction)back:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;




@end
