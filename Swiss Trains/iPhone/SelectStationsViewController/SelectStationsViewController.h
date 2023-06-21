//
//  SelectStationsViewController.h
//  Swiss Trains
//
//  Created by Alain on 20.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <sys/utsname.h>

#import "StationsCell.h"
#import "Stations.h"
#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"
#import "StationsViewToolbar.h"

#import "ConnectionsContainerViewController.h"
#import "DateAndTimePickerController.h"
#import "StationPickerViewController.h"
#import "StationboardConnectionsViewController.h"

#import "SBBAPIController.h"
#import "Station.h"
#import "Reachability.h"
#import "WBInfoNoticeView.h"
#import "WBErrorNoticeView.h"

#import "BaseKitLocationManager.h"
#import "HZActivityIndicatorView.h"

#import "FTWButton.h"
#import "SDSegmentedControl.h"
#import "MCFlashMessageView.h"
#import "MBProgressHUD.h"

#import "NoticeviewMessages.h"

#import "RssInfoCell.h"
#import "RssDetailInfoViewController.h"

#import "Config.h"

#import "IASKAppSettingsViewController.h"

#import "ControlsBackgroundView.h"

#import "PullTableViewHeaderFooterViews.h"

#import "UIDevice+IdentifierAddition.h"

#import "IntroMoviePlayerController.h"

@class ControlsBackgroundView;

@interface SelectStationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UITextFieldDelegate, DateTimePickerDelegate, StationPickerViewControllerDelegate, IASKSettingsDelegate, IntroMoviePlayerControllerDelegate, ConnectionsContainerViewControllerDelegate>

@property (strong, nonatomic) UISearchBar *stationsSearchBar;
@property (strong, nonatomic) UITableView *stationsTableView;

@property (strong, nonatomic) UIView *conReqContrainerView;
@property (strong, nonatomic) UIView *stbContrainerView;
@property (strong, nonatomic) UIView *delayinfoContrainerView;

@property (strong, nonatomic) ControlsBackgroundView *stationsControlBackgroundView;
@property (strong, nonatomic) ControlsBackgroundView *timeControlBackgroundView;
@property (strong, nonatomic) ControlsBackgroundView *stationsViaControlBackgroundView;
@property (strong, nonatomic) ControlsBackgroundView *stationsStbControlBackgroundView;

@property (strong, nonatomic) ConnectionsContainerViewController *connectionsContainerViewController;
@property (strong, nonatomic) StationboardConnectionsViewController *stationboardConnectionsViewController;
@property (strong, nonatomic) RssDetailInfoViewController *rssDetailInfoViewController;

@property (strong, nonatomic) UITableView *delayInfoTableView;

@property (strong, nonatomic) SDSegmentedControl *requestTypeSegmentControl;
@property (strong, nonatomic) SVSegmentedControl *navSC;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) StationsViewToolbar *stationsViewToolbar;
@property (strong, nonatomic) DateAndTimePickerController *dateAndTimePickerController;

@property (strong, nonatomic) StationPickerViewController *stationPickerViewController;

@property (strong, nonatomic) HZActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) UIButton *infoButton;

@property (strong, nonatomic) FTWButton *timeButton;
@property (strong, nonatomic) FTWButton *timenowButton;
@property (strong, nonatomic) FTWButton *timePlus10MButton;
@property (strong, nonatomic) FTWButton *timePlus30MButton;
@property (strong, nonatomic) FTWButton *timePlus60MButton;
@property (strong, nonatomic) UIButton *switchStationsButton;
@property (strong, nonatomic) UIButton *pinStartButton;
@property (strong, nonatomic) UIButton *pinEndButton;
@property (strong, nonatomic) UIButton *goButton;
@property (strong, nonatomic) UIButton *viaButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *cancelStbDirButton;

@property (strong, nonatomic) UIButton *conreqButton;
@property (strong, nonatomic) UIButton *stbreqButton;
@property (strong, nonatomic) UIButton *inforeqButton;

@property (strong, nonatomic) FTWButton *startStationButton;
@property (strong, nonatomic) FTWButton *endStationButton;
@property (strong, nonatomic) FTWButton *viaStationButton;

@property (strong, nonatomic) FTWButton *searchButton;

@property (strong, nonatomic) NSString *startStationName;
@property (strong, nonatomic) NSString *startStationID;
@property (strong, nonatomic) NSString *endStationName;
@property (strong, nonatomic) NSString *endStationID;
@property (strong, nonatomic) NSString *viaStationName;
@property (strong, nonatomic) NSString *viaStationID;

@property (strong, nonatomic) NSNumber *startStationLatitude;
@property (strong, nonatomic) NSNumber *startStationLongitude;
@property (strong, nonatomic) NSNumber *endStationLatitude;
@property (strong, nonatomic) NSNumber *endStationLongitude;

@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

@property (strong, nonatomic) CLLocation *userLocation;
@property (strong, nonatomic) NSDate *userLocationDate;

@property (strong, nonatomic) CAShapeLayer *separatorLineLayer;
@property (strong, nonatomic) CAShapeLayer *separatorLineLayerTime;

@property (assign) NSUInteger selectedRequestType;

@property (assign) NSUInteger currentlyPushedViewController;

- (void) setLocationsFromMapAppInitAndPushBackToCurrentVCIfRequired:(Station *)from to:(Station *)to push:(BOOL)push searchinit:(BOOL)searchinit;

//--------------------------------------------------------------------------------

@property (strong, nonatomic) NSString *stbStationName;
@property (strong, nonatomic) NSString *stbStationID;
@property (strong, nonatomic) NSString *dirStationName;
@property (strong, nonatomic) NSString *dirStationID;

@property (assign) BOOL stbCurrentStationIsPrechecked;
@property (assign) BOOL stbIsPreCheckingStation;
@property (assign) BOOL stbPushStationboardViewControllerAfterPreCheck;
@property (assign) NSUInteger stbStationboardCurrentPrecheckedProductType;

//--------------------------------------------------------------------------------

@property (nonatomic, strong) IASKAppSettingsViewController *appSettingsViewController;

//--------------------------------------------------------------------------------

@property (nonatomic, strong) RssHeaderView *headerView;

@property (assign) BOOL isDragging;
@property (assign) BOOL isLoadingMoreTop;
@property (assign) CGRect headerViewFrame;
@property (assign) CGFloat initialContentOffset;

//--------------------------------------------------------------------------------

@property (assign) BOOL showIntroFlag;
@property (assign) BOOL skipIntroFlag;

@end


