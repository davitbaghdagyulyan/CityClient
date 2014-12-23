//
//  TachometerViewController.h
//  CityMobilDriver
//
//  Created by Intern on 11/19/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetOrderResponse.h"

@interface TachometerViewController : UIViewController


@property (nonatomic,weak) IBOutlet UIButton* yandexButton;
@property (nonatomic,weak) IBOutlet UIButton* cityButton;




@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *tachoElements;

@property (weak, nonatomic) IBOutlet UILabel *shortLabel;


@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *distance;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *elements;

- (IBAction)elementAction:(id)sender;
- (IBAction)openMap:(UIButton*)sender;



@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelsColoection;


@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *hardLabelsColoection;

@property (weak, nonatomic) IBOutlet UIView *informationView;


@property(nonatomic,strong)NSString* idHash;
@property(nonatomic,strong)NSString* collDate;
@property(nonatomic,strong)NSString* shortname;
@property(nonatomic,strong)NSString* collMetroName;
@property(nonatomic,strong)NSString* collComment;
@property(nonatomic,strong)NSString* deliveryMetroName;
@property(nonatomic,strong)NSString* tariff;
@property(nonatomic,strong)NSString* ourComment;


@property (nonatomic,strong) GetOrderResponse* orderResponse;

- (IBAction)goingToOrder:(UIButton *)sender;

- (IBAction)endOrderAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *endOrder;

@property (weak, nonatomic) IBOutlet UIButton *goingToOrder;


//// left Menu /////
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
- (IBAction)back:(id)sender;
@end






