//
//  ConnectionsJourneyDetailViewController.h
//  Swiss Trains
//
//  Created by Alain on 12.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

#import <MTDirectionsKit/MTDirectionsKit.h>

#import "MTDJourneyParser.h"
#import "MTDJourneyRequest.h"
#import "MTDJourneyOverlayView.h"

//#import "MTDMapView+ZoomToFit.h"

#import "StationAnnotation.h"
#import "StationsAnnotationView.h"

#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"

#import "ConnectionsJourneyDetailDirectionsCell.h"
#import "ConnectionsJourneyDetailPasslistCell.h"

#import "SBBAPIController.h"

#ifdef IncludeDetailedTrainlinesiPhone
#import "TrainLinesController.h"
#endif

#import "MBProgressHUD.h"

#import "Config.h"

#import "UIApplication+AppDimension.h"

#import "UIActionSheet+Blocks.h"

#import "GCDiscreetNotificationView.h"

enum connectionJourneyDetailViewType {
    mapViewType = 1,
    listViewType = 2
};

enum connectionJourneyConsectionType {
    consectionWalkType = 1,
    conSectionJourneyType = 2,
    consectionAllType = 3
};

@interface ConnectionsJourneyDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MTDDirectionsDelegate, MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) MTDMapView *mapView;
@property (strong, nonatomic) UITableView *listTableView;
@property (strong, nonatomic) UILongPressGestureRecognizer *mapLongPressGestureRecognizer;

@property (strong, nonatomic) UIView *activityView;

@property (strong, nonatomic) CLLocationManager *headingManager;

@property (strong, nonatomic) UIView *topInfoView;
@property (strong, nonatomic) CAShapeLayer *topInfoViewSeparatorLineLayer;
@property (strong, nonatomic) UIImageView *topInfoTransportTypeImageView;
@property (strong, nonatomic) UIImageView *topInfoTransportNameImageView;

@property (strong, nonatomic) UIView *bottomInfoView;
@property (strong, nonatomic) CAShapeLayer *bottomInfoViewSeparatorLineLayer;
@property (strong, nonatomic) UILabel *bottomInfoStartStationLabel;
@property (strong, nonatomic) UILabel *bottomInfoEndStationLabel;
@property (strong, nonatomic) UILabel *bottomInfoDepartureTimeLabel;
@property (strong, nonatomic) UILabel *bottomInfoArrivalTimeLabel;

@property (strong, nonatomic) UIButton *locationheadingButton;

@property (strong, nonatomic) UIButton *trainlineButton;

@property (assign) NSUInteger connectionJourneyDetailViewTypeSelected;

@property (assign) NSUInteger connectionIndex;
@property (assign) NSUInteger consectionIndex;
@property (assign) NSUInteger selectedConsectionType;

//@property (nonatomic, strong) MKPointAnnotation *fromAnnotation;
//@property (nonatomic, strong) MKPointAnnotation *toAnnotation;
@property (nonatomic, strong) StationAnnotation *fromAnnotation;
@property (nonatomic, strong) StationAnnotation *toAnnotation;

@property (strong, nonatomic) GCDiscreetNotificationView *notificationView;

@property (assign) BOOL trainlinebuttonvisible;

- (void) switchToMapViewAsConnectionJourneyDetailView;
- (void) switchToListViewAsConnectionJourneyDetailView;

- (void) setJourneyDetailWithConnectionAndConsectionIndex:(NSUInteger)connectionIndex consectionIndex:(NSUInteger)consecionIndex;

- (void) stopAllMapTransactionsAndRemoveOverlayAndAnnotations;
- (void) stopAllMapTransactions;

- (void) openMapsAppForRoutingIfWalkTypeWithConnectionAndConsectionIndex:(NSUInteger)connectionIndex consectionIndex:(NSUInteger)consecionIndex;
//- (void) openMapsAppForRoutingIfWalkTypeWithCurrentySelectedJourneyDetails;

- (void) leaveLocationHeadingMode;

- (void) adjustForViewWillAppear;
- (void) adjustForViewWillDisappear;

@property (assign) NSUInteger detaillevelForTrainlinesForDetailedRoutes;

- (void) setDetailedRouteDetaillevelForTrainlines:(NSUInteger)detaillevel;

@end
