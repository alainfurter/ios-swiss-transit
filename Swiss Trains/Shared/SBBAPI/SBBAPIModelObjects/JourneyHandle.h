//
//  JourneyHandle.h
//  Swiss Trains
//
//  Created by Alain on 18.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JourneyHandle : NSObject

@property (strong, nonatomic) NSString *tnr;
@property (strong, nonatomic) NSString *puic;
@property (strong, nonatomic) NSString *cycle;

@end
