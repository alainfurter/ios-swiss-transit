//
//  Journey.m
//  Swiss Trains
//
//  Created by Alain on 29.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "Journey.h"

@implementation Journey

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
        //NSLog(@"Init journey object");
        self.passList = [NSMutableArray arrayWithCapacity:1];
        self.journeyIsDelayed = NO;
    }
    return self;
}

@end
