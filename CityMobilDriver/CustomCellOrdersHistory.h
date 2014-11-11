//
//  CustomCellOrdersHistory.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 11/6/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellOrdersHistory : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelShortName;
@property (weak, nonatomic) IBOutlet UILabel *callMetroName;
@property (weak, nonatomic) IBOutlet UILabel *deliveryMetroName;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@end
