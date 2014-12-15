//
//  CardsViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/31/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "CardsViewController.h"
#import "RequestStandart.h"

@interface CardsViewController ()
{
    RequestStandart* object;
}
@end

@implementation CardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getCarInfo];
}



-(void)getCarInfo
{
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    
    object = [[RequestStandart alloc]init];
    object.method = @"getcards";
    NSDictionary* jsonDictionary=[object toDictionary];
    NSString* jsons=[object toJSONString];
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
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:@"Нет соединения с интернетом!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            return ;
        }
        
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
       // NSError*err;
        
        
        //        LoginResponse* loginResponseObject=nil;
        //
        //        loginResponseObject = [[LoginResponse alloc] initWithString:jsonString error:&err];
        //
        //        if(loginResponseObject.code!=nil)
        //        {
        //
        //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
        //                                                            message:@"Неправильно указан логин и/или пароль"
        //                                                           delegate:self
        //                                                  cancelButtonTitle:@"OK"
        //                                                  otherButtonTitles:nil];
        //            [alert show];
        //            return;
        //
        //        }
        //        else
        //        {
        //            [[SingleDataProvider sharedKey]setKey:loginResponseObject.key];
        //            [self.navigationController popViewControllerAnimated:NO];
        //        }
        [indicator stopAnimating];
    }];
    
}


@end
