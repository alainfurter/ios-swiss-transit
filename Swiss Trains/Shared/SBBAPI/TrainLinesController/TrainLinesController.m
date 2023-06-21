//
//  TrainLinesController.m
//  Swiss Trains
//
//  Created by Alain on 13.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "TrainLinesController.h"

@implementation TrainLinesController

+ (TrainLinesController *)sharedTrainLinesController
{
    static TrainLinesController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TrainLinesController alloc] init];

        sharedInstance.detaillevel = 1;
        sharedInstance.routeleadsawaysfromdestinationtolerance = 1;
        sharedInstance.conReqTrainlineOperationQueue = [[NSOperationQueue alloc] init];
        sharedInstance.stbReqTrainlineOperationQueue = [[NSOperationQueue alloc] init];
    });
    
    return sharedInstance;
}

- (void)setTrainlinesControllerDetaillevel:(NSUInteger)detaillevel {
    if (detaillevel <= 4) {
        self.detaillevel = detaillevel;
    }
}

- (void)setRouteleadsawaysfromdestinationtolerancelevel:(NSUInteger)tolerancelevel {
    if (tolerancelevel <=3) {
        self.routeleadsawaysfromdestinationtolerance = tolerancelevel;
        return;
    }
}

- (NSString *)getSimpleExternalid:(NSString *)externalid {
    if (externalid) {
        NSArray *splitarray = [externalid componentsSeparatedByString: @"#"];
        if (splitarray && splitarray.count == 2) {
            return [splitarray objectAtIndex: 0];
        }
    }
    
    return externalid;
}

#ifdef TrainlineLogLevelFull
- (void)logPasslist:(NSArray *)passlist {
    if (passlist && passlist.count > 0) {
        for (BasicStop *currenstop in passlist) {
            Station *currentstation = [self getStationForBasicStop: currenstop];
            NSLog(@"Passlist station: %@, %@, %.6f, %.6f", currentstation.stationName, currentstation.stationId, [currentstation.latitude doubleValue], [currentstation.longitude doubleValue]);
        }
    }
}
#endif

- (BOOL) areStationsOnCommonRoute:(Station *)startstation endstation:(Station *)endstation {
    
    if (startstation && endstation && startstation.stationId && endstation.stationId) {
        NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
        NSString *dbpath = [bundlePath stringByAppendingPathComponent:@"Trainlines.sqlite"];
        FMDatabase *database = [FMDatabase databaseWithPath:dbpath];
        
        if (![database open]) {
            NSLog(@"Could not open trainline database");
            return NO;
        }
        
        NSString *simpleexternalidstartstation = [self getSimpleExternalid: startstation.stationId];
        NSString *simpleexternalidendstation = [self getSimpleExternalid: endstation.stationId];
        
        #ifdef TrainlineLogLevelFull
        NSLog(@"AreStationsOnCommonRoute: %@, %@, / %@, %@", startstation.stationName, simpleexternalidstartstation, endstation.stationName, simpleexternalidendstation);
        #endif
        
        NSString *queryString = [NSString stringWithFormat: @"select distinct trainroute_id from trainroutes_trainstations where trainstation_id in (select distinct trainstation_id from trainstations where trainstation_extid = '%@') and trainroute_id in (select distinct trainroute_id from trainroutes_trainstations, trainstations where trainroutes_trainstations.trainstation_id = trainstations.trainstation_id AND trainstations.trainstation_extid = '%@');", simpleexternalidstartstation, simpleexternalidendstation];
        FMResultSet *s = [database executeQuery:queryString];
        
        NSUInteger routecount = 0;
        
        while ([s next]) {
            routecount++;
        }
        
        [database close];
        
        #ifdef TrainlineLogLevelFull
        NSLog(@"AreStationsOnCommonRoute (tc): %@", (routecount>0)?@"Y":@"N");
        #endif
        
        return (routecount > 0);
    }
    return NO;
}

- (BOOL) isTrainportTypeEqualToTrainForConsection:(ConSection *)conSection {
    
    //NSArray *fastTrainArray = [NSArray arrayWithObjects:  @"IC", @"IR", @"ICE", @"ICN", @"EC", @"RJ", @"TGV", @"EN", @"CNL" , nil];
    //NSArray *regioTrainArray = [NSArray arrayWithObjects:  @"S", @"RE", @"R" , nil];
    //NSArray *otherTransportArray = [NSArray arrayWithObjects:  @"BAT", @"FUN", @"BUS", @"TRO", @"TRAM", @"MET" , nil];
    
    //@"IC", @"IR", @"ICE", @"ICN", @"EC", @"RJ", @"TGV", @"EN", @"CNL" , nil];
    //  1       2      0       1       1       0     0       0      0
    //0-2
    
    //@"S", @"RE", @"R" , nil];
    //  5      3     5
    //3-5
    
    //@"BAT", @"FUN", @"BUS", @"TRO", @"TRAM", @"MET" , nil];
    //           7       6      6          9      9
    //> 5
    
    if (conSection) {
        if ([conSection conSectionType] == walkType) {
            return NO;
        }
        
        Journey *journey = [conSection journey];
        NSString *categoryCodeString = [journey journeyCategoryCode];
        NSNumber *categoryCode = [NSNumber numberWithInt: [categoryCodeString integerValue]];
        
        if ([categoryCode integerValue] <= 5 || [categoryCode integerValue] == 8) {
            return YES;
        }
        
    }
    return NO;
}

- (BOOL) isTrainportTypeEqualToTrainForStationboardJourney:(Journey *)journey {
    
    //NSArray *fastTrainArray = [NSArray arrayWithObjects:  @"IC", @"IR", @"ICE", @"ICN", @"EC", @"RJ", @"TGV", @"EN", @"CNL" , nil];
    //NSArray *regioTrainArray = [NSArray arrayWithObjects:  @"S", @"RE", @"R" , nil];
    //NSArray *otherTransportArray = [NSArray arrayWithObjects:  @"BAT", @"FUN", @"BUS", @"TRO", @"TRAM", @"MET" , nil];
    
    //@"IC", @"IR", @"ICE", @"ICN", @"EC", @"RJ", @"TGV", @"EN", @"CNL" , nil];
    //  1       2      0       1       1       0     0       0      0
    //0-2
    
    //@"S", @"RE", @"R" , nil];
    //  5      3     5
    //3-5
    
    //@"BAT", @"FUN", @"BUS", @"TRO", @"TRAM", @"MET" , nil];
    //           7       6      6          9      9
    //> 5
    
    if (journey) {
        NSString *categoryCodeString = [journey journeyCategoryCode];
        NSNumber *categoryCode = [NSNumber numberWithInt: [categoryCodeString integerValue]];
        
        if ([categoryCode integerValue] <= 5 || [categoryCode integerValue] == 8) {
            return YES;
        }
        
    }
    return NO;
}

- (NSArray *) getBasicStopsForConsection:(ConSection *)conSection {
    NSMutableArray *stationsArray = [NSMutableArray arrayWithCapacity:2];
    if ([conSection conSectionType] == walkType) {
        BasicStop *departureStation = [[BasicStop alloc] init];
        BasicStop *arrivalStation = [[BasicStop alloc] init];
        
        departureStation.arr = [[conSection arrival] arr];
        departureStation.dep = [[conSection departure] dep];
        departureStation.station = [[conSection departure] station];
        departureStation.basicStopType = departureType;
        departureStation.platform = [[conSection departure] platform];
        
        arrivalStation.arr = [[conSection arrival] arr];
        arrivalStation.dep = [[conSection departure] dep];
        arrivalStation.station = [[conSection arrival] station];
        arrivalStation.basicStopType = arrivalType;
        arrivalStation.platform = [[conSection arrival] platform];
        
        [stationsArray addObject: departureStation];
        [stationsArray addObject: arrivalStation];
        return stationsArray;
    } else if ([conSection conSectionType] == journeyType) {
        NSArray *passlist = [[conSection journey] passList];
        for (int i = 0;  i < [passlist count];  i++) {
            BasicStop *currentBasicStop = (BasicStop *)[passlist objectAtIndex: i];
            [stationsArray addObject: currentBasicStop];
        }
        return stationsArray;
    }
    return nil;
}

- (NSArray *) getBasicStopsForStationboardJourneyRequestResult:(Journey *)journey {
    NSMutableArray *stationsArray = [NSMutableArray arrayWithCapacity:2];
    if (journey) {
        NSArray *passlist = [journey passList];
        for (int i = 0;  i < [passlist count];  i++) {
            BasicStop *currentBasicStop = (BasicStop *)[passlist objectAtIndex: i];
            [stationsArray addObject: currentBasicStop];
        }
        return stationsArray;
    }
    return nil;
}

-  (Station *) getStationForBasicStop:(BasicStop *)basicStop {
    if (basicStop) {
        if ([basicStop isKindOfClass: [BasicStop class]]) {
            return [basicStop station];
        }
    }
    return nil;
}

- (BOOL)isDetailedTrainlinePotentiallyAvailableForConresult:(ConResult *)conresult {
    if (conresult) {
        if ([[conresult conSectionList] conSections]) {
            if ([[[conresult conSectionList] conSections] count] > 0) {
                
                BOOL atLeastOneDetailConsectionFound = NO;
                
                for (ConSection *currentConsection in [[conresult conSectionList]  conSections]) {
                                        
                    if ([self isTrainportTypeEqualToTrainForConsection: currentConsection]) {
                        BOOL consectiondetailsavailable = [self isDetailedTrainlinePotentiallyAvailableForConsection: currentConsection];
                        if (consectiondetailsavailable) {
                            atLeastOneDetailConsectionFound = YES;
                        }
                    }
                }
                return atLeastOneDetailConsectionFound;
            }
        }
    }
    return NO;
}

- (BOOL)isDetailedTrainlinePotentiallyAvailableForConsection:(ConSection *)consection {
    
    if (![self isTrainportTypeEqualToTrainForConsection: consection]) {
        return NO;
    }
    
    NSArray *basicStopList = [self getBasicStopsForConsection:consection];
    BasicStop *startStop = [basicStopList objectAtIndex: 0];
    BasicStop *endStop = [basicStopList lastObject];
    Station *startStation = [self getStationForBasicStop: startStop];
    Station *endStation = [self getStationForBasicStop: endStop];
    
    BOOL stationsareoncommonroute = [self areStationsOnCommonRoute: startStation endstation: endStation];
    if (stationsareoncommonroute) {
        return YES;
    } else {
        NSMutableArray *startstationsarray = [NSMutableArray array];
        NSMutableArray *endstationsarray = [NSMutableArray array];
        for (int i = 0; i < [basicStopList count] - 1; i++) {
            [startstationsarray addObject: [basicStopList objectAtIndex: i]];
            [endstationsarray addObject: [basicStopList objectAtIndex: i + 1]];
        }
        
        BOOL atLeastOnePartialDetailedRouteFound = NO;
        
        for (int i = 0; i < [startstationsarray count]; i++) {
            Station *startstation = [[startstationsarray objectAtIndex: i] station];
            Station *endstation = [[endstationsarray objectAtIndex: i] station];
                        
            BOOL stationsareoncommonroute = [self areStationsOnCommonRoute: startstation endstation: endstation];
            if (stationsareoncommonroute) {
                atLeastOnePartialDetailedRouteFound = YES;
            }
            
        }
        return atLeastOnePartialDetailedRouteFound;
    }
    return NO;
}

- (BOOL)isDetailedTrainlinePotentiallyAvailableForJourney:(Journey *)journey {
    
    if (![self isTrainportTypeEqualToTrainForStationboardJourney: journey]) {
        return NO;
    }
    
    NSArray *basicStopList = [self getBasicStopsForStationboardJourneyRequestResult:journey];
    BasicStop *startStop = [basicStopList objectAtIndex: 0];
    BasicStop *endStop = [basicStopList lastObject];
    Station *startStation = [self getStationForBasicStop: startStop];
    Station *endStation = [self getStationForBasicStop: endStop];
    
    BOOL stationsareoncommonroute = [self areStationsOnCommonRoute: startStation endstation: endStation];
    if (stationsareoncommonroute) {
        return YES;
    } else {
        NSMutableArray *startstationsarray = [NSMutableArray array];
        NSMutableArray *endstationsarray = [NSMutableArray array];
        for (int i = 0; i < [basicStopList count] - 1; i++) {
            [startstationsarray addObject: [basicStopList objectAtIndex: i]];
            [endstationsarray addObject: [basicStopList objectAtIndex: i + 1]];
        }
        
        BOOL atLeastOnePartialDetailedRouteFound = NO;
        
        for (int i = 0; i < [startstationsarray count]; i++) {
            Station *startstation = [[startstationsarray objectAtIndex: i] station];
            Station *endstation = [[endstationsarray objectAtIndex: i] station];
            
            BOOL stationsareoncommonroute = [self areStationsOnCommonRoute: startstation endstation: endstation];
            if (stationsareoncommonroute) {
                atLeastOnePartialDetailedRouteFound = YES;
            }
            
        }
        return atLeastOnePartialDetailedRouteFound;
    }
    return NO;
    
}

- (void)sendConResTrainlineDetailsRequest:(ConResult *)conresult detaillevel:(NSUInteger)detaillevel connections:(Connections *)connections successBlock:(void(^)(NSArray *routes))successBlock failureBlock:(void(^)(NSUInteger))failureBlock routesavailableandprocessingblock:(void(^)(ConResult *conresult, BOOL detailsavailable))routesavailableandprocessingblock {
    
    [self.conReqTrainlineOperationQueue cancelAllOperations];
    
    if (conresult && [[conresult conSectionList] conSections] && [[[conresult conSectionList] conSections] count] > 0) {
        
        if (conresult.routes && conresult.routes.count > 0) {
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"SendConresDetailTrainlineRequest. Route already available");
            #endif
            
            if (successBlock) {
                successBlock(conresult.routes);
            }
            return;
        }
        
        if (conresult && conresult.detailedroutesprechecked && !conresult.detailedroutesavailable) {
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"SendConresDetailTrainlineRequest. Route prechecked and not available");
            #endif
            
            if (failureBlock) {
                failureBlock(kTRAINLINEREQUESTNORESULT);
            }
            return;
        }
        
        if (![self isDetailedTrainlinePotentiallyAvailableForConresult: conresult]) {
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"No detailed trainline available for connection result");
            #endif
            
            if (failureBlock) {
                failureBlock(kTRAINLINEREQUESTNORESULT);
            }
        }
        
        TrainlineOperation *trainlineOperation = [[TrainlineOperation alloc] initWithConresultAndDetaillevelAndConnections:conresult detaillevel: detaillevel connections:connections];
        
        [trainlineOperation setRouteleadsawaysfromdestinationtolerancelevel: self.routeleadsawaysfromdestinationtolerance];
        
        [trainlineOperation setCompletionBlockWithSuccess:^(NSArray *routes){
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"Operation completed with success");
            #endif
            
            if (routes && routes.count > 0) {
                conresult.routes = [routes copy];
                if (conresult && conresult.conSectionList && conresult.conSectionList.conSections && conresult.conSectionList.conSections.count > 0) {
                    if (routes.count == conresult.conSectionList.conSections.count) {
                        
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"Saving consection routes in conresults consections");
                        #endif
                        
                        for (int i = 0; i < conresult.conSectionList.conSections.count; i++) {
                            
                            #ifdef TrainlineLogLevelFull
                            NSLog(@"Saving consection routes in conresults consections. Processing consection: %d", i);
                            #endif
                            
                            ConSection *currentsection = [[[conresult conSectionList] conSections] objectAtIndex: i];
                            
                            if (!([currentsection conSectionType] == walkType)) {
                                
                                if ([self isTrainportTypeEqualToTrainForConsection:currentsection]) {
                                    #ifdef TrainlineLogLevelFull
                                    NSLog(@"Saving consection routes in conresults consections. Saving in consection: %d", i);
                                    #endif
                                    
                                    NSArray *currentroutarray = [NSArray arrayWithObject: [routes objectAtIndex:i]];
                                    currentsection.routes = [currentroutarray copy];
                                }
                                #ifdef TrainlineLogLevelFull
                                else {
                                    NSLog(@"Don't save consection routes in conresults consections. Is not train. %d", i);
                                }
                                #endif
                            }
                        }
                    }
                }
            }
            
            if (successBlock) {
                successBlock(routes);
            }
         
            }
            failure:^(NSUInteger errorcode){
                #ifdef TrainlineLogLevelFull
                NSLog(@"Operation failed: Error %d", errorcode);
                #endif
                
                if (failureBlock) {
                    failureBlock(errorcode);
                }
                
            }];
        
        [trainlineOperation setConresultPrecheckedBlock:^(NSArray *precheckedconsections, ConResult *checkedconresult) {
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"Got prechecked details block result");
            #endif
            
            BOOL atleastonedetailedsectionfound = NO;
            if (checkedconresult && [checkedconresult.conResId isEqualToString: conresult.conResId]) {
                if (precheckedconsections && precheckedconsections.count == conresult.conSectionList.conSections.count) {
                    
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"Got prechecked details block result. Conres and consections are ok");
                    #endif
                    
                    for (int i = 0; i < [[[conresult conSectionList] conSections] count]; i++) {
                        ConSection *conressection = [[[conresult conSectionList] conSections] objectAtIndex: i];
                        BOOL precheckedflag = [[precheckedconsections objectAtIndex: i] boolValue];
                        conressection.detailedroutesprechecked = YES;
                        conressection.detailedroutesavailable = precheckedflag;
                        if (precheckedflag) {
                            atleastonedetailedsectionfound = YES;
                        }
                    }
                    
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"Got prechecked details block result. Details available for at least one subroute: %@", atleastonedetailedsectionfound?@"Y":@"N");
                    #endif
                    
                    conresult.detailedroutesprechecked = YES;
                    conresult.detailedroutesavailable = atleastonedetailedsectionfound;
                }
            }
            if (routesavailableandprocessingblock) {
                routesavailableandprocessingblock(conresult, atleastonedetailedsectionfound);
            }
        }];
        
        [self.conReqTrainlineOperationQueue addOperation:trainlineOperation];
    }
}

- (void)sendConReqTrainlineDetailsRequest:(ConSection *)consection detaillevel:(NSUInteger)detaillevel connections:(Connections *)connections successBlock:(void(^)(NSArray *routes))successBlock failureBlock:(void(^)(NSUInteger))failureBlock routesavailableandprocessingblock:(void(^)(ConSection *consection, BOOL detailsavailable))routesavailableandprocessingblock {
    
    [self.conReqTrainlineOperationQueue cancelAllOperations];
    
    #ifdef TrainlineLogLevelFull
    [self logPasslist: consection.journey.passList];
    #endif
    
    if (consection) {
        
        if (consection.routes && consection.routes.count > 0) {
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"SendConreqDetailTrainlineRequest. Route already available");
            #endif
            
            if (successBlock) {
                successBlock(consection.routes);
            }
            return;
        }
        
        if (consection && consection.detailedroutesprechecked && !consection.detailedroutesavailable) {
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"SendConreqDetailTrainlineRequest. Route prechecked and not available");
            #endif
            
            if (failureBlock) {
                failureBlock(kTRAINLINEREQUESTNORESULT);
            }
            return;
        }
        
        if (![self isDetailedTrainlinePotentiallyAvailableForConsection:consection]) {
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"No detailed trainline available for consection");
            #endif
            
            if (failureBlock) {
                failureBlock(kTRAINLINEREQUESTNORESULT);
            }
        }
        
        TrainlineOperation *trainlineOperation = [[TrainlineOperation alloc] initWithConsectionAndDetaillevelAndConnections:consection detaillevel:detaillevel connections:connections];
        
        [trainlineOperation setRouteleadsawaysfromdestinationtolerancelevel: self.routeleadsawaysfromdestinationtolerance];
        
        [trainlineOperation setCompletionBlockWithSuccess:^(NSArray *routes){
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"Operation completed with success");
            #endif
            
            if (routes && routes.count > 0) {
                consection.routes = [routes copy];
            }
            
                if (successBlock) {
                    successBlock(routes);
                }
            
            }
            failure:^(NSUInteger errorcode){
                #ifdef TrainlineLogLevelFull
                NSLog(@"Operation failed: Error %d", errorcode);
                #endif
                
                if (failureBlock) {
                    failureBlock(errorcode);
                }
                
            }];
        
        [self.conReqTrainlineOperationQueue addOperation:trainlineOperation];
    }
}

- (void)sendStbReqTrainlineDetailsRequest:(Journey *)journey detaillevel:(NSUInteger)detaillevel stationboardresults:(StationboardResults *)stationboardresults successBlock:(void(^)(NSArray *routes))successBlock failureBlock:(void(^)(NSUInteger))failureBlock routesavailableandprocessingblock:(void(^)(Journey *journey, BOOL detailsavailable))routesavailableandprocessingblock {
    
    [self.stbReqTrainlineOperationQueue cancelAllOperations];
    
    if (journey) {
        
        if (journey.routes && journey.routes.count > 0) {
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"SendStbreqDetailTrainlineRequest. Route already available");
            #endif
            
            if (successBlock) {
                successBlock(journey.routes);
            }
            return;
        }
        
        if (journey && journey.detailedroutesprechecked && !journey.detailedroutesavailable) {
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"SendStbreqDetailTrainlineRequest. Route prechecked and not available");
            #endif
            
            if (failureBlock) {
                failureBlock(kTRAINLINEREQUESTNORESULT);
            }
            return;
        }
        
        if (![self isDetailedTrainlinePotentiallyAvailableForJourney:journey]) {
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"No detailed trainline available for journey");
            #endif
            
            if (failureBlock) {
                failureBlock(kTRAINLINEREQUESTNORESULT);
            }
        }
                
        TrainlineOperation *trainlineOperation = [[TrainlineOperation alloc] initWithJourneyAndDetaillevelAndStationboardresults:journey detaillevel:detaillevel stationboardresults:stationboardresults];
        
        [trainlineOperation setRouteleadsawaysfromdestinationtolerancelevel: self.routeleadsawaysfromdestinationtolerance];
        
        [trainlineOperation setCompletionBlockWithSuccess:^(NSArray *routes){
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"Operation completed with success");
            #endif
            
            if (routes && routes.count > 0) {
                
                #ifdef TrainlineLogLevelFull
                NSLog(@"SendStbreqDetailTrainlineRequest. Adding routes to journey");
                #endif
                
                journey.routes = [routes copy];
            }
            
                if (successBlock) {
                    successBlock(routes);
                }
            
            }
            failure:^(NSUInteger errorcode){
                #ifdef TrainlineLogLevelFull
                NSLog(@"Operation failed: Error %d", errorcode);
                #endif
                
                if (failureBlock) {
                    failureBlock(errorcode);
                }
                
            }];
        
        [trainlineOperation setJourneyPrecheckedBlock:^(BOOL detailedjourneyavailable, Journey *checkedjourney) {
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"Got prechecked journey details block result. Available: %@", detailedjourneyavailable?@"Y":@"N");
            #endif
            
            if (checkedjourney && journey) {
                journey.detailedroutesavailable = detailedjourneyavailable;
                journey.detailedroutesprechecked = YES;
            }
            
            if (routesavailableandprocessingblock) {
                routesavailableandprocessingblock(journey, detailedjourneyavailable);
            }
        }];

        

        [self.stbReqTrainlineOperationQueue addOperation:trainlineOperation];
    }
}

- (void)cancelAllTrainlineOperations {
    
    #ifdef TrainlineLogLevelFull
    NSLog(@"Cancel train line operations");
    #endif
    
    if (self.conReqTrainlineOperationQueue) {
        [self.conReqTrainlineOperationQueue cancelAllOperations];
    }
    if (self.stbReqTrainlineOperationQueue) {
        [self.stbReqTrainlineOperationQueue cancelAllOperations];
    }
}

- (void)cancelConReqTrainlineOperations {
    
    #ifdef TrainlineLogLevelFull
    NSLog(@"Cancel conreq train line operations");
    #endif
    
    if (self.conReqTrainlineOperationQueue) {
        [self.conReqTrainlineOperationQueue cancelAllOperations];
    }
}

- (void)cancelStbReqTrainlineOperations {
    
    #ifdef TrainlineLogLevelFull
    NSLog(@"Cancel stb train line operations");
    #endif
    
    if (self.stbReqTrainlineOperationQueue) {
        [self.stbReqTrainlineOperationQueue cancelAllOperations];
    }
}

@end

