//
//  StationboardResults.m
//  Swiss Trains
//
//  Created by Alain on 17.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "StationboardResults.h"

@implementation StationboardResults

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
        //NSLog(@"Init stb object");
        self.stbJourneys = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

@end
