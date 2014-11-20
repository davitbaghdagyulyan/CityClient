//
//  CreateProfilViewController.h
//  CityMobilDriver
//
//  Created by Intern on 10/28/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfilViewController.h"
#import "RequestSetDriverInfo.h"
#import "RequestSetDriverInfoWithPoto.h"
#import "DriverInfoResponse.h"

@interface CreateProfilViewController : UIViewController<UIScrollViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;



- (IBAction)seveUserInformation:(UIButton *)sender;
@property(nonatomic,strong) UIImage* profilImage;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *createPhotoImageView;

- (IBAction)segmentContollAction:(UISegmentedControl*)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControll;


@property (weak, nonatomic) IBOutlet UITextField *middleName;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
///////

@property (weak, nonatomic) IBOutlet UITextField *pasportSer;
@property (weak, nonatomic) IBOutlet UITextField *pasportNum;
@property (weak, nonatomic) IBOutlet UITextField *pasportWho;
@property (weak, nonatomic) IBOutlet UITextField *passportDate;
@property (weak, nonatomic) IBOutlet UITextField *pasportAdress;

///////

@property (weak, nonatomic) IBOutlet UITextField *driverLicenseNumber;
@property (weak, nonatomic) IBOutlet UITextField *driverLicenseSerial;
@property (weak, nonatomic) IBOutlet UITextField *driverLicenseClass;



- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
- (IBAction)back:(UIButton *)sender;
@end
