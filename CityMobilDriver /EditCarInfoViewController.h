//
//  EditCarInfoViewController.h
//  CityMobilDriver
//
//  Created by Intern on 10/29/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfilViewController.h"
#import "CarInfoViewController.h"
#import "RequestGetMarkList.h"
#import "SingleDataProvider.h"
#import "ResponseGetMarkList.h"
#import "Mark.h"
#import "RequestGetModelList.h"
#import "ResponseGetModelList.h"
#import "RequestGetColorList.h"
#import "ResponseGetColorList.h"
#import "RequestSetCarInfo.h"
#import "ResponseSetCarInfo.h"
#import "RequestSetCarInfoWidthPhoto.h"

@interface EditCarInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,weak) IBOutlet UIButton* yandexButton;
@property (nonatomic,weak) IBOutlet UIButton* cityButton;


@property(nonatomic,strong) UIImage* carImage;
@property(nonatomic,strong) NSString* id_car;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControll;
- (IBAction)segmentControllAction:(UISegmentedControl*)sender;


@property (weak, nonatomic) IBOutlet UIButton *mark;

- (IBAction)markAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *model;

- (IBAction)modelAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *color;

- (IBAction)colorAction:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *gosNumber;


@property (weak, nonatomic) IBOutlet UITextField *vinCode;


@property (weak, nonatomic) IBOutlet UITextField *firstLicense;

@property (weak, nonatomic) IBOutlet UITextField *lastLicense;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UITextField *year;

- (IBAction)saveAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (weak, nonatomic) IBOutlet UIImageView *carImageView;



#pragma mark - left Menu
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
- (IBAction)back:(UIButton *)sender;

@end