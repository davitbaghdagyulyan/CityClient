//
//  CustomCellSelectORDER.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 10/21/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellSelectORDER : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *orangeView;
@property (strong, nonatomic) IBOutlet UILabel *DL5Label;
@property (strong, nonatomic) IBOutlet UIView *underView;
@property (strong, nonatomic) IBOutlet UIButton *buttonMap1;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCall;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewDel;
@property (weak, nonatomic) IBOutlet UILabel *DL1;
@property (weak, nonatomic) IBOutlet UILabel *DL4;
@property (weak, nonatomic) IBOutlet UIButton *Button;
@property (weak, nonatomic) IBOutlet UIButton *buttonMap2;
@property (weak, nonatomic) IBOutlet UILabel *whiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelDeliveryMetroName;
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UIView *View1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1Height;
@property (weak, nonatomic) IBOutlet UIButton *showAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelCallMetroName;
@property (weak, nonatomic) IBOutlet UILabel *labelShortName;
@property (weak, nonatomic) IBOutlet UILabel *labelPercent;
@property (weak, nonatomic) IBOutlet UIView *View2;
@property (weak, nonatomic) IBOutlet UIView *View3;
@property(strong,nonatomic)NSString * callDate;
@property(strong,nonatomic)NSString * stringForSrochno;
@property(strong,nonatomic)NSString * shortName;
@property(assign,nonatomic)BOOL timerForUpdatingLabelShortNameIsCreated;
@property(nonatomic,strong) NSTimer * updateLabelTimer;
-(void)updateLabelShortName;
@end
