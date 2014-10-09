//
//  LoginViewController.m
//  CityMobilDriver
//
//  Created by Intern on 9/24/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "LoginViewController.h"
#import "SingleDataProvider.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize loginSpace;
@synthesize keyboardHeightInPortrait;
@synthesize keyboardHeightInLandscape;
@synthesize curentTextField;

@synthesize login;
@synthesize password;
@synthesize button;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [[self navigationController] setNavigationBarHidden:YES animated:NO];

    login.placeholder = @"логин";
    login.returnKeyType = UIReturnKeyNext;
    [login setTranslatesAutoresizingMaskIntoConstraints:NO];
    login.delegate = self;
    
    password.placeholder = @"Пароль";
    password.returnKeyType = UIReturnKeyDone;
    password.delegate = self;
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        int screenHeight = self.view.frame.size.height;
        if (screenHeight == 768)
        {
            keyboardHeightInLandscape = 391;
        }
        
        else if (screenHeight == 375)
        {
            keyboardHeightInLandscape = 194;
        }
        else if (screenHeight == 414)
        {
            keyboardHeightInLandscape = 194;
        }
        else
        {
            keyboardHeightInLandscape = 193;
        }
        loginSpace.constant = self.view.frame.size.height -  keyboardHeightInLandscape - login.frame.size.height - 25;//po
    }
    
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        int screenHeight = self.view.frame.size.height;
        if (screenHeight == 1024)
        {
            keyboardHeightInPortrait = 303;
        }
        else if (screenHeight == 667)
        {
            keyboardHeightInPortrait = 258;
        }
        else if (screenHeight == 736)
        {
            keyboardHeightInPortrait = 271;
        }
        else
        {
            keyboardHeightInPortrait = 253;
        }
        loginSpace.constant = self.view.frame.size.height -  keyboardHeightInPortrait - login.frame.size.height - 25;//g
    }
    
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == login)
    {
        curentTextField = 1;
    }
    
    if (textField == password)
    {
        curentTextField = 2;
        
        if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
        {
            
            [login resignFirstResponder];
            loginSpace.constant = self.view.frame.size.height -  keyboardHeightInPortrait - 2*login.frame.size.height - 35;//g
            [password becomeFirstResponder];
        }
        
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            [login resignFirstResponder];
            if (self.view.frame.size.height == 768)
            {
                loginSpace.constant = self.view.frame.size.height -  keyboardHeightInLandscape - 2*login.frame.size.height - 30;//g
            }
            else
            {
                loginSpace.constant = self.view.frame.size.height -  keyboardHeightInLandscape - 2*login.frame.size.height - 15;//g
            }
            [password becomeFirstResponder];
        }
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == login)
    {
        if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
        {
            [login resignFirstResponder];
            loginSpace.constant = self.view.frame.size.height -  keyboardHeightInPortrait - 2*self.view.frame.size.height;//g
            [password becomeFirstResponder];
        }
        
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            [login resignFirstResponder];
            loginSpace.constant = self.view.frame.size.height -  keyboardHeightInLandscape - 2*self.view.frame.size.height;//g
            [password becomeFirstResponder];
        }
    }
    
    if (textField == password)
    {
        if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
        {
            [password resignFirstResponder];
            loginSpace.constant = self.view.frame.size.height -  keyboardHeightInPortrait - login.frame.size.height - 25;//g
            curentTextField = -1;
        }
        
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            int screenHeight = self.view.frame.size.height;
            [password resignFirstResponder];
            if (screenHeight == 768)
            {
                loginSpace.constant = self.view.frame.size.height -  keyboardHeightInLandscape - login.frame.size.height  - 25;//g
            }
            else
            {
                loginSpace.constant = self.view.frame.size.height -  keyboardHeightInLandscape - login.frame.size.height - 8;//g
            }
            curentTextField = -1;
        }
    }
    
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        int screenHeight = self.view.frame.size.height;
        if (screenHeight == 1024)
        {
            keyboardHeightInPortrait = 303;
        }
        
        else if (screenHeight == 667)
        {
            keyboardHeightInPortrait = 258;
        }
        else if (screenHeight == 736)
        {
            keyboardHeightInPortrait = 271;
        }
        else
        {
            keyboardHeightInPortrait = 253;
        }
        
        if (curentTextField == 1)
        {
            loginSpace.constant = self.view.frame.size.height -  keyboardHeightInPortrait - login.frame.size.height - 25;//g
        }
        else if (curentTextField == 2)
        {
            loginSpace.constant = self.view.frame.size.height -  keyboardHeightInPortrait - 2*login.frame.size.height - 35;//g
        }
        else
        {
            NSLog(@"---------->>>>>>>>>> %i",curentTextField);
            loginSpace.constant = self.view.frame.size.height -  keyboardHeightInPortrait - login.frame.size.height - 25;//g
        }
    }
    
    if (fromInterfaceOrientation == UIInterfaceOrientationPortrait || fromInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
    {
        int screenHeight = self.view.frame.size.height;
        
        if (screenHeight == 768)
        {
            keyboardHeightInLandscape = 391;
        }
        else if (screenHeight == 375 || screenHeight == 414)
        {
            keyboardHeightInLandscape = 194;
        }
        else
        {
            keyboardHeightInLandscape = 193;
        }
        
        if (curentTextField == 1)
        {
            if (screenHeight == 768)
            {
                loginSpace.constant = self.view.frame.size.height -  keyboardHeightInLandscape - login.frame.size.height  - 25;//g
            }
            else
            {
                loginSpace.constant = self.view.frame.size.height -  keyboardHeightInLandscape - login.frame.size.height - 8;//g
            }
        }
        else if (curentTextField == 2)
        {
            if (self.view.frame.size.height == 768)
            {
                loginSpace.constant = self.view.frame.size.height -  keyboardHeightInLandscape - 2*login.frame.size.height - 30;//g
            }
            else
            {
                loginSpace.constant = self.view.frame.size.height -  keyboardHeightInLandscape - 2*login.frame.size.height - 15;//g
            }
        }
        else
        {
            if (screenHeight == 768)
            {
                loginSpace.constant = self.view.frame.size.height -  keyboardHeightInLandscape - login.frame.size.height  - 25;//g
            }
            else
            {
                loginSpace.constant = self.view.frame.size.height -  keyboardHeightInLandscape - login.frame.size.height - 8;//g
            }
        }
    }
}


//- (IBAction)backAction:(id)sender
//{
//  [self.navigationController popViewControllerAnimated:NO];
//    
//}

- (IBAction)actionLogin:(UIButton *)sender
{
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    LoginJson* loginJsonObject=[[LoginJson alloc]init];
    loginJsonObject.bankid=@"104382";//login.text;
    loginJsonObject.pass=@"84609";//password.text;


    NSDictionary*jsonDictionary=[loginJsonObject toDictionary];
    NSString*jsons=[loginJsonObject toJSONString];
    NSLog(@"%@",jsons);
 
    
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
    request.timeoutInterval = 10;
    
    
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
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        NSError*err;
        LoginResponse*loginResponseObject = [[LoginResponse alloc] initWithString:jsonString error:&err];
        
        
        if(loginResponseObject.code!=nil)
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                            message:@"Неправильно указан логин и/или пароль"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
            
        }
        else
        {
            
            [[SingleDataProvider sharedKey]setKey:loginResponseObject.key];
            [self.navigationController popViewControllerAnimated:NO];
        }
        
    }];
    
    [indicator stopAnimating];
}
@end
