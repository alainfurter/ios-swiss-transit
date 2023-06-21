//
//  StationboardConnectionsViewController.h
//  Swiss Trains
//
//  Created by Alain on 18.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Reachability.h"

#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"

#import "MBProgressHUD.h"
#import "SVSegmentedControl.h"

#import "UIApplication+AppDimension.h"

#import "StationboardTableViewCell.h"

//#import "StationsViewToolbar.h"

#import "SBBAPIController.h"

//#import "StationboardJourneyDetailViewController.h"

#import "Config.h"

#import "NoticeviewMessages.h"

#import "PullTableViewHeaderFooterViews.h"

@class StationboardResultsContainerViewController;

@protocol StationboardResultContainerViewControllerDelegate <NSObject>
- (void)didSelectStationboardCellWithIndexAndProductType:(StationboardResultsContainerViewController *)controller index:(NSUInteger)index producttype:(NSUInteger)producttype;
- (void)showNoNetworkErrorMessage;
@end

@interface StationboardResultsContainerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *connectionsTableView;

//@property (strong, nonatomic) StationsViewToolbar *stationsViewToolbar;

@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) UIButton *updateButton;

@property (strong, nonatomic) UIView *bottomStbSelectionView;

@property (strong, nonatomic) SVSegmentedControl *navSC;

//@property (strong, nonatomic) StationboardJourneyDetailViewController *stationboardJourneyDetailViewController;

@property (assign) NSUInteger stationBoardResultProductType;

@property (strong, nonatomic) Station *stbStation;
@property (strong, nonatomic) Station *dirStation;
@property (strong, nonatomic) NSDate *connectionTime;
@property (assign) BOOL isDepartureTime;

@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *startStationLabel;
@property (strong, nonatomic) UILabel *endStationLabel;

//@property (assign) BOOL isJourneyDetailViewControllerOnScreen;

@property (weak) id <StationboardResultContainerViewControllerDelegate> delegate;

- (void) setCurrentStationBoardProductCodesType:(NSUInteger)productCodeType;
- (void) updateControllerWithStationBoardProductCodesType:(NSUInteger)productCodeTypes;
- (void) UpdateTableViewWithNumberOfResults:(NSUInteger) numberofresults;

- (void) selectFastTrainResults;
- (void) selectRegioTrainResults;
- (void) selectTramBusResults;
- (void) selectAllResults;

-(void) forcePushBackToPreviousViewController;

- (void)showLoadingIndicator;
- (void)hideLoadingIndicator;

@property (strong, nonatomic) NSDate *lastRequestDate;
@property (assign) BOOL appcamefrombackground;

//--------------------------------------------------------------------------------

@property (nonatomic, strong) StbHeaderView *headerView;
@property (nonatomic, strong) StbFooterView *footerView;

@property (assign) BOOL isDragging;
@property (assign) BOOL isLoadingMoreBottom;
@property (assign) BOOL isLoadingMoreTop;

@property (assign) CGRect headerViewFrame;
@property (assign) CGRect footerViewFrame;

@property (assign) CGFloat initialContentOffset;

@end
