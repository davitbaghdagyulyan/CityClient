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

@interface TariffsCityMobilViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *tariffsSacrollView;
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
- (IBAction)back:(id)sender;
@end
