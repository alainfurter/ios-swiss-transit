//
//  MTDJourneyParser.m
//  Swiss Trains
//
//  Created by Alain on 12.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "MTDJourneyParser.h"
//#import "MTDRoute.h"

@implementation MTDJourneyParser

- (void)parseWithCompletion:(mtd_parser_block)completion {
    NSString *dataString = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    //NSString dataString = [NSString stringWithContentsOfFile:  encoding:<#(NSStringEncoding)#> error:<#(NSError *__autoreleasing *)#>]
    NSArray *components = [dataString componentsSeparatedByString:@"|"];
    NSMutableArray *waypoints = [NSMutableArray array];
    
    //NSLog(@"Stationsfile: %@", dataString);
    
    for (NSString *component in components) {
        NSArray *waypointComponents = [component componentsSeparatedByString:@";"];
        CLLocationDegrees latitude = [waypointComponents[1] doubleValue];
        CLLocationDegrees longitude = [waypointComponents[2] doubleValue];
        
        MTDWaypoint *waypoint = [MTDWaypoint waypointWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
        [waypoints addObject:waypoint];
    }
    
    MTDRoute *route = [[MTDRoute alloc] initWithWaypoints:waypoints
                                                maneuvers:nil
                                                 distance:[MTDDistance distanceWithMeters:150866.3]
                                            timeInSeconds:7915
                                                     name:nil
                                                routeType:self.routeType
                                           additionalInfo:nil];
    
    
    //MTDRoute *route = [[MTDRoute alloc] initWithWaypoints:waypoints maneuvers:nil distance:[MTDDistance distanceWithMeters:150866.3] timeInSeconds:7915 name:nil routeType:self.routeType additionalInfo:nil];
    
    MTDDirectionsOverlay *overlay = [[MTDDirectionsOverlay alloc] initWithRoutes:@[route]
                                                               intermediateGoals:self.intermediateGoals
                                                                       routeType:self.routeType];
    
    [self callCompletion:completion overlay:overlay error:nil];
     
}

@end
