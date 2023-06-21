//
//  SearchStationPickerControlleriPad.h
//  Swiss Trains
//
//  Created by Alain on 06.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <MapKit/MapKit.h>

#import <dispatch/dispatch.h>

#import "UIApplication+AppDimension.h"

#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"

#import "Stations.h"
#import "ClosestStationsCell.h"
#import "BKLocationManager.h"
#import "StationsCell.h"
#import "Station.h"
#import "StationPickerStationAnnotationView.h"
#import "FavoritesDataController.h"
#import "StatusToolbariPad.h"
#import "SplitSeparatorView.h"

#import "Config.h"
#import "NoticeviewMessages.h"

#import "NSManagedObjectContext+Blocks.h"

#import "SBBAPIController.h"
#import "Reachability.h"

@class SearchStationPickerControlleriPad;

@protocol SearchStationPickerControllerDelegateiPad <NSObject>
- (void)didSelectStationWithStationTypeIndex:(SearchStationPickerControlleriPad *)controller stationTypeIndex:(NSUInteger)index station:(Station *)station;
- (void)didPressPushBackViewController:(SearchStationPickerControlleriPad *)controller;
- (void)showLocationOutsideSwitzerlandMessage;
- (void)showLocationManagerDeniedMessage;
- (void)showLocationManagerErrorMessage;
- (void)showNoNetworkErrorMessage;
- (void)showGeocodingErrorMessage;
@end

@interface SearchStationPickerControlleriPad : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UIView *searchContainerView;
@property (strong, nonatomic) UIView *listContainerView;

@property (strong, nonatomic) SplitSeparatorView *divider;

@property (strong, nonatomic) UITableView *stationsTableView;
@property (strong, nonatomic) UITableView *nextStationsTableView;

@property (strong, nonatomic) CLGeocoder *geocoder;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) NSArray *validationResults;
@property (strong, nonatomic) NSTimer *validationtimer;
@property (assign) BOOL validationrequestalreadyexecuted;
@property (strong, nonatomic) UIActivityIndicatorView *searchactivityindicator;
@property (assign) NSUInteger lastfavoritesearchresultcount;
@property (assign) NSUInteger laststationsearchresultcount;
@property (assign) BOOL lastfavoritesearchresultchanged;
@property (assign) BOOL laststationsearchresultchanged;

@property (strong, nonatomic) NSDate *dateoflastkeyboardtick;

@property (strong, nonatomic) NSArray *filteredSearchResults;

@property (strong, nonatomic) UITextField *stationTextField;

//@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) NSString *stationName;
@property (strong, nonatomic) NSString *stationID;
@property (strong, nonatomic) NSNumber *stationlat;
@property (strong, nonatomic) NSNumber *stationlng;

@property (strong, nonatomic) CAShapeLayer *separatorLineLayer;

@property (assign) NSUInteger stationTypeIndex;
@property (assign) NSUInteger stationpickerType;

@property (strong, nonatomic) NSArray *stationsToCurrentLocation;
@property (strong, nonatomic) NSArray *sortedStationsToCurrentLocation;
@property (strong, nonatomic) CLLocation *userLocation;
@property (strong, nonatomic) NSDate *userLocationDate;

@property (strong, nonatomic) BKLocationManager *locationManager;

@property (weak) id <SearchStationPickerControllerDelegateiPad> delegate;

@property (strong, nonatomic) dispatch_queue_t fetchrequestresultsortingqueue;

- (void) clearStationSetting;

-(void) forcePushBackToPreviousViewController;

-(void) updateStationPickerWithData;

@end
