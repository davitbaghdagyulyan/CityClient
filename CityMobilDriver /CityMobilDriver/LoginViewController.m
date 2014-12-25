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
#import "IconsColorSingltone.h"
#import "RegionalSettingsViewController.h"

NSString* const UserDefaultsBankId = @"bankid";
NSString* const UserDefaultsPassword = @"password";
NSString* const UserDefaultsIsRemember = @"isRemember";


@interface LoginViewController ()

@end

@implementation LoginViewController

//@synthesize loginSpace;
//@synthesize keyboardHeightInPortrait;
//@synthesize keyboardHeightInLandscape;
//@synthesize curentTextField;
//@synthesize login;
//@synthesize password;
//@synthesize button;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    self.login.placeholder = @"логин";
    self.login.returnKeyType = UIReturnKeyNext;
   
    
    self.password.placeholder = @"Пароль";
    self.password.returnKeyType = UIReturnKeyDone;
    self.password.delegate = self;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"%@",[defaults objectForKey:@"login"]);
    
    if (![[defaults stringForKey:@"login"] isEqualToString:@"firstLogin"]) {
        RegionalSettingsViewController* rsvc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegionalSettingsViewController"];
        [self.navigationController pushViewController:rsvc animated:NO];
    }
    [defaults setObject:@"firstLogin" forKey:@"login"];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.login setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.login.delegate = self;
    
    if([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationLandscapeLeft ||
       [[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationLandscapeRight)
    {
    
//    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
//    {
        int screenHeight = self.view.frame.size.height;
        if (screenHeight == 768)
        {
            self.keyboardHeightInLandscape = 391;
        }
        
        else if (screenHeight == 375)
        {
            self.keyboardHeightInLandscape = 194;
        }
        else if (screenHeight == 414)
        {
            self.keyboardHeightInLandscape = 194;
        }
        else
        {
            self.keyboardHeightInLandscape = 193;
        }
        self.loginSpace.constant = self.view.frame.size.height -  self.keyboardHeightInLandscape - self.login.frame.size.height - 25;
//    }
    }
    else{
//        if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
//        {
            int screenHeight = self.view.frame.size.height;
            if (screenHeight == 1024)
            {
                self.keyboardHeightInPortrait = 303;
            }
            else if (screenHeight == 667)
            {
                self.keyboardHeightInPortrait = 258;
            }
            else if (screenHeight == 736)
            {
                self.keyboardHeightInPortrait = 271;
            }
            else
            {
                self.keyboardHeightInPortrait = 253;
            }
            self.loginSpace.constant = self.view.frame.size.height -  self.keyboardHeightInPortrait - self.login.frame.size.height - 25;//g
//        }
    }
    

    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    
    
    if ([defaults boolForKey:UserDefaultsIsRemember]) {
        //[self.rememberButton setImage:[UIImage imageNamed:@"box2.png"] forState:UIControlStateNormal];
        
        [self.rememberButton setSelected:YES];
        self.login.text = [defaults stringForKey:UserDefaultsBankId];
        self.password.text = [defaults stringForKey:UserDefaultsPassword];
    }
    else{
//        [self.rememberButton setImage:[UIImage imageNamed:@"box.png"] forState:UIControlStateNormal];
        [self.rememberButton setSelected:NO];
        self.login.placeholder = @"логин";
        self.password.placeholder = @"Пароль";
        
//        login.text=@"110314";
//        password.text=@"52750";
    }
    
    
    if ([UserRegistrationInformation sharedInformation].bankId) {
        self.login.text = [UserRegistrationInformation sharedInformation].bankId;
        self.password.text = [UserRegistrationInformation sharedInformation].password;
    }
    
    
    //NSInteger count = self.navigationController.viewControllers.count;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.login]) {
        self.curentTextField = 1;
        [self.password resignFirstResponder];
        [self.login becomeFirstResponder];
    }
    
    if ([textField isEqual:self.password]) {
        self.curentTextField = 2;
        
        if([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortrait ||
           [[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortraitUpsideDown)
        {
        
//        if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
//        {
            
            [self.login resignFirstResponder];
            self.loginSpace.constant = self.view.frame.size.height -  self.keyboardHeightInPortrait - 2*self.login.frame.size.height - 35;//g
            //            [self.password becomeFirstResponder];
//        }
        }
        else{
//        
//        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
//        {
            [self.login resignFirstResponder];
            if (self.view.frame.size.height == 768)
            {
                self.loginSpace.constant = self.view.frame.size.height -  self.keyboardHeightInLandscape - 2*self.login.frame.size.height - 30;//g
            }
            else
            {
                self.loginSpace.constant = self.view.frame.size.height -  self.keyboardHeightInLandscape - 2*self.login.frame.size.height - 15;//g
            }
            
//        }
        }
        [self.login resignFirstResponder];
        [self.password becomeFirstResponder];

    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if ([textField isEqual:self.login]) {
        if([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortrait ||
           [[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortraitUpsideDown)
        {
        
//        if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
//        {
            [self.login resignFirstResponder];
            self.loginSpace.constant = self.view.frame.size.height -  self.keyboardHeightInPortrait - 2*self.view.frame.size.height;//g
            //            [self.password becomeFirstResponder];
//        }
        }
        else{
//        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
//        {
            [self.login resignFirstResponder];
            self.loginSpace.constant = self.view.frame.size.height -  self.keyboardHeightInLandscape - 2*self.view.frame.size.height;//g
            //            [self.password becomeFirstResponder];
//        }
        }
        [self.login resignFirstResponder];
        [self.password becomeFirstResponder];

    }
    

    if ([textField isEqual:self.password]) {
        if([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortrait ||
           [[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortraitUpsideDown)
        {
//        if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
//        {
            //            [self.password resignFirstResponder];
            self.loginSpace.constant = self.view.frame.size.height -  self.keyboardHeightInPortrait - self.login.frame.size.height - 25;//g
            self.curentTextField = -1;
//        }
    }
        else{
//        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
//        {
            int screenHeight = self.view.frame.size.height;
//            [self.password resignFirstResponder];
            if (screenHeight == 768)
            {
                self.loginSpace.constant = self.view.frame.size.height -  self.keyboardHeightInLandscape - self.login.frame.size.height  - 25;//g
            }
            else
            {
                self.loginSpace.constant = self.view.frame.size.height -  self.keyboardHeightInLandscape - self.login.frame.size.height - 8;//g
            }
            self.curentTextField = -1;
//        }
        }
        [self.password resignFirstResponder];

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
            self.keyboardHeightInPortrait = 303;
        }
        
        else if (screenHeight == 667)
        {
            self.keyboardHeightInPortrait = 258;
        }
        else if (screenHeight == 736)
        {
            self.keyboardHeightInPortrait = 271;
        }
        else
        {
            self.keyboardHeightInPortrait = 253;
        }
        
        if (self.curentTextField == 1)
        {
            self.loginSpace.constant = self.view.frame.size.height -  self.keyboardHeightInPortrait - self.login.frame.size.height - 25;//g
        }
        else if (self.curentTextField == 2)
        {
            self.loginSpace.constant = self.view.frame.size.height -  self.keyboardHeightInPortrait - 2*self.login.frame.size.height - 35;//g
        }
        else
        {
            NSLog(@"---------->>>>>>>>>> %i",self.curentTextField);
            self.loginSpace.constant = self.view.frame.size.height -  self.keyboardHeightInPortrait - self.login.frame.size.height - 25;//g
        }
    }
    
    if (fromInterfaceOrientation == UIInterfaceOrientationPortrait || fromInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
    {
        int screenHeight = self.view.frame.size.height;
        
        if (screenHeight == 768)
        {
            self.keyboardHeightInLandscape = 391;
        }
        else if (screenHeight == 375 || screenHeight == 414)
        {
            self.keyboardHeightInLandscape = 194;
        }
        else
        {
            self.keyboardHeightInLandscape = 193;
        }
        
        if (self.curentTextField == 1)
        {
            if (screenHeight == 768)
            {
                self.loginSpace.constant = self.view.frame.size.height -  self.keyboardHeightInLandscape - self.login.frame.size.height  - 25;//g
            }
            else
            {
                self.loginSpace.constant = self.view.frame.size.height -  self.keyboardHeightInLandscape - self.login.frame.size.height - 8;//g
            }
        }
        else if (self.curentTextField == 2)
        {
            if (self.view.frame.size.height == 768)
            {
                self.loginSpace.constant = self.view.frame.size.height -  self.keyboardHeightInLandscape - 2*self.login.frame.size.height - 30;//g
            }
            else
            {
                self.loginSpace.constant = self.view.frame.size.height -  self.keyboardHeightInLandscape - 2*self.login.frame.size.height - 15;//g
            }
        }
        else
        {
            if (screenHeight == 768)
            {
                self.loginSpace.constant = self.view.frame.size.height -  self.keyboardHeightInLandscape - self.login.frame.size.height  - 25;//g
            }
            else
            {
                self.loginSpace.constant = self.view.frame.size.height -  self.keyboardHeightInLandscape - self.login.frame.size.height - 8;//g
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
//    else{
//        loginJsonObject.bankid=@"110314";
//        loginJsonObject.pass=@"52750";
//    }
//    

    
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
    request.timeoutInterval = 30;
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:@"Нет соединения с интернетом!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
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
        [IconsColorSingltone sharedColor].yandexColor = loginResponseObject.y_autoget;
        [IconsColorSingltone sharedColor].cityMobilColor = loginResponseObject.autoget;
        
        
        
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
            [[SingleDataProvider sharedKey] startTimer];
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
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        
        [indicator stopAnimating];
    }];
    

}

- (IBAction)remember:(UIButton*)sender {
    
    
//    if ([self image:sender.imageView.image isEqualTo:[UIImage imageNamed:@"box.png"]]) {
//        [self.rememberButton setImage:[UIImage imageNamed:@"box2.png"] forState:UIControlStateNormal];
//    }
//    else{
//        [self.rememberButton setImage:[UIImage imageNamed:@"box.png"] forState:UIControlStateNormal];
//    }
    
    if ([self.rememberButton isSelected]) {
        [self.rememberButton setSelected:NO];
    }
    else{
        [self.rememberButton setSelected:YES];
    }
    
}

- (IBAction)rememberButton:(UIButton*)sender{
    if ([self.rememberButton isSelected]) {
        [self.rememberButton setSelected:NO];
    }
    else{
        [self.rememberButton setSelected:YES];
    }
}


- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    return [data1 isEqual:data2];
}
@end
