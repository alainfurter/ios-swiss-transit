//
//  Connections.m
//  Swiss Trains
//
//  Created by Alain on 30.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "Connections.h"

@implementation Connections

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
        //NSLog(@"Init connections object");
        self.conResults = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

@end
