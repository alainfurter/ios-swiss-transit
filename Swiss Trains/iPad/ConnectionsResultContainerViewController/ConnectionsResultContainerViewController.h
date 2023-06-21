//
//  ConnectionsContainerViewController.h
//  Swiss Trains
//
//  Created by Alain on 28.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
//#import <MessageUI/MessageUI.h>

#import "Reachability.h"

#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"
//#import "StationsViewToolbar.h"
//#import "UIView+Origami.h"

#import "ConnectionsOverviewViewControlleriPad.h"
#import "ConnectionsDetailViewControlleriPad.h"
//#import "ConnectionsJourneyDetailViewController.h"

//#import "SVSegmentedControl.h"

#import "SBBAPIController.h"

//#import "ConnectionInfoViewController.h"
//#import "FPPopoverController.h"

#import "ConnectionInfoCell.h"

#import "UIActionSheet+Blocks.h"

#import "NoticeviewMessages.h"

@class ConnectionsResultContainerViewController;

@protocol ConnectionsResultContainerViewControllerDelegate <NSObject>
- (void)didSelectOverviewCellWithIndex:(ConnectionsOverviewViewControlleriPad *)controller index:(NSUInteger)index;
- (void)didTriggerOverviewCellWithIndexLongPress:(ConnectionsOverviewViewControlleriPad *)controller index:(NSUInteger)index;
- (void)didSelectDetailviewCellWithIndex:(ConnectionsDetailViewControlleriPad *)controller index:(NSUInteger)index;
- (void)didTriggerDetailviewCellWithIndexLongPress:(ConnectionsDetailViewControlleriPad *)controller index:(NSUInteger)index viewrect:(CGRect)viewrect;
- (void)showNoNetworkErrorMessage;
@end

@interface ConnectionsResultContainerViewController : UIViewController <ConnectionsOverviewViewControlleriPadDelegate, ConnectionsDetailViewControlleriPadDelegate, UIGestureRecognizerDelegate>

//@property (strong, nonatomic) StationsViewToolbar *stationsViewToolbar;

//@property (strong, nonatomic) UIButton *backButton;
//@property (strong, nonatomic) UIButton *mapButton;
//@property (strong, nonatomic) UIButton *listButton;
//@property (strong, nonatomic) UIButton *shareButton;
//@property (strong, nonatomic) UIButton *showJourneyDetailButton;

//@property (strong, nonatomic) SVSegmentedControl *navSC;

@property (strong, nonatomic) UIView *connectionsViewControllerContainerView;
@property (strong, nonatomic) ConnectionsOverviewViewControlleriPad *connectionsOverviewViewController;
@property (strong, nonatomic) ConnectionsDetailViewControlleriPad *connectionsDetailViewController;
//@property (strong, nonatomic) ConnectionsJourneyDetailViewController *connectionsJourneyDetailViewController;

//@property (strong, nonatomic) UISwipeGestureRecognizer *swipeLeftGestureRecognizer;
//@property (strong, nonatomic) UISwipeGestureRecognizer *swipeRightGestureRecognizer;

@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *startStationLabel;
@property (strong, nonatomic) UILabel *endStationLabel;

//@property (strong, nonatomic) MKMapView *mapView;

//@property (assign) NSUInteger viewMode;
@property (assign) NSInteger selectedOverviewIndex;

@property (weak) id <ConnectionsResultContainerViewControllerDelegate> delegate;

- (void) forcePushBackToPreviousViewController;
- (void) updateOverViewAndDetailViewWithConnectionIndex:(NSUInteger)index;
- (void) moveConnectionsResultOverviewtableviewToTopRow;

@end
