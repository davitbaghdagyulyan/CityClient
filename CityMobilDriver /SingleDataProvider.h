//
//  SingleDataProvider.h
//  CityMobilDriver
//
//  Created by Intern on 10/8/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//
#import "MapViewController.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AddGPSJson.h"
#import "AddGPSResponse.h"
#import "UserInformationProvider.h"
#import "IconsColorSingltone.h"
#import "IncomingOrderViewController.h"
@interface SingleDataProvider : NSObject<CLLocationManagerDelegate>
{
    CLLocation* currentLocation;
   
    AddGPSJson*addGPSJsonObject;
    AddGPSResponse*addGPSResponseObject;
    NSOperationQueue *myQueue ;
    IncomingOrderViewController*iovc;
}


@property(nonatomic,strong)NSMutableArray * arrayOfIndexes1;
@property(nonatomic,strong)NSMutableArray * arrayOfIndexes2;
@property(nonatomic,strong) NSString* key;
@property(nonatomic,strong)NSTimer*timer;
@property(nonatomic,assign)CGFloat lat;
@property(nonatomic,assign)CGFloat lon;
@property(nonatomic,assign)CGFloat time;
@property(nonatomic,assign)CGFloat direction;
@property(nonatomic,assign)CGFloat speed;
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)UIButton*gpsButtonHandler;
@property(nonatomic,strong)UIButton*gpsButtonHandlerPort;
@property(nonatomic,strong)UIButton*gpsButtonHandlerLand;
@property(nonatomic,strong)UIButton*gpsButtonHandlerIpad;
@property(nonatomic,strong)MapViewController*mapViewController;
@property(nonatomic,assign)BOOL isGPSEnabled;
+(SingleDataProvider*)sharedKey;
-(void)startTimer;
-(void)stopTimer;
@end
