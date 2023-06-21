//
//  StationboardContainerViewControlleriPad.h
//  Swiss Trains
//
//  Created by Alain on 01.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JBTabBarController.h"
#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"

#import "StatusToolbariPad.h"

#import "UIApplication+AppDimension.h"

#import "SplitSeparatorView.h"

#import "StationboardMapViewController.h"
#import "StationboardListViewController.h"

#import "StationboardSelectionViewControlleriPad.h"
//#import "StationPickerViewControlleriPad.h"
#import "SearchStationPickerControlleriPad.h"

#import "StationboardResultsContainerViewController.h"

#import "IASKAppSettingsViewController.h"
#import "IASKSpecifier.h"
#import "IASKSettingsReader.h"

#import "IntroMoviePlayerControlleriPad.h"

#import "Config.h"

@interface StationboardContainerViewControlleriPad : UIViewController <StationboardSelectionViewControlleriPadDelegate, UIGestureRecognizerDelegate, StationboardResultContainerViewControllerDelegate, IASKSettingsDelegate, MFMailComposeViewControllerDelegate, SearchStationPickerControllerDelegateiPad, StationboardMapViewControlleriPadDelegate, IntroMoviePlayerControlleriPadDelegate>

@property (strong, nonatomic) StatusToolbariPad *statusToolBar;

@property (strong, nonatomic) SplitSeparatorView *divider;

@property (strong, nonatomic) StationboardSelectionViewControlleriPad *stationboardSelectionViewControlleriPad;

@property (strong, nonatomic) StationboardMapViewController *stationboardMapViewController;
@property (strong, nonatomic) StationboardListViewController *stationboardListViewController;
@property (strong, nonatomic) UIPopoverController *listViewPopOverController;

@property (strong, nonatomic) SVSegmentedControl *navSC;

@property (strong, nonatomic) UIButton *infoButton;
@property (strong, nonatomic) UIButton *goButton;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *listButton;
@property (strong, nonatomic) UIButton *closestStationsButton;

@property (strong, nonatomic) UIButton *trainlineButton;

@property (strong, nonatomic) UIView *topInfoView;
//@property (strong, nonatomic) UIImageView *topInfoTransportTypeImageView;
@property (strong, nonatomic) UIImageView *topInfoTransportNameImageView;
@property (strong, nonatomic) UILabel *bottomInfoStartStationLabel;
//@property (strong, nonatomic) UILabel *bottomInfoEndStationLabel;
@property (strong, nonatomic) UILabel *bottomInfoDepartureTimeLabel;
//@property (strong, nonatomic) UILabel *bottomInfoArrivalTimeLabel;

@property (strong, nonatomic) UIPopoverController *dtPickerPopOverController;
@property (strong, nonatomic) UIDatePicker *dtDatePicker;
@property (assign) BOOL dtPickerDepArr;

@property (assign) BOOL dirStationIsVisible;

@property (assign) BOOL navBarVisible;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//@property (strong, nonatomic) StationPickerViewControlleriPad *stationPickerViewController;
@property (strong, nonatomic) SearchStationPickerControlleriPad *searchStationPickerController;
@property (strong, nonatomic) UIPopoverController *searchStationPickerPopOverController;

@property (strong, nonatomic) StationboardResultsContainerViewController *stationboardResultContainerViewController;

@property (strong, nonatomic) CLLocation *userLocation;
@property (strong, nonatomic) NSDate *userLocationDate;

@property (nonatomic, assign) BOOL stationboardResultContainerViewIsOut;

@property (assign) NSInteger selectedConnectionIndex;

@property (assign) BOOL stbCurrentStationIsPrechecked;
@property (assign) BOOL stbIsPreCheckingStation;
@property (assign) BOOL stbPushStationboardViewControllerAfterPreCheck;
@property (assign) NSUInteger stbStationboardCurrentPrecheckedProductType;

@property (assign) NSUInteger currentlyPushedViewController;

@property (strong, nonatomic) UIView *topStationView;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *startStationLabel;
@property (strong, nonatomic) UILabel *endStationLabel;

@property (weak) JBTabBarController *tabbarControllerReference;

- (void) viewControllerSelectedFromTabbar;

//--------------------------------------------------------------------------------

@property (nonatomic, strong) IASKAppSettingsViewController *appSettingsViewController;

//--------------------------------------------------------------------------------

@property (strong, nonatomic) MKMapView *mapView;

@end
