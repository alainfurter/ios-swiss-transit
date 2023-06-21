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

#import "StationsViewToolbar.h"

#import "SBBAPIController.h"

#import "StationboardJourneyDetailViewController.h"

#import "Config.h"

#import "NoticeviewMessages.h"

#import "PullTableViewHeaderFooterViews.h"

//@class StbHeaderView, StbFooterView;

@interface StationboardConnectionsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *connectionsTableView;

@property (strong, nonatomic) StationsViewToolbar *stationsViewToolbar;

@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) UIButton *updateButton;

@property (strong, nonatomic) UIView *bottomStbSelectionView;

@property (strong, nonatomic) SVSegmentedControl *navSC;

@property (strong, nonatomic) StationboardJourneyDetailViewController *stationboardJourneyDetailViewController;

@property (assign) NSUInteger stationBoardResultProductType;

@property (strong, nonatomic) Station *stbStation;
@property (strong, nonatomic) Station *dirStation;
@property (strong, nonatomic) NSDate *connectionTime;
@property (assign) BOOL isDepartureTime;

@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *startStationLabel;
@property (strong, nonatomic) UILabel *endStationLabel;

@property (strong, nonatomic) NSDate *lastRequestDate;
@property (assign) BOOL appcamefrombackground;

@property (assign) BOOL isJourneyDetailViewControllerOnScreen;

- (void) updateControllerWithStationBoardProductCodesType:(NSUInteger)productCodeTypes;

-(void) forcePushBackToPreviousViewController;

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

//--------------------------------------------------------------------------------


/*
typedef enum {
    
    StbPullToRefreshViewStateIdle = 0, //<! The control is invisible right after being created or after a reloading was completed
    StbPullToRefreshViewStatePull, //<! The control is becoming visible and shows "pull to refresh" message
    StbPullToRefreshViewStateRelease, //<! The control is whole visible and shows "release to load" message
    StbPullToRefreshViewStateLoading //<! The control is loading and shows activity indicator
    
} StbPullToRefreshViewState;


@interface StbHeaderView : UIView
@property (nonatomic, strong) UIImageView* headerImageView;
@property (nonatomic, strong) UILabel* headerLabel;
@property (nonatomic, strong) UIActivityIndicatorView  *loadingActivityIndicator;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) CGFloat fixedHeight;
@property (nonatomic, readwrite, assign) StbPullToRefreshViewState state;
- (void)changeStateOfControl:(StbPullToRefreshViewState)state offset:(CGFloat)offset;
@end

@interface StbFooterView : UIView
@property (nonatomic, strong) UIImageView* footerImageView;
@property (nonatomic, strong) UILabel* footerLabel;
@property (nonatomic, strong) UIActivityIndicatorView  *loadingActivityIndicator;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) CGFloat fixedHeight;
@property (nonatomic, readwrite, assign) StbPullToRefreshViewState state;
- (void)changeStateOfControl:(StbPullToRefreshViewState)state offset:(CGFloat)offset;
@end
*/ 
