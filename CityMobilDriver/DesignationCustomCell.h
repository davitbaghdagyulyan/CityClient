//
//  DesignationCustomCell.h
//  CityMobilDriver
//
//  Created by Intern on 11/10/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"

@interface DesignationCustomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet CustomLabel *designationLabel;
@property (strong, nonatomic) IBOutlet UIImageView *designationImageView;
@property (strong, nonatomic) IBOutlet UIView *viewForImage;
@property (strong, nonatomic) IBOutlet UIView *designationView;

@end
