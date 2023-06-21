//
//  DepArr.m
//  Swiss Trains
//
//  Created by Alain on 29.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "DepArr.h"

@implementation DepArr

- (NSUInteger) getDaysFromTime {
    if (self.timeString) {
        if ([self.timeString length] == 11) {
            NSArray *durationSplit = [self.timeString componentsSeparatedByString: @"d"];
            if ([durationSplit count] == 2) {
                return [[durationSplit objectAtIndex: 0] integerValue];
            }
        }
    }
    return 0;
}

- (NSString *) getDaysStringFromTime {
    if (self.timeString) {
        if ([self.timeString length] == 11) {
            NSArray *durationSplit = [self.timeString componentsSeparatedByString: @"d"];
            if ([durationSplit count] == 2) {
                return [durationSplit objectAtIndex: 0];
            }
        }
    }
    return nil;
}

- (NSUInteger) getHoursFromTime {
    if (self.timeString) {
        if ([self.timeString length] == 11) {
            NSArray *durationSplit = [self.timeString componentsSeparatedByString: @"d"];
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
    if (self.timeString) {
        if ([self.timeString length] == 11) {
            NSArray *durationSplit = [self.timeString componentsSeparatedByString: @"d"];
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
    if (self.timeString) {
        if ([self.timeString length] == 11) {
            NSArray *durationSplit = [self.timeString componentsSeparatedByString: @"d"];
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
    if (self.timeString) {
        if ([self.timeString length] == 11) {
            NSArray *durationSplit = [self.timeString componentsSeparatedByString: @"d"];
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

- (NSString *) getFormattedTimeStringFromTime {
    NSString *durationHoursString = [self getHoursStringFromTime];
    NSString *durationMinutesString = [self getMinutesStringFromTime];
    return [NSString stringWithFormat: @"%@:%@", durationHoursString, durationMinutesString];
}

- (NSString *) getExpectedHoursStringFromTime {
    if (self.expectedTimeString) {
        if ([self.expectedTimeString length] == 11) {
            NSArray *durationSplit = [self.expectedTimeString componentsSeparatedByString: @"d"];
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

- (NSString *) getExpectedMinutesStringFromTime {
    if (self.expectedTimeString) {
        if ([self.expectedTimeString length] == 11) {
            NSArray *durationSplit = [self.expectedTimeString componentsSeparatedByString: @"d"];
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

- (NSString *) getFormattedExpectedTimeStringFromTime {
    NSString *durationHoursString = [self getExpectedHoursStringFromTime];
    NSString *durationMinutesString = [self getExpectedMinutesStringFromTime];
    if (durationHoursString && durationMinutesString) {
        return [NSString stringWithFormat: @"%@:%@", durationHoursString, durationMinutesString];
    }
    return nil;
}

@end
