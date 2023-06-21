//
//  Station.h
//  Swiss Trains
//
//  Created by Alain on 29.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

enum stationTypeCodes {
    stationTypeStation = 1,
    stationTypePoi = 2,
    stationTypeAddress = 3,
    stationTypeOtherYetUndefined = 4
};

@interface Station : NSObject

@property (strong, nonatomic) NSString *stationName;
@property (strong, nonatomic) NSString *stationId;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;

@property (strong, nonatomic) NSNumber *trainlinecode;
@property (strong, nonatomic) NSNumber *trainlinerank;
@property (strong, nonatomic) NSNumber *trainlineend;

@property (assign) NSUInteger stationType;

@end
