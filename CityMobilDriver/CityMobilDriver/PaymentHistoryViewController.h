//
//  PaymentHistoryViewController.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 12/3/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentHistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *viewForGradient;
@property (strong, nonatomic) IBOutlet UITableView *PaymentsHistoryTableView;
- (IBAction)openAndCloseLeftMenu:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)refresh:(id)sender;
@property (nonatomic,weak) IBOutlet UIButton* yandexButton;
@property (nonatomic,weak) IBOutlet UIButton* cityButton;
@end
