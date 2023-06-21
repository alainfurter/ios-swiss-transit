//
//  StationPickerViewControlleriPad.h
//  Swiss Trains
//
//  Created by Alain on 02.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

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
#import "NoticeviewMessages.h"

#import "Config.h"

@class StationPickerViewControlleriPad;

@protocol StationPickerViewControllerDelegateiPad <NSObject>
- (void)didSelectStationWithStationTypeIndex:(StationPickerViewControlleriPad *)controller stationTypeIndex:(NSUInteger)index station:(Station *)station;
- (void)didPressPushBackViewController:(StationPickerViewControlleriPad *)controller;
@end

@interface StationPickerViewControlleriPad : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UITextFieldDelegate, MKMapViewDelegate>

@property (strong, nonatomic) UIView *searchContainerView;
@property (strong, nonatomic) UIView *mapContainerView;
@property (strong, nonatomic) UIView *listContainerView;

@property (strong, nonatomic) SplitSeparatorView *dividerLeft;
@property (strong, nonatomic) SplitSeparatorView *dividerRight;

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UITableView *stationsTableView;
@property (strong, nonatomic) UITableView *nextStationsTableView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSArray *filteredSearchResults;

@property (strong, nonatomic) StatusToolbariPad *stationsViewToolbar;

@property (strong, nonatomic) UITextField *stationTextField;

@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) NSString *stationName;
@property (strong, nonatomic) NSString *stationID;

@property (strong, nonatomic) CAShapeLayer *separatorLineLayer;

@property (assign) NSUInteger stationTypeIndex;

@property (strong, nonatomic) NSArray *stationsToCurrentLocation;
@property (strong, nonatomic) NSArray *sortedStationsToCurrentLocation;
@property (strong, nonatomic) CLLocation *userLocation;
@property (strong, nonatomic) NSDate *userLocationDate;

@property (strong, nonatomic) BKLocationManager *locationManager;

@property (weak) id <StationPickerViewControllerDelegateiPad> delegate;

- (void) clearStationSetting;

-(void) forcePushBackToPreviousViewController;

-(void) updateStationPickerWithMapData;

@end
