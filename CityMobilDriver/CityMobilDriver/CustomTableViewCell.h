//
//  CustomTableViewCell.h
//  CityMobilDriver
//
//  Created by Intern on 10/16/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellText;
@property (weak, nonatomic) IBOutlet UIImageView *selectedCell;

@end
