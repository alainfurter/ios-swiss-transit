//
//  MTDJourneyRequest.m
//  Swiss Trains
//
//  Created by Alain on 12.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "MTDJourneyRequest.h"

@implementation MTDJourneyRequest

- (void)setValueForParameterWithIntermediateGoals:(NSArray *)intermediateGoals {
    // doing nothing here
}

- (NSString *)HTTPAddress {
    // We don't really use the address, since we return a hardcoded URL in preparedURLForAddress
    return @"http://www.zonezeroapps.com";
}

- (MTDDirectionsAPI)API {
    return MTDDirectionsAPICustom;
}

- (NSURL *)preparedURLForAddress:(NSString *)address {
    // we always want to return the same file for our test request
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths lastObject];
    
    NSString *fileString = [documentPath stringByAppendingPathComponent: kJourneyStationsListFile];
    
    //NSLog(@"Parser file path: %@", fileString);
    
    return [NSURL fileURLWithPath:fileString];
    
    //NSURL *URL = [[NSBundle mainBundle] URLForResource:@"sample" withExtension:@"directions"];
    
    //return URL;
}


@end
