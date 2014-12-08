//
//  PaymentHistoryCustomCell.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 12/3/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentHistoryCustomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labelOppDate;
@property (strong, nonatomic) IBOutlet UILabel *labelSum;
@property (strong, nonatomic) IBOutlet UILabel *labelComment;
@property(copy,nonatomic)NSString * oppDate;
@property(copy,nonatomic)NSString * sum;
@property(copy,nonatomic)NSString * comment;
-(void)updateLabels;
@end
