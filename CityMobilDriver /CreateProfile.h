//
//  CreateProfile.h
//  CityMobilDriver
//
//  Created by Intern on 10/22/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestSetDriverInfo.h"
#import "SingleDataProvider.h"
#import "DriverInfoResponse.h"
#import "RequestSetDriverInfoWithPoto.h"
#import "SettingsViewController.h"

@protocol CreateProfilViewDelegate <NSObject>
-(BOOL)IsPhotoEqual;
- (IBAction)showSettingViewController:(UIButton *)sender;
-(void)addImagePicker:(UIView*)view;
-(void)removeImagePicker:(UIView*)view;
@end


@interface CreateProfile : UIView <UIScrollViewDelegate,UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property(nonatomic, assign) BOOL isSubview;

- (IBAction)seveUserInformation:(UIButton *)sender;

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



@property (weak, nonatomic) IBOutlet UIImageView *createPhotoImageView;



@property(nonatomic,weak) id<CreateProfilViewDelegate> delegate;


- (IBAction)showSettingViewController:(UIButton *)sender;



@end
