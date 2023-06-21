//
//  StationAnnotation.m
//  Swiss Trains
//
//  Created by Alain on 14.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "StationAnnotation.h"

@implementation StationAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    
    if (self != nil) {
        self.coordinate = coordinate;
    }
    
    return self;
}

- (NSString *)title {
    return _title;
}

- (NSString *)subtitle {
    return _subtitle;
}

- (MKMapItem*)mapItem {
    // 1
    /*
    NSDictionary *addressDict = @{
    (NSString *) kABPersonAddressStreetKey : location.street,
    (NSString *) kABPersonAddressStreetKey : location.street,
    (NSString *) kABPersonAddressCityKey : location.city,
    (NSString *) kABPersonAddressStateKey : location.state,
    (NSString *) kABPersonAddressZIPKey : location.zip,
    (NSString *) kABPersonAddressCountryKey : @"CH"
    };
    */
    NSDictionary *addressDict = @{
    (NSString *) kABPersonAddressCountryKey : @"CH"
    };
    
    
    // 2
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:addressDict];
 
    // 3
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;    
    return mapItem;
}

@end
