//
//  MapViewController.h
//  CityMobilDriver
//
//  Created by Intern on 1/7/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)backAction:(UIButton *)sender;

-(void)addAnotation:(CLLocationCoordinate2D)lastPoint;
@end
