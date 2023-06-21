//
//  ConSection.h
//  Swiss Trains
//
//  Created by Alain on 29.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicStop.h"
#import "Walk.h"
#import "Journey.h"

enum consectionType {
    journeyType = 1,
    walkType = 2,
    gisrouteType = 3
};

@interface ConSection : NSObject

@property (strong, nonatomic) BasicStop *departure;
@property (strong, nonatomic) BasicStop *arrival;

@property (strong, nonatomic) Journey *journey;
@property (strong, nonatomic) Walk *walk;

@property (assign) NSUInteger conSectionType;

@property (strong, nonatomic) NSArray *routes;
@property (assign) BOOL detailedroutesprechecked;
@property (assign) BOOL detailedroutesavailable;

@end
