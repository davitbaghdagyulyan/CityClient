//
//  TariffCustomCell.h
//  CityMobilDriver
//
//  Created by Intern on 11/5/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"

@interface TariffCustomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet CustomLabel *priceLabel;
@property (strong, nonatomic) IBOutlet CustomLabel *txtLabel;

@end
