//
//  DepArr.h
//  Swiss Trains
//
//  Created by Alain on 29.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DepArr : NSObject

@property (strong, nonatomic) NSString *timeString;
@property (strong, nonatomic) NSString *platform;

@property (strong, nonatomic) NSString *expectedTimeString;
@property (strong, nonatomic) NSString *expectedPlatform;

- (NSUInteger) getDaysFromTime;
- (NSUInteger) getHoursFromTime;
- (NSUInteger) getMinutesFromTime;

- (NSString *) getDaysStringFromTime;
- (NSString *) getHoursStringFromTime;
- (NSString *) getMinutesStringFromTime;

- (NSString *) getFormattedTimeStringFromTime;

- (NSString *) getExpectedHoursStringFromTime;
- (NSString *) getExpectedMinutesStringFromTime;

- (NSString *) getFormattedExpectedTimeStringFromTime;

@end
