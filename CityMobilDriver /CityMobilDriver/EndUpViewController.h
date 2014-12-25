//
//  EndUpViewController.h
//  CityMobilDriver
//
//  Created by Intern on 12/9/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetOrderResponse.h"
#import "Elements.h"

@interface EndUpViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet GPSIcon *gpsButton;
@property (weak, nonatomic) IBOutlet UIScrollView *endUpScrollView;


@property (nonatomic,strong) GetOrderResponse* orderResponse;
@property (nonatomic,strong) NSString* bill;


@property (nonatomic,strong) NSArray<Elements>* elements;
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
- (IBAction)back:(id)sender;
- (IBAction)openMap:(UIButton*)sender;
@property (nonatomic,weak) IBOutlet UIButton* yandexButton;
@property (nonatomic,weak) IBOutlet UIButton* cityButton;

@end
