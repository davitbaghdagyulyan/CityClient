//
//  CustomCellSelectedOrders.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 10/9/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellSelectedOrders : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *additionalView;
@property (weak, nonatomic) IBOutlet UILabel *labelShortName0;
@property (weak, nonatomic) IBOutlet UILabel *labelPercent0;
@property (weak, nonatomic) IBOutlet UILabel *labelCallMetroName0;
@property (weak, nonatomic) IBOutlet UIView *additionalViewXib2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightAdditionalView;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCall;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewDel;
@property (weak, nonatomic) IBOutlet UIView *View1;
@property (weak, nonatomic) IBOutlet UIView *View2;
@property (weak, nonatomic) IBOutlet UIView *View3;
@property (weak, nonatomic) IBOutlet UILabel *labelShortName;
@property (weak, nonatomic) IBOutlet UILabel *labelPercent;
@property (weak, nonatomic) IBOutlet UILabel *labelCollMetroName;
@property (weak, nonatomic) IBOutlet UILabel *labelDeliveryMetroName;
@property(strong,nonatomic)NSString * callDate;
@property(strong,nonatomic)NSString * stringForSrochno;
@property(strong,nonatomic)NSString * shortName;
@property(assign,nonatomic)BOOL timerForUpdatingLabelShortNameIsCreated;
-(void)updateLabelShortName;
@end
