//
//  TrainLinesController.h
//  Swiss Trains
//
//  Created by Alain on 13.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import <MTDirectionsKit/MTDirectionsKit.h>

#import "Station.h"
#import "BasicStop.h"

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

#import "TrainlineOperation.h"
//#import "TrainlineTestOperation.h"

#import "Connections.h"
#import "ConSection.h"
#import "StationboardResults.h"
#import "Journey.h"

//#define TrainlineLogLevelFull 1

@interface TrainLinesController : NSObject

+ (TrainLinesController *) sharedTrainLinesController;

@property (strong, nonatomic) NSOperationQueue *conReqTrainlineOperationQueue;
@property (strong, nonatomic) NSOperationQueue *stbReqTrainlineOperationQueue;
@property (assign) NSUInteger detaillevel;
@property (assign) NSUInteger routeleadsawaysfromdestinationtolerance;

- (void)setTrainlinesControllerDetaillevel:(NSUInteger)detaillevel;
- (void)setRouteleadsawaysfromdestinationtolerancelevel:(NSUInteger)tolerancelevel;

- (BOOL)areStationsOnCommonRoute:(Station *)startstation endstation:(Station *)endstation;

- (BOOL)isDetailedTrainlinePotentiallyAvailableForConresult:(ConResult *)conresult;
- (BOOL)isDetailedTrainlinePotentiallyAvailableForConsection:(ConSection *)consection;
- (BOOL)isDetailedTrainlinePotentiallyAvailableForJourney:(Journey *)journey;

- (void)sendConResTrainlineDetailsRequest:(ConResult *)conresult detaillevel:(NSUInteger)detaillevel connections:(Connections *)connections successBlock:(void(^)(NSArray *routes))successBlock failureBlock:(void(^)(NSUInteger))failureBlock routesavailableandprocessingblock:(void(^)(ConResult *conresult, BOOL detailsavailable))routesavailableandprocessingblock;

- (void)sendConReqTrainlineDetailsRequest:(ConSection *)consection detaillevel:(NSUInteger)detaillevel connections:(Connections *)connections successBlock:(void(^)(NSArray *routes))successBlock failureBlock:(void(^)(NSUInteger))failureBlock routesavailableandprocessingblock:(void(^)(ConSection *consection, BOOL detailsavailable))routesavailableandprocessingblock;

- (void)sendStbReqTrainlineDetailsRequest:(Journey *)journey detaillevel:(NSUInteger)detaillevel stationboardresults:(StationboardResults *)stationboardresults successBlock:(void(^)(NSArray *routes))successBlock failureBlock:(void(^)(NSUInteger))failureBlock routesavailableandprocessingblock:(void(^)(Journey *journey, BOOL detailsavailable))routesavailableandprocessingblock;

- (void)cancelAllTrainlineOperations;
- (void)cancelConReqTrainlineOperations;
- (void)cancelStbReqTrainlineOperations;

@end
