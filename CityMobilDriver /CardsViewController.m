//
//  CardsViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/31/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "CardsViewController.h"
#import "RequestStandart.h"
#import "OpenMapButtonHandler.h"
#import "ProfilViewController.h"
#import "CardsViewController.h"

@interface CardsViewController ()
{
    RequestStandart* object;
    OpenMapButtonHandler*openMapButtonHandlerObject;
}
@end

@implementation CardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.segmentControll.selectedSegmentIndex = 2;
    [self.yandexButton setNeedsDisplay];
    [self.cityButton setNeedsDisplay];
}

- (IBAction)segmentControllAction:(UISegmentedControl*)sender
{
    if (sender.selectedSegmentIndex == 0)
    {
        ProfilViewController* profilViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ProfilViewController"];
        //[self.navigationController pushViewController:profilViewController animated:NO];
        [self pushOrPopViewController:profilViewController];
    }
    if (sender.selectedSegmentIndex == 1)
    {
        CarInfoViewController* createProfilController=[self.storyboard instantiateViewControllerWithIdentifier:@"CarInfoViewController"];
        [self.navigationController pushViewController:createProfilController animated:NO];
    }
    if (sender.selectedSegmentIndex == 2) {
    }
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

- (IBAction)openMap:(UIButton*)sender
{
    openMapButtonHandlerObject=[[OpenMapButtonHandler alloc]init];
    [openMapButtonHandlerObject setCurentSelf:self];
}


@end
