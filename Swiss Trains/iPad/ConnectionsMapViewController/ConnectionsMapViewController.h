//
//  ConnectionsMapViewController.h
//
//
//  Created by Alain on 02.01.13.
//  Copyright (c) 2013 Furter
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

#import <MTDirectionsKit/MTDirectionsKit.h>

#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"

#import "UIApplication+AppDimension.h"

#import "StationAnnotation.h"
#import "StationsAnnotationView.h"

#import "MTDJourneyParser.h"
#import "MTDJourneyRequest.h"
#import "MTDJourneyOverlayView.h"

#import "SBBAPIController.h"

#ifdef IncludeDetailedTrainlinesiPad
#import "TrainLinesController.h"
#endif

#import "UIActionSheet+Blocks.h"

#import "MBProgressHUD.h"
#import "GCDiscreetNotificationViewiPad.h"

#import "Stations.h"
#import "BKLocationManager.h"
#import "StationPickerStationAnnotationView.h"
#import "StationPickerStationCalloutAnnotationView.h"
//#import "StationPickerAnnotation.h"
//#import "SMCalloutView.h"

#import "NoticeviewMessages.h"

#import "MKMapView+ZoomLevel.h"

#import "Config.h"

@class ConnectionsMapViewController;
@class GCDiscreetNotificationView;

@protocol ConnectionsMapViewControlleriPadDelegate <NSObject>
- (void)didTriggerMapViewJourneyWithLongPress:(ConnectionsMapViewController *)controller startitem:(MKMapItem *)startitem enditem:(MKMapItem *)enditem viewrect:(CGRect)viewrect;
- (void)didSelectStationPickerAnnotaton:(ConnectionsMapViewController *)controller station:(Station *)station viewrect:(CGRect)viewrect;
- (void)showLocationOutsideSwitzerlandMessage;
- (void)showLocationManagerDeniedMessage;
- (void)showLocationManagerErrorMessage;
- (void)headingManagerDidLeaveAllTrackingModes;
- (void)showTrainlineButton;
- (void)hideTrainlineButton;
@end

@interface ConnectionsMapViewController : UIViewController <MTDDirectionsDelegate, MKMapViewDelegate, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) MTDMapView *mapView;

@property (strong, nonatomic) UILongPressGestureRecognizer *mapLongPressGestureRecognizer;

@property (strong, nonatomic) UIView *activityView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) BKLocationManager *locationManager;
@property (strong, nonatomic) CLLocationManager *headingManager;
@property (strong, nonatomic) NSArray *stationsToCurrentLocation;
@property (strong, nonatomic) NSArray *sortedStationsToCurrentLocation;
@property (strong, nonatomic) CLLocation *userLocation;
@property (strong, nonatomic) NSDate *userLocationDate;
 
@property (assign) NSUInteger connectionJourneyDetailViewTypeSelected;

@property (assign) NSUInteger connectionIndex;
@property (assign) NSUInteger consectionIndex;
@property (assign) NSUInteger selectedConsectionType;

@property (nonatomic, strong) StationAnnotation *fromAnnotation;
@property (nonatomic, strong) StationAnnotation *toAnnotation;

@property (weak) id <ConnectionsMapViewControlleriPadDelegate> delegate;

@property (strong, nonatomic) GCDiscreetNotificationViewiPad *notificationView;

- (void) setJourneyDetailWithConnectionAndConsectionIndex:(NSUInteger)connectionIndex consectionIndex:(NSUInteger)consecionIndex;

- (void) stopAllMapTransactionsAndRemoveOverlayAndAnnotations;
- (void) stopAllMapTransactions;

- (void) getStationsAndUpdateMapView;

- (void) enterLocationHeadingMode;
- (void) leaveLocationHeadingMode;

- (void) switchToNormalTrainline:(BOOL)normalline;

@property (assign) NSUInteger detaillevelForTrainlinesForDetailedRoutes;

- (void) setDetailedRouteDetaillevelForTrainlines:(NSUInteger)detaillevel;

//- (void) openMapsAppForRoutingIfWalkTypeWithConnectionAndConsectionIndex:(NSUInteger)connectionIndex consectionIndex:(NSUInteger)consecionIndex;

@end
