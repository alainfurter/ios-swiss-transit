//
//  Journey.h
//  Swiss Trains
//
//  Created by Alain on 29.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JourneyHandle.h"
#import "BasicStop.h"


@interface Journey : NSObject

@property (strong, nonatomic) JourneyHandle *journeyHandle;         // all but only important in stb and journey request
@property (strong, nonatomic) BasicStop *mainstop;                  // only stb station board request

@property (strong, nonatomic) NSString *journeyName;
@property (strong, nonatomic) NSString *journeyNumber;
@property (strong, nonatomic) NSString *journeyCategoryCode;
@property (strong, nonatomic) NSString *journeyCategoryName;
@property (strong, nonatomic) NSString *journeyAdministration;
@property (strong, nonatomic) NSString *journeyOperator;
@property (strong, nonatomic) NSString *journeyDirection;
@property (strong, nonatomic) NSMutableArray *passList;             // only con req connection request and journey request
@property (strong, nonatomic) NSString *prognosis;

@property (assign) BOOL journeyIsDelayed;

@property (strong, nonatomic) NSArray *routes;
@property (assign) BOOL detailedroutesprechecked;
@property (assign) BOOL detailedroutesavailable;


@end
