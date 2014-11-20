//
//  MessagesCell.h
//  CityMobilDriver
//
//  Created by Intern on 11/11/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"

@interface MessagesCell : UITableViewCell
@property (strong, nonatomic) IBOutlet CustomLabel *titLabel;



@property (strong, nonatomic) IBOutlet UILabel *dateLabel;


@end
