//
//  ASMapAnnotation.h
//  MapTest
//
//  Created by Oleksii Skutarenko on 11.01.14.
//  Copyright (c) 2014 Alex Skutarenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>


@interface ASMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
