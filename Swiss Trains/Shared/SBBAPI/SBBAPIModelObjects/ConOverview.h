//
//  ConOverview.h
//  Swiss Trains
//
//  Created by Alain on 29.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicStop.h"

@interface ConOverview : NSObject

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *duration;
@property (strong, nonatomic) NSString *transfers;
@property (strong, nonatomic) NSString *products;

@property (strong, nonatomic) BasicStop *departure;
@property (strong, nonatomic) BasicStop *arrival;

- (NSDate *) getDateFromDateString;
- (NSString *) getDateStringFromDateString;

- (NSUInteger) getDaysFromDuration;
- (NSUInteger) getHoursFromDuration;
- (NSUInteger) getMinutesFromDuration;

- (NSString *) getDaysStringFromDuration;
- (NSString *) getHoursStringFromDuration;
- (NSString *) getMinutesStringFromDuration;

@end
