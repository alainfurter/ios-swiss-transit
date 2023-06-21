//
//  Walk.m
//  Swiss Trains
//
//  Created by Alain on 29.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "Walk.h"

@implementation Walk

- (NSUInteger) getHoursFromTime {
    if (self.duration) {
        if ([self.duration length] == 11) {
            NSArray *durationSplit = [self.duration componentsSeparatedByString: @"d"];
            if ([durationSplit count] == 2) {
                NSArray *timeSplit = [[durationSplit objectAtIndex:1] componentsSeparatedByString: @":"];
                if ([timeSplit count] == 3) {
                    return [[timeSplit objectAtIndex:0] integerValue];
                }
            }
        }
    }
    return 0;
}

- (NSString *) getHoursStringFromTime {
    if (self.duration) {
        if ([self.duration length] == 11) {
            NSArray *durationSplit = [self.duration componentsSeparatedByString: @"d"];
            if ([durationSplit count] == 2) {
                NSArray *timeSplit = [[durationSplit objectAtIndex:1] componentsSeparatedByString: @":"];
                if ([timeSplit count] == 3) {
                    return [timeSplit objectAtIndex:0];
                }
            }
        }
    }
    return nil;
}

- (NSUInteger) getMinutesFromTime {
    if (self.duration) {
        if ([self.duration length] == 11) {
            NSArray *durationSplit = [self.duration componentsSeparatedByString: @"d"];
            if ([durationSplit count] == 2) {
                NSArray *timeSplit = [[durationSplit objectAtIndex:1] componentsSeparatedByString: @":"];
                if ([timeSplit count] == 3) {
                    return [[timeSplit objectAtIndex:1] integerValue];
                }
            }
        }
    }
    return 0;
}

- (NSString *) getMinutesStringFromTime {
    if (self.duration) {
        if ([self.duration length] == 11) {
            NSArray *durationSplit = [self.duration componentsSeparatedByString: @"d"];
            if ([durationSplit count] == 2) {
                NSArray *timeSplit = [[durationSplit objectAtIndex:1] componentsSeparatedByString: @":"];
                if ([timeSplit count] == 3) {
                    return [timeSplit objectAtIndex:1];
                }
            }
        }
    }
    return nil;
}

- (NSString *) getFormattedMetresStringFromDistance {
    if (self.distance) {
        NSUInteger distanceInMeters = [self.distance integerValue];
        //distanceInMeters = 1658;
        if (distanceInMeters > 0) {
            if (distanceInMeters > 1000) {
                NSUInteger distanceInKs = distanceInMeters / 1000;
                NSUInteger distanceRest = distanceInMeters - distanceInKs * 1000;
                NSUInteger distanceInHundreds = distanceRest / 100;
                return [NSString stringWithFormat: @"%d.%d km", distanceInKs, distanceInHundreds];
            } else {
                return [NSString stringWithFormat: @"%d m", distanceInMeters];
            }
        }
    }
    return  nil;
}

- (NSString *) getFormattedDurationStringFromDuration {
    NSUInteger durationHours = [self getHoursFromTime];
    NSUInteger durationMinutes = [self getMinutesFromTime];
    //durationHours = 12;
    //durationMinutes = 52;
    if (durationHours > 0) {
        return [NSString stringWithFormat: @"%dh %dm", durationHours, durationMinutes];
    } else {
        return [NSString stringWithFormat: @"%d min", durationMinutes];
    }
    return  nil;
}

@end
