//
//  CardView.h
//  CityMobilDriver
//
//  Created by Intern on 1/9/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *pan;
@property (weak, nonatomic) IBOutlet UILabel *expiration;
@property (weak, nonatomic) IBOutlet UILabel *cardholder;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
