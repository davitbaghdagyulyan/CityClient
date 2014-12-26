///Users/intern/Documents/Projects/CityMobilDriver/SendingMessageViewController.h
//  TakenOrderViewController.h
//  CityMobilDriver
//
//  Created by Intern on 11/13/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TakenOrderViewController : UIViewController
@property (weak, nonatomic) IBOutlet GPSIcon *gpsButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
-(void)setIdHash:(NSString*)idhash andUnderView:(UIView*)underView;
- (IBAction)back:(id)sender;

- (IBAction)openMap:(UIButton*)sender;
@property (nonatomic,weak) IBOutlet UIButton* yandexButton;
@property (nonatomic,weak) IBOutlet UIButton* cityButton;
@property(nonatomic,strong)NSString*payment_method;
@end
