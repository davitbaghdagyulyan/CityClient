//
//  OpenMapButtonHandler.m
//  CityMobilDriver
//
//  Created by Intern on 12/5/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "OpenMapButtonHandler.h"

@implementation OpenMapButtonHandler

-(void)setCurentSelf:(UIViewController*)cSelf
{
    curentSelf=cSelf;
    
    viewMap=[[CustomViewForMaps alloc] init];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomViewForMaps" owner:self options:nil];
    viewMap = [nib objectAtIndex:0];
    viewMap.frame=curentSelf.view.frame;
    viewMap.center=curentSelf.view.center;
    viewMap.smallMapView.layer.cornerRadius = 30;
    viewMap.smallMapView.layer.borderWidth = 2;
    viewMap.smallMapView.layer.borderColor=[UIColor clearColor].CGColor;
    viewMap.smallMapView.layer.masksToBounds = YES;
    [viewMap.closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *singleTapYandex =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openYandexMap)];
    [singleTapYandex setNumberOfTapsRequired:1];
    UITapGestureRecognizer *singleTapGoogle =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openGoogleMap)];
    [singleTapYandex setNumberOfTapsRequired:1];
    viewMap.yandexImageView.userInteractionEnabled=YES;
    viewMap.googleImageView.userInteractionEnabled=YES;
    [viewMap.yandexImageView addGestureRecognizer:singleTapYandex];
    [viewMap.googleImageView addGestureRecognizer:singleTapGoogle];
    [self openMap];
}


- (void)openMap
{
    [curentSelf.view addSubview:viewMap];
    viewMap.smallMapView.transform = CGAffineTransformMakeScale(0,0);
    GetLastKnownLocationJson*getLastKnownLocationJson=[[GetLastKnownLocationJson alloc] init];
    
    
    UIActivityIndicatorView*indicator1 = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator1.center = curentSelf.view.center;
    indicator1.color=[UIColor blackColor];
    [indicator1 startAnimating];
    [curentSelf.view addSubview:indicator1];
    
    
    
    NSDictionary*jsonDictionary=[getLastKnownLocationJson toDictionary];
    NSString*jsons=[getLastKnownLocationJson toJSONString];
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
            
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        [indicator1 stopAnimating];
                                        return ;
                                    }];
            [alert addAction:cancel];
            [curentSelf presentViewController:alert animated:YES completion:nil];
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",jsonString);
        NSError*err;
        
        
        
        GetLastKnownLocationResponse*getLastKnownLocationResponseObject = [[GetLastKnownLocationResponse alloc] initWithString:jsonString error:&err];
        
        
        
        if(getLastKnownLocationResponseObject.code!=nil)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка сервера" message:getLastKnownLocationResponseObject.text preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
            [alert addAction:cancel];
            [curentSelf presentViewController:alert animated:YES completion:nil];
            [indicator1 stopAnimating];
            
        }
        else
        {
            if ((getLastKnownLocationResponseObject.latitude ==nil)||(getLastKnownLocationResponseObject.longitude==nil))
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка сервера" message:@"взять gps данные из iPhone/iPad?" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                            [viewMap removeFromSuperview];
                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                            
                                        }];
                [alert addAction:cancel];
                
                UIAlertAction*ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        [self animation];
                                        googleMapUrl=[NSString stringWithFormat:@"http://maps.google.com/maps?z=4&t=m&q=loc:%f+%f",
                                                      [SingleDataProvider sharedKey].lat,
                                                      [SingleDataProvider sharedKey].lon];
                                        
                                        yandexMapUrl=[NSString stringWithFormat:@"yandexnavi://show_point_on_map?lat=%f&lon=%f&zoom=4&no-balloon=1",
                                                      [SingleDataProvider sharedKey].lat,
                                                      [SingleDataProvider sharedKey].lon];
                                        
                                    }];
                [alert addAction:ok];
                [curentSelf presentViewController:alert animated:YES completion:nil];
                
            }
            else
            {
                googleMapUrl=[NSString stringWithFormat:@"http://maps.google.com/maps?z=4&t=m&q=loc:%f+%f",
                              [getLastKnownLocationResponseObject.latitude doubleValue],
                              [getLastKnownLocationResponseObject.longitude doubleValue]];
                
                yandexMapUrl=[NSString stringWithFormat:@"yandexnavi://show_point_on_map?lat=%f&lon=%f&zoom=4&no-balloon=1",
                              [getLastKnownLocationResponseObject.latitude doubleValue],
                              [getLastKnownLocationResponseObject.longitude doubleValue]];
                
                [self animation];
                
            }
            
        }
        [indicator1 stopAnimating];
        
    }];
    
}
-(void)openYandexMap
{
    
    
    NSString* urlStr= yandexMapUrl;
    NSURL* naviURL = [NSURL URLWithString:urlStr];
    NSLog(@"urlStr=%@",urlStr);
    if ([[UIApplication sharedApplication] canOpenURL:naviURL]) {
        // Если Навигатор установлен - открываем его
        [[UIApplication sharedApplication] openURL:naviURL];
    } else {
        // Если не установлен - открываем страницу в App Store
        NSURL* appStoreURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/yandex.navigator/id474500851?mt=8"];
        [[UIApplication sharedApplication] openURL:appStoreURL];
        
    }
    
}
-(void)openGoogleMap
{
    
    NSString* urlStr= googleMapUrl;
    NSURL* naviURL = [NSURL URLWithString:urlStr];
    NSLog(@"urlStr=%@",urlStr);
    if ([[UIApplication sharedApplication] canOpenURL:naviURL])
    {
        // Если Навигатор установлен - открываем его
        [[UIApplication sharedApplication] openURL:naviURL];
    }
    else
    {
        // Если не установлен - открываем страницу в App Store
        NSURL* appStoreURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/google-maps/id585027354?mt=8"];
        [[UIApplication sharedApplication] openURL:appStoreURL];
    }
    
}

-(void)animation
{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: 0
                     animations:^(void)
     {
         viewMap.smallMapView.transform = CGAffineTransformIdentity;
     }
                     completion:nil];
}
-(void)close
{
    [viewMap removeFromSuperview];
}
@end
