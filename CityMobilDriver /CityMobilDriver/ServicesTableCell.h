//
//  ServicesTableCell.h
//  CityMobilDriver
//
//  Created by Intern on 12/5/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServicesTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkbox;

- (IBAction)checkboxAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
