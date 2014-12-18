//
//  LoginViewController.h
//  CityMobilDriver
//
//  Created by Intern on 9/24/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginJson.h"
#import "LoginResponse.h"
#import "SingleDataProvider.h"
#import "UserInformationProvider.h"


extern NSString* const UserDefaultsBankId;
extern NSString* const UserDefaultsPassword;
extern NSString* const UserDefaultsIsRemember;


@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,strong) NSString* bankid;
@property(nonatomic,strong) NSString* passwordText;

- (IBAction)remember:(UIButton*)sender;
- (IBAction)rememberButton:(UIButton*)sender;

@property (weak, nonatomic) IBOutlet UIButton *rememberButton;

@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet UITextField *login;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property(nonatomic , assign) int keyboardHeightInPortrait;
@property(nonatomic , assign) int keyboardHeightInLandscape;
@property(nonatomic,assign) int curentTextField;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginSpace;


- (IBAction)actionLogin:(UIButton *)sender;

//- (IBAction)backAction:(id)sender;



@end
