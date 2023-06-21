//
//  Stations.h
//  Swiss Trains
//
//  Created by Alain on 20.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>

@interface Stations : NSManagedObject <MKAnnotation>

@property (nonatomic, retain) NSString * stationname;
@property (nonatomic, retain) NSString * searchstationname;
@property (nonatomic, retain) NSString * searchstationname2;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * externalid;
//@property (nonatomic, retain) NSNumber * trainlinecode;
//@property (nonatomic, retain) NSNumber * trainlinerank;
//@property (nonatomic, retain) NSNumber * trainlineend;

@property (assign) float distance;

- (CLLocationCoordinate2D)coordinate;
- (NSString *)title;
- (NSString *)subtitle;
- (NSString *)getFormmattedStationDistance;

- (MKMapItem*)mapItem;

@end
