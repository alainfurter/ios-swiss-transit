//
//  StationPickerStationAnnotationView.h
//  Swiss Trains
//
//  Created by Alain on 15.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface StationPickerStationAnnotationView : MKAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end
