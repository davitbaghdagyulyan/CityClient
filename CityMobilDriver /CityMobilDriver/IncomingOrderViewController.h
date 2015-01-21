//
//  IncomingOrderViewController.h
//  CityMobilDriver
//
//  Created by Intern on 1/19/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import <AVFoundation/AVFoundation.h>

@interface IncomingOrderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *dinamicTimeLabel;
- (IBAction)acceptAction:(UIButton *)sender;
- (IBAction)ToRefuseAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *deliveryAdressText;
@property (weak, nonatomic) IBOutlet UILabel *collAdressTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortNameAndTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *line1View;
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UIView *orangeView;
@property(nonatomic,strong)Order*order;
@property(nonatomic,strong)NSTimer*timer;
@property(nonatomic,strong)AVAudioPlayer*player;
@property(nonatomic,strong)UILabel*orderCommentLabel;
@end
