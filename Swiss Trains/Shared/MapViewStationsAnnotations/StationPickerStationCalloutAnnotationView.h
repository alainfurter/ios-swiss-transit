//
//  StationPickerStationAnnotationView.h
//  Swiss Trains
//
//  Created by Alain on 15.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface StationPickerCalloutStationAnnotationView : MKAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, strong) UIView *contentView;

@end
