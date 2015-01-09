//
//  CustomTableViewCell.h
//  CityMobilDriver
//
//  Created by Intern on 10/16/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"
@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet CustomLabel *cellText;
//@property (weak, nonatomic) IBOutlet Cust *cellText;
@property (weak, nonatomic) IBOutlet UIImageView *selectedCell;

@end
