//
//  GPSConection.m
//  CityMobilDriver
//
//  Created by Intern on 12/19/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "GPSConection.h"
#import <CoreLocation/CoreLocation.h>

@implementation GPSConection

+(void) showGPSConection:(UIViewController*) viewController
{
    if (![CLLocationManager locationServicesEnabled])
    {
    UIAlertController* gpsNotEnabled = [UIAlertController alertControllerWithTitle:@"Беспроводные сети или GPS отключены" message:@"Включить беспроводные сети и GPS?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* no = [UIAlertAction actionWithTitle:@"нет" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                         {
                             [gpsNotEnabled dismissViewControllerAnimated:YES completion:nil];
                         }];
    UIAlertAction* yes = [UIAlertAction actionWithTitle:@"да" style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action)
                          {
                              [gpsNotEnabled dismissViewControllerAnimated:YES completion:nil];
//                              NSURL *url = [NSURL URLWithString:@"prefs://root=LOCATION_SERVICES"];
//                              [[UIApplication sharedApplication] openURL:url];
                               [[UIApplication sharedApplication] openURL: [NSURL URLWithString: UIApplicationOpenSettingsURLString]];
                          }];
    [gpsNotEnabled addAction:yes];
    [gpsNotEnabled addAction:no];
    
    [viewController presentViewController:gpsNotEnabled animated:NO completion:nil];
    }
}







@end
