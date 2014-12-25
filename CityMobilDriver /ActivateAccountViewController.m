//
//  ActivateAccountViewController.m
//  CityMobilDriver
//
//  Created by Intern on 11/6/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "ActivateAccountViewController.h"
#import "RegisterRequest.h"
#import "RegisterResponse.h"
#import "LoginViewController.h"
#import "UserRegistrationInformation.h"

@interface ActivateAccountViewController ()

@end

@implementation ActivateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    self.pinCode.keyboardType = UIKeyboardTypePhonePad;
    self.getPassword.titleLabel.numberOfLines = 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getPassword:(UIButton *)sender {
    [self getActivationCode];
}



#pragma mark keyBoard
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField keyboard:(CGSize)keyBoardSize
{
    if (textField == self.pinCode) {
        self.buttomSpace.constant = keyBoardSize.height - self.getPassword.frame.size.height - 4;
    }
    return YES;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(keyboardWillBeHidden:)
    //                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize keyBoardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self textFieldShouldBeginEditing:self.pinCode keyboard:keyBoardSize];
}

#pragma mark UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.pinCode resignFirstResponder];
    self.buttomSpace.constant = 20.f;
}


#pragma mark Requests

-(void)getActivationCode
{
    RegisterRequest* requestObject=[[RegisterRequest alloc]init];
    requestObject.phone = self.phone;
    requestObject.code = self.pinCode.text;
    
    NSDictionary* jsonDictionary = [requestObject toDictionary];
    
    NSURL* url = [NSURL URLWithString:@"https://driver-msk.city-mobil.ru/taxiserv/api/driver/"];
    
    NSError* error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    request.timeoutInterval = 30;
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:@"NO INTERNET CONECTION"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            
            [alert show];
            return ;
        }
        
        NSError* err;
        NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        RegisterResponse* responseObject = [[RegisterResponse alloc]initWithString:jsonString error:&err];
        
        if (responseObject.code != nil) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:responseObject.text delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        if (responseObject.result == 1) {
            LoginViewController* loginController=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            
            
            loginController.bankid = responseObject.bankid;
            loginController.passwordText = responseObject.password;
            
            [UserRegistrationInformation sharedInformation].bankId = responseObject.bankid;
            [UserRegistrationInformation sharedInformation].password = responseObject.password;
            
            [self pushOrPopViewController:loginController];
        }
    }];
}

-(void)pushOrPopViewController:(UIViewController*)controller
{
    NSArray *viewControlles = self.navigationController.viewControllers;
    
    for (UIViewController* currentController in viewControlles) {
        if ([controller isKindOfClass:currentController.class]) {
            [self.navigationController popToViewController:currentController animated:NO];
            return;
        }
    }
    [self.navigationController pushViewController:controller animated:NO];
}






@end
