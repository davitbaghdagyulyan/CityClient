//
//  CarInfo.h
//  CityMobilDriver
//
//  Created by Intern on 10/27/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarInfo : UIView<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *carInfoTable;
@property(nonatomic, assign) BOOL isSubview;

- (IBAction)editCarInfo:(id)sender;

@end