//
//  Walk.h
//  Swiss Trains
//
//  Created by Alain on 29.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Walk : NSObject

@property (strong, nonatomic) NSString *duration;
@property (strong, nonatomic) NSString *distance;

- (NSString *) getHoursStringFromTime;
- (NSString *) getMinutesStringFromTime;

- (NSString *) getFormattedMetresStringFromDistance;
- (NSString *) getFormattedDurationStringFromDuration;

@end
