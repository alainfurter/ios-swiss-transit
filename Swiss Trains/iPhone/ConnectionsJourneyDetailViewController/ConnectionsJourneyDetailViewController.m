//
//  ConnectionsJourneyDetailViewController.m
//  Swiss Trains
//
//  Created by Alain on 12.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "ConnectionsJourneyDetailViewController.h"

@interface ConnectionsJourneyDetailViewController ()

@end

@implementation ConnectionsJourneyDetailViewController

- (id)initWithFrame:(CGRect)viewFrame
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.view.frame = viewFrame;
        
        //self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        self.view.backgroundColor = [UIColor listviewControllersBackgroundColor];
        
        /*
        self.detailViewTableView = [[UITableView alloc] initWithFrame: self.view.bounds style:UITableViewStylePlain];
        self.detailViewTableView.rowHeight = 142;
        //self.detailViewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.detailViewTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.detailViewTableView.separatorColor = [UIColor lightGrayColor];
        self.detailViewTableView.backgroundColor = [UIColor detailTableviewBackgroundColor];
        //self.detailViewTableView.backgroundColor = [UIColor darkGrayColor];
        [self.detailViewTableView registerClass:[ConnectionsDetailviewCell class] forCellReuseIdentifier: @"ConnectionsDetailviewCell"];
        [self.view addSubview: self.detailViewTableView];
        self.detailViewTableView.dataSource = self;
        self.detailViewTableView.delegate = self;
        
        self.view.clipsToBounds = NO;
        self.view.layer.masksToBounds = NO;
        self.view.layer.shadowColor = [UIColor blackColor].CGColor;
        self.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.view.layer.shadowOpacity = 1.0f;
        self.view.layer.shadowRadius = 2.5f;
        self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
         */
    }
    return self;
}

- (void) loadView {
    CGSize size = [UIApplication currentScreenSize];
    float padding = -25;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320 - 80 - padding, size.height - TOOLBARHEIGHT)];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = view;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        self.view.backgroundColor = [UIColor listviewControllersBackgroundColor];
        
        self.connectionJourneyDetailViewTypeSelected = mapViewType;
        
        float padding = -25;
        self.trainlinebuttonvisible = NO;
        
        self.topInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320 - 80 - padding, CONJRNTOPINFOBARHEIGHT)];
        self.topInfoView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        self.topInfoView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.6f];
        //self.conSectionDetailView.font = [UIFont boldSystemFontOfSize:14.f];
        //self.conSectionDetailView.textColor = [UIColor whiteColor];
        //self.conSectionDetailViewtextAlignment = UITextAlignmentCenter;
        //self.conSectionDetailView.shadowColor = [UIColor blackColor];
        //self.conSectionDetailView.shadowOffset = CGSizeMake(0.f, 1.f);
        self.topInfoView.userInteractionEnabled = NO;
        
        self.topInfoViewSeparatorLineLayer = CAShapeLayer.layer;
        self.topInfoViewSeparatorLineLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        self.topInfoViewSeparatorLineLayer.lineWidth = .5;
        self.topInfoViewSeparatorLineLayer.fillColor = nil;
        [self.topInfoView.layer addSublayer:self.topInfoViewSeparatorLineLayer];
        CGRect ownframe = self.topInfoView.frame;
        CGFloat lineWidth = self.topInfoViewSeparatorLineLayer.lineWidth;
        UIBezierPath *borderBottomPath = [UIBezierPath bezierPathWithRect: CGRectMake(ownframe.origin.x, ownframe.size.height - lineWidth, ownframe.size.width, lineWidth)];
        //const CGFloat lineY = bottom - self.borderBottomLayer.lineWidth;
        //[self addArrowAtPoint:CGPointMake(position, lineY) toPath:borderBottomPath withLineWidth:_borderBottomLayer.lineWidth];
        self.topInfoViewSeparatorLineLayer.path = borderBottomPath.CGPath;
        
        self.topInfoTransportTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 30, 30)];
        self.topInfoTransportTypeImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        self.topInfoTransportTypeImageView.backgroundColor = [UIColor clearColor];
        self.topInfoTransportTypeImageView.contentMode = UIViewContentModeScaleAspectFill;
        //self.conSectionDetailView.font = [UIFont boldSystemFontOfSize:14.f];
        //self.conSectionDetailView.textColor = [UIColor whiteColor];
        //self.conSectionDetailViewtextAlignment = UITextAlignmentCenter;
        //self.conSectionDetailView.shadowColor = [UIColor blackColor];
        //self.conSectionDetailView.shadowOffset = CGSizeMake(0.f, 1.f);
        //self.topInfoTransportTypeImageView.userInteractionEnabled = NO;
        [self.topInfoView addSubview:self.topInfoTransportTypeImageView];
        
        self.topInfoTransportNameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(320 - 80 - padding - 80 - 8, 13, 80, 20)];
        self.topInfoTransportNameImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        self.topInfoTransportNameImageView.backgroundColor = [UIColor clearColor];
        self.topInfoTransportNameImageView.contentMode = UIViewContentModeScaleAspectFill;
        //self.conSectionDetailView.font = [UIFont boldSystemFontOfSize:14.f];
        //self.conSectionDetailView.textColor = [UIColor whiteColor];
        //self.conSectionDetailViewtextAlignment = UITextAlignmentCenter;
        //self.conSectionDetailView.shadowColor = [UIColor blackColor];
        //self.conSectionDetailView.shadowOffset = CGSizeMake(0.f, 1.f);
        //self.topInfoTransportNameImageView.userInteractionEnabled = NO;
        [self.topInfoView addSubview:self.topInfoTransportNameImageView];
        
        self.mapView = [[MTDMapView alloc] initWithFrame: CGRectMake(0, 0, 320 - 80 - padding, self.view.frame.size.height - TOOLBARHEIGHT)];
        [self.view addSubview: self.mapView];
        //CLLocationCoordinate2D zoomLocation;
        //zoomLocation.latitude = 40.7310;
        //zoomLocation.longitude= -73.9977;
        //MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 10000, 10000);
        //[self.mapView setRegion:viewRegion animated:NO];
        self.mapView.delegate = self;
        self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(46.897739, 8.426514),
                                                     MKCoordinateSpanMake(4.026846,4.032959));
        
        //[self.mapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped:)]];
        self.mapLongPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped:)];
        self.mapLongPressGestureRecognizer.minimumPressDuration = 1.0;
        [self.mapView addGestureRecognizer:self.mapLongPressGestureRecognizer];
        
        CGFloat scaleFactorLocationheadingButton = 1.2;
        self.locationheadingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *locationheadingButtonImage =  [UIImage newImageFromMaskImage: [[UIImage locationheadingButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON* scaleFactorLocationheadingButton, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorLocationheadingButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor lightGrayColor]];
        UIImage *locationheadingImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage locationheadingButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorLocationheadingButton, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorLocationheadingButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
        UIImage *locationheadingButtonImageSelected =  [UIImage newImageFromMaskImage: [[UIImage locationheadingButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON* scaleFactorLocationheadingButton, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorLocationheadingButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor blackColor]];
        [self.locationheadingButton setImage: locationheadingButtonImage forState: UIControlStateNormal];
        [self.locationheadingButton setImage: locationheadingImageHighlighted forState: UIControlStateHighlighted];
        [self.locationheadingButton setImage: locationheadingButtonImageSelected forState: UIControlStateSelected];
        self.locationheadingButton.imageView.contentMode = UIViewContentModeCenter;
        self.locationheadingButton.frame = CGRectMake(320 - 80 - padding - BUTTONHEIGHT - 8, self.view.frame.size.height - CONJRNBOTTOMINFOBARHEIGHT - BUTTONHEIGHT - 5, BUTTONHEIGHT, BUTTONHEIGHT);
        //self.locationheadingButton.frame = CGRectMake(320 - 80 - padding - BUTTONHEIGHT - 8, 40, BUTTONHEIGHT, BUTTONHEIGHT);
        self.locationheadingButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.locationheadingButton.showsTouchWhenHighlighted = YES;
        [self.locationheadingButton addTarget: self action: @selector(enterLocationHeadingMode:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: self.locationheadingButton];
        self.locationheadingButton.alpha = 0.0;
        
        //CGFloat scaleFactorTrainlineButton = 1.0;
        self.trainlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *trainlineButtonImage =  [UIImage renderCircleButtonImage: [UIImage trainlineNormalButtonImage] backgroundColor:[UIColor detailTableViewCellJourneyInfoImageBackgroundColor] imageColor:[UIColor detailTableViewCellJourneyInfoImageColor]];
        UIImage *trainlineButtonImageHighlighted =  [UIImage renderCircleButtonImage: [UIImage trainlineNormalButtonImage] backgroundColor:[UIColor detailTableViewCellJourneyInfoImageBackgroundColor] imageColor:[UIColor detailTableViewCellJourneyInfoImageColor]];
        UIImage *trainlineButtonImageSelected =  [UIImage renderCircleButtonImage: [UIImage trainlineDetailedButtonImage] backgroundColor:[UIColor detailTableViewCellJourneyInfoImageBackgroundColor] imageColor:[UIColor detailTableViewCellJourneyInfoImageColor]];
        [self.trainlineButton setImage: trainlineButtonImage forState: UIControlStateNormal];
        [self.trainlineButton setImage: trainlineButtonImageHighlighted forState: UIControlStateHighlighted];
        [self.trainlineButton setImage: trainlineButtonImageSelected forState: UIControlStateSelected];
        //self.trainlineButton.imageView.contentMode = UIViewContentModeCenter;
        //self.trainlineButton.frame = CGRectMake(320 - 80 - padding - BUTTONHEIGHT - 8, 40, BUTTONHEIGHT, BUTTONHEIGHT);
        self.trainlineButton.frame = CGRectMake(320 - 80 - padding - BUTTONHEIGHT - 8, self.view.frame.size.height - CONJRNBOTTOMINFOBARHEIGHT - BUTTONHEIGHT - 5, BUTTONHEIGHT, BUTTONHEIGHT);
        self.trainlineButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.trainlineButton.showsTouchWhenHighlighted = YES;
        [self.trainlineButton addTarget: self action: @selector(switchtrainlinemode:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: self.trainlineButton];
        self.trainlineButton.alpha = 0.0;
        
        //self.listTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, CONJRNTOPINFOBARHEIGHT, 320 - 80 - padding, self.view.frame.size.height - CONJRNTOPINFOBARHEIGHT - CONJRNBOTTOMINFOBARHEIGHT) style:UITableViewStylePlain];
        self.listTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, 320 - 80 - padding, self.view.frame.size.height - CONJRNBOTTOMINFOBARHEIGHT) style:UITableViewStylePlain];
        //self.listTableView.rowHeight = 50;
        //self.detailViewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.listTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.listTableView.separatorColor = [UIColor lightGrayColor];
        //self.listTableView.backgroundColor = [UIColor detailTableviewBackgroundColor];
        self.listTableView.backgroundColor = [UIColor listviewControllersBackgroundColor];
        //self.detailViewTableView.backgroundColor = [UIColor darkGrayColor];
        [self.listTableView registerClass:[ConnectionsJourneyDetailDirectionsCell class] forCellReuseIdentifier: @"ConnectionsJourneyDetailDirectionsCell"];
        [self.listTableView registerClass:[ConnectionsJourneyDetailPasslistCell class] forCellReuseIdentifier: @"ConnectionsJourneyDetailPasslistCell"];
        [self.view addSubview: self.listTableView];
        self.listTableView.dataSource = self;
        self.listTableView.delegate = self;
        
        UIView *dummyFooterView =  [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320 - 80 - padding, 10)];
        self.listTableView.tableFooterView = dummyFooterView;
        dummyFooterView.hidden = YES;
        
        self.listTableView.alpha = 0.0;
        
        //MTDDirectionsSetLogLevel(MTDLogLevelVerbose);
        
        self.bottomInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - CONJRNBOTTOMINFOBARHEIGHT, self.view.bounds.size.width, CONJRNBOTTOMINFOBARHEIGHT)];
        self.bottomInfoView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        self.bottomInfoView.backgroundColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapBackgroundColor];
        //self.bottomInfoView.backgroundColor = [UIColor clearColor];
        self.bottomInfoView.userInteractionEnabled = NO;
        //self.view addSubview:self.bottomInfoView];
        self.bottomInfoView.alpha = 1.0;
        
        self.bottomInfoViewSeparatorLineLayer = CAShapeLayer.layer;
        self.bottomInfoViewSeparatorLineLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        self.bottomInfoViewSeparatorLineLayer.lineWidth = 1.0;
        self.bottomInfoViewSeparatorLineLayer.fillColor = nil;
        [self.view.layer addSublayer:self.bottomInfoViewSeparatorLineLayer];
        CGRect bottomLayerframe = self.bottomInfoView.frame;
        CGFloat bottomLineWidth = self.bottomInfoViewSeparatorLineLayer.lineWidth;
        UIBezierPath *bottomBorderBottomPath = [UIBezierPath bezierPathWithRect: CGRectMake(bottomLayerframe.origin.x, bottomLayerframe.origin.y, bottomLayerframe.size.width, bottomLineWidth)];
        //const CGFloat lineY = bottom - self.borderBottomLayer.lineWidth;
        //[self addArrowAtPoint:CGPointMake(position, lineY) toPath:borderBottomPath withLineWidth:_borderBottomLayer.lineWidth];
        self.bottomInfoViewSeparatorLineLayer.path = bottomBorderBottomPath.CGPath;
        
        self.bottomInfoStartStationLabel = [[UILabel alloc] initWithFrame: CGRectMake(8, 3, self.bottomInfoView.bounds.size.width -8 - 5 - 40 - 8, 14)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.bottomInfoStartStationLabel.font = [UIFont systemFontOfSize: 12.0];
        self.bottomInfoStartStationLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
        self.bottomInfoStartStationLabel.backgroundColor = [UIColor clearColor];
        self.bottomInfoStartStationLabel.textAlignment = NSTextAlignmentLeft;
        [self.bottomInfoView addSubview:self.bottomInfoStartStationLabel];
        
        self.bottomInfoEndStationLabel = [[UILabel alloc] initWithFrame: CGRectMake(8, 18, self.bottomInfoView.bounds.size.width -8 - 5 - 40 - 8, 14)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.bottomInfoEndStationLabel.font = [UIFont systemFontOfSize: 12.0];
        self.bottomInfoEndStationLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
        self.bottomInfoEndStationLabel.backgroundColor = [UIColor clearColor];
        self.bottomInfoEndStationLabel.textAlignment = NSTextAlignmentLeft;
        [self.bottomInfoView addSubview:self.bottomInfoEndStationLabel];
        
        self.bottomInfoDepartureTimeLabel = [[UILabel alloc] initWithFrame: CGRectMake(self.bottomInfoView.bounds.size.width - 40 - 8, 3, 40, 14)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.bottomInfoDepartureTimeLabel.font = [UIFont systemFontOfSize: 12.0];
        self.bottomInfoDepartureTimeLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
        self.bottomInfoDepartureTimeLabel.backgroundColor = [UIColor clearColor];
        self.bottomInfoDepartureTimeLabel.textAlignment = NSTextAlignmentLeft;
        [self.bottomInfoView addSubview:self.bottomInfoDepartureTimeLabel];
        
        self.bottomInfoArrivalTimeLabel = [[UILabel alloc] initWithFrame: CGRectMake(self.bottomInfoView.bounds.size.width - 40 - 8, 18, 40, 14)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.bottomInfoArrivalTimeLabel.font = [UIFont systemFontOfSize: 12.0];
        self.bottomInfoArrivalTimeLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
        self.bottomInfoArrivalTimeLabel.backgroundColor = [UIColor clearColor];
        self.bottomInfoArrivalTimeLabel.textAlignment = NSTextAlignmentLeft;
        [self.bottomInfoView addSubview:self.bottomInfoArrivalTimeLabel];
        
        [self.view addSubview:self.topInfoView];
        
        self.notificationView = [[GCDiscreetNotificationView alloc] initWithText:NSLocalizedString(@"Loading walking directions...", @"Loading walking directions notification view title")
                                                                    showActivity:YES
                                                              inPresentationMode:GCDiscreetNotificationViewPresentationModeBottom
                                                                          inView:self.mapView];
        
        self.notificationView.frame = CGRectMake(self.view.frame.size.width / 2 - 220 / 2, self.view.frame.size.height, 220, 15);
         
        [self.view addSubview:self.bottomInfoView];
    }
    return self;
}

- (void) setDetailedRouteDetaillevelForTrainlines:(NSUInteger)detaillevel {
    if (detaillevel <= 4) {
        self.detaillevelForTrainlinesForDetailedRoutes = detaillevel;
    }
}

- (void)showTrainlineButton {
    #ifdef LOGOUTPUTON
    NSLog(@"Show train line button");
    #endif

    if (self.trainlinebuttonvisible &&  self.connectionJourneyDetailViewTypeSelected == mapViewType) {
        self.trainlineButton.selected = NO;
        self.trainlineButton.alpha = 1.0;
    } else if (self.trainlinebuttonvisible) {
        self.trainlineButton.selected = NO;
    }
}

- (void)hideTrainlineButton {
    #ifdef LOGOUTPUTON
    NSLog(@"Hide train line button");
    #endif
    
    self.trainlinebuttonvisible = NO;
    self.trainlineButton.alpha = 0.0;
    self.trainlineButton.selected = NO;
}

- (void) switchtrainlinemode:(id)sender {
    if (!self.trainlineButton.selected) {
        [self switchToNormalTrainline:YES];
        self.trainlineButton.selected = YES;
    } else {
        [self switchToNormalTrainline:NO];
        self.trainlineButton.selected = NO;
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
    
#ifdef IncludeDetailedTrainlinesiPhone
    [[TrainLinesController sharedTrainLinesController] cancelConReqTrainlineOperations];
#endif
    
    if (self.selectedConsectionType == consectionAllType) {
        #ifdef LOGOUTPUTON
        NSLog(@"Journey detail: load map view directions. Is all connection type.");
        #endif
        
        MTDDirectionsSetActiveAPI(MTDDirectionsAPICustom);
        MTDOverrideClass([MTDDirectionsOverlayView class], [MTDJourneyOverlayView class]);
        
        [self.mapView removeDirectionsOverlay];
        
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {

            NSArray *routesArray = [[SBBAPIController sharedSBBAPIController] getMTDRoutesForConnectionResultWithIndex:self.connectionIndex];
            
            [self.mapView loadRoutes: routesArray zoomToShowDirections: YES];
            
#ifdef IncludeDetailedTrainlinesiPhone
            
            ConResult *conresult = [[SBBAPIController sharedSBBAPIController] getConnectionResultWithIndex: self.connectionIndex];
            
            if (conresult.routes && conresult.routes.count > 0) {
                [self.mapView loadRoutes: conresult.routes zoomToShowDirections: YES];
                
                self.trainlinebuttonvisible = YES;
                [self showTrainlineButton];
                
                return;
            }
        
            //[self showLoadingIndicator];
            
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
            
            [[TrainLinesController sharedTrainLinesController] sendConResTrainlineDetailsRequest:conresult detaillevel:self.detaillevelForTrainlinesForDetailedRoutes connections:nil successBlock:^(NSArray *routes){
                
                [self hideLoadingIndicator];
                if (routes && routes.count > 0) {
                    [self.mapView loadRoutes: routes zoomToShowDirections: NO];
                    
                    self.trainlinebuttonvisible = YES;
                    [self showTrainlineButton];
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
            
            [self.mapView removeDirectionsOverlay];
            
            //[self showLoadingIndicator];
            
            MTDRoute *route = [[SBBAPIController sharedSBBAPIController] getMTDRouteForConsection: conSection];
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            
                NSArray *routesArray = [NSArray arrayWithObject: route];
                
                [self.mapView loadRoutes: routesArray zoomToShowDirections: YES];
                
#ifdef IncludeDetailedTrainlinesiPhone

                if (conSection.routes && conSection.routes.count > 0) {
                    [self.mapView loadRoutes: conSection.routes zoomToShowDirections: YES];
                    
                    self.trainlinebuttonvisible = YES;
                    [self showTrainlineButton];
                    
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
                
                [[TrainLinesController sharedTrainLinesController] sendConReqTrainlineDetailsRequest:conSection detaillevel:self.detaillevelForTrainlinesForDetailedRoutes connections:nil successBlock:^(NSArray *routes){
                    
                    [self hideLoadingIndicator];
                    if (routes && routes.count > 0) {
                        [self.mapView loadRoutes: routes zoomToShowDirections: NO];
                        
                        self.trainlinebuttonvisible = YES;
                        [self showTrainlineButton];
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
            #ifdef LOGOUTPUTON
            NSLog(@"Journey detail: load map view directions. Is journey type.");
            #endif
            
            if (conSection.routes && conSection.routes.count > 0) {
                [self.mapView loadRoutes: conSection.routes zoomToShowDirections: YES];
                
                if ([CLLocationManager locationServicesEnabled] && [CLLocationManager headingAvailable]) {
                    self.locationheadingButton.alpha = 1.0;
                } else {
                    self.locationheadingButton.alpha = 0.0;
                }
                
                return;
            }
            
            
            MTDDirectionsSetActiveAPI(MTDDirectionsAPICustom);
            
            MTDOverrideClass([MTDDirectionsOverlayView class], [MTDJourneyOverlayView class]);
            
            [self stopAllMapTransactionsAndRemoveOverlayAndAnnotations];
            
#ifdef IncludeDetailedTrainlinesiPhone
            [[TrainLinesController sharedTrainLinesController] cancelConReqTrainlineOperations];
#endif
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            
                //[self showLoadingIndicator];
                //[self showLoadingIndicatorForWalkingDirections];
                
                MTDRoute *route = [[SBBAPIController sharedSBBAPIController] getMTDWalkingRouteForConsection:conSection];
                
                NSArray *routesArray = [NSArray arrayWithObject: route];
                
                [self.mapView loadRoutes: routesArray zoomToShowDirections: YES];
                
                [self showLoadingIndicatorForWalkingDirections];
                
                [[SBBAPIController sharedSBBAPIController] sendMTDDetailedWalkingDirectionsRouteForConsection:conSection successBlock:^(NSArray *routes){
                    
                    [self hideLoadingIndicator];
                    
                    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager headingAvailable]) {
                        self.locationheadingButton.alpha = 1.0;
                    } else {
                        self.locationheadingButton.alpha = 0.0;
                    }
                    
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

- (void) enterLocationHeadingMode:(id)sender {
    
    if (!self.locationheadingButton.selected) {
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
        
        self.locationheadingButton.selected = YES;
    } else {
        
        [self.mapView setUserTrackingMode:MKUserTrackingModeNone animated: NO];
        if (self.headingManager) {
            [self.headingManager stopUpdatingHeading];
            self.headingManager = nil;
        }
        [self.mapView setShowsUserLocation: NO];
        
        
        self.locationheadingButton.selected = NO;
    }
}

- (void) leaveLocationHeadingMode {
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone animated: NO];
    if (self.headingManager) {
        [self.headingManager stopUpdatingHeading];
        self.headingManager = nil;
    }
    [self.mapView setShowsUserLocation: NO];
    
    self.locationheadingButton.selected = NO;

}

- (void) switchToMapViewAsConnectionJourneyDetailView {
    #ifdef LOGOUTPUTON
    NSLog(@"Journey detail: switch to map view");
    #endif
    
    if (self.trainlinebuttonvisible) {
        self.trainlineButton.alpha = 1.0;
    }
    
    self.listTableView.alpha = 0.0;
    self.topInfoView.alpha = 1.0;
    self.connectionJourneyDetailViewTypeSelected = mapViewType;
    self.topInfoView.backgroundColor = [UIColor connectionsJourneyDetailViewTopInfoViewMapBackgroundColor];
    self.bottomInfoView.backgroundColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapBackgroundColor];
    //self.bottomInfoView.backgroundColor = [UIColor clearColor];
    self.bottomInfoStartStationLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
    self.bottomInfoEndStationLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
    self.bottomInfoDepartureTimeLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
    self.bottomInfoArrivalTimeLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
    self.topInfoViewSeparatorLineLayer.hidden = YES;
    self.bottomInfoViewSeparatorLineLayer.hidden = YES;
    [UIView animateWithDuration: 0.3 animations: ^{
        self.mapView.alpha = 1.0;
    }];
    
}
- (void) switchToListViewAsConnectionJourneyDetailView {
    #ifdef LOGOUTPUTON
    NSLog(@"Journey detail: switch to list view");
    #endif
    
    self.trainlineButton.alpha = 0.0;
        
    [self leaveLocationHeadingMode];
    
    self.mapView.alpha = 0.0;
    self.topInfoView.alpha = 0.0;
    self.connectionJourneyDetailViewTypeSelected = listViewType;
    self.topInfoView.backgroundColor = [UIColor connectionsJourneyDetailViewTopInfoViewListBackgroundColor];
    self.bottomInfoView.backgroundColor = [UIColor connectionsJourneyDetailViewBottomInfoViewListBackgroundColor];
    self.bottomInfoStartStationLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewListTextColor];
    self.bottomInfoEndStationLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewListTextColor];
    self.bottomInfoDepartureTimeLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewListTextColor];
    self.bottomInfoArrivalTimeLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewListTextColor];
    self.topInfoViewSeparatorLineLayer.hidden = NO;
    self.bottomInfoViewSeparatorLineLayer.hidden = NO;
    [self.listTableView reloadData];
    [UIView animateWithDuration: 0.3 animations: ^{
        self.listTableView.alpha = 1.0;
    }];
}

- (void) forceLeaveLocationHeadingModeIfNecessary {
    if (self.locationheadingButton.selected) {
        [self leaveLocationHeadingMode];
        self.locationheadingButton.selected = NO;
    }
}

- (void) setJourneyDetailWithConnectionAndConsectionIndex:(NSUInteger)connectionIndex consectionIndex:(NSUInteger)consecionIndex {
    
    [self hideTrainlineButton];
    
    if (consecionIndex == 9999) {
        
        self.connectionIndex = connectionIndex;
        self.consectionIndex = consecionIndex;
        self.selectedConsectionType = consectionAllType;
        
        self.locationheadingButton.alpha = 0.0;
        [self forceLeaveLocationHeadingModeIfNecessary];
        
        NSArray *basicStopList = [[SBBAPIController sharedSBBAPIController] getAllBasicStopsForConnectionResultWithIndex: connectionIndex];
        
        if ([basicStopList count] >= 2) {
            NSString *fromStationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList objectAtIndex: 0]];
            NSString *toStationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList lastObject]];
            NSString *arrivalTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForBasicStop: [basicStopList lastObject]];
            NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForBasicStop: [basicStopList objectAtIndex: 0]];
            self.bottomInfoStartStationLabel.text = fromStationName;
            self.bottomInfoEndStationLabel.text = toStationName;
            self.bottomInfoDepartureTimeLabel.text = departureTime;
            self.bottomInfoArrivalTimeLabel.text = arrivalTime;
        } else {
            self.bottomInfoStartStationLabel.text = nil;
            self.bottomInfoEndStationLabel.text = nil;
            self.bottomInfoDepartureTimeLabel.text = nil;
            self.bottomInfoArrivalTimeLabel.text = nil;
        }
        
        [self.topInfoTransportTypeImageView setImage: nil];
        [self.topInfoTransportNameImageView setImage: nil];

    } else {
        //NSLog(@"Journey detail: set connection and consection index: %d, %d", connectionIndex, consecionIndex);
        self.connectionIndex = connectionIndex;
        self.consectionIndex = consecionIndex;
        
        //ConResult *conResult = [[[[SBBAPIController sharedSBBAPIController] connectionsResult] conResults] objectAtIndex: self.connectionIndex];
        //ConSection *conSection = [[[conResult conSectionList] conSections] objectAtIndex: self.consectionIndex];
        
        ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.connectionIndex consectionIndex: self.consectionIndex];
        NSUInteger journeyTypeFlag = [conSection conSectionType];
        
        UIImage *transportTypeImage = [[SBBAPIController sharedSBBAPIController] renderTransportTypeImageForConsection: conSection];
        UIImage *transportNameImage = [[SBBAPIController sharedSBBAPIController] renderTransportNameImageForConsection: conSection];
        
        NSArray *basicStopList = [[SBBAPIController sharedSBBAPIController] getBasicStopsForConsection:conSection];
        
        if ([basicStopList count] >= 2) {
            NSString *fromStationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList objectAtIndex: 0]];
            NSString *toStationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList lastObject]];
            NSString *arrivalTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForBasicStop: [basicStopList lastObject]];
            NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForBasicStop: [basicStopList objectAtIndex: 0]];
            self.bottomInfoStartStationLabel.text = fromStationName;
            self.bottomInfoEndStationLabel.text = toStationName;
            self.bottomInfoDepartureTimeLabel.text = departureTime;
            self.bottomInfoArrivalTimeLabel.text = arrivalTime;
        } else {
            self.bottomInfoStartStationLabel.text = nil;
            self.bottomInfoEndStationLabel.text = nil;
            self.bottomInfoDepartureTimeLabel.text = nil;
            self.bottomInfoArrivalTimeLabel.text = nil;
        }
        
        [self.topInfoTransportTypeImageView setImage: transportTypeImage];
        [self.topInfoTransportNameImageView setImage: transportNameImage];
        
        if (journeyTypeFlag == walkType) {
            self.selectedConsectionType = consectionWalkType;
            
            [self forceLeaveLocationHeadingModeIfNecessary];
            
        } else if (journeyTypeFlag == journeyType) {
            
            self.locationheadingButton.alpha = 0.0;
            [self forceLeaveLocationHeadingModeIfNecessary];
            
            self.selectedConsectionType = conSectionJourneyType;
        }
        
        //NSLog(@"Set type: %@", (self.selectedConsectionType==consectionWalkType)?@"WALK":@"JOURNEY");
    }
        
    [self loadMapViewDirections];
    [self.listTableView reloadData];
    
    if (self.connectionJourneyDetailViewTypeSelected == mapViewType) {
        self.topInfoViewSeparatorLineLayer.hidden = YES;
        self.bottomInfoViewSeparatorLineLayer.hidden = YES;
        self.topInfoView.backgroundColor = [UIColor connectionsJourneyDetailViewTopInfoViewMapBackgroundColor];
        self.bottomInfoView.backgroundColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapBackgroundColor];
        self.bottomInfoStartStationLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
        self.bottomInfoEndStationLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
        self.bottomInfoDepartureTimeLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
        self.bottomInfoArrivalTimeLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
    } else if (self.connectionJourneyDetailViewTypeSelected == listViewType) {
        self.topInfoViewSeparatorLineLayer.hidden = NO;
        self.bottomInfoViewSeparatorLineLayer.hidden = NO;
        self.topInfoView.backgroundColor = [UIColor connectionsJourneyDetailViewTopInfoViewListBackgroundColor];
        self.bottomInfoView.backgroundColor = [UIColor connectionsJourneyDetailViewBottomInfoViewListBackgroundColor];
        self.bottomInfoStartStationLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewListTextColor];
        self.bottomInfoEndStationLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewListTextColor];
        self.bottomInfoDepartureTimeLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewListTextColor];
        self.bottomInfoArrivalTimeLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewListTextColor];
    }
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
        #ifdef LOGOUTPUTON
        NSLog(@"Tapped view: %@", [self.mapView viewForOverlay:tappedOverlay]);
        #endif
        
        if (self.selectedConsectionType == consectionWalkType) {
            if (self.mapView.directionsOverlay) {
                if (self.fromAnnotation && self.toAnnotation) {
                    RIButtonItem *cancelButton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Cancel", @"Open maps app cancel block action sheet title")];
                    RIButtonItem *openButton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Open in maps", @"Open maps app open block action sheet title")];
                    openButton.action = ^{
                        NSArray *mapItems = @[[self.fromAnnotation mapItem], [self.toAnnotation mapItem]];
                        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
                        [MKMapItem openMapsWithItems:mapItems launchOptions:launchOptions];
                    };
                    UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle: NSLocalizedString(@"Maps", @"Open maps app block action sheet title") cancelButtonItem: cancelButton destructiveButtonItem: nil otherButtonItems: openButton , nil];
                    [shareActionSheet showInView: self.view.superview];
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
    
    //[mapView zoomToFitDirectionsOverlay];
    
    
    if (self.connectionJourneyDetailViewTypeSelected == listViewType) {
        [self.listTableView reloadData];
    }
        
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
    
    if (self.selectedConsectionType == consectionWalkType) {
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
    
    if (self.connectionJourneyDetailViewTypeSelected == listViewType) {
        //NSLog(@"Region did change. List. Execute table list reload with delay");
        [self performSelector: @selector(switchToListViewAsConnectionJourneyDetailView) withObject: nil afterDelay: 0.3];
    } else {
        //NSLog(@"Region did change. Map. Execute table list reload with delay");
        //[self performSelector: @selector(switchToListViewAsConnectionJourneyDetailView) withObject: nil afterDelay: 0.3];
    }
    
    //CGFloat insetProportion = 0.1;
    /*
    //Inset
    MKMapRect mapRect = self.mapView.visibleMapRect;
    NSLog(@"Overlay map rect: %.6f, %.6f, %.6f, %.6f", mapRect.origin.x, mapRect.origin.y, mapRect.size.width, mapRect.size.height);

    //CGFloat inset = (CGFloat)(mapRect.size.width*insetProportion);
    //mapRect = [mapView mapRectThatFits:MKMapRectInset(mapRect, inset, inset)];
    //NSLog(@"Overlay map rect: %.6f, %.6f, %.6f, %.6f", mapRect.origin.x, mapRect.origin.y, mapRect.size.width, mapRect.size.height);
    
    //Set
    //MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    //[mapView setRegion:region animated:YES];
    */
    
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    //NSLog(@"Region will change.");
    
    if (self.connectionJourneyDetailViewTypeSelected == listViewType) {
        [self.listTableView reloadData];
    }
    
    /*
    CGFloat insetProportion = 0.1;
    
    //Inset
    MKMapRect mapRect = self.mapView.visibleMapRect;
    NSLog(@"Overlay map rect: %.6f, %.6f, %.6f, %.6f", mapRect.origin.x, mapRect.origin.y, mapRect.size.width, mapRect.size.height);
    
    CGFloat inset = (CGFloat)(mapRect.size.width*insetProportion);
    mapRect = [mapView mapRectThatFits:MKMapRectInset(mapRect, inset, inset)];
    NSLog(@"Overlay map rect: %.6f, %.6f, %.6f, %.6f", mapRect.origin.x, mapRect.origin.y, mapRect.size.width, mapRect.size.height);
     */
}

////////////////////////////////////////////////////////////////////////
#pragma mark - MKMapViewDelegate
////////////////////////////////////////////////////////////////////////

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated {
    //NSLog(@"User tracking mode is: %@", (mode == MKUserTrackingModeFollowWithHeading)?@"FollowWithHeading":((mode == MKUserTrackingModeFollow)?@"Follow":@"None"));
    
    if (mode == MKUserTrackingModeNone) {
        [self forceLeaveLocationHeadingModeIfNecessary];
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    //NSLog(@"mapView:%@ viewForAnnotation:%@", mapView, annotation);
    
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
}

/*
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MTDirectionsKitAnnotation"];
    
    if (pin == nil) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MTDirectionsKitAnnotation"];
    } else {
        pin.annotation = annotation;
    }
    
    pin.draggable = NO;
    pin.animatesDrop = YES;
    pin.canShowCallout = YES;
    
    if (annotation == self.fromAnnotation) {
        pin.pinColor = MKPinAnnotationColorRed;
    } else if (annotation == self.toAnnotation) {
        pin.pinColor = MKPinAnnotationColorGreen;
    } else {
        pin.pinColor = MKPinAnnotationColorPurple;
    }
    
    return pin;
}
*/
/*
- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState {
    
    if(newState == MKAnnotationViewDragStateEnding) {
        [self.mapView loadDirectionsFrom:[MTDWaypoint waypointWithCoordinate:self.fromAnnotation.coordinate]
                                      to:[MTDWaypoint waypointWithCoordinate:self.toAnnotation.coordinate]
                       intermediateGoals:self.intermediateGoals
                           optimizeRoute:YES
                               routeType:self.routeType
                    zoomToShowDirections:NO];
        
        
        self.fromControl.text = [NSString stringWithFormat:@"%f/%f",
                                 self.fromAnnotation.coordinate.latitude,
                                 self.fromAnnotation.coordinate.longitude];
        self.toControl.text = [NSString stringWithFormat:@"%f/%f",
                               self.toAnnotation.coordinate.latitude,
                               self.toAnnotation.coordinate.longitude];
       
    }
}
*/

- (void)routeInMaps:(id)sender {
    if (self.mapView.directionsOverlay) {
        NSArray *mapItems = @[[self.fromAnnotation mapItem], [self.toAnnotation mapItem]];
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
        [MKMapItem openMapsWithItems:mapItems launchOptions:launchOptions];
    }
}


- (void) openMapsAppForRoutingIfWalkTypeWithConnectionAndConsectionIndex:(NSUInteger)connectionIndex consectionIndex:(NSUInteger)consecionIndex {
    ConSection *conSection =  [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: connectionIndex consectionIndex: consecionIndex];
    if ([conSection conSectionType] == walkType) {
        RIButtonItem *cancelButton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Cancel", @"Open maps app cancel block action sheet title")];
        RIButtonItem *openButton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Open in maps", @"Open maps app open block action sheet title")];
        openButton.action = ^{
            MKMapItem *arrivalItem = [[SBBAPIController sharedSBBAPIController] getArrivalMapItemForConsection: conSection];
            MKMapItem *departureItem = [[SBBAPIController sharedSBBAPIController] getDepartureMapItemNameForConsection: conSection];
            if (arrivalItem && departureItem) {
                NSArray *mapItems = @[departureItem, arrivalItem];
                NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
                [MKMapItem openMapsWithItems:mapItems launchOptions:launchOptions];
            }
        };
        UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle: NSLocalizedString(@"Maps", @"Open maps app block action sheet title") cancelButtonItem: cancelButton destructiveButtonItem: nil otherButtonItems: openButton , nil];
        [shareActionSheet showInView: self.view.superview];
    }
}

/*
- (void) openMapsAppForRoutingIfWalkTypeWithCurrentySelectedJourneyDetails {
    if (self.mapView.directionsOverlay) {
        if (self.fromAnnotation && self.toAnnotation) {
            NSArray *mapItems = @[[self.fromAnnotation mapItem], [self.toAnnotation mapItem]];
            NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
            [MKMapItem openMapsWithItems:mapItems launchOptions:launchOptions];
        }
    }
}
*/

#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.selectedConsectionType == consectionAllType) {
        //NSLog(@"List view. All connection number of sections. %d", [[SBBAPIController sharedSBBAPIController] getNumberOfConsectionsForConnectionResultWithIndex: self.connectionIndex]);
        return [[SBBAPIController sharedSBBAPIController] getNumberOfConsectionsForConnectionResultWithIndex: self.connectionIndex];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"Nums of rows: %@", (self.selectedConsectionType==consectionWalkType)?@"WALK":@"JOURNEY");
    
    if (self.selectedConsectionType == consectionAllType) {
        ConSection *conSection =  [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.connectionIndex consectionIndex: section];
        NSArray *stationsList = [[SBBAPIController sharedSBBAPIController] getBasicStopsForConsection: conSection];
        //NSLog(@"List view. All connection number of rows. %d", [stationsList count]);
        return [stationsList count];
    } else {
        if (self.selectedConsectionType == consectionWalkType) {
            if (self.mapView.directionsOverlay.activeRoute != nil) {
                //NSLog(@"List view. Walk. %d", [self.mapView.directionsOverlay.activeRoute.maneuvers count]);
                return [self.mapView.directionsOverlay.activeRoute.maneuvers count];
            }
        } else if (self.selectedConsectionType == conSectionJourneyType) {
            //ConResult *conResult = [[[[SBBAPIController sharedSBBAPIController] connectionsResult] conResults] objectAtIndex: self.connectionIndex];
            //ConSection *conSection = [[[conResult conSectionList] conSections] objectAtIndex: self.consectionIndex];
            
            ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.connectionIndex consectionIndex: self.consectionIndex];
            NSArray *stationsList = [[SBBAPIController sharedSBBAPIController] getStationsForConsection: conSection];
            //NSLog(@"List view. Jounrey. %d", [stationsList count]);
            return [stationsList count];
        }

    }
    
    return 0;
}

- (NSString *) shortenStationNameIfTooLong:(NSString *)stationName maxLenth:(NSUInteger)maxLength {
    if (!stationName) return  nil; if (maxLength == 0) return  nil;
    NSString *shortenStationName;
    if ([stationName length] > maxLength) {
        shortenStationName = [stationName substringToIndex: maxLength - 3];
        return [NSString stringWithFormat:@"%@...", shortenStationName];
    }
    return stationName;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectedConsectionType == consectionAllType) {
        ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.connectionIndex consectionIndex: indexPath.section];
        NSArray *basicStopList = [[SBBAPIController sharedSBBAPIController] getBasicStopsForConsection:conSection];
        
        NSString *stationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
        NSString *arrivalTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
        NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
        NSString *platform = [[SBBAPIController sharedSBBAPIController] getPlatformForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
        
        ConnectionsJourneyDetailPasslistCell *passlistcell = (ConnectionsJourneyDetailPasslistCell *)cell;
        
        //passlistcell.stationNameLabel.text = [self shortenStationNameIfTooLong:stationName maxLenth: 22];
        passlistcell.arrivalTimeLabel.text = arrivalTime;
        passlistcell.departureTimeLabel.text = departureTime;
        //passlistcell.trackLabel.text = platform;
        
        if (platform && ([platform length] > 1)) {
            [passlistcell shortenStationNameLabelIfTrackInfo];
            passlistcell.stationNameLabel.text = [self shortenStationNameIfTooLong: stationName maxLenth: 22];
        } else {
            [passlistcell prolongStationNameLabelIfNoTrackInfo];
            passlistcell.stationNameLabel.text = [self shortenStationNameIfTooLong: stationName maxLenth: 25];
        }
        
        passlistcell.trackLabel.text = platform;
        
        //NSString *arrTime4 = [arrivalTime substringToIndex: 1];
        //NSString *depTime4 = [departureTime substringToIndex: 1];
        //NSLog(@"arr, dep 4: %@, %@", arrTime4, depTime4);
        
        if ((indexPath.row == 0) && !(indexPath.row == ([basicStopList count] - 1))) {
            passlistcell.oneTimeLabel.text = departureTime;
            passlistcell.arrivalTimeLabel.text = nil;
            passlistcell.departureTimeLabel.text = nil;
        } else if (!(indexPath.row == 0) && indexPath.row == ([basicStopList count] - 1)) {
            passlistcell.oneTimeLabel.text = arrivalTime;
            passlistcell.arrivalTimeLabel.text = nil;
            passlistcell.departureTimeLabel.text = nil;
        } else {
            if (!arrivalTime && departureTime) {
                passlistcell.oneTimeLabel.text = departureTime;
                passlistcell.arrivalTimeLabel.text = nil;
                passlistcell.departureTimeLabel.text = nil;
            } else if (arrivalTime && !departureTime) {
                passlistcell.oneTimeLabel.text = arrivalTime;
                passlistcell.arrivalTimeLabel.text = nil;
                passlistcell.departureTimeLabel.text = nil;
            } else if (!arrivalTime && !departureTime) {
                passlistcell.oneTimeLabel.text = nil;
                passlistcell.arrivalTimeLabel.text = nil;
                passlistcell.departureTimeLabel.text = nil;
            } else if (arrivalTime && departureTime) {
                if ([arrivalTime isEqualToString:departureTime]) {
                    passlistcell.oneTimeLabel.text = departureTime;
                    passlistcell.arrivalTimeLabel.text = nil;
                    passlistcell.departureTimeLabel.text = nil;
                } else {
                    passlistcell.oneTimeLabel.text = nil;
                    passlistcell.arrivalTimeLabel.text = arrivalTime;
                    passlistcell.departureTimeLabel.text = departureTime;
                }
            }
        }
        
        BOOL topLine = NO; BOOL bottomLine = NO;
        
        if ((indexPath.row == 0) && !(indexPath.row == ([basicStopList count] - 1))) {
            topLine = NO; bottomLine = YES;
        } else if (!(indexPath.row == 0) && indexPath.row == ([basicStopList count] - 1)) {
            topLine = YES; bottomLine = NO;
        } else if ((indexPath.row == 0) && (indexPath.row == ([basicStopList count] - 1))) {
            topLine = NO; bottomLine = NO;
        } else {
            topLine = YES; bottomLine = YES;
        }
        
        UIImage *passlistImage = [[SBBAPIController sharedSBBAPIController] renderPasslistImageWithSize:CGSizeMake(30, 50)  topLine: topLine bottomLine: bottomLine];
        [passlistcell.passlistImage setImage: passlistImage];

    } else {
        if (self.selectedConsectionType == consectionWalkType) {
            if ([cell isKindOfClass: [ConnectionsJourneyDetailDirectionsCell class]]) {
                if (self.mapView.directionsOverlay.activeRoute != nil) {
                    ConnectionsJourneyDetailDirectionsCell *directionscell = (ConnectionsJourneyDetailDirectionsCell *)cell;
                    MTDManeuver *maneuver = [self.mapView.directionsOverlay.activeRoute.maneuvers objectAtIndex:indexPath.row];
                    directionscell.maneuver = maneuver;
                }
            }
        } else if (self.selectedConsectionType == conSectionJourneyType) {
            //ConResult *conResult = [[[[SBBAPIController sharedSBBAPIController] connectionsResult] conResults] objectAtIndex: self.connectionIndex];
            //ConSection *conSection = [[[conResult conSectionList] conSections] objectAtIndex: self.consectionIndex];
            
            ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.connectionIndex consectionIndex: self.consectionIndex];
            NSArray *basicStopList = [[SBBAPIController sharedSBBAPIController] getBasicStopsForConsection:conSection];
            
            NSString *stationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
            NSString *arrivalTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
            NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
            NSString *platform = [[SBBAPIController sharedSBBAPIController] getPlatformForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
            
            ConnectionsJourneyDetailPasslistCell *passlistcell = (ConnectionsJourneyDetailPasslistCell *)cell;
            
            passlistcell.stationNameLabel.text = [self shortenStationNameIfTooLong:stationName maxLenth: 25];
            passlistcell.arrivalTimeLabel.text = arrivalTime;
            passlistcell.departureTimeLabel.text = departureTime;
            passlistcell.trackLabel.text = platform;
            
            //NSString *arrTime4 = [arrivalTime substringToIndex: 1];
            //NSString *depTime4 = [departureTime substringToIndex: 1];
            //NSLog(@"arr, dep 4: %@, %@", arrTime4, depTime4);
            
            if ((indexPath.row == 0) && !(indexPath.row == ([basicStopList count] - 1))) {
                passlistcell.oneTimeLabel.text = departureTime;
                passlistcell.arrivalTimeLabel.text = nil;
                passlistcell.departureTimeLabel.text = nil;
            } else if (!(indexPath.row == 0) && indexPath.row == ([basicStopList count] - 1)) {
                passlistcell.oneTimeLabel.text = arrivalTime;
                passlistcell.arrivalTimeLabel.text = nil;
                passlistcell.departureTimeLabel.text = nil;
            } else {
                if (!arrivalTime && departureTime) {
                    passlistcell.oneTimeLabel.text = departureTime;
                    passlistcell.arrivalTimeLabel.text = nil;
                    passlistcell.departureTimeLabel.text = nil;
                } else if (arrivalTime && !departureTime) {
                    passlistcell.oneTimeLabel.text = arrivalTime;
                    passlistcell.arrivalTimeLabel.text = nil;
                    passlistcell.departureTimeLabel.text = nil;
                } else if (!arrivalTime && !departureTime) {
                    passlistcell.oneTimeLabel.text = nil;
                    passlistcell.arrivalTimeLabel.text = nil;
                    passlistcell.departureTimeLabel.text = nil;
                } else if (arrivalTime && departureTime) {
                    if ([arrivalTime isEqualToString:departureTime]) {
                        passlistcell.oneTimeLabel.text = departureTime;
                        passlistcell.arrivalTimeLabel.text = nil;
                        passlistcell.departureTimeLabel.text = nil;
                    } else {
                        passlistcell.oneTimeLabel.text = nil;
                        passlistcell.arrivalTimeLabel.text = arrivalTime;
                        passlistcell.departureTimeLabel.text = departureTime;
                    }
                }
            }
            
            BOOL topLine = NO; BOOL bottomLine = NO;
            
            if ((indexPath.row == 0) && !(indexPath.row == ([basicStopList count] - 1))) {
                topLine = NO; bottomLine = YES;
            } else if (!(indexPath.row == 0) && indexPath.row == ([basicStopList count] - 1)) {
                topLine = YES; bottomLine = NO;
            } else if ((indexPath.row == 0) && (indexPath.row == ([basicStopList count] - 1))) {
                topLine = NO; bottomLine = NO;
            } else {
                topLine = YES; bottomLine = YES;
            }
            
            UIImage *passlistImage = [[SBBAPIController sharedSBBAPIController] renderPasslistImageWithSize:CGSizeMake(30, 50)  topLine: topLine bottomLine: bottomLine];
            [passlistcell.passlistImage setImage: passlistImage];
        }

    }    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedConsectionType == consectionWalkType) {
        if (self.mapView.directionsOverlay.activeRoute != nil) {
            MTDManeuver *maneuver = [self.mapView.directionsOverlay.activeRoute.maneuvers objectAtIndex:indexPath.row];
            return [ConnectionsJourneyDetailDirectionsCell neededHeightForManeuver:maneuver constrainedToWidth:tableView.bounds.size.width];
        }
    }
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (self.selectedConsectionType == consectionAllType) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ConnectionsJourneyDetailPasslistCell"];
    } else if (self.selectedConsectionType == consectionWalkType) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ConnectionsJourneyDetailDirectionsCell"];
    } else if (self.selectedConsectionType == conSectionJourneyType) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ConnectionsJourneyDetailPasslistCell"];
    }
    [self configureCell: cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CONJRNTOPINFOBARHEIGHT;
}


-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //NSLog(@"View for header in section: %d", section);
    
    float padding = -25;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320 - 80 - padding, CONJRNTOPINFOBARHEIGHT)];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    headerView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.6f];
    headerView.userInteractionEnabled = NO;
    
    UIImageView *topInfoTransportTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 30, 30)];
    topInfoTransportTypeImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    topInfoTransportTypeImageView.backgroundColor = [UIColor clearColor];
    topInfoTransportTypeImageView.contentMode = UIViewContentModeScaleAspectFill;
    [headerView addSubview:topInfoTransportTypeImageView];
    
    UIImageView *topInfoTransportNameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(320 - 80 - padding - 80 - 8, 13, 80, 20)];
    topInfoTransportNameImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    topInfoTransportNameImageView.backgroundColor = [UIColor clearColor];
    topInfoTransportNameImageView.contentMode = UIViewContentModeScaleAspectFill;
    [headerView addSubview:topInfoTransportNameImageView];
    
    ConSection *conSection;
    
    if (self.selectedConsectionType == consectionAllType) {
        conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.connectionIndex consectionIndex: section];
    } else {
        conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.connectionIndex consectionIndex: self.consectionIndex];
    }
        
    UIImage *transportTypeImage = [[SBBAPIController sharedSBBAPIController] renderTransportTypeImageForConsection: conSection];
    UIImage *transportNameImage = [[SBBAPIController sharedSBBAPIController] renderTransportNameImageForConsection: conSection];
    
    [topInfoTransportTypeImageView setImage: transportTypeImage];
    [topInfoTransportNameImageView setImage: transportNameImage];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
}

// override to support editing the table view
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return  NO;
}

- (void) stopAllMapTransactionsAndRemoveOverlayAndAnnotations {
    [MBProgressHUD hideAllHUDsForView: self.view animated: NO];
    [self.mapView cancelLoadOfDirections];
    [self.mapView removeAnnotations: self.mapView.annotations];
    [self.mapView removeDirectionsOverlay];
}

- (void) stopAllMapTransactions {
    [MBProgressHUD hideAllHUDsForView: self.view animated: NO];
    [self.mapView cancelLoadOfDirections];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)hideLoadingIndicator {
    
    //[MBProgressHUD hideAllHUDsForView: self.view animated: NO];
    /*
    [self.activityView removeFromSuperview];
    self.activityView = nil;
    */
    
    [UIView animateWithDuration: 0.3 animations: ^{
        CGRect viewframe = self.notificationView.frame;
        viewframe.origin.y = self.view.frame.size.height;
        self.notificationView.frame = viewframe;
        
    }];
    
    [self.notificationView.activityIndicator stopAnimating];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)showLoadingIndicatorForTrainlines {
    
    //NSLog(@"View height: %.1f", self.view.frame.size.height);
    
    [self.notificationView setTextLabel: NSLocalizedString(@"Loading trainline ...", @"Loading trainline notification view title")];
    [self.notificationView setUserInteractionEnabled: NO];
    self.notificationView.frame = CGRectMake(self.view.frame.size.width / 2 - 220 / 2, self.view.frame.size.height, 220, 15);
    
    CGFloat viewadjustment = 0;
        
    [self.notificationView.activityIndicator startAnimating];
    [UIView animateWithDuration: 0.3 animations: ^{
        CGRect viewframe = self.notificationView.frame;
        viewframe.origin.y = self.view.frame.size.height - CONJRNBOTTOMINFOBARHEIGHT - 22 - viewadjustment;
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
    
    self.notificationView.frame = CGRectMake(self.view.frame.size.width / 2 - 220 / 2, self.view.frame.size.height, 220, 15);
    
    CGFloat viewadjustment = 0;
        
    [self.notificationView.activityIndicator startAnimating];
    [UIView animateWithDuration: 0.3 animations: ^{
        CGRect viewframe = self.notificationView.frame;
        viewframe.origin.y = self.view.frame.size.height - CONJRNBOTTOMINFOBARHEIGHT - 22 - viewadjustment;
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

/*
- (void)showLoadingIndicator {
    [self hideLoadingIndicator];
    
    [MBProgressHUD hideAllHUDsForView: self.view animated: NO];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
*/

- (void) adjustForViewWillAppear {
#ifdef AdsCodeIsOn
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveBannerBeforeSlideIn) name:@"BannerWillSlideIn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveBannerBeforeSlideOut) name:@"BannerWillSlideOut" object:nil];
    
    //CGRectMake(0, 0, 320 - 80 - padding, self.view.frame.size.height - TOOLBARHEIGHT) map
    //CGRectMake(0, 0, 320 - 80 - padding, self.view.frame.size.height - CONJRNBOTTOMINFOBARHEIGHT)  list
    //CGRectMake(320 - 80 - padding - BUTTONHEIGHT - 8, self.view.frame.size.height - CONJRNBOTTOMINFOBARHEIGHT - BUTTONHEIGHT - 5, BUTTONHEIGHT, BUTTONHEIGHT) button
    //CGRectMake(0, self.view.bounds.size.height - CONJRNBOTTOMINFOBARHEIGHT, self.view.bounds.size.width, CONJRNBOTTOMINFOBARHEIGHT) bottom
    
    CGFloat targetHeight = self.view.frame.size.height;
    
    //NSLog(@"Con map view: %.1f, %.1f, %.1f, %.1f", size.height, self.view.frame.size.height, self.mapView.frame.size.height, targetHeight);
    
    if (![[DTShop sharedShop] isProductInstalledWithSKU: AppStoreInAppFreeIPHONE]) {
        if ([DTBannerManager sharedManager].isBannerVisible) {
            
            #ifdef LOGOUTPUTON
            NSLog(@"Banner is visible: %@", self.nibName);
            #endif
            
            if (self.mapView.frame.size.height == targetHeight - TOOLBARHEIGHT) {
                CGRect mapviewframe = self.mapView.frame;
                CGRect listviewframe = self.listTableView.frame;
                CGRect bottominfoviewframe = self.bottomInfoView.frame;
                CGRect trainbuttonframe = self.trainlineButton.frame;
                CGRect trainstorebuttonframe = self.trainlineButtonStore.frame;
                mapviewframe.size.height = targetHeight - TOOLBARHEIGHT - AdSizeHeightiPhone;
                listviewframe.size.height = targetHeight - CONJRNBOTTOMINFOBARHEIGHT - AdSizeHeightiPhone;
                bottominfoviewframe.origin.y = targetHeight - CONJRNBOTTOMINFOBARHEIGHT - AdSizeHeightiPhone;
                trainbuttonframe.origin.y = targetHeight - CONJRNBOTTOMINFOBARHEIGHT - BUTTONHEIGHT - 5 - AdSizeHeightiPhone;
                trainstorebuttonframe.origin.y = targetHeight - CONJRNBOTTOMINFOBARHEIGHT - BUTTONHEIGHT - 5 - AdSizeHeightiPhone;
                self.mapView.frame = mapviewframe;
                self.listTableView.frame = listviewframe;
                self.bottomInfoView.frame = bottominfoviewframe;
                self.trainlineButton.frame = trainbuttonframe;
                self.trainlineButtonStore.frame = trainstorebuttonframe;
                CGRect bottomLayerframe = self.bottomInfoViewSeparatorLineLayer.frame;
                bottomLayerframe.origin.y = bottominfoviewframe.origin.y;
                self.bottomInfoViewSeparatorLineLayer.frame = bottomLayerframe;
            }
        } else {
            
            #ifdef LOGOUTPUTON
            NSLog(@"Banner is NOT visible: %@", self.nibName);
            #endif
            
            if (self.mapView.frame.size.height != targetHeight - TOOLBARHEIGHT) {
                CGRect mapviewframe = self.mapView.frame;
                CGRect listviewframe = self.listTableView.frame;
                CGRect bottominfoviewframe = self.bottomInfoView.frame;
                CGRect trainbuttonframe = self.trainlineButton.frame;
                CGRect trainstorebuttonframe = self.trainlineButtonStore.frame;
                mapviewframe.size.height = targetHeight - TOOLBARHEIGHT;
                listviewframe.size.height = targetHeight - CONJRNBOTTOMINFOBARHEIGHT;
                bottominfoviewframe.origin.y = targetHeight - CONJRNBOTTOMINFOBARHEIGHT;
                trainbuttonframe.origin.y = targetHeight - CONJRNBOTTOMINFOBARHEIGHT - BUTTONHEIGHT - 5;
                trainstorebuttonframe.origin.y = targetHeight - CONJRNBOTTOMINFOBARHEIGHT - BUTTONHEIGHT - 5;
                self.mapView.frame = mapviewframe;
                self.listTableView.frame = listviewframe;
                self.bottomInfoView.frame = bottominfoviewframe;
                self.trainlineButton.frame = trainbuttonframe;
                self.trainlineButtonStore.frame = trainstorebuttonframe;
                CGRect bottomLayerframe = self.bottomInfoViewSeparatorLineLayer.frame;
                bottomLayerframe.origin.y = bottominfoviewframe.origin.y;
                self.bottomInfoViewSeparatorLineLayer.frame = bottomLayerframe;
            }
        }
    } else {
        if (self.mapView.frame.size.height != targetHeight - TOOLBARHEIGHT) {
            CGRect mapviewframe = self.mapView.frame;
            CGRect listviewframe = self.listTableView.frame;
            CGRect bottominfoviewframe = self.bottomInfoView.frame;
            CGRect trainbuttonframe = self.trainlineButton.frame;
            CGRect trainstorebuttonframe = self.trainlineButtonStore.frame;
            mapviewframe.size.height = targetHeight - TOOLBARHEIGHT;
            listviewframe.size.height = targetHeight - CONJRNBOTTOMINFOBARHEIGHT;
            bottominfoviewframe.origin.y = targetHeight - CONJRNBOTTOMINFOBARHEIGHT;
            trainbuttonframe.origin.y = targetHeight - CONJRNBOTTOMINFOBARHEIGHT - BUTTONHEIGHT - 5;
            trainstorebuttonframe.origin.y = targetHeight - CONJRNBOTTOMINFOBARHEIGHT - BUTTONHEIGHT - 5;
            self.mapView.frame = mapviewframe;
            self.listTableView.frame = listviewframe;
            self.bottomInfoView.frame = bottominfoviewframe;
            self.trainlineButton.frame = trainbuttonframe;
            self.trainlineButtonStore.frame = trainstorebuttonframe;
            CGRect bottomLayerframe = self.bottomInfoViewSeparatorLineLayer.frame;
            bottomLayerframe.origin.y = bottominfoviewframe.origin.y;
            self.bottomInfoViewSeparatorLineLayer.frame = bottomLayerframe;
        }
    }
#endif
   
}

- (void) adjustForViewWillDisappear {
    
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    self.mapView.delegate = self;
    
    #ifdef AdsCodeIsOn
    [self adjustForViewWillAppear];
    #endif
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    self.mapView.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
