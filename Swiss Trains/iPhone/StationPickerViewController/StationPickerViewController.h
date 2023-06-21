//
//  StationPickerViewController.h
//  Swiss Trains
//
//  Created by Alain on 13.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import <dispatch/dispatch.h>

#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"

#import "StationsViewToolbar.h"

#import "StationsCell.h"
#import "Station.h"

#import "SVSegmentedControl.h"

#import "Config.h"

#import "Stations.h"
#import "ClosestStationsCell.h"

#import "BKLocationManager.h"

#import "WBInfoNoticeView.h"
#import "WBErrorNoticeView.h"
#import "NoticeviewMessages.h"

#import "StationPickerStationAnnotationView.h"

#import "FavoritesDataController.h"

#import "NSManagedObjectContext+Blocks.h"

#import "SBBAPIController.h"
#import "Reachability.h"

enum stationTypeIndexes {
    startStationType = 1,
    endStationType = 2,
    viaStationType = 3
};

@class StationPickerViewController;

@protocol StationPickerViewControllerDelegate <NSObject>
- (void)didSelectStationWithStationTypeIndex:(StationPickerViewController *)controller stationTypeIndex:(NSUInteger)index station:(Station *)station;
@end

@interface StationPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UITextFieldDelegate, MKMapViewDelegate>

@property (strong, nonatomic) UIView *searchContainerView;
@property (strong, nonatomic) UIView *mapContainerView;
@property (strong, nonatomic) UIView *listContainerView;

@property (strong, nonatomic) CLGeocoder *geocoder;

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UITableView *stationsTableView;
@property (strong, nonatomic) UITableView *nextStationsTableView;

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

@property (strong, nonatomic) StationsViewToolbar *stationsViewToolbar;

@property (strong, nonatomic) UITextField *stationTextField;

@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) NSString *stationName;
@property (strong, nonatomic) NSString *stationID;
@property (strong, nonatomic) NSNumber *stationlat;
@property (strong, nonatomic) NSNumber *stationlng;

@property (strong, nonatomic) CAShapeLayer *separatorLineLayer;

@property (strong, nonatomic) SVSegmentedControl *navSC;

@property (assign) NSUInteger stationTypeIndex;
@property (assign) NSUInteger stationpickerType;

@property (strong, nonatomic) NSArray *stationsToCurrentLocation;
@property (strong, nonatomic) NSArray *sortedStationsToCurrentLocation;
@property (strong, nonatomic) CLLocation *userLocation;
@property (strong, nonatomic) NSDate *userLocationDate;

@property (strong, nonatomic) BKLocationManager *locationManager;

@property (weak) id <StationPickerViewControllerDelegate> delegate;

- (void) clearStationSetting;

- (void) switchToSearchView;
- (void) switchToMapView;
- (void) switchToListView;

-(void) forcePushBackToPreviousViewController;

@property (strong, nonatomic) dispatch_queue_t fetchrequestresultsortingqueue;

@end
