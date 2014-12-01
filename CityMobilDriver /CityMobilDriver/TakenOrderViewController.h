///Users/intern/Documents/Projects/CityMobilDriver/SendingMessageViewController.h
//  TakenOrderViewController.h
//  CityMobilDriver
//
//  Created by Intern on 11/13/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface TakenOrderViewController : UIViewController<CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
-(void)setIdHash:(NSString*)idhash andUnderView:(UIView*)underView;
- (IBAction)back:(id)sender;
@property (nonatomic,weak) IBOutlet UIButton* yandexButton;
@property (nonatomic,weak) IBOutlet UIButton* cityButton;
@end
