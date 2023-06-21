//
//  Connections.h
//  Swiss Trains
//
//  Created by Alain on 30.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Connections : NSObject

@property (strong, nonatomic) NSString *direction;
@property (strong, nonatomic) NSString *conId;

@property (strong, nonatomic) NSString *conIdexconscrid;
@property (strong, nonatomic) NSNumber *conscridbackwards;
@property (strong, nonatomic) NSNumber *conscridforward;

@property (strong, nonatomic) NSString *knownBetterStartLocationName;
@property (strong, nonatomic) NSString *knownBetterEndLocationName;

@property (strong, nonatomic) NSMutableArray *conResults;

@property (strong, nonatomic) NSDate *searchdate;
@property (assign) BOOL searchdateisdeparturedate;

@end
