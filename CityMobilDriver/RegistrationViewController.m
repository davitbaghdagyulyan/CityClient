//
//  RegistrationViewController.m
//  CityMobilDriver
//
//  Created by Intern on 11/5/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "RegistrationViewController.h"
#import "CustomTableViewCell.h"
#import "GetActivationCodeRequest.h"
#import "GetActivationCodeResponse.h"
#import "ActivateAccountViewController.h"
@interface RegistrationViewController ()
{
    //CGSize keyBoardSize;
    UIView* regionBackgroundView;
    UITableView* regionTable;
    NSInteger idLocalityNumber;
}
@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    self.phoneNumber.keyboardType = UIKeyboardTypePhonePad;
}

- (IBAction)region:(id)sender {
    regionBackgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    regionBackgroundView.backgroundColor = [UIColor grayColor];
    regionBackgroundView.alpha = 0.3f;
    [self.view addSubview:regionBackgroundView];
    
    NSString* aa = [UIDevice currentDevice].model;
    NSLog(@"%@",aa);
    
    if ([[UIDevice currentDevice].model isEqualToString:@"iPad Simulator"] || [[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        regionTable = [[UITableView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 400)/2, (self.view.frame.size.height - 80)/2, 400, 80)];
    }
    else{
        regionTable = [[UITableView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 300)/2, (self.view.frame.size.height - 80)/2, 300, 80)];
    }
    
    regionTable.delegate = self;
    regionTable.dataSource = self;
    [self.view addSubview:regionTable];
}

- (IBAction)getPinCode:(UIButton *)sender {
    [self getActivationCode];
}

#pragma mark keyBoard
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField keyboard:(CGSize)keyBoardSize
{
    if (textField == self.phoneNumber) {
        self.spaceTobuttom.constant = keyBoardSize.height - self.getPinCode.frame.size.height - self.region.frame.size.height - 16;
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
    [self textFieldShouldBeginEditing:self.phoneNumber keyboard:keyBoardSize];
}


#pragma mark UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.phoneNumber resignFirstResponder];
    self.spaceTobuttom.constant = 20.f;
}




#pragma mark rotation UIContentContainer
- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         //UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         regionBackgroundView.frame = self.view.frame;
         if ([[UIDevice currentDevice].model isEqualToString:@"iPad Simulator"] || [[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
             regionTable.frame = CGRectMake((self.view.frame.size.width - 400)/2, (self.view.frame.size.height - 80)/2, 400, 80);
         }
         else{
             regionTable.frame = CGRectMake((self.view.frame.size.width - 300)/2, (self.view.frame.size.height - 80)/2, 300, 80);
         }
     }
     
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                                     
                                 }];
    
    [super viewWillTransitionToSize: size withTransitionCoordinator: coordinator];
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil] objectAtIndex:0];;
    if (indexPath.row == 0) {
        cell.cellText.text = @"  Москва";
    }
    if (indexPath.row == 1) {
        cell.cellText.text = @"  Краснодар";
    }
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [regionTable removeFromSuperview];
    [regionBackgroundView removeFromSuperview];
    idLocalityNumber = indexPath.row;
}




#pragma mark Requests

-(void)getActivationCode
{
    GetActivationCodeRequest* RequestObject=[[GetActivationCodeRequest alloc]init];
    RequestObject.phone = self.phoneNumber.text;
    if (idLocalityNumber == 0) {
        RequestObject.id_locality = 338;
    }
    if (idLocalityNumber == 1) {
        RequestObject.id_locality = 2;
    }
    
    NSDictionary* jsonDictionary = [RequestObject toDictionary];
    
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
        
        NSError* err;
        NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        GetActivationCodeResponse* responseObject = [[GetActivationCodeResponse alloc]initWithString:jsonString error:&err];
        responseObject.delegate = self;
        
//        if (responseObject.code != nil) {
//            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:responseObject.text delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//            [alert show];
//        }
        if (responseObject.result == 1) {
            ActivateAccountViewController* activationController=[self.storyboard instantiateViewControllerWithIdentifier:@"ActivateAccountViewController"];
            activationController.phone = self.phoneNumber.text;
            [self.navigationController pushViewController:activationController animated:NO];
        }
        
    }];
}







@end
