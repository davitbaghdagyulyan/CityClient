//
//  SingleDataProvider.m
//  CityMobilDriver
//
//  Created by Intern on 10/8/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "SingleDataProvider.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import <MapKit/MapKit.h>
#import "ASMapAnnotation.h"

@implementation SingleDataProvider
+(SingleDataProvider*)sharedKey
{
    static SingleDataProvider* obj = nil;
    if (obj == nil)
    {
        
        obj = [[super alloc] init];
        

        
    }
   
    return obj;
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
    
    if (status==kCLAuthorizationStatusAuthorizedAlways)
   {
       [[SingleDataProvider sharedKey]setIsGPSEnabled:YES];

//       if ([[(UINavigationController *)[[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController] visibleViewController] isKindOfClass:[RootViewController class]])
//       {
//           [[SingleDataProvider sharedKey].gpsButtonHandlerPort setImage:[UIImage imageNamed:@"gps_green.png"] forState:UIControlStateNormal];
//           
//           [[SingleDataProvider sharedKey].gpsButtonHandlerLand setImage:[UIImage imageNamed:@"gps_green.png"] forState:UIControlStateNormal];
//           
//           [[SingleDataProvider sharedKey].gpsButtonHandlerIpad setImage:[UIImage imageNamed:@"gps_green.png"] forState:UIControlStateNormal];
//
//       }
//       else
       {
           [[SingleDataProvider sharedKey].gpsButtonHandler setImage:[UIImage imageNamed:@"gps_green.png"] forState:UIControlStateNormal];
       }

       
   }
    else
    {
       
          [[SingleDataProvider sharedKey]setIsGPSEnabled:NO];
       
//          if ([[(UINavigationController *)[[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController] visibleViewController] isKindOfClass:[RootViewController class]])
//          {
//              
//          [[SingleDataProvider sharedKey].gpsButtonHandlerPort setImage:[UIImage imageNamed:@"gps.png"] forState:UIControlStateNormal];
//        
//        [[SingleDataProvider sharedKey].gpsButtonHandlerLand setImage:[UIImage imageNamed:@"gps.png"] forState:UIControlStateNormal];
//        
//        [[SingleDataProvider sharedKey].gpsButtonHandlerIpad setImage:[UIImage imageNamed:@"gps.png"] forState:UIControlStateNormal];
//          }
//          else
          {
              [[SingleDataProvider sharedKey].gpsButtonHandler  setImage:[UIImage imageNamed:@"gps.png"] forState:UIControlStateNormal];
          }
 
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations lastObject];
    [SingleDataProvider sharedKey].lat= currentLocation.coordinate.latitude;
    [SingleDataProvider sharedKey].lon= currentLocation.coordinate.longitude;
    [SingleDataProvider sharedKey].time=currentLocation.timestamp.timeIntervalSince1970;
    [SingleDataProvider sharedKey].direction= currentLocation.horizontalAccuracy;
    [SingleDataProvider sharedKey].speed=currentLocation.speed;
     if ([[(UINavigationController *)[[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController] visibleViewController] isKindOfClass:[MapViewController class]])
     {
    [[SingleDataProvider sharedKey].mapViewController addAnotation:currentLocation.coordinate];
     }
}
-(void)startTimer
{
    /////test map////
    UIViewController*vc=[(UINavigationController *)[[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController] visibleViewController];
    [SingleDataProvider sharedKey].mapViewController=[vc.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    //[SingleDataProvider sharedKey].mapViewController.mapView=[[MKMapView alloc] init];
    
    //test end map////
    addGPSJsonObject=[[AddGPSJson alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = [SingleDataProvider sharedKey];
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.locationManager requestAlwaysAuthorization];
    
       
    }
    [self.locationManager startUpdatingLocation];
    self.timer=[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(addGPSaction) userInfo:nil repeats:YES];
     myQueue = [[NSOperationQueue alloc] init];

}

-(void)stopTimer
{
    [self.timer invalidate];
}

-(void)addGPSaction
{
    NSLog(@"self==%@",self);
   
   [self performSelectorInBackground:@selector(addGPS) withObject:nil];
}

-(void)addGPS
{
    addGPSJsonObject.lat=[NSString stringWithFormat:@"%f",[SingleDataProvider sharedKey].lat];
    addGPSJsonObject.lon=[NSString stringWithFormat:@"%f",[SingleDataProvider sharedKey].lon];
    addGPSJsonObject.time=[NSString stringWithFormat:@"%f",[SingleDataProvider sharedKey].time];
    addGPSJsonObject.direction=[NSString stringWithFormat:@"%f",[SingleDataProvider sharedKey].direction];
    addGPSJsonObject.speed=[NSString stringWithFormat:@"%f",[SingleDataProvider sharedKey].direction];
    NSDictionary*jsonDictionary=[addGPSJsonObject toDictionary];
    NSString*jsons=[addGPSJsonObject toJSONString];
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
            NSLog(@"%@",@"Нет соединения с интернетом!");
            return ;
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",jsonString);
        NSError*err;
        
        
        
        addGPSResponseObject = [[AddGPSResponse alloc] initWithString:jsonString error:&err];
        
        
        
        
        
        if(addGPSResponseObject.code==nil && addGPSResponseObject.gpsError!=1)
        {
            [UserInformationProvider sharedInformation].balance = addGPSResponseObject.balance;
            [IconsColorSingltone sharedColor].yandexColor = [addGPSResponseObject.y_autoget integerValue];
            [IconsColorSingltone sharedColor].cityMobilColor = [addGPSResponseObject.autoget integerValue];
        }

       
        if (addGPSResponseObject.order != nil)
        {

          dispatch_async(dispatch_get_main_queue(), ^{
              
              
                        if ([[(UINavigationController *)[[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController] visibleViewController] isKindOfClass:[IncomingOrderViewController class]])
                        {
                             [(UINavigationController *)[[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController ] popViewControllerAnimated:NO];
                        }
              
              
              iovc = [[(UINavigationController *)[[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController] visibleViewController].storyboard instantiateViewControllerWithIdentifier:@"IncomingOrderViewController"];
              
             

              iovc.order= addGPSResponseObject.order;
              //addGPSResponseObject.order=nil;
              /////test ////
              
//              iovc.order.OrderComment=@"uygugygyu uvyubuybubuy uybuybbybyby yvbyvyvy yvyvybyb";
//              iovc.order.DeliveryAddressText=@"м. Парк культуры, пер Кропоткинский, д.12";
//              iovc.order.canReject=@"1";
//              iovc.order.idhash=@"e07877686ca81175433e40c41ae160c4";
              
              
              //////test ///
              
              
                
                [(UINavigationController *)[[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController ] pushViewController:iovc animated:NO];
           });
            
            
            
        }

    }];
    
    
   
}

@end
