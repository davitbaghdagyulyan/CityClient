//
//  BadRequest.m
//  CityMobilDriver
//
//  Created by Intern on 12/18/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "BadRequest.h"
#import "LoginViewController.h"

@implementation BadRequest


-(void) showErrorAlertMessage:(NSString*)message code:(NSString*)code{
    if (code != nil) {
        if ([code isEqualToString:@"400"])
        {
    UIAlertController *keyExpiredAlert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                         {
                             [keyExpiredAlert dismissViewControllerAnimated:YES completion:nil];
                            LoginViewController* loginController=[self.delegate.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                             [self.delegate.navigationController pushViewController:loginController animated:NO];
                         }];
    [keyExpiredAlert addAction:ok];
    [self.delegate presentViewController:keyExpiredAlert animated:YES completion:nil];
        }
        else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
            
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
                                         {
                                             [alert dismissViewControllerAnimated:YES completion:nil];
            
                                         }];
                [alert addAction:ok];
                [self.delegate presentViewController:alert animated:YES completion:nil];
        }
    }
}
@end