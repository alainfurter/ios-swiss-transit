//
//  ConSectionList.m
//  Swiss Trains
//
//  Created by Alain on 29.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "ConSectionList.h"

@implementation ConSectionList

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
        //NSLog(@"Init consectionlist object");
        self.conSections = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

@end
