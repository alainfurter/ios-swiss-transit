//
//  StationboardSelectionViewControlleriPad.h
//  Swiss Trains
//
//  Created by Alain on 02.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

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

#import "Config.h"

#import "ControlsBackgroundView.h"

@class StationboardSelectionViewControlleriPad;

@protocol StationboardSelectionViewControlleriPadDelegate <NSObject>
- (void)selectStbStartStationButtonPressed:(StationboardSelectionViewControlleriPad *)controller fromrect:(CGRect)rect;
- (void)selectStbDirStationButtonPressed:(StationboardSelectionViewControlleriPad *)controller fromrect:(CGRect)rect;
- (void)dateAndTimePickerButtonPressedFromRect:(CGRect)rect withdate:(NSDate *)date deparr:(BOOL)deparr;
- (void)didModifyStartOrDirStation:(StationboardSelectionViewControlleriPad *)controller;
- (void)didTriggerOpenShowDirStationWithVisibleFlag:(StationboardSelectionViewControlleriPad *)controller visible:(BOOL)visible;
- (void)didTriggerStartSearch:(StationboardSelectionViewControlleriPad *)controller;
@end

@interface StationboardSelectionViewControlleriPad : UIViewController

@property (strong, nonatomic) ControlsBackgroundView *stationsControlBackgroundView;
@property (strong, nonatomic) ControlsBackgroundView *timeControlBackgroundView;
@property (strong, nonatomic) ControlsBackgroundView *stationsStbControlBackgroundView;

@property (strong, nonatomic) SVSegmentedControl *navSC;

@property (strong, nonatomic) FTWButton *timeButton;
@property (strong, nonatomic) FTWButton *timenowButton;
@property (strong, nonatomic) FTWButton *timePlus10MButton;
@property (strong, nonatomic) FTWButton *timePlus30MButton;
@property (strong, nonatomic) FTWButton *timePlus60MButton;
//@property (strong, nonatomic) UIButton *switchStationsButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *viaButton;
@property (strong, nonatomic) UIButton *cancelStbDirButton;

@property (strong, nonatomic) FTWButton *searchButton;

@property (strong, nonatomic) FTWButton *startStationButton;
@property (strong, nonatomic) FTWButton *endStationButton;

@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

//@property (strong, nonatomic) CLLocation *userLocation;
//@property (strong, nonatomic) NSDate *userLocationDate;

@property (strong, nonatomic) CAShapeLayer *separatorLineLayer;
@property (strong, nonatomic) CAShapeLayer *separatorLineLayerTime;

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

@property (weak) id <StationboardSelectionViewControlleriPadDelegate> delegate;

- (void) setStbStartLocationWithStation:(Station *)station;
- (void) setStbDirLocationWithStation:(Station *)station;

- (Station *) getStbStartLocation;
- (Station *) getStbDirLocation;
- (NSDate *) getConnectionDate;
- (BOOL) getConnectionDateDepArr;

- (void)setConnectionDate:(NSDate *)date depArr:(BOOL)depArr;

@end
