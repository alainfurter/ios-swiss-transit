//
//  StbJourney.h
//  Swiss Trains
//
//  Created by Alain on 17.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicStop.h"
#import "JourneyHandle.h"

@interface StbJourney : NSObject

@property (strong, nonatomic) JourneyHandle *journeyHandle;
@property (strong, nonatomic) BasicStop *mainstop;

@property (strong, nonatomic) NSString *journeyName;
@property (strong, nonatomic) NSString *journeyNumber;
@property (strong, nonatomic) NSString *journeyCategoryCode;
@property (strong, nonatomic) NSString *journeyCategoryName;
@property (strong, nonatomic) NSString *journeyAdministration;
@property (strong, nonatomic) NSString *journeyOperator;
@property (strong, nonatomic) NSString *journeyDirection;
@property (strong, nonatomic) NSString *prognosis;

@end
