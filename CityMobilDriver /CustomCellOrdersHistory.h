//
//  CustomCellOrdersHistory.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 11/6/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellOrdersHistory : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelYandexReview;
@property (weak, nonatomic) IBOutlet UIImageView *rateImgView1;
@property (weak, nonatomic) IBOutlet UIImageView *rateImgView2;
@property (weak, nonatomic) IBOutlet UIImageView *rateImgView3;
@property (weak, nonatomic) IBOutlet UIImageView *rateImgView4;
@property (weak, nonatomic) IBOutlet UIImageView *rateImgView5;
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIView *underView;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelCallMetroName;
@property (weak, nonatomic) IBOutlet UILabel *labelShortName;
@property (weak, nonatomic) IBOutlet UILabel *labelOrderDate;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *deliveryMetroName;
@end
