//
//  CustomViewForMaps.h
//  CityMobilDriver
//
//  Created by Intern on 11/11/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomViewForMaps : UIView
@property (strong, nonatomic) IBOutlet UIView *smallMapView;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIImageView *googleImageView;
@property (strong, nonatomic) IBOutlet UIImageView *yandexImageView;

@end
