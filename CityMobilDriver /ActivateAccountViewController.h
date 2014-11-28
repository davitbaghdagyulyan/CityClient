//
//  ActivateAccountViewController.h
//  CityMobilDriver
//
//  Created by Intern on 11/6/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivateAccountViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *pinCode;
@property (weak, nonatomic) IBOutlet UIButton *getPassword;
- (IBAction)getPassword:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomSpace;

@property(nonatomic,strong) NSString* phone;
@end
