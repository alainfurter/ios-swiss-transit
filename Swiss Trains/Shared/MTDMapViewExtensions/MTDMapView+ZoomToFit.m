//
//  MTDMapView+ZoomToFit.m
//  Swiss Trains
//
//  Created by Alain on 13.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "MTDMapView+ZoomToFit.h"

@implementation MTDMapView (ZoomToFit)

#pragma mark -
#pragma mark Zoom to Fit

- (void)zoomToFitOverlays {
    NSLog(@"Zoom to fit overlays");
    [self zoomToFitOverlaysAnimated:YES];
}

- (void)zoomToFitDirectionsOverlay {
    NSLog(@"Zoom to fit directions overlay");
    
    MKMapRect mapRect = MKMapRectNull;
    MTDDirectionsOverlay *overlay = [self directionsOverlay];
    mapRect = overlay.boundingMapRect;
    NSLog(@"Overlay map rect: %.6f, %.6f, %.6f, %.6f", mapRect.origin.x, mapRect.origin.y, mapRect.size.width, mapRect.size.height);
    
    CGFloat insetProportion = 0.1;
    
    //Inset
    CGFloat inset = (CGFloat)(mapRect.size.width*insetProportion);
    mapRect = [self mapRectThatFits:MKMapRectInset(mapRect, inset, inset)];
    NSLog(@"Overlay map rect: %.6f, %.6f, %.6f, %.6f", mapRect.origin.x, mapRect.origin.y, mapRect.size.width, mapRect.size.height);
    
    //Set
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    [self setRegion:region animated:YES];
}

- (void)zoomToFitOverlay:(id<MKOverlay>)anOverlay {
    [self zoomToFitOverlay:[NSArray arrayWithObject:anOverlay] animated:YES];
}

- (void)zoomToFitOverlays:(NSArray *)someOverlays {
    [self zoomToFitOverlays:someOverlays animated:YES];
}

- (void)zoomToFitOverlaysAnimated:(BOOL)animated {
    [self zoomToFitOverlays:self.overlays animated:animated];
}

- (void)zoomToFitOverlay:(id<MKOverlay>)anOverlay animated:(BOOL)animated {
    [self zoomToFitOverlays:[NSArray arrayWithObject:anOverlay] animated:YES];
}

- (void)zoomToFitOverlays:(NSArray *)someOverlays animated:(BOOL)animated {
    [self zoomToFitOverlays:someOverlays animated:animated insetProportion:.1];
}

- (void)zoomToFitOverlays:(NSArray *)someOverlays animated:(BOOL)animated insetProportion:(CGFloat)insetProportion {
    //Check
    
    NSLog(@"Zoom to fit overlays parse.");
    
    if ( !someOverlays || !someOverlays.count ) {
        return;
    }
    
    NSLog(@"Zoom to fit overlays parse go.");
    //Union
    MKMapRect mapRect = MKMapRectNull;
    if ( someOverlays.count == 1 ) {
        mapRect = ((id<MKOverlay>)someOverlays.lastObject).boundingMapRect;
    } else {
        for ( id<MKOverlay> anOverlay in someOverlays ) {
            mapRect = MKMapRectUnion(mapRect, anOverlay.boundingMapRect);
        }
    }
    
    //Inset
    CGFloat inset = (CGFloat)(mapRect.size.width*insetProportion);
    mapRect = [self mapRectThatFits:MKMapRectInset(mapRect, inset, inset)];
    
    //Set
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    [self setRegion:region animated:animated];
}


@end
