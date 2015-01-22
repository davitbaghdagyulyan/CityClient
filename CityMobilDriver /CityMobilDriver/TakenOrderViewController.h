///Users/intern/Documents/Projects/CityMobilDriver/SendingMessageViewController.h
//  TakenOrderViewController.h
//  CityMobilDriver
//
//  Created by Intern on 11/13/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelUnderLine.h"

@interface TakenOrderViewController : UIViewController<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *orangeView;
- (IBAction)deliveryMapAction:(UIButton *)sender;
- (IBAction)collMapAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *deliveryMetroName;
@property (weak, nonatomic) IBOutlet UIButton *deliveryMapButton;
@property (weak, nonatomic) IBOutlet UIImageView *deliveryImageView;
@property (weak, nonatomic) IBOutlet UILabel *collMetroName;
@property (weak, nonatomic) IBOutlet UIButton *collMapButton;
@property (weak, nonatomic) IBOutlet UIImageView *collMetroImageView;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *shortNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UIView *view1;

@property (weak, nonatomic) IBOutlet UIView *labelVew;
@property (weak, nonatomic) IBOutlet UILabel *asteriskLabel;
@property (weak, nonatomic) IBOutlet UILabel *klientNameLabel;
@property (weak, nonatomic) IBOutlet LabelUnderLine *phoneLabel;


@property (strong, nonatomic) IBOutlet UIView *whiteView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightVIew1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightView2;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightView3;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *proportionalHeight;



//////////////new//////////////////


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightOrangeView;


//////////////////////////////////
@property (weak, nonatomic) IBOutlet GPSIcon *gpsButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
-(void)setIdHash:(NSString*)idhash andUnderView:(UIView*)underView;
- (IBAction)back:(id)sender;

- (IBAction)openMap:(UIButton*)sender;
@property (nonatomic,weak) IBOutlet UIButton* yandexButton;
@property (nonatomic,weak) IBOutlet UIButton* cityButton;
@property(nonatomic,strong)NSString*payment_method;
@property(nonatomic,strong)NSString*idhash;
@end
