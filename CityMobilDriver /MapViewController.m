//
//  MapViewController.m
//  CityMobilDriver
//
//  Created by Intern on 1/7/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//
#import "SingleDataProvider.h"
#import "MapViewController.h"
#import "ASMapAnnotation.h"

@interface MapViewController ()
{
    MKPolylineView* lineView;
    CLLocationCoordinate2D firstLocation;
}

@end

@implementation MapViewController



- (void)viewDidLoad {
    [super viewDidLoad];
        self.backButton.clipsToBounds=YES;
        self.backButton.layer.cornerRadius = self.backButton.frame.size.height/2.0f;
        self.backButton.layer.borderWidth = 1;
        self.backButton.layer.borderColor=[UIColor clearColor].CGColor;
        self.backButton.layer.masksToBounds = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    //self.mapView=[[MKMapView alloc]init];
    self.mapView.delegate=self;
  
    NSLog(@"%@",self.mapView.annotations);

}
-(void)addAnotation:(CLLocationCoordinate2D)lastLocation
{
    //[self actionShowAll];
    if (firstLocation.latitude==0&&firstLocation.longitude==0)
    {
        CLLocationCoordinate2D coord = {lastLocation.latitude, lastLocation.longitude};
        MKCoordinateSpan span = {0.5,0.5};
        MKCoordinateRegion region = {coord,span};
        
        [self.mapView setRegion:region];
        
        firstLocation=lastLocation;
        return;
    }
    
    [self drawRouteLine:firstLocation secondPoint:lastLocation];
    
     firstLocation=lastLocation;
    
    
    ASMapAnnotation* annotation = [[ASMapAnnotation alloc] init];
    
    annotation.title = @"Test Title";
    annotation.subtitle = @"Test Subtitle";
    
    
    annotation.coordinate = lastLocation;
    [self.mapView addAnnotation:annotation];
    NSLog(@"%@",self.mapView.annotations);


    
   
    
  
}
- (IBAction)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    
//    if ([annotation isKindOfClass:[MKUserLocation class]]) {
//        return nil;
//    }
//    
//    static NSString* identifier = @"Annotation";
//    
//    MKPinAnnotationView* pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
//    
//    if (!pin) {
//        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
//        pin.pinColor = MKPinAnnotationColorPurple;
//        pin.animatesDrop = YES;
//        pin.canShowCallout = YES;
//        pin.draggable = YES;
//    } else {
//        pin.annotation = annotation;
//    }
//    
//    return pin;
//}

- (void) actionShowAll
{
    
    MKMapRect zoomRect = MKMapRectNull;
    
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        
        CLLocationCoordinate2D location = annotation.coordinate;
        
        MKMapPoint center = MKMapPointForCoordinate(location);
        
        static double delta = 2000;
        
        MKMapRect rect = MKMapRectMake(center.x - delta, center.y - delta, delta * 2, delta * 2);
        
        zoomRect = MKMapRectUnion(zoomRect, rect);
    }
    
    zoomRect = [self.mapView mapRectThatFits:zoomRect];
    
    [self.mapView setVisibleMapRect:zoomRect
                        edgePadding:UIEdgeInsetsMake(50, 50, 50, 50)
                           animated:YES];
    
}
- (void)drawRouteLine:(CLLocationCoordinate2D)firstPoint secondPoint:(CLLocationCoordinate2D)secondPoint
{
    
    //start coordinate for street marking
    //lorain rd start
    //41.450074, -81.816620
    
    CLLocationCoordinate2D startCoordinate = firstPoint;
//    startCoordinate.latitude = 41.450074;
//    startCoordinate.longitude = -81.816620;
    
    //lorain rd end
    //41.485447, -81.700406
    
    CLLocationCoordinate2D endCoordinate = secondPoint;
//    endCoordinate.latitude = 41.485447;
//    endCoordinate.longitude = -81.700406;
    
    MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * 2);
    
    MKMapPoint point1 = MKMapPointForCoordinate(startCoordinate);
    pointArr[0] = point1;
    MKMapPoint point2 = MKMapPointForCoordinate(endCoordinate);
    pointArr[1] = point2;
    
    // create a polyline with all cooridnates
    MKPolyline *polyline = [MKPolyline polylineWithPoints:pointArr count:2];
    [self.mapView addOverlay:polyline];
    
    lineView = [[MKPolylineView alloc]initWithPolyline:polyline];
    lineView.strokeColor = [UIColor redColor];
    lineView.lineWidth = 5;
    
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    return lineView;
}


@end
