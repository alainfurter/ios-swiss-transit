//
//  MTDMapView+ZoomToFit.h
//  Swiss Trains
//
//  Created by Alain on 13.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <MTDirectionsKit/MTDirectionsKit.h>

@interface MTDMapView (ZoomToFit)

- (void)zoomToFitOverlays; //Animation defaults to YES
- (void)zoomToFitOverlay:(id<MKOverlay>)anOverlay;
- (void)zoomToFitOverlays:(NSArray *)someOverlays;

- (void)zoomToFitOverlaysAnimated:(BOOL)animated;
- (void)zoomToFitOverlay:(id<MKOverlay>)anOverlay animated:(BOOL)animated;
- (void)zoomToFitOverlays:(NSArray *)someOverlays animated:(BOOL)animated;

- (void)zoomToFitOverlays:(NSArray *)someOverlays animated:(BOOL)animated insetProportion:(CGFloat)insetProportion; //inset 0->1, defaults in other methods to .1 (10%)

- (void)zoomToFitDirectionsOverlay;

@end
