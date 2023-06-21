//
//  RSSTransportNewContainerViewControlleriPad.h
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

#import "SplitSeparatorView.h"

#import "PullTableViewHeaderFooterViews.h"

#import "RssInfoCell.h"

#import "Reachability.h"
#import "SBBAPIController.h"

#import "MBProgressHUD.h"

#import "NoticeviewMessages.h"

#import "UIApplication+AppDimension.h"

#import "IASKAppSettingsViewController.h"
#import "IASKSpecifier.h"
#import "IASKSettingsReader.h"

#import "IntroMoviePlayerControlleriPad.h"

#import "Config.h"

@interface RSSTransportNewContainerViewControlleriPad : UIViewController <UITableViewDataSource, UITableViewDelegate, IASKSettingsDelegate, MFMailComposeViewControllerDelegate, UIWebViewDelegate, IntroMoviePlayerControlleriPadDelegate>

@property (strong, nonatomic) StatusToolbariPad *statusToolBar;

@property (strong, nonatomic) SplitSeparatorView *divider;

@property (strong, nonatomic) UITableView *delayInfoTableView;
@property (strong, nonatomic) UIWebView *descriptionDetailView;

@property (strong, nonatomic) UIView *topInfoView;
@property (strong, nonatomic) UILabel *lastUpdateLabel;

@property (strong, nonatomic) UIButton *infoButton;

@property (nonatomic, strong) RssHeaderView *headerView;

@property (nonatomic, strong) NSString *rsshtmlsource;

@property (assign) BOOL isDragging;
@property (assign) BOOL isLoadingMoreTop;
@property (assign) CGRect headerViewFrame;
@property (assign) CGFloat initialContentOffset;

//- (void) loadDescriptionIntoDetailView:(NSString *)description;

@property (assign) NSUInteger currentlyPushedViewController;

- (void) viewControllerSelectedFromTabbar;

//--------------------------------------------------------------------------------

@property (nonatomic, strong) IASKAppSettingsViewController *appSettingsViewController;

//--------------------------------------------------------------------------------

@end
