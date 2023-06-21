//
//  StationsAnnotationView.h
//  Swiss Trains
//
//  Created by Alain on 14.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <MapKit/MapKit.h>

enum stationAnnotationeType {
    startStation = 1,
    middleStation = 2,
    endStation = 3
};


@interface StationsAnnotationView : MKAnnotationView


@property (nonatomic, assign) NSUInteger annotationType;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

- (void) setAnnotationImageForType:(NSUInteger)annotationType;
- (void) setAnnotationImageForType:(NSUInteger)annotationType withscale:(double)scale;

@end
