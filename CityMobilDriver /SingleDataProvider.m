//
//  SingleDataProvider.m
//  CityMobilDriver
//
//  Created by Intern on 10/8/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "SingleDataProvider.h"


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
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations lastObject];
    
    [SingleDataProvider sharedKey].lat= currentLocation.coordinate.latitude;
    [SingleDataProvider sharedKey].lon= currentLocation.coordinate.longitude;
    [SingleDataProvider sharedKey].time=currentLocation.timestamp.timeIntervalSince1970;
    [SingleDataProvider sharedKey].direction= currentLocation.horizontalAccuracy;
    [SingleDataProvider sharedKey].speed=currentLocation.speed;
    
    
}
-(void)startTimer
{
   
    addGPSJsonObject=[[AddGPSJson alloc] init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = [SingleDataProvider sharedKey];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    self.timer=[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(addGPSaction) userInfo:nil repeats:YES];
//    [NSThread detachNewThreadSelector:@selector(addGPSaction) toTarget:self withObject:nil];
     myQueue = [[NSOperationQueue alloc] init];

}

-(void)stopTimer
{
    [self.timer invalidate];
}

-(void)addGPSaction
{
    
    [self performSelectorInBackground:@selector(fff) withObject:nil];
}

-(void)fff
{
    addGPSJsonObject.lat=[NSString stringWithFormat:@"%f",[SingleDataProvider sharedKey].lat];
    addGPSJsonObject.lon=[NSString stringWithFormat:@"%f",[SingleDataProvider sharedKey].lon];
    addGPSJsonObject.time=[NSString stringWithFormat:@"%f",[SingleDataProvider sharedKey].time];
    addGPSJsonObject.direction=[NSString stringWithFormat:@"%f",[SingleDataProvider sharedKey].direction];
    addGPSJsonObject.speed=[NSString stringWithFormat:@"%f",[SingleDataProvider sharedKey].direction];
    NSDictionary*jsonDictionary=[addGPSJsonObject toDictionary];
    NSString*jsons=[addGPSJsonObject toJSONString];
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
    [NSURLConnection sendAsynchronousRequest:request queue:myQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data)
        {
            NSLog(@"%@",@"Нет соединения с интернетом!");
            return ;
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",jsonString);
        NSError*err;
        
        
        
        addGPSResponseObject = [[AddGPSResponse alloc] initWithString:jsonString error:&err];
        
        
        
        
        
        if(addGPSResponseObject.code==nil)
        {
            [UserInformationProvider sharedInformation].balance = addGPSResponseObject.balance;
            [IconsColorSingltone sharedColor].yandexColor = [addGPSResponseObject.y_autoget integerValue];
            [IconsColorSingltone sharedColor].cityMobilColor = [addGPSResponseObject.autoget integerValue];
        }
    }];

}

@end
