//
//  InternetConectionViewController.m
//  CityMobilDriver
//
//  Created by Intern on 12/18/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "InternetConectionViewController.h"
#import "Reachability.h"
#import "LoginViewController.h"

@interface InternetConectionViewController ()

@end

@implementation InternetConectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Проверьте наличие интернет соединения" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* update = [UIAlertAction actionWithTitle:@"Обновить" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                             {
                                 Reachability *reachability = [Reachability reachabilityForInternetConnection];
                                 [reachability startNotifier];
                                 
                                 NetworkStatus status = [reachability currentReachabilityStatus];
                                 
                                 if(status != NotReachable)
                                 {
                                     LoginViewController* lvc =[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                                     [self.navigationController pushViewController:lvc animated:NO];
                                 }
                                 else
                                 {
                                     [alert dismissViewControllerAnimated:NO completion:nil];
                                     [self presentViewController:alert animated:YES completion:nil];
                                 }
                             }];
    [alert addAction:update];
    [self presentViewController:alert animated:YES completion:nil];
}











@end
