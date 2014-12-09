//
//  CustomCell.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 10/3/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *underView;
@property (weak, nonatomic) IBOutlet UIView *View2;
@property (weak, nonatomic) IBOutlet UIView *View1;

@property (strong, nonatomic) IBOutlet UILabel *label1;


@property (strong, nonatomic) IBOutlet UILabel *label2;

@end
