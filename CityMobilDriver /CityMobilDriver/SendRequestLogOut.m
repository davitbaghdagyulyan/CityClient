//
//  SendRequestLogOut.m
//  CityMobilDriver
//
//  Created by Intern on 2/3/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//
#import "IdhashSetSingleTon.h"
#import "SendRequestLogOut.h"
#import "LoginViewController.h"
@implementation SendRequestLogOut
-(void)requestLogOut:(UIViewController*)curentSelf
{

        UIActivityIndicatorView*indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.center = curentSelf.view.center;
        indicator.color=[UIColor blackColor];
        [indicator startAnimating];
        [curentSelf.view addSubview:indicator];
        
        RequestLogOut* requestLogOutObject=[[RequestLogOut alloc]init];
        
        NSDictionary*jsonDictionary=[requestLogOutObject toDictionary];
        NSString*jsons=[requestLogOutObject toJSONString];
        NSLog(@"%@",jsons);
        NSURL* url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"api_url"]];
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
                
                UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                            
                                        }];
                [alert addAction:cancel];
                [curentSelf presentViewController:alert animated:YES completion:nil];
                
                
                [indicator stopAnimating];
                return ;
            }
            NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"responseLogOutString:%@",jsonString);
            NSError*err;
            ResponseLogOut*responseLogOutObject = [[ResponseLogOut alloc] initWithString:jsonString error:&err];
            
           
            
            
                    if(responseLogOutObject.code!=nil)
                    {
            
            
            
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:responseLogOutObject.text preferredStyle:UIAlertControllerStyleAlert];
            
                        UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action)
                                                {
                                                    [alert dismissViewControllerAnimated:YES completion:nil];
            
                                                }];
                        [alert addAction:cancel];
                        [curentSelf presentViewController:alert animated:YES completion:nil];
            
            
            
                        [indicator stopAnimating];
                    }
                    //else if([responseLogOutObject.result intValue])
                    {
                        [IdhashSetSingleTon setIdHashSet:nil];
                        LoginViewController* lvc=[curentSelf.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                        [curentSelf.navigationController pushViewController:lvc animated:NO];
                        
                    }
            [indicator stopAnimating];

        }];
}
@end
