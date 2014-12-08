//
//  RegistrationViewController.h
//  CityMobilDriver
//
//  Created by Intern on 11/5/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceTobuttom;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
- (IBAction)region:(UIButton *)sender;
- (IBAction)getPinCode:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *region;
@property (weak, nonatomic) IBOutlet UIButton *getPinCode;

@end
