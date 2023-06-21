//
//  TrainlineOperation.h
//  Swiss Trains
//
//  Created by Alain on 22.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import <MTDirectionsKit/MTDirectionsKit.h>

#import "UIColor+SwissTrains.h"

#import "Station.h"
#import "BasicStop.h"

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

#import "Connections.h"
#import "StationboardResults.h"
#import "ConResult.h"
#import "ConSection.h"
#import "Journey.h"

#define ROUTELINEDB @"Trainlines.sqlite"

//#define TrainlineLogLevelFull   1
//#define TrainlineLogLevelPoints 1

@class TrainlinesLine;

//CONFIG
#define TRAINSTATIONMAXRANGETOLINESTARTENDPOINT        100.0
#define LINETOLINEPOINTMAXRANGE                         50.0
#define LINETOLINEPOINTMAXRANGEONLYONELINELEFT        1000.0
#define STARTENDCOORDINATETOWAYPOINTSSTARTENDDISTANCE  500.0

#define kTRAINLINEREQUESTNORESULT                       5501
#define kTRAINLINEREQUESTCANCELLED                      5502
#define kTRAINLINEREQUESTWRONGINPUT                     5502
#define kTRAINLINEREQUESTUNKNOWNERROR                   5503

#define kTRAINLINEERRORDOMAIN                           @"TRAINLINEERROR"

enum trainlineJourneyTransportTypeCodes {
    trainlineTransportFastTrain = 1,
    trainlineTransportSlowTrain = 2,
    trainlineTransportTram = 3,
    trainlineTransportBus = 4,
    trainlineTransportShip = 5,
    trainlineTransportUnknown = 6,
    trainlineTransportFuni = 7,
    trainlineTransportCablecar = 8
};

typedef void (^TrainlineOperationCompletionSuccessBlock)(NSArray *);
typedef void (^TrainlineOperationCompletionFailureBlock)(NSUInteger);
typedef void (^TrainlineOperationConresultPrecheckedBlock)(NSArray *, ConResult *);
typedef void (^TrainlineOperationConsectionPrecheckedBlock)(BOOL, ConSection *);
typedef void (^TrainlineOperationJourneyPrecheckedBlock)(BOOL, Journey *);

@interface TrainlineOperation : NSOperation

@property (assign) NSUInteger detaillevel;
@property (assign) NSUInteger routeleadsawaysfromdestinationtolerance;

@property (assign) Connections *connections;
@property (assign) StationboardResults *stationboardresults;

@property (strong, nonatomic) ConResult *conresult;
@property (strong, nonatomic) ConSection *consection;
@property (strong, nonatomic) Journey *journey;

@property (strong, nonatomic) TrainlineOperationCompletionSuccessBlock trainlineOperationCompletionSuccessBlock;
@property (strong, nonatomic) TrainlineOperationCompletionFailureBlock trainlineOperationCompletionFailureBlock;
@property (strong, nonatomic) TrainlineOperationConresultPrecheckedBlock trainlineOperationConresultPrecheckedBlock;
@property (strong, nonatomic) TrainlineOperationConsectionPrecheckedBlock trainlineOperationConsectionPrecheckedBlock;
@property (strong, nonatomic) TrainlineOperationJourneyPrecheckedBlock trainlineOperationJourneyPrecheckedBlock;

- (id)initWithConresultAndDetaillevelAndConnections:(ConResult *)conresult detaillevel:(NSUInteger)detaillevel connections:(Connections *)connections;
- (id)initWithConsectionAndDetaillevelAndConnections:(ConSection *)consection detaillevel:(NSUInteger)detaillevel connections:(Connections *)connections;
- (id)initWithJourneyAndDetaillevelAndStationboardresults:(Journey *)journey detaillevel:(NSUInteger)detaillevel stationboardresults:(StationboardResults *)stationboardresults;

- (void)setCompletionBlockWithSuccess:(TrainlineOperationCompletionSuccessBlock)successblock
                              failure:(TrainlineOperationCompletionFailureBlock)failureblock;

- (void)setConresultPrecheckedBlock:(TrainlineOperationConresultPrecheckedBlock)conresprecheckedblock;
- (void)setConsectionPrecheckedBlock:(TrainlineOperationConsectionPrecheckedBlock)consecprecheckedblock;
- (void)setJourneyPrecheckedBlock:(TrainlineOperationJourneyPrecheckedBlock)journeyprecheckedblock;

- (void)setRouteleadsawaysfromdestinationtolerancelevel:(NSUInteger)tolerancelevel;

@end


@interface RouteLineCutBlock : NSObject
@property(assign) NSUInteger lineid;
@property(assign) NSUInteger lineindex;
@property(assign) BOOL pointmatch;
@property(assign) NSUInteger pointmatchpointindex;
@property(assign) CLLocationCoordinate2D pointmatchcoordinate;
@property(assign) NSUInteger nopointmatchstartpointindex;
@property(assign) NSUInteger nopointmatchendpointindex;
@property(assign) CLLocationCoordinate2D nopointmatchmiddlecoordinate;
@end

@interface RouteSegment : NSObject
@property(assign) CLLocationCoordinate2D routestartlocation;
@property(assign) CLLocationCoordinate2D routeendlocation;
@property(strong, nonatomic) NSMutableArray *routelines;
@property(strong, nonatomic) NSMutableArray *linesegments;
@property(strong, nonatomic) NSMutableArray *waypoints;
@property(assign) BOOL ended;
@property(assign) BOOL endedwithstation;
@property(assign) BOOL endedwithrouteend;
//@property(assign) BOOL splitstartlinewithlinepoint;
//@property(assign) BOOL splitstartlinewithintermediatelinepoint;
//@property(assign) BOOL splitendlinewithlinepoint;
//@property(assign) BOOL splitendlinewithintermediatelinepoint;
@property(assign) NSUInteger routedistance;
@property(assign) NSUInteger passlistpoints;
@property(assign) NSUInteger leadsawaysfromdestinationpoints;
//@property(strong, nonatomic) NSString *routename;
@property(strong, nonatomic) NSNumber *routeid;
- (void)removeLineByLineFromRoutesegmentlines:(TrainlinesLine *)line;
@property(strong, nonatomic) NSMutableArray *routelinesreversegeomflags;
- (NSUInteger)getNumbersOfRouteLines;
- (TrainlinesLine *)getRoutelineWithIndex:(NSUInteger)lineindex;
- (TrainlinesLine *)getStartRouteline;
- (TrainlinesLine *)getEndRouteline;
- (NSUInteger)getNumbersOfRouteLinesReverseorderflags;
- (BOOL)getReverseorderflagForRoutelineWithIndex:(NSUInteger)lineindex;
- (NSUInteger)getNumbersOfLinepointsForRoutelineWithIndex:(NSUInteger)lineindex;
- (CLLocationCoordinate2D)getLinepointWithIndexOfLineWithIndex:(NSUInteger)lineindex pointindex:(NSUInteger)pointindex;
- (CLLocationCoordinate2D)getRoutestartpoint;
- (CLLocationCoordinate2D)getRouteendpoint;
//- (NSArray *)getAllMTDWaypointsForRoutelines;
//- (void)extractAllWaypoints;
//- (BOOL)extractWaypointsTerminatingWithCoordinateAndCheckForTermination:(CLLocationCoordinate2D)coordinate;
- (NSArray *)getWaypoints;
- (void)extractWaypointsByCuttingStartAndEndpoint;
@property(strong, nonatomic) RouteLineCutBlock *startcutblock;
@property(strong, nonatomic) RouteLineCutBlock *endcutblock;
@end

@interface TrainlinesLine : NSObject
@property(strong, nonatomic) NSData *geommetrydata;
@property(assign) NSUInteger lineId;
//@property(assign) CLLocationCoordinate2D startpoint;
//@property(assign) CLLocationCoordinate2D endpoint;
@property(assign) CLLocationCoordinate2D mincoordinate;
@property(assign) CLLocationCoordinate2D maxcoordinate;
@property(assign) NSUInteger linedistance;
//@property(assign) BOOL readGeometryDataInReverseOrder;
- (id)initWithIdAndGeometrydata:(NSUInteger)lineid geometrydata:(NSData *)geometrydata;
//- (CLLocationCoordinate2D)getPointAtIndex:(NSUInteger)pointindex;
- (CLLocationCoordinate2D)getPointAtIndexWithReverseorderflag:(NSUInteger)pointindex reverseorder:(BOOL)reverseorder;
- (NSUInteger)getNumberOfPoints;
- (void) reverseGeometryData;
- (BOOL) isEqualToLine:(TrainlinesLine *)line;
//- (void) setReadGeometryInReverseOrderFlag:(BOOL)reverseorder;
- (CLLocationCoordinate2D)getStartpointWithoutReverseorderflag;
- (CLLocationCoordinate2D)getEndpointWithoutReverseorderflag;
- (CLLocationCoordinate2D)getStartpointWithReverseorderflag:(BOOL)reverseorder;
- (CLLocationCoordinate2D)getEndpointWithReverseorderflag:(BOOL)reverseorder;
@end


@interface TrainlinesStation : NSObject
@property(strong, nonatomic) NSArray *routeNumbers;
@property(strong, nonatomic) CLLocation *location;
@property(strong, nonatomic) NSString *stationname;
@property(strong, nonatomic) NSString *externalid;
//@property(assign) NSUInteger rank;
//@property(assign) BOOL isEndPoint;
//@property(assign) NSUInteger altitude;
@property(assign) NSUInteger stationId;
//- (id)initWithId:(NSUInteger)stationid name:(NSString *)stationname externalid:(NSString *)externalid latitude:(double)latitude longitude:(double)longitude altitude:(NSUInteger)altitude isEndPoint:(BOOL)isendpoint rank:(NSUInteger)rank;
- (id)initWithId:(NSUInteger)stationid name:(NSString *)stationname externalid:(NSString *)externalid latitude:(double)latitude longitude:(double)longitude;
//- (id)initWithId:(NSUInteger)stationid name:(NSString *)stationname externalid:(NSString *)externalid isEndPoint:(BOOL)isendpoint;
- (BOOL)hasLocation;
- (BOOL)isEqual:(id)trainlinesstation;
- (BOOL)isEqualToStation:(TrainlinesStation *)trainlinesstation;
- (NSArray *)getRouteNumbersWithout:(TrainlinesStation *)trainlinesstation;
- (NSArray *)getRouteNumbers;
@end


@interface TrainlinesRoute : NSObject
@property(strong, nonatomic) NSString *companies;
@property(strong, nonatomic) NSString *name;
//@property(strong, nonatomic) NSString *routeNumber;
@property(strong, nonatomic) NSNumber *routeid;
@property(assign) double minLon;
@property(assign) double maxLon;
@property(assign) double minLat;
@property(assign) double maxLat;
@property(assign) NSUInteger totalLength;
//- (id)initWithNumber:(NSString *)routenumber routename:(NSString *)routename;
- (id)initWithId:(NSNumber *)routeid routename:(NSString *)routename;
- (MKMapRect)getRegion;
- (NSString *)getCompaniesString;
- (NSArray *)getCompanyNames;
- (BOOL)isEqual:(id)route;
- (BOOL)isEqualToRoute:(TrainlinesRoute *)route;
@end