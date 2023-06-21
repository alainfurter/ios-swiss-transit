//
//  MTDSampleOverlayView.h
//  MTDirectionsKitDemo
//
//  Created by Matthias Tretter
//  Copyright (c) 2012 Matthias Tretter (@myell0w). All rights reserved.
//

#import <MTDirectionsKit/MTDirectionsKit.h>

@class MTDRoute;

@interface MTDJourneyOverlayView : MTDDirectionsOverlayView

@property (nonatomic, strong) MTDRoute *checkroute;

@end
