//
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

@end
