//
//  TariffsCityMobilViewController.h
//  CityMobilDriver
//
//  Created by Intern on 10/31/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetTariffsUrlJson.h"
#import "GetTariffsUrlResponse.h"
#import "LeftMenu.h"
#import "XMLReader.h"
#import "NSDictionary+BVJSONString.h"

@interface TariffsCityMobilViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleOfPage;
@property (weak, nonatomic) IBOutlet GPSIcon *gpsButton;
@property (strong, nonatomic) IBOutlet UIScrollView *tariffsSacrollView;
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
- (IBAction)back:(id)sender;
@property (nonatomic,weak) IBOutlet UIButton* yandexButton;
@property (nonatomic,weak) IBOutlet UIButton* cityButton;
- (IBAction)openMap:(UIButton*)sender;
@property (nonatomic, assign) CGFloat lastContentOffset;

@end
