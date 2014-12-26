//
//  OpenMapButtonHandler.m
//  CityMobilDriver
//
//  Created by Intern on 12/15/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "OpenMapButtonHandler.h"

@implementation OpenMapButtonHandler
-(instancetype)init
{
    viewMap=nil;
  googleMapUrl=nil;
  yandexMapUrl=nil;
    curentSelf=nil;
    return self;
}
-(void)setCurentSelf:(UIViewController*)cSelf
{
    curentSelf=cSelf;
    
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomViewForMaps" owner:curentSelf options:nil];
    viewMap = [nib objectAtIndex:0];
    
    
    //    viewMap.frame=curentSelf.view.frame;
    
    [curentSelf.view addSubview:viewMap];
    
    viewMap.translatesAutoresizingMaskIntoConstraints=NO;
    
    [curentSelf.view addConstraint:[NSLayoutConstraint constraintWithItem:viewMap
                                                                attribute:NSLayoutAttributeLeading
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:curentSelf.view
                                                                attribute:NSLayoutAttributeLeading
                                                               multiplier:1.0
                                                                 constant:0]];
    
    
    [curentSelf.view addConstraint:[NSLayoutConstraint constraintWithItem:viewMap
                                                                attribute:NSLayoutAttributeTrailing
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:curentSelf.view
                                                                attribute:NSLayoutAttributeTrailing
                                                               multiplier:1.0
                                                                 constant:0]];
    
    [curentSelf.view addConstraint:[NSLayoutConstraint constraintWithItem:viewMap
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:curentSelf.view
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0
                                                                 constant:0]];
    
    [curentSelf.view addConstraint:[NSLayoutConstraint constraintWithItem:viewMap
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:curentSelf.view
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:0]];
    
    
    
    
    
    
//    viewMap.smallMapView.layer.cornerRadius = 30;
//    viewMap.smallMapView.layer.borderWidth = 2;
//    viewMap.smallMapView.layer.borderColor=[UIColor clearColor].CGColor;
//    viewMap.smallMapView.layer.masksToBounds = YES;
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
    request.timeoutInterval = 30;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data)
        {
            
            
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:@"Нет соединения с интернетом!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        [indicator1 stopAnimating];
                                        [viewMap removeFromSuperview];
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
                                
                                        
                                        
                                        googleMapUrl=[NSString stringWithFormat:@"comgooglemaps://?q=%f,%f&zoom=15",
                                                      [SingleDataProvider sharedKey].lat,
                                                      [SingleDataProvider sharedKey].lon];
                                        
                                yandexMapUrl=[NSString stringWithFormat:@"yandexnavi://show_point_on_map?lat=%f&lon=%f&zoom=15",
                                                      [SingleDataProvider sharedKey].lat,
                                                      [SingleDataProvider sharedKey].lon];
                                        
                                    }];
                [alert addAction:ok];
                [curentSelf presentViewController:alert animated:YES completion:nil];
                
            }
            else
            {
                googleMapUrl=[NSString stringWithFormat:@"comgooglemaps://?q=%f,%f&zoom=15",
                              [getLastKnownLocationResponseObject.latitude doubleValue],
                              [getLastKnownLocationResponseObject.longitude doubleValue]];
                
                yandexMapUrl=[NSString stringWithFormat:@"yandexnavi://show_point_on_map?lat=%f&lon=%f&zoom=15",
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
-(void)dealloc
{

}
@end
