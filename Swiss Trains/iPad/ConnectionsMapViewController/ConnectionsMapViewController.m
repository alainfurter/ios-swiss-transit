//
//  ConnectionsMapViewController.m
//  
//
//  Created by Alain on 02.01.13.
//  Copyright (c) 2013 Alain Furter
//

#import "ConnectionsMapViewController.h"

@interface ConnectionsMapViewController ()

@end

@implementation ConnectionsMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization        
        self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
    }
    return self;
}

- (void) loadView {
    CGSize size = [UIApplication currentScreenSize];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = view;
}

- (void) layoutSubviewsWithAnimated:(BOOL)animated beforeRotation:(BOOL)beforeRotation interfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //NSLog(@"CConnectionsMapViewControlleriPad layoutSubviews");
	
	CGSize size = [UIApplication currentScreenSize];
    CGSize newSize;
    if (beforeRotation) {
        if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            newSize.width = MAX(size.width, size.height) + STATUSBARHEIGHT;
            newSize.height = MIN(size.width, size.height) - STATUSBARHEIGHT;
        } else {
            newSize.height = MAX(size.width, size.height) - STATUSBARHEIGHT;
            newSize.width = MIN(size.width, size.height) + STATUSBARHEIGHT;
        }
    } else {
        newSize.width = size.width;
        newSize.height = size.height;
    }
    
    newSize.width = size.width;
    newSize.height = size.height;
    
    if (animated) {
        [UIView beginAnimations:@"ConnectionsMapViewControlleriPad LayoutSubviewWithAnimation" context:NULL];
    }
    
    //self.mapView.frame = self.view.bounds;
    self.mapView.frame = CGRectMake(0, 0, newSize.width - SPLITVIEWMAINVIEWWIDTH + SPLITVIEWDIVIDERWIDTH, newSize.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT);
        
    if (animated) {
        [UIView commitAnimations];
    }
}

- (void) layoutSubviews:(BOOL)beforeRotation toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    [self layoutSubviewsWithAnimated:NO beforeRotation: beforeRotation interfaceOrientation: toInterfaceOrientation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGSize size = [UIApplication currentScreenSize];
    
    self.detaillevelForTrainlinesForDetailedRoutes = 2;
    
    //NSLog(@"StationboardMapViewController viewdidload: %.1f, %.1f, %.1f, %.1f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    //MTDDirectionsSetLogLevel(MTDLogLevelVerbose);
    
	// Do any additional setup after loading the view.
    self.mapView = [[MTDMapView alloc] initWithFrame: CGRectMake(0, 0, size.width - SPLITVIEWMAINVIEWWIDTH + SPLITVIEWDIVIDERWIDTH, size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT)];
    //self.mapView = [[MTDMapView alloc] initWithFrame: self.view.bounds];
    
    //self.mapView.directionsEdgePadding = UIEdgeInsetsMake(CONJRNTOPINFOBARHEIGHT + 20.0f, 20.0f, 20.0f, 20.0f);
    [self.view addSubview: self.mapView];
    self.mapView.delegate = self;
    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(46.897739, 8.426514),
                                                 MKCoordinateSpanMake(4.026846,4.032959));
    //[self.mapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped:)]];
    self.mapLongPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped:)];
    self.mapLongPressGestureRecognizer.minimumPressDuration = 1.0;
    [self.mapView addGestureRecognizer:self.mapLongPressGestureRecognizer];
    
    //self.mapView.directionsEdgePadding = UIEdgeInsetsMake(CONJRNTOPINFOBARHEIGHT + 20.0f, 20.0f, 20.0f, 20.0f);
    self.mapView.directionsEdgePadding = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f);
    
    //UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    //pinchRecognizer.delegate = self;
    //[self.mapView addGestureRecognizer:pinchRecognizer];
    
    self.notificationView = [[GCDiscreetNotificationViewiPad alloc] initWithText:NSLocalizedString(@"Loading walking directions...", @"Loading walking directions notification view title")
                                                           showActivity:YES
                                                     inPresentationMode:GCDiscreetNotificationViewPresentationModeTopiPad
                                                                 inView:self.view];
    
    self.notificationView.frame = CGRectMake(self.view.frame.size.width / 2 - 375 / 2, -60, 375, 15);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appwillresignactive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void) appwillresignactive:(NSNotification *)notification {
    [self.mapView setShowsUserLocation: NO];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void) setDetailedRouteDetaillevelForTrainlines:(NSUInteger)detaillevel {
    if (detaillevel <= 4) {
        self.detaillevelForTrainlinesForDetailedRoutes = detaillevel;
    }
}

- (void) switchToNormalTrainline:(BOOL)normalline {
    
    if (normalline) {
        if (self.selectedConsectionType == consectionAllTypeiPad) {
            MTDDirectionsSetActiveAPI(MTDDirectionsAPICustom);
            MTDOverrideClass([MTDDirectionsOverlayView class], [MTDJourneyOverlayView class]);
            [self stopAllMapTransactionsAndRemoveOverlayAndAnnotations];
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                NSArray *routesArray = [[SBBAPIController sharedSBBAPIController] getMTDRoutesForConnectionResultWithIndex:self.connectionIndex];
                [self.mapView loadRoutes: routesArray zoomToShowDirections: YES];
            });
        } else {
            ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.connectionIndex consectionIndex: self.consectionIndex];
            NSUInteger journeyTypeFlag = [conSection conSectionType];
            if (journeyTypeFlag == journeyType) {
                
                MTDDirectionsSetActiveAPI(MTDDirectionsAPICustom);
                MTDOverrideClass([MTDDirectionsOverlayView class], [MTDJourneyOverlayView class]);
                [self stopAllMapTransactionsAndRemoveOverlayAndAnnotations];
                            
                double delayInSeconds = 0.1;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                    
                    MTDRoute *route = [[SBBAPIController sharedSBBAPIController] getMTDRouteForConsection: conSection];
                    NSArray *routesArray = [NSArray arrayWithObject: route];
                    [self.mapView loadRoutes: routesArray zoomToShowDirections: YES];
                });
                
                
            } else if (journeyTypeFlag == walkType) {
                
                if (conSection.routes && conSection.routes.count > 0) {
                    [self.mapView loadRoutes: conSection.routes zoomToShowDirections: YES];
                    return;
                }
                
                MTDDirectionsSetActiveAPI(MTDDirectionsAPICustom);
                MTDOverrideClass([MTDDirectionsOverlayView class], [MTDJourneyOverlayView class]);
                [self stopAllMapTransactionsAndRemoveOverlayAndAnnotations];
                                
                double delayInSeconds = 0.1;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                    MTDRoute *route = [[SBBAPIController sharedSBBAPIController] getMTDWalkingRouteForConsection:conSection];
                    
                    NSArray *routesArray = [NSArray arrayWithObject: route];
                    
                    [self.mapView loadRoutes: routesArray zoomToShowDirections: YES];
                    
                    [self showLoadingIndicatorForWalkingDirections];
                    
                    [[SBBAPIController sharedSBBAPIController] sendMTDDetailedWalkingDirectionsRouteForConsection:conSection successBlock:^(NSArray *routes){
                        
                        [self hideLoadingIndicator];
                        [self.mapView cancelLoadOfDirections];
                        [self.mapView removeDirectionsOverlay];
                        [self.mapView loadRoutes: routes zoomToShowDirections: YES];
                        
                    } failureBlock:^(NSUInteger errorcode) {
                        [self hideLoadingIndicator];
                        
                    }];
                    
                });
            }
        }
            
    } else {
        if (self.selectedConsectionType == consectionAllTypeiPad) {
            MTDDirectionsSetActiveAPI(MTDDirectionsAPICustom);
            MTDOverrideClass([MTDDirectionsOverlayView class], [MTDJourneyOverlayView class]);
            [self stopAllMapTransactionsAndRemoveOverlayAndAnnotations];
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                
                ConResult *conresult = [[SBBAPIController sharedSBBAPIController] getConnectionResultWithIndex: self.connectionIndex];
                
                if (conresult.routes && conresult.routes.count > 0) {
                    [self.mapView loadRoutes: conresult.routes zoomToShowDirections: YES];
                    return;
                }
                
            });
        } else {
            ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.connectionIndex consectionIndex: self.consectionIndex];
            NSUInteger journeyTypeFlag = [conSection conSectionType];
            if (journeyTypeFlag == journeyType) {
                
                MTDDirectionsSetActiveAPI(MTDDirectionsAPICustom);
                MTDOverrideClass([MTDDirectionsOverlayView class], [MTDJourneyOverlayView class]);
                [self stopAllMapTransactionsAndRemoveOverlayAndAnnotations];
                
                double delayInSeconds = 0.1;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                    
                    if (conSection.routes && conSection.routes.count > 0) {
                        [self.mapView loadRoutes: conSection.routes zoomToShowDirections: YES];
                        return;
                    }

                });
                
            } else if (journeyTypeFlag == walkType) {
                
                if (conSection.routes && conSection.routes.count > 0) {
                    [self.mapView loadRoutes: conSection.routes zoomToShowDirections: YES];
                    return;
                }
                
                MTDDirectionsSetActiveAPI(MTDDirectionsAPICustom);
                MTDOverrideClass([MTDDirectionsOverlayView class], [MTDJourneyOverlayView class]);
                [self stopAllMapTransactionsAndRemoveOverlayAndAnnotations];
                
                double delayInSeconds = 0.1;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                    MTDRoute *route = [[SBBAPIController sharedSBBAPIController] getMTDWalkingRouteForConsection:conSection];
                    
                    NSArray *routesArray = [NSArray arrayWithObject: route];
                    
                    [self.mapView loadRoutes: routesArray zoomToShowDirections: YES];
                    
                    [self showLoadingIndicatorForWalkingDirections];
                    
                    [[SBBAPIController sharedSBBAPIController] sendMTDDetailedWalkingDirectionsRouteForConsection:conSection successBlock:^(NSArray *routes){
                        
                        [self hideLoadingIndicator];
                        [self.mapView cancelLoadOfDirections];
                        [self.mapView removeDirectionsOverlay];
                        [self.mapView loadRoutes: routes zoomToShowDirections: YES];
                        
                    } failureBlock:^(NSUInteger errorcode) {
                        [self hideLoadingIndicator];
                        
                    }];
                    
                });
            }
        }
    }
}


- (BOOL) coordinatesAreSet:(CLLocationCoordinate2D)coordinates {
    return (coordinates.latitude != 0 && coordinates.longitude != 0);
}

- (void) loadMapViewDirections {
    
    self.detaillevelForTrainlinesForDetailedRoutes = 2;
        
#ifdef IncludeDetailedTrainlinesiPad
    [[TrainLinesController sharedTrainLinesController] cancelConReqTrainlineOperations];
#endif

    
    if (self.selectedConsectionType == consectionAllTypeiPad) {
        #ifdef LOGOUTPUTON
        NSLog(@"Journey detail: load map view directions. Is all connection type.");
        #endif
        
        MTDDirectionsSetActiveAPI(MTDDirectionsAPICustom);
        MTDOverrideClass([MTDDirectionsOverlayView class], [MTDJourneyOverlayView class]);
        
        
        [self stopAllMapTransactionsAndRemoveOverlayAndAnnotations];
        
        //[self showLoadingIndicator];
        //[self showLoadingIndicatorForTrainlines];
        
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            NSArray *routesArray = [[SBBAPIController sharedSBBAPIController] getMTDRoutesForConnectionResultWithIndex:self.connectionIndex];
            [self.mapView loadRoutes: routesArray zoomToShowDirections: YES];
            
#ifdef IncludeDetailedTrainlinesiPad
            
            ConResult *conresult = [[SBBAPIController sharedSBBAPIController] getConnectionResultWithIndex: self.connectionIndex];

            if (conresult.routes && conresult.routes.count > 0) {
                [self.mapView loadRoutes: conresult.routes zoomToShowDirections: YES];
                
                if (self.delegate && [self.delegate respondsToSelector: @selector(showTrainlineButton)]) {
                    [self.delegate showTrainlineButton];
                }
                
                return;
            }
        
            [[TrainLinesController sharedTrainLinesController] cancelConReqTrainlineOperations];
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            NSString *trainlinedetailsenabledstring = [defaults objectForKey: @"trainlineSwitch"];
            BOOL trainlinedetailsenabled = [defaults boolForKey: @"trainlineSwitch"];
            if (!trainlinedetailsenabledstring) {
                trainlinedetailsenabled = YES;
            }
            if (!trainlinedetailsenabled) {
                return;
            }
            NSString *trainlinedetaillevelstring = [defaults objectForKey: @"trainlinedetailvalues"];
            NSUInteger trainlinedetaillevel = [defaults integerForKey: @"trainlinedetailvalues"];
            if (!trainlinedetaillevelstring) {
                trainlinedetaillevel = 2;
            }
            [[TrainLinesController sharedTrainLinesController] setRouteleadsawaysfromdestinationtolerancelevel: trainlinedetaillevel];
            
            Connections *connections = [[SBBAPIController sharedSBBAPIController] getConnectionsresults];
            
            [[TrainLinesController sharedTrainLinesController] sendConResTrainlineDetailsRequest:conresult detaillevel:self.detaillevelForTrainlinesForDetailedRoutes connections:connections successBlock:^(NSArray *routes){
                
                [self hideLoadingIndicator];
                if (routes && routes.count > 0) {
                    [self.mapView loadRoutes: routes zoomToShowDirections: NO];
                    
                    if (self.delegate && [self.delegate respondsToSelector: @selector(showTrainlineButton)]) {
                        [self.delegate showTrainlineButton];
                    }
                }
                
            } failureBlock:^(NSUInteger errorcode) {
                #ifdef LOGOUTPUTON
                NSLog(@"Detailed trainline for connection result failed %d, %d", self.connectionIndex, self.consectionIndex);
                #endif
                
                [self hideLoadingIndicator];
                
            } routesavailableandprocessingblock:^(ConResult *conresult, BOOL detailsavailable) {
                [self showLoadingIndicatorForTrainlines];
            }];
            
#endif

        });
        
        
    } else {
        #ifdef LOGOUTPUTON
        NSLog(@"Journey detail: load map view directions: %d, %d", self.connectionIndex, self.consectionIndex);
        #endif

        ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.connectionIndex consectionIndex: self.consectionIndex];
        
        NSUInteger journeyTypeFlag = [conSection conSectionType];
        
        if (journeyTypeFlag == journeyType) {
            
            #ifdef LOGOUTPUTON
            NSLog(@"Journey detail: load map view directions. Is journey type.");
            #endif
            
            MTDDirectionsSetActiveAPI(MTDDirectionsAPICustom);
            
            MTDOverrideClass([MTDDirectionsOverlayView class], [MTDJourneyOverlayView class]);
            
            [self stopAllMapTransactionsAndRemoveOverlayAndAnnotations];
            
            //[self showLoadingIndicator];
            //[self showLoadingIndicatorForTrainlines];
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            
                MTDRoute *route = [[SBBAPIController sharedSBBAPIController] getMTDRouteForConsection: conSection];
                
                NSArray *routesArray = [NSArray arrayWithObject: route];
                
                [self.mapView loadRoutes: routesArray zoomToShowDirections: YES];
                
#ifdef IncludeDetailedTrainlinesiPad

                if (conSection.routes && conSection.routes.count > 0) {
                    [self.mapView loadRoutes: conSection.routes zoomToShowDirections: YES];
                    
                    if (self.delegate && [self.delegate respondsToSelector: @selector(showTrainlineButton)]) {
                        [self.delegate showTrainlineButton];
                    }
                    
                    return;
                }
                //[self showLoadingIndicatorForTrainlines];
                
                [[TrainLinesController sharedTrainLinesController] cancelConReqTrainlineOperations];
                
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                NSString *trainlinedetailsenabledstring = [defaults objectForKey: @"trainlineSwitch"];
                BOOL trainlinedetailsenabled = [defaults boolForKey: @"trainlineSwitch"];
                if (!trainlinedetailsenabledstring) {
                    trainlinedetailsenabled = YES;
                }
                if (!trainlinedetailsenabled) {
                    return;
                }
                NSString *trainlinedetaillevelstring = [defaults objectForKey: @"trainlinedetailvalues"];
                NSUInteger trainlinedetaillevel = [defaults integerForKey: @"trainlinedetailvalues"];
                if (!trainlinedetaillevelstring) {
                    trainlinedetaillevel = 2;
                }
                [[TrainLinesController sharedTrainLinesController] setRouteleadsawaysfromdestinationtolerancelevel: trainlinedetaillevel];
                
                Connections *connections = [[SBBAPIController sharedSBBAPIController] getConnectionsresults];
                
                [[TrainLinesController sharedTrainLinesController] sendConReqTrainlineDetailsRequest:conSection detaillevel:self.detaillevelForTrainlinesForDetailedRoutes connections:connections successBlock:^(NSArray *routes){
                    
                    [self hideLoadingIndicator];
                    if (routes && routes.count > 0) {
                        [self.mapView loadRoutes: routes zoomToShowDirections: NO];
                        
                        if (self.delegate && [self.delegate respondsToSelector: @selector(showTrainlineButton)]) {
                            [self.delegate showTrainlineButton];
                        }
                    }
                    
                } failureBlock:^(NSUInteger errorcode) {
                    #ifdef LOGOUTPUTON
                    NSLog(@"Detailed trainline for journey result failed %d, %d", self.connectionIndex, self.consectionIndex);
                    #endif
                    
                    [self hideLoadingIndicator];
                    
                } routesavailableandprocessingblock:^(ConSection *consection, BOOL detailsavailable) {
                    [self showLoadingIndicatorForTrainlines];
                }];
#endif

            });

        } else if (journeyTypeFlag == walkType) {
            
            if (conSection.routes && conSection.routes.count > 0) {
                [self.mapView loadRoutes: conSection.routes zoomToShowDirections: YES];
                return;
            }
            
            MTDDirectionsSetActiveAPI(MTDDirectionsAPICustom);
            
            MTDOverrideClass([MTDDirectionsOverlayView class], [MTDJourneyOverlayView class]);
            
            [self stopAllMapTransactionsAndRemoveOverlayAndAnnotations];
            
#ifdef IncludeDetailedTrainlinesiPad
            [[TrainLinesController sharedTrainLinesController] cancelConReqTrainlineOperations];
#endif
            
            //[self showLoadingIndicator];
            //[self showLoadingIndicatorForWalkingDirections];
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                MTDRoute *route = [[SBBAPIController sharedSBBAPIController] getMTDWalkingRouteForConsection:conSection];
                
                NSArray *routesArray = [NSArray arrayWithObject: route];
                
                [self.mapView loadRoutes: routesArray zoomToShowDirections: YES];
                
                [self showLoadingIndicatorForWalkingDirections];
                
                [[SBBAPIController sharedSBBAPIController] sendMTDDetailedWalkingDirectionsRouteForConsection:conSection successBlock:^(NSArray *routes){
                    
                    [self hideLoadingIndicator];
                    [self.mapView cancelLoadOfDirections];
                    [self.mapView removeDirectionsOverlay];
                    [self.mapView loadRoutes: routes zoomToShowDirections: YES];
                    
                } failureBlock:^(NSUInteger errorcode) {
                    [self hideLoadingIndicator];
                    
                }];

            });
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    // [MapView setTransform:CGAffineTransformMakeRotation(-1 * newHeading.magneticHeading * M_PI / 180)];
    //double rotation = newHeading.magneticHeading * 3.14159 / 180;
    //CGPoint anchorPoint = CGPointMake(0, -23); // The anchor point for your pin
    
    //[self.mapView setTransform:CGAffineTransformMakeRotation(-rotation)];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:NO];
    
    /*
    [[self.mapView annotations] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MKAnnotationView * view = [self.mapView viewForAnnotation:obj];
        
        [view setTransform:CGAffineTransformMakeRotation(rotation)];
        [view setCenterOffset:CGPointApplyAffineTransform(anchorPoint, CGAffineTransformMakeRotation(rotation))];
        
    }];
    */ 
}

- (void) enterLocationHeadingMode {
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.mapView setShowsUserLocation: YES];
        
        if ([CLLocationManager headingAvailable]) {
            
            if (!self.headingManager) {
                self.headingManager = [[CLLocationManager alloc] init];
                self.headingManager.delegate = self;
            }
            
            self.headingManager.headingFilter = 20;
            [self.headingManager startUpdatingHeading];
            //[self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated: NO];
        } else {
            //[self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated: NO];
        }
    }
}

- (void) leaveLocationHeadingMode {
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone animated: NO];
    if (self.headingManager) {
        [self.headingManager stopUpdatingHeading];
        self.headingManager = nil;
    }
    [self.mapView setShowsUserLocation: NO];
}

- (void) setJourneyDetailWithConnectionAndConsectionIndex:(NSUInteger)connectionIndex consectionIndex:(NSUInteger)consecionIndex {
        
    if (consecionIndex == 9999) {
        self.selectedConsectionType = consectionAllTypeiPad;
        self.connectionIndex = connectionIndex;
        self.consectionIndex = consecionIndex;
    } else {
        //NSLog(@"Journey detail: set connection and consection index: %d, %d", connectionIndex, consecionIndex);
        self.connectionIndex = connectionIndex;
        self.consectionIndex = consecionIndex;
                
        ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.connectionIndex consectionIndex: self.consectionIndex];
        NSUInteger journeyTypeFlag = [conSection conSectionType];
                
        
        if (journeyTypeFlag == walkType) {
            self.selectedConsectionType = consectionWalkTypeiPad;
        } else if (journeyTypeFlag == journeyType) {
            self.selectedConsectionType = conSectionJourneyTypeiPad;
        }
        
        //NSLog(@"Set type: %@", (self.selectedConsectionType==consectionWalkTypeiPad)?@"WALK":@"JOURNEY");
    }
    
    [self loadMapViewDirections];
}

- (void)mapTapped:(UITapGestureRecognizer *)recognizer
{
    id<MKOverlay> tappedOverlay = nil;
    for (id<MKOverlay> overlay in self.mapView.overlays)
    {
        MKOverlayView *view = [self.mapView viewForOverlay:overlay];
        if (view)
        {
            // Get view frame rect in the mapView's coordinate system
            CGRect viewFrameInMapView = [view.superview convertRect:view.frame toView:self.mapView];
            // Get touch point in the mapView's coordinate system
            CGPoint point = [recognizer locationInView:self.mapView];
            // Check if the touch is within the view bounds
            if (CGRectContainsPoint(viewFrameInMapView, point))
            {
                tappedOverlay = overlay;
                //NSLog(@"Tapped view: %@", [self.mapView viewForOverlay:tappedOverlay]);
                break;
            }
        }
    }
    
    if (tappedOverlay) {
        //NSLog(@"Tapped view overlay found: %@", [self.mapView viewForOverlay:tappedOverlay]);
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didTriggerMapViewJourneyWithLongPress:startitem:enditem:viewrect:)])
        {
            if (self.selectedConsectionType == consectionWalkTypeiPad) {
                //NSLog(@"Tapped view overlay found. Is walk type");
                if (self.mapView.directionsOverlay) {
                    //NSLog(@"Tapped view overlay found. directions overlay there");
                    if (self.fromAnnotation && self.toAnnotation) {
                        //NSLog(@"Tapped view overlay found. from to annotation there");
                        MKOverlayView *overlayview = [self.mapView viewForOverlay:tappedOverlay];
                        CGRect viewFrameInMapView = [overlayview.superview convertRect:overlayview.frame toView:self.mapView];
                        [self.delegate didTriggerMapViewJourneyWithLongPress:self startitem:[self.fromAnnotation mapItem] enditem:[self.toAnnotation mapItem] viewrect: viewFrameInMapView];
                    }
                }
            } 
        }
    } else {
        //NSLog(@"Map long tapped pressed. No overlay view in range");
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - MTDDirectionsDelegate
////////////////////////////////////////////////////////////////////////

- (void)mapView:(MTDMapView *)mapView willStartLoadingRoutes:(NSArray *)routes {
    
}

- (void)mapView:(MTDMapView *)mapView willStartLoadingDirectionsFrom:(MTDWaypoint *)from to:(MTDWaypoint *)to routeType:(MTDDirectionsRouteType)routeType {
    /*
    NSLog(@"MapView %@ willStartLoadingDirectionsFrom:%@ to:%@ routeType:%d",
          mapView,
          from,
          to,
          routeType);
    */
    //[self showLoadingIndicator];
}

- (MTDDirectionsOverlay *)mapView:(MTDMapView *)mapView didFinishLoadingDirectionsOverlay:(MTDDirectionsOverlay *)directionsOverlay {
    
    #ifdef LOGOUTPUTON
    NSLog(@"MapView %@ didFinishLoadingDirectionsOverlay: %@ (fromAddress:%@, toAddress:%@)",
          mapView, directionsOverlay, directionsOverlay.fromAddress, directionsOverlay.toAddress);
    #endif
    
    //[self hideLoadingIndicator];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
        
    NSArray *routesArray;
    NSArray *basicStopList;
    
    if (self.selectedConsectionType == consectionAllTypeiPad) {
        
        routesArray = [[SBBAPIController sharedSBBAPIController] getMTDRoutesForConnectionResultWithIndex:self.connectionIndex];
        basicStopList = [[SBBAPIController sharedSBBAPIController] getAllBasicStopsForConnectionResultWithIndex: self.connectionIndex];
    } else {
        ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.connectionIndex consectionIndex: self.consectionIndex];
        MTDRoute *route = [[SBBAPIController sharedSBBAPIController] getMTDRouteForConsection: conSection];
        routesArray = [NSArray arrayWithObject: route];
        basicStopList = [[SBBAPIController sharedSBBAPIController] getBasicStopsForConsection:conSection];
    }
    
    if (routesArray && basicStopList && routesArray.count > 0 && basicStopList.count >= 2) {
        MTDRoute *firstRoute = [routesArray objectAtIndex: 0];
        MTDRoute *lastRoute = [routesArray lastObject];
        
        self.fromAnnotation = [[StationAnnotation alloc] initWithCoordinate: firstRoute.from.coordinate];
        self.toAnnotation = [[StationAnnotation alloc] initWithCoordinate: lastRoute.to.coordinate];
        
        self.fromAnnotation.title = firstRoute.from.name;
        self.fromAnnotation.subtitle = firstRoute.from.departuretime;
        
        self.toAnnotation.title = lastRoute.to.name;
        self.toAnnotation.subtitle = lastRoute.to.arrivaltime;
        
        [self.mapView addAnnotation:self.fromAnnotation];
        [self.mapView addAnnotation:self.toAnnotation];
        
        if (basicStopList.count >= 3) {
            for (int i = 1; i < [basicStopList count] - 1; i++) {
        
                Station *currentStation = [[SBBAPIController sharedSBBAPIController] getStationForBasicStop: [basicStopList objectAtIndex: i]];
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([currentStation.latitude doubleValue], [currentStation.longitude doubleValue]);
                
                StationAnnotation *annotation = [[StationAnnotation alloc] initWithCoordinate:coordinate];

                NSString *stationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList objectAtIndex: i]];
                NSString *arrivalTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForBasicStop: [basicStopList objectAtIndex: i]];
                NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForBasicStop: [basicStopList objectAtIndex: i]];

                annotation.title = stationName;
          
                if (departureTime && arrivalTime) {
                    annotation.subtitle = [NSString stringWithFormat:@"%@ / %@", arrivalTime, departureTime];
                }
                
                [self.mapView addAnnotation:annotation];
                
            }
        }
    }
    
    [self hideLoadingIndicator];
    
    return directionsOverlay;
}

- (void)mapView:(MTDMapView *)mapView didFailLoadingDirectionsOverlayWithError:(NSError *)error {
    //NSLog(@"MapView %@ didFailLoadingDirectionsOverlayWithError: %@", mapView, error);
    
    //[self setDirectionsInfoText:[error.userInfo objectForKey:MTDDirectionsKitErrorMessageKey]];
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.fromAnnotation = nil;
    self.toAnnotation = nil;
    
    [self hideLoadingIndicator];
    
}

- (void)mapView:(MTDMapView *)mapView didActivateRoute:(MTDRoute *)route ofDirectionsOverlay:(MTDDirectionsOverlay *)directionsOverlay {
    //[self setDirectionsInfoFromRoute:route];
    //NSLog(@"User taped on route: %@", [[directionsOverlay activeRoute] description]);
}

- (UIColor *)mapView:(MTDMapView *)mapView colorForDirectionsOverlay:(MTDDirectionsOverlay *)directionsOverlay {
    //NSLog(@"MapView %@ colorForDirectionsOverlay: %@", mapView, directionsOverlay);
    
    if (self.selectedConsectionType == consectionWalkTypeiPad) {
        return [UIColor detailTableViewCellChangeLineColor];
    } else {
        return [UIColor detailTableViewCellJourneyLineColor];
    }
    return [UIColor darkGrayColor];
}

- (CGFloat)mapView:(MTDMapView *)mapView lineWidthFactorForDirectionsOverlay:(MTDDirectionsOverlay *)directionsOverlay {
    
    return 1.0f;
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //NSLog(@"Region did change.");
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    //NSLog(@"Region will change.");
}

////////////////////////////////////////////////////////////////////////
#pragma mark - MKMapViewDelegate
////////////////////////////////////////////////////////////////////////
/*
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.mapType = MKMapTypeStandard;   // also MKMapTypeSatellite or MKMapTypeHybrid
    
    // Add a pinch gesture recognizer
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinchRecognizer.delegate = self;
    [self.mapView addGestureRecognizer:pinchRecognizer];
    [pinchRecognizer release];
}
 
 -(void)mapView:(MKMapView *)pMapView regionDidChangeAnimated:(BOOL)animated{
 NSLog(@"mapView.region.span.latitudeDelta = %f",pMapView.region.span.latitudeDelta);
 for (id <MKAnnotation> annotation in pMapView.annotations) {
 MKAnnotationView *annotationView  = [pMapView viewForAnnotation: annotation];
 }
 }

*/

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated {
    //NSLog(@"User tracking mode is: %@", (mode == MKUserTrackingModeFollowWithHeading)?@"FollowWithHeading":((mode == MKUserTrackingModeFollow)?@"Follow":@"None"));
    
    if (mode == MKUserTrackingModeNone) {
        [self leaveLocationHeadingMode];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(headingManagerDidLeaveAllTrackingModes)]) {
            [self.delegate headingManagerDidLeaveAllTrackingModes];
        }
    }
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchRecognizer {
        
    if (pinchRecognizer.state != UIGestureRecognizerStateChanged) {
        return;
    }
    
    MKMapView *aMapView = (MKMapView *)pinchRecognizer.view;
    
    for (id <MKAnnotation>annotation in aMapView.annotations) {
        // if it's the user location, just return nil.
        if ([annotation isKindOfClass:[MKUserLocation class]])
            return;
        
        // handle our custom annotations
        //
        
        
        
        if ([annotation isKindOfClass:[StationAnnotation class]])
        {
            // try to retrieve an existing pin view first
            StationsAnnotationView *annotationview = (StationsAnnotationView *)[aMapView viewForAnnotation:annotation];
            //Format the pin view
            [self formatAnnotationView:annotationview forMapView:aMapView];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)formatAnnotationView:(StationsAnnotationView *)annotationview forMapView:(MKMapView *)aMapView {
    if (annotationview)
    {
        double zoomLevel = [aMapView zoomLevel];
        double scale = -1 * sqrt((double)(1 - pow((zoomLevel/20.0), 2.0))) + 1.1; // This is a circular scale function where at zoom level 0 scale is 0.1 and at zoom level 20 scale is 1.1
        
        // Option #1
        annotationview.transform = CGAffineTransformMakeScale(scale, scale);
        
        [annotationview setAnnotationImageForType: annotationview.annotationType withscale: scale];
        
        // Option #2
        //UIImage *pinImage = [UIImage imageNamed:@"YOUR_IMAGE_NAME_HERE"];
        //pinView.image = [pinImage resizedImage:CGSizeMake(pinImage.size.width * scale, pinImage.size.height * scale) interpolationQuality:kCGInterpolationHigh];
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass: [StationAnnotation class]]) {
        //NSLog(@"ConnectionsMapViewController. View for annotation. Is StationAnnotation class");
        
        static NSString *const kAnnotationIdentifier = @"StationAnnotation";
        StationsAnnotationView *annotationView = (StationsAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kAnnotationIdentifier];
        if (! annotationView) {
            annotationView = [[StationsAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kAnnotationIdentifier];
        }
        
        annotationView.canShowCallout = YES;
        
        if (annotation == self.fromAnnotation) {
            annotationView.annotationType = startStation;
        } else if (annotation == self.toAnnotation) {
            annotationView.annotationType = endStation;
        } else {
            annotationView.annotationType = middleStation;
        }
        [annotationView setAnnotationImageForType: annotationView.annotationType];
        
        //[annotationView setNeedsDisplay];
        
        [annotationView setAnnotation:annotation];
        
        return annotationView;

    } else if ([annotation isKindOfClass: [Stations class]]) {
        
        //NSLog(@"ConnectionsMapViewController. View for annotation. Is StationPickerAnnotation class");
        
        static NSString *const kAnnotationIdentifier = @"StationPickerStationAnnotation";
        StationPickerStationAnnotationView *annotationView = (StationPickerStationAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kAnnotationIdentifier];
        if (! annotationView) {
            annotationView = [[StationPickerStationAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kAnnotationIdentifier];
        }
        
        annotationView.canShowCallout = NO;
        
        //UIButton *chooseStationButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        UIButton *chooseStationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *chooseStationButtonImage = [UIImage newImageFromMaskImage: [UIImage chooseStationButtonImage] inColor: [UIColor selectStationsViewButtonColorNormal]];
        UIImage *chooseStationButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage chooseStationButtonImage] inColor: [UIColor selectStationsViewButtonColorHighlighted]];
        [chooseStationButton setImage: chooseStationButtonImage forState: UIControlStateNormal];
        [chooseStationButton setImage: chooseStationButtonImageHighlighted forState: UIControlStateHighlighted];
        chooseStationButton.imageView.contentMode = UIViewContentModeCenter;
        chooseStationButton.frame = CGRectMake(0, 0, BUTTONHEIGHT, BUTTONHEIGHT);
        //[chooseStationButton addTarget: self action: @selector(userChoosedStationOnMap:) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView=chooseStationButton;
        annotationView.enabled = YES;
        annotationView.multipleTouchEnabled = NO;
        
        [annotationView setAnnotation:annotation];
        
        return annotationView;
    } 
        
    return  nil;
}

- (void)mapView:(MKMapView *)theMapView didSelectAnnotationView:(MKAnnotationView *)view {
	if ([view.annotation isKindOfClass:[Stations class]]) {
		
        //NSLog(@"On station picker annotation view tapped");
        Stations *selectedAnnotation = (Stations *)view.annotation;
        
        [self.mapView deselectAnnotation: selectedAnnotation animated: NO];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectStationPickerAnnotaton:station:viewrect:)]) {
            Station *station = [[Station alloc] init];
            station.stationName = [selectedAnnotation valueForKey: @"stationname"];
            station.stationId = [selectedAnnotation valueForKey: @"externalid"];
            
            CGRect viewFrameInMapView = [view.superview convertRect:view.frame toView:self.mapView];
            
            [self.delegate didSelectStationPickerAnnotaton:self station: station viewrect: viewFrameInMapView];
        }
	} else {
        //NSLog(@"On journey annotation view tapped");
    }
}

- (void)mapView:(MKMapView *)theMapView didDeselectAnnotationView:(MKAnnotationView *)view {

}
 
- (void) stopAllMapTransactionsAndRemoveOverlayAndAnnotations {
    [self.mapView setShowsUserLocation: NO];
    [MBProgressHUD hideAllHUDsForView: self.view animated: NO];
    [self.mapView cancelLoadOfDirections];
    [[SBBAPIController sharedSBBAPIController] cancelSBBAPIWalkingDirectionsOperations];
    [self.mapView removeAnnotations: self.mapView.annotations];
    [self.mapView removeDirectionsOverlay];
}

- (void) stopAllMapTransactions {
    [self.mapView setShowsUserLocation: NO];
    [MBProgressHUD hideAllHUDsForView: self.view animated: NO];
    [self.mapView cancelLoadOfDirections];
    [[SBBAPIController sharedSBBAPIController] cancelSBBAPIWalkingDirectionsOperations];
}

#pragma mark -
#pragma mark Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    //NSLog(@"NSFetchedResultsController will change content");
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    //NSLog(@"NSFetchedResultscontroller did change object");
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    //NSLog(@"NSFetchedResultsController did change content");
}

- (void)hideLoadingIndicator {
    
    //[self.notificationView hide: YES];
    
    [UIView animateWithDuration: 0.3 animations: ^{
        CGRect viewframe = self.notificationView.frame;
        viewframe.origin.y = -30;
        self.notificationView.frame = viewframe;
        
    }];
    
    [self.notificationView.activityIndicator stopAnimating];
    
    //[MBProgressHUD hideAllHUDsForView: self.view animated: NO];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)showLoadingIndicatorForTrainlines {
    
    [self.notificationView setTextLabel: NSLocalizedString(@"Loading trainline ...", @"Loading trainline notification view title")];
    [self.notificationView setUserInteractionEnabled: NO];
    self.notificationView.frame = CGRectMake(self.view.frame.size.width / 2 - 375 / 2, -15, 375, 15);
    
    [self.notificationView.activityIndicator startAnimating];
    [UIView animateWithDuration: 0.3 animations: ^{
        CGRect viewframe = self.notificationView.frame;
        viewframe.origin.y = 8;
        self.notificationView.frame = viewframe;
    
    }];
    
    //[self.notificationView setOrigin: self.view.frame];
    //[self.notificationView show:YES];
    
    /*
     [self hideLoadingIndicator];
     
     [MBProgressHUD hideAllHUDsForView: self.view animated: NO];
     
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     hud.removeFromSuperViewOnHide = YES;
     hud.userInteractionEnabled = NO;
     */
    
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


- (void)showLoadingIndicatorForWalkingDirections {
    
    [self.notificationView setTextLabel: NSLocalizedString(@"Loading walking directions...", @"Loading walking directions notification view title")];
    [self.notificationView setUserInteractionEnabled: NO];
    
    self.notificationView.frame = CGRectMake(self.view.frame.size.width / 2 - 375 / 2, -15, 375, 15);
    
    [self.notificationView.activityIndicator startAnimating];
    [UIView animateWithDuration: 0.3 animations: ^{
        CGRect viewframe = self.notificationView.frame;
        viewframe.origin.y = 8;
        self.notificationView.frame = viewframe;
        
    }];
    
    //[self.notificationView setOrigin: self.view.frame];
    
    //[self.notificationView show:YES];
    
    /*
    [self hideLoadingIndicator];
    
    [MBProgressHUD hideAllHUDsForView: self.view animated: NO];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    */
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)showLoadingIndicator {
    
    [self.notificationView show:YES];
    
    
    [self hideLoadingIndicator];
    
    [MBProgressHUD hideAllHUDsForView: self.view animated: NO];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

// ------------------------------------------------------------------------------------------------------

- (float) calculateDistance: (CLLocationCoordinate2D) aPoint bPoint:(CLLocationCoordinate2D)bPoint {
	CLLocation *startpoint = [[CLLocation alloc] initWithLatitude:aPoint.latitude longitude:aPoint.longitude];
	CLLocation *endPoint = [[CLLocation alloc] initWithLatitude:bPoint.latitude longitude:bPoint.longitude];
	CLLocationDistance calculatedDistance;
	calculatedDistance = [startpoint distanceFromLocation:endPoint];
	return ((float)calculatedDistance);
}

- (void)updateToStation:(Stations *)aStation {
	if (aStation) {
		//double cMapSpan = [self getCurrentMapSpan];
        double cMapSpan = mapSpaniPad;
		[self.mapView setRegion: MKCoordinateRegionMakeWithDistance(aStation.coordinate, cMapSpan, cMapSpan) animated: YES];
	}
}

- (BOOL) checkIfInCH: (CLLocationCoordinate2D) coordinate {
    if (coordinate.latitude > 47.818688) return NO;
    if (coordinate.latitude < 45.79817) return NO;
    if (coordinate.longitude > 10.508423) return NO;
    if (coordinate.longitude < 5.921631) return NO;
    return YES;
}

- (void)selectAnnotation:(Stations *)aStation
{
	[self.mapView selectAnnotation:aStation animated:YES];
    
}

- (NSArray *) fetchStationsClosestToCurrentLocation:(CLLocationCoordinate2D)coordinate {
    NSManagedObjectContext *context = self.managedObjectContext;
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity: [NSEntityDescription entityForName:@"Stations" inManagedObjectContext:context]];
    
    double cSearchSpan = searchSpaniPad;
    
	[request setPredicate:[NSPredicate predicateWithFormat:
                           @"latitude BETWEEN {%@, %@} AND longitude BETWEEN {%@, %@}",
                           [NSNumber numberWithFloat:coordinate.latitude - cSearchSpan],
                           [NSNumber numberWithFloat:coordinate.latitude + cSearchSpan],
                           [NSNumber numberWithFloat:coordinate.longitude - cSearchSpan],
                           [NSNumber numberWithFloat:coordinate.longitude + cSearchSpan]]];
    
	NSError *error = nil;
	NSArray *results = [context executeFetchRequest:request error:&error];
	if (error) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
        //abort();
	}
    
    if (results) {
        if ([results count]>0) {
            //NSLog(@"Stations fetched and calculating distances...");
            for (Stations *currentPOI in results) {
                //NSLog(@"Current station: %@", currentPOI.stationname);
                currentPOI.distance = [self calculateDistance: coordinate bPoint: [currentPOI coordinate]];
            }
            //NSLog(@"Stations fetched. Distances calculated. Return results.");
            return results;
        }
    }
    return  nil;
}

- (void) getStationsClosestToCurrentLocationAndUpdateResultsArray:(void(^)(CLLocationCoordinate2D))successBlock failureBlock:(void(^)(NSUInteger))failureBlock {
    
    self.locationManager = nil;
    
    if (!self.locationManager) {
        self.locationManager = [BKLocationManager sharedManager];
        
        __weak ConnectionsMapViewController *weakSelf = self;
        
        [self.locationManager setDidUpdateLocationBlock:^(CLLocationManager *manager, CLLocation *newLocation, CLLocation *oldLocation) {
            //NSLog(@"didUpdateLocation: lat: %.6f, %.6f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
            
            weakSelf.userLocation = newLocation;
            weakSelf.userLocationDate = [NSDate date];
            
            [manager stopUpdatingLocation];
            manager = nil;
            
            /*
            if (![weakSelf checkIfInCH: newLocation.coordinate]) {
                
                //UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
                //[[NoticeviewMessages sharedNoticeMessagesController] showLocationOutsideSwitzerland: currentWindow];
                
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(showLocationOutsideSwitzerlandMessage)]) {
                    [weakSelf.delegate showLocationOutsideSwitzerlandMessage];
                }
            }
            */ 
            
            //NSLog(@"Got current location. FetchStationsClosestToCurrentLocation.");
            NSArray *resultArray = [weakSelf fetchStationsClosestToCurrentLocation: newLocation.coordinate];
            
            if (resultArray) {
                if ([resultArray count] > 0) {
                    if (weakSelf.stationsToCurrentLocation) {
                        weakSelf.stationsToCurrentLocation = nil;
                    }
                    weakSelf.stationsToCurrentLocation = resultArray;
                    if (successBlock) {
                        successBlock(newLocation.coordinate);
                    }
                } else {
                    int kStationsFetchAroundCurrentLocationDidNotReturnResults = 9988;
                    if (failureBlock) {
                        failureBlock(kStationsFetchAroundCurrentLocationDidNotReturnResults);
                    }
                }
            }
        }];
        
        [self.locationManager setDidFailBlock:^(CLLocationManager *manager, NSError *error) {
            //NSLog(@"didFailUpdateLocation");
            
            //[self.activityIndicatorView stopAnimating];
            //self.activityIndicatorView.alpha = 0.0;
            
            NSString * errorMessage;
            
            switch ([error code]) {
                    
                case kCLErrorLocationUnknown:
                    errorMessage =
                    NSLocalizedString(@"We could not determine your location. Please try again later.", nil);
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(showLocationManagerErrorMessage)]) {
                        [weakSelf.delegate showLocationManagerErrorMessage];
                    }
                    break;
                    
                case kCLErrorDenied:
                    errorMessage =
                    NSLocalizedString(@"We could not access your current location.", nil);
                    
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(showLocationManagerDeniedMessage)]) {
                        [weakSelf.delegate showLocationManagerDeniedMessage];
                    }
                    
                    break;
                    
                default:
                    errorMessage =
                    NSLocalizedString(@"An unexpected error occured when trying to determine your location.", nil);
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(showLocationManagerErrorMessage)]) {
                        [weakSelf.delegate showLocationManagerErrorMessage];
                    }
                    break;
            };
            
            NSLog(@"Error: %@", errorMessage);
            
            //int kFailedToLocationStationsNearCurrentLocation = 1;
            if (failureBlock) {
                failureBlock([error code]);
            }
        }];
    }
    
    [self.locationManager stopUpdatingLocationAndRestManager];
    [self.locationManager startUpdatingLocationWithAccuracy:kCLLocationAccuracyHundredMeters];
}

-(void)zoomToFitMapAnnotations:(MKMapView*)mapView
{
    if([mapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(Stations* annotation in mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.8;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

- (void) updateMapViewWithStationsAnnotationAndSelectedClosestStationToCoordinate:(CLLocationCoordinate2D)coordinate {
    //NSLog(@"Update map view with annotations");
    
    NSInteger closestIndex = 0;
    NSInteger currentIndex = 0;
    
    double closestDistanceSquared = CGFLOAT_MAX;
    for (Stations *current in self.stationsToCurrentLocation)
    {
        double longitude = [[current valueForKey:@"longitude"] doubleValue];
        double latitude = [[current valueForKey:@"latitude"] doubleValue];
        double delatLongitude = longitude - coordinate.longitude;
        double delatLatitude = latitude - coordinate.latitude;
        
        double distanceSquared =
        delatLongitude * delatLongitude + delatLatitude * delatLatitude;
        if (distanceSquared < closestDistanceSquared)
        {
            closestDistanceSquared = distanceSquared;
            closestIndex = currentIndex;
        }
        currentIndex++;
    }
    
    [self updateToStation:[self.stationsToCurrentLocation objectAtIndex:closestIndex]];
    [self.mapView removeAnnotations: self.mapView.annotations];


    [self.mapView addAnnotations:self.stationsToCurrentLocation];
    
    /*
     MKMapRect r = [self.mapView visibleMapRect];
     MKMapPoint pt = MKMapPointForCoordinate([[self.stationsToCurrentLocation objectAtIndex:closestIndex] coordinate]);
     r.origin.x = pt.x - r.size.width * 0.5;
     r.origin.y = pt.y - r.size.height * 0.25;
     //r.origin.x = pt.x - 0.4;
     //r.origin.y = pt.y - 0.4;
     //MKMapRect pointRect = MKMapRectMake(pt.x, pt.y, 0.2, 0.2);
     [self.mapView setVisibleMapRect:r animated:NO];
     */
    
    [self zoomToFitMapAnnotations:self.mapView];
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.mapView setShowsUserLocation: YES];
    }
    
    [self performSelector:@selector(selectAnnotation:)
               withObject:[self.stationsToCurrentLocation objectAtIndex:closestIndex]
               afterDelay:AnnotationDelayiPad];
    
}

- (void) getStationsAndUpdateMapView {
    //NSLog(@"GetStationsAndUpdateMapView");
    if (self.stationsToCurrentLocation) {
        if (self.userLocationDate && self.userLocation) {
            NSTimeInterval howRecent = [self.userLocationDate timeIntervalSinceNow];
            if (abs(howRecent) < SECS_OLD_MAX) {
                
                if ([CLLocationManager locationServicesEnabled]) {
                    [self.mapView setShowsUserLocation: YES];
                }
                
                return;
            }
        }
    }
    [self getStationsClosestToCurrentLocationAndUpdateResultsArray:^(CLLocationCoordinate2D coordinate) {
        [self updateMapViewWithStationsAnnotationAndSelectedClosestStationToCoordinate: coordinate];
        
    }
                                                      failureBlock: ^(NSUInteger errorCode){
                                                          NSLog(@"Error code: %d", errorCode);
                                                      }];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"ConnectionsMapViewControlleriPad: should autororate");
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	NSLog(@"ConnectionsMapViewControlleriPad: willRotateToInterfaceOrientation");
    //[self layoutSubviews:YES toInterfaceOrientation:toInterfaceOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"ConnectionsMapViewControlleriPad: didRotateToInterfaceOrientation");
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"ConnectionsMapViewControlleriPad: willAnimateRotateToInterfaceOrientation");
    //[self layoutSubviews:YES toInterfaceOrientation:toInterfaceOrientation];
	//[self.connectionsMapViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration: duration];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    self.mapView.delegate = self;
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    //[self layoutSubviews: NO toInterfaceOrientation: [[UIDevice currentDevice] orientation]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    self.mapView.delegate = nil;
    
    [self.mapView setShowsUserLocation: NO];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
