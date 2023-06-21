//
//  ConOverview.m
//  Swiss Trains
//
//  Created by Alain on 29.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "ConOverview.h"

@implementation ConOverview

- (NSDate *) getDateFromDateString {
    if (self.date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
        NSDate *date = [dateFormatter dateFromString: self.date];
        //NSLog(@"Datestring: %@", self.date);
        return date;
    }
    return  nil;
}

- (NSString *) getDateStringFromDateString {
    if (self.date) {        
        return self.date;
    }
    return  nil;
}

- (NSUInteger) getDaysFromDuration {
    if (self.duration) {
        if ([self.duration length] == 11) {
            NSArray *durationSplit = [self.duration componentsSeparatedByString: @"d"];
            if ([durationSplit count] == 2) {
                return [[durationSplit objectAtIndex: 0] integerValue];
            }
        }
    }
    return 0;
}

- (NSString *) getDaysStringFromDuration {
    if (self.duration) {
        if ([self.duration length] == 11) {
            NSArray *durationSplit = [self.duration componentsSeparatedByString: @"d"];
            if ([durationSplit count] == 2) {
                return [durationSplit objectAtIndex: 0];
            }
        }
    }
    return nil;
}

- (NSUInteger) getHoursFromDuration {
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

- (NSString *) getHoursStringFromDuration {
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

- (NSUInteger) getMinutesFromDuration {
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

- (NSString *) getMinutesStringFromDuration {
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

@end
