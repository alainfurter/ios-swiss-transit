//
//  StationboardMapViewController.h
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

#import "Config.h"

@class StationboardMapViewController;

@protocol StationboardMapViewControlleriPadDelegate <NSObject>
- (void)didSelectStationPickerAnnotaton:(StationboardMapViewController *)controller station:(Station *)station viewrect:(CGRect)viewrect;
- (void)showLocationOutsideSwitzerlandMessage;
- (void)showLocationManagerDeniedMessage;
- (void)showLocationManagerErrorMessage;
- (void)showTrainlineButton;
- (void)hideTrainlineButton;
@end

@interface StationboardMapViewController : UIViewController <MTDDirectionsDelegate, MKMapViewDelegate>

@property (strong, nonatomic) MTDMapView *mapView;
 
@property (assign) NSUInteger connectionJourneyDetailViewTypeSelected;

@property (assign) NSUInteger stbSelectedJourneyIndex;
@property (assign) NSUInteger stbSelectedJourneyProducttype;

//@property (assign) NSUInteger connectionIndex;
//@property (assign) NSUInteger consectionIndex;
//@property (assign) NSUInteger selectedConsectionType;

@property (nonatomic, strong) StationAnnotation *fromAnnotation;
@property (nonatomic, strong) StationAnnotation *toAnnotation;

@property (strong, nonatomic) GCDiscreetNotificationViewiPad *notificationView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) BKLocationManager *locationManager;
@property (strong, nonatomic) NSArray *stationsToCurrentLocation;
@property (strong, nonatomic) NSArray *sortedStationsToCurrentLocation;
@property (strong, nonatomic) CLLocation *userLocation;
@property (strong, nonatomic) NSDate *userLocationDate;

@property (weak) id <StationboardMapViewControlleriPadDelegate> delegate;

//@property (assign) NSUInteger selectedStationboardJourney;
//- (void) updateJourneyTableViewWithStationboardIndex:(NSUInteger)index;
- (void) updateJourneyMapViewController;

- (void) stopAllMapTransactionsAndRemoveOverlayAndAnnotations;
- (void) stopAllMapTransactions;

- (void)showLoadingIndicator;
- (void)hideLoadingIndicator;

- (void) getStationsAndUpdateMapView;

- (void) switchToNormalTrainline:(BOOL)normalline;

@property (assign) NSUInteger detaillevelForTrainlinesForDetailedRoutes;

- (void) setDetailedRouteDetaillevelForTrainlines:(NSUInteger)detaillevel;

@end
