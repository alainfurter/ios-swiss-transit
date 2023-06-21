//
//  BasicStop.h
//  Swiss Trains
//
//  Created by Alain on 29.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Station.h"
#import "Arr.h"
#import "Dep.h"

enum basicStoptype {
    departureType = 1,
    arrivalType = 2,
    bothType = 3
    };

@interface BasicStop : NSObject

@property (strong, nonatomic) Station *station;
@property (strong, nonatomic) Arr *arr;
@property (strong, nonatomic) Dep *dep;
@property (assign) NSUInteger basicStopType;
//@property (strong, nonatomic) NSString *timeString;
@property (strong, nonatomic) NSString *platform;
@property (strong, nonatomic) NSNumber *capacity1st;
@property (strong, nonatomic) NSNumber *capacity2nd;
@property (strong, nonatomic) NSString *scheduled;

@end
