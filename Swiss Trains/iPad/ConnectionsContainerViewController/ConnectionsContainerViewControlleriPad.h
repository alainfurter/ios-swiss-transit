//
//  ConnectionsContainerViewControlleriPad.h
//  Swiss Trains
//
//  Created by Alain on 01.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <sys/utsname.h>

#import "JBTabBarController.h"
#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"

#import "StatusToolbariPad.h"

#import "UIApplication+AppDimension.h"

#import "SplitSeparatorView.h"

#import "ConnectionsMapViewController.h"
#import "ConnectionsListViewController.h"

#import "ConnectionsSelectionViewControlleriPad.h"
//#import "StationPickerViewControlleriPad.h"
#import "SearchStationPickerControlleriPad.h"

#import "ConnectionsResultContainerViewController.h"

#import "IASKAppSettingsViewController.h"
#import "IASKSpecifier.h"
#import "IASKSettingsReader.h"

#import "UIDevice+IdentifierAddition.h"

#ifdef IncludeDetailedTrainlinesiPad
#import "TrainLinesController.h"
#endif

#import "Config.h"

#import "IntroMoviePlayerControlleriPad.h"

#import "MSCalendarViewController.h"

#import "NDHTMLtoPDF.h"

@interface ConnectionsContainerViewControlleriPad : UIViewController <ConnectionsSelectionViewControlleriPadDelegate, UIGestureRecognizerDelegate, ConnectionsResultContainerViewControllerDelegate, IASKSettingsDelegate, MFMailComposeViewControllerDelegate, ConnectionsMapViewControlleriPadDelegate, SearchStationPickerControllerDelegateiPad, IntroMoviePlayerControlleriPadDelegate, NDHTMLtoPDFDelegate>

@property (strong, nonatomic) StatusToolbariPad *statusToolBar;

@property (strong, nonatomic) SplitSeparatorView *divider;

@property (strong, nonatomic) ConnectionsSelectionViewControlleriPad *connectionsSelectionViewControlleriPad;

@property (strong, nonatomic) ConnectionsMapViewController *connectionsMapViewController;
@property (strong, nonatomic) ConnectionsListViewController *connectionsListViewController;
@property (strong, nonatomic) UIPopoverController *listViewPopOverController;
@property (strong, nonatomic) UIPopoverController *shareViewPopOverController;

@property (strong, nonatomic) MSCalendarViewController *calendarViewController;
@property (strong, nonatomic) UIPopoverController *calendarViewPopOverController;

//@property (strong, nonatomic) UIPopoverController *openMapsAppPopOverController;

@property (strong, nonatomic) UIButton *infoButton;
@property (strong, nonatomic) UIButton *goButton;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *listButton;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UIButton *closestStationsButton;

#ifdef IncludeAlarmAndAddToCalendar
@property (strong, nonatomic) UIButton *setalarmButton;
@property (strong, nonatomic) UIButton *addtocalendarButton;
#endif

@property (strong, nonatomic) UIButton *locationheadingButton;

@property (strong, nonatomic) UIButton *trainlineButton;

@property (strong, nonatomic) UIButton *calendarviewButton;

@property (strong, nonatomic) UIView *topInfoView;
@property (strong, nonatomic) UIImageView *topInfoTransportTypeImageView;
@property (strong, nonatomic) UIImageView *topInfoTransportNameImageView;
@property (strong, nonatomic) UILabel *bottomInfoStartStationLabel;
@property (strong, nonatomic) UILabel *bottomInfoEndStationLabel;
@property (strong, nonatomic) UILabel *bottomInfoDepartureTimeLabel;
@property (strong, nonatomic) UILabel *bottomInfoArrivalTimeLabel;

@property (strong, nonatomic) UIPopoverController *dtPickerPopOverController;
@property (strong, nonatomic) UIDatePicker *dtDatePicker;
@property (assign) BOOL dtPickerDepArr;

@property (assign) BOOL viaStationIsVisible;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//@property (strong, nonatomic) StationPickerViewControlleriPad *stationPickerViewController;
@property (strong, nonatomic) SearchStationPickerControlleriPad *searchStationPickerController;
@property (strong, nonatomic) UIPopoverController *searchStationPickerPopOverController;

@property (strong, nonatomic) ConnectionsResultContainerViewController *connectionsResultContainerViewController;

@property (strong, nonatomic) CLLocation *userLocation;
@property (strong, nonatomic) NSDate *userLocationDate;

@property (nonatomic, assign) BOOL connectionsResultContainerViewIsOut;

@property (assign) NSInteger selectedOverviewIndex;
@property (assign) NSInteger selectedDetailIndex;

@property (assign) NSUInteger currentlyPushedViewController;

@property (nonatomic, strong) NDHTMLtoPDF *PDFCreator;

- (void) viewControllerSelectedFromTabbar;
- (void) setLocationsFromMapAppInitAndPushBackToCurrentVCIfRequired:(Station *)from to:(Station *)to push:(BOOL)push searchinit:(BOOL)searchinit;

//--------------------------------------------------------------------------------

@property (nonatomic, strong) IASKAppSettingsViewController *appSettingsViewController;

//--------------------------------------------------------------------------------

//@property (strong, nonatomic) MKMapView *mapView;

//--------------------------------------------------------------------------------

@property (assign) BOOL showIntroFlag;
@property (assign) BOOL skipIntroFlag;

@end
