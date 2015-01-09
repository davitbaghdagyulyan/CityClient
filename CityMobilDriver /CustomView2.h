//
//  CustomView2.h
//  CityMobilDriver
//
//  Created by Intern on 1/8/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//
@protocol view1_2Delegate

-(void)setDriverPayment;

@end
#import <UIKit/UIKit.h>

@interface CustomView2 : UIView
- (IBAction)replenishmentAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIView *cardsView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *chooseCardLabel;
@property (weak, nonatomic) IBOutlet UIButton *replenishmentButton;
@property(weak,nonatomic)id<view1_2Delegate> delegate;
@end
