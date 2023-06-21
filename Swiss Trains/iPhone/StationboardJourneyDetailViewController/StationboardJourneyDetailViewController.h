//
//  StationboardJourneyDetailViewController.h
//  Swiss Trains
//
//  Created by Alain on 18.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MTDirectionsKit/MTDirectionsKit.h>

#import "MTDJourneyParser.h"
#import "MTDJourneyRequest.h"
#import "MTDJourneyOverlayView.h"

#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"

#import "UIApplication+AppDimension.h"

#import "ConnectionsJourneyDetailPasslistCell.h"

#import "StationsViewToolbar.h"

#import "StationsAnnotationView.h"
#import "StationAnnotation.h"

#import "SVSegmentedControl.h"

#import "SBBAPIController.h"

#import "GCDiscreetNotificationView.h"

#ifdef IncludeDetailedTrainlinesiPhone
#import "TrainLinesController.h"
#endif

#import "Config.h"

/*
enum connectionJourneyDetailViewType {
    mapViewType = 1,
    listViewType = 2
};
*/
@interface StationboardJourneyDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MTDDirectionsDelegate, MKMapViewDelegate>

@property (strong, nonatomic) UITableView *journeyDetailTableView;
@property (strong, nonatomic) MTDMapView *mapView;

@property (strong, nonatomic) StationsViewToolbar *stationsViewToolbar;

@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) UIImageView *transportNameImageView;
@property (strong, nonatomic) UILabel *startStationLabel;

@property (nonatomic, strong) StationAnnotation *fromAnnotation;
@property (nonatomic, strong) StationAnnotation *toAnnotation;

@property (strong, nonatomic) SVSegmentedControl *navSC;

@property (assign) NSUInteger selectedStationboardJourney;
@property (assign) NSUInteger stbSelectedJourneyProducttype;

@property (strong, nonatomic) UIButton *trainlineButton;

@property (strong, nonatomic) GCDiscreetNotificationView *notificationView;

@property (assign) NSUInteger connectionJourneyDetailViewTypeSelected;

@property (assign) BOOL trainlinebuttonvisible;

- (void) updateJourneyTableViewWithStationboardIndex:(NSUInteger)index;

-(void) forcePushBackToPreviousViewController;

@property (assign) NSUInteger detaillevelForTrainlinesForDetailedRoutes;

- (void) setDetailedRouteDetaillevelForTrainlines:(NSUInteger)detaillevel;

@end
