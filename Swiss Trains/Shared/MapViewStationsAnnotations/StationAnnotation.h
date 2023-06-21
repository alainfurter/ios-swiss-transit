//
//  StationAnnotation.h
//  Swiss Trains
//
//  Created by Alain on 14.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>

@interface StationAnnotation :  NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

- (MKMapItem*)mapItem;

@end
