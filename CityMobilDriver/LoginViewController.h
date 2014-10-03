//
//  LoginViewController.h
//  CityMobilDriver
//
//  Created by Intern on 9/24/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet UITextField *login;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property(nonatomic , assign) int keyboardHeightInPortrait;
@property(nonatomic , assign) int keyboardHeightInLandscape;
@property(nonatomic,assign) int curentTextField;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginSpace;




- (IBAction)backAction:(id)sender;



@end
