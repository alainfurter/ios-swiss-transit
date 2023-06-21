//
//  ConnectionsSelectionViewControlleriPad.h
//  Swiss Trains
//
//  Created by Alain on 02.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "UIApplication+AppDimension.h"

//#import "StationPickerViewControlleriPad.h"

#import "StationsCell.h"
#import "Stations.h"
#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"

//#import "DateAndTimePickerController.h"
//#import "StationPickerViewControlleriPad.h"

#import "SBBAPIController.h"
#import "Station.h"
#import "Reachability.h"
#import "WBInfoNoticeView.h"
#import "WBErrorNoticeView.h"

#import "BaseKitLocationManager.h"

#import "FTWButton.h"
//#import "SDSegmentedControl.h"
//#import "MCFlashMessageView.h"
#import "MBProgressHUD.h"
#import "SVSegmentedControl.h"

#import "NoticeviewMessages.h"

#import "ControlsBackgroundView.h"

#import "Config.h"

@class ControlsBackgroundViewiPad;
@class ConnectionsSelectionViewControlleriPad;

@protocol ConnectionsSelectionViewControlleriPadDelegate <NSObject>
- (void)selectStartStationButtonPressed:(ConnectionsSelectionViewControlleriPad *)controller fromrect:(CGRect)rect;
- (void)selectEndStationButtonPressed:(ConnectionsSelectionViewControlleriPad *)controller fromrect:(CGRect)rect;
- (void)selectViaStationButtonPressed:(ConnectionsSelectionViewControlleriPad *)controller fromrect:(CGRect)rect;
- (void)dateAndTimePickerButtonPressedFromRect:(CGRect)rect withdate:(NSDate *)date deparr:(BOOL)deparr;
- (void)didTriggerOpenShowViaStationWithVisibleFlag:(ConnectionsSelectionViewControlleriPad *)controller visible:(BOOL)visible;
- (void)didTriggerStartSearch:(ConnectionsSelectionViewControlleriPad *)controller;
@end

@interface ConnectionsSelectionViewControlleriPad : UIViewController

@property (strong, nonatomic) ControlsBackgroundView *stationsControlBackgroundView;
@property (strong, nonatomic) ControlsBackgroundView *timeControlBackgroundView;
@property (strong, nonatomic) ControlsBackgroundView *stationsViaControlBackgroundView;

@property (strong, nonatomic) SVSegmentedControl *navSC;

//@property (strong, nonatomic) DateAndTimePickerController *dateAndTimePickerController;

@property (strong, nonatomic) FTWButton *timeButton;
@property (strong, nonatomic) FTWButton *timenowButton;
@property (strong, nonatomic) FTWButton *timePlus10MButton;
@property (strong, nonatomic) FTWButton *timePlus30MButton;
@property (strong, nonatomic) FTWButton *timePlus60MButton;
@property (strong, nonatomic) UIButton *switchStationsButton;
@property (strong, nonatomic) UIButton *pinStartButton;
@property (strong, nonatomic) UIButton *pinEndButton;
@property (strong, nonatomic) UIButton *viaButton;
@property (strong, nonatomic) UIButton *cancelButton;

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

//@property (strong, nonatomic) CLLocation *userLocation;
//@property (strong, nonatomic) NSDate *userLocationDate;

@property (strong, nonatomic) CAShapeLayer *separatorLineLayer;
@property (strong, nonatomic) CAShapeLayer *separatorLineLayerTime;

//@property (assign) NSUInteger currentlyPushedViewController;

@property (weak) id <ConnectionsSelectionViewControlleriPadDelegate> delegate;

- (void) setStartLocationWithStation:(Station *)station;
- (void) setEndLocationWithStation:(Station *)station;
- (void) setViaLocationWithStation:(Station *)station;

- (Station *) getStartLocation;
- (Station *) getEndLocation;
- (Station *) getViaLocation;
- (NSDate *) getConnectionDate;
- (BOOL) getConnectionDateDepArr;

- (void)setConnectionDate:(NSDate *)date depArr:(BOOL)depArr;

- (void) setLocationsFromMapAppInitAndPushBackToCurrentVCIfRequired:(Station *)from to:(Station *)to push:(BOOL)push searchinit:(BOOL)searchinit;

@end

//@interface ControlsBackgroundViewiPad : UIView
//@end
