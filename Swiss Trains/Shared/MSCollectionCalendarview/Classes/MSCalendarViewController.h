//
//  MSCalendarViewController.h
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SBBAPIController.h"

@interface MSCalendarViewController : UICollectionViewController

@property (assign) NSUInteger connectionIndex;
@property (assign) NSUInteger consectionIndex;
@property (assign) NSUInteger selectedConsectionType;

- (void) setJourneyDetailWithConnectionAndConsectionIndex:(NSUInteger)connectionIndex consectionIndex:(NSUInteger)consecionIndex;
- (void) updateViewData;

@end
