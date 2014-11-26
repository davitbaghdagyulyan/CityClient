//
//  ProfilViewController.h
//  CityMobilDriver
//
//  Created by Intern on 10/17/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestDocScansUrl.h"
#import "SingleDataProvider.h"
#import "ResponseGetDocScansUrl.h"
#import "LeftMenu.h"
#import "DriverAllInfoResponse.h"
#import "CarInfoViewController.h"
#import "CreateProfilViewController.h"

@interface ProfilViewController : UIViewController <UIScrollViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (nonatomic,weak) IBOutlet UIView* bgView;


@property (nonatomic,weak) IBOutlet UIButton* yandexButton;
@property (nonatomic,weak) IBOutlet UIButton* cityButton;



@property (weak, nonatomic) IBOutlet UIImageView *profilImageView;

- (IBAction)edit:(UIButton *)sender;


- (IBAction)sendDocumentsAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControll;
- (IBAction)segmentContollAction:(UISegmentedControl*)sender;




/// interface views
@property (weak, nonatomic) IBOutlet UILabel *lastName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *middleName;


@property (weak, nonatomic) IBOutlet UILabel *percentToCharge;
@property (weak, nonatomic) IBOutlet UILabel *passportSer;
@property (weak, nonatomic) IBOutlet UILabel *passportNum;
@property (weak, nonatomic) IBOutlet UILabel *pasportDate;

@property (weak, nonatomic) IBOutlet UILabel *dateRegister;
@property (weak, nonatomic) IBOutlet UILabel *passportWho;
@property (weak, nonatomic) IBOutlet UILabel *passportAddress;



@property (weak, nonatomic) IBOutlet UILabel *driverLicenseSerial;
@property (weak, nonatomic) IBOutlet UILabel *driverLicenseNumber;
@property (weak, nonatomic) IBOutlet UILabel *driverLicenseClass;



#pragma mark - left menu
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
- (IBAction)back:(UIButton *)sender;
@end
