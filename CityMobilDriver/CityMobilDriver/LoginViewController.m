//
//  LoginViewController.m
//  CityMobilDriver
//
//  Created by Intern on 9/24/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "LoginViewController.h"
#import "SingleDataProvider.h"
#import "UserRegistrationInformation.h"

NSString* const UserDefaultsBankId = @"bankid";
NSString* const UserDefaultsPassword = @"password";
NSString* const UserDefaultsIsRemember = @"isRemember";


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
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    
    
    if ([defaults boolForKey:UserDefaultsIsRemember]) {
        [self.rememberButton setImage:[UIImage imageNamed:@"box2.png"] forState:UIControlStateNormal];
        login.text = [defaults stringForKey:UserDefaultsBankId];
        password.text = [defaults stringForKey:UserDefaultsPassword];
    }
    else{
        [self.rememberButton setImage:[UIImage imageNamed:@"box.png"] forState:UIControlStateNormal];
        login.placeholder = @"логин";
        password.placeholder = @"Пароль";
        
        login.text=@"110314";
        password.text=@"52750";
    }
    
    
    if ([UserRegistrationInformation sharedInformation].bankId) {
        login.text = [UserRegistrationInformation sharedInformation].bankId;
        password.text = [UserRegistrationInformation sharedInformation].password;
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




- (IBAction)actionLogin:(UIButton *)sender
{
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    LoginJson* loginJsonObject=[[LoginJson alloc]init];

    //loginJsonObject.bankid=@"6666";//login.text;
    //loginJsonObject.pass=@"6666";//password.text;


    

    

    
    
    if (self.login.text.length > 0) {
        loginJsonObject.bankid = self.login.text;
        loginJsonObject.pass = self.password.text;
    }
    else{
        loginJsonObject.bankid=@"6666";
        loginJsonObject.pass=@"6666";
    }
    

    
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
            [indicator stopAnimating];
            return ;
        }
        
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        NSError*err;
        LoginResponse*loginResponseObject=nil;
        
        loginResponseObject = [[LoginResponse alloc] initWithString:jsonString error:&err];
        
        
        NSLog(@"%@",loginResponseObject.key);
        
        [SingleDataProvider sharedKey].key = loginResponseObject.key;
        [UserInformationProvider sharedInformation].balance = loginResponseObject.balance;
        [UserInformationProvider sharedInformation].bankid = loginResponseObject.bankid;
        [UserInformationProvider sharedInformation].credit_limit = loginResponseObject.credit_limit;
        
        
        if(loginResponseObject.code!=nil)
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                            message:@"Неправильно указан логин и/или пароль"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
        
        else
        {
            [[SingleDataProvider sharedKey]setKey:loginResponseObject.key];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([self image:self.rememberButton.imageView.image isEqualTo:[UIImage imageNamed:@"box2.png"]]) {
                [defaults setObject:[NSNumber numberWithBool:YES] forKey:UserDefaultsIsRemember];
                [defaults setObject:loginJsonObject.bankid forKey:UserDefaultsBankId];
                [defaults setObject:loginJsonObject.pass forKey:UserDefaultsPassword];
                [defaults synchronize];
            }
            else{
                [defaults setObject:[NSNumber numberWithBool:NO] forKey:UserDefaultsIsRemember];
                [defaults setObject:@"логин" forKey:UserDefaultsBankId];
                [defaults setObject:@"Пароль" forKey:UserDefaultsPassword];
            }
            [self.navigationController popViewControllerAnimated:NO];
        }
        
        [indicator stopAnimating];
    }];
    
    
}

- (IBAction)remember:(UIButton*)sender {
    
    
    if ([self image:sender.imageView.image isEqualTo:[UIImage imageNamed:@"box.png"]]) {
        [self.rememberButton setImage:[UIImage imageNamed:@"box2.png"] forState:UIControlStateNormal];
    }
    else{
        [self.rememberButton setImage:[UIImage imageNamed:@"box.png"] forState:UIControlStateNormal];
    }
}


- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    return [data1 isEqual:data2];
}
@end
