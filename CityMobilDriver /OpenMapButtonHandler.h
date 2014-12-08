//
//  OpenMapButtonHandler.h
//  CityMobilDriver
//
//  Created by Intern on 12/5/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GetLastKnownLocationJson.h"
#import "GetLastKnownLocationResponse.h"
#import "CustomViewForMaps.h"
#import "SingleDataProvider.h"

@interface OpenMapButtonHandler : NSObject
{
    CustomViewForMaps*viewMap;
    NSString* googleMapUrl;
    NSString* yandexMapUrl;
    UIViewController*curentSelf;
}
-(void)setCurentSelf:(UIViewController*)cSelf;
@end
