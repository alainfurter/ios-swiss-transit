//
//  ConnectionsContainerViewController.h
//  Swiss Trains
//
//  Created by Alain on 28.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import <EventKit/EventKit.h>

#import "Reachability.h"

#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"
#import "StationsViewToolbar.h"
#import "UIView+Origami.h"

#import "ConnectionsOverviewViewController.h"
#import "ConnectionsDetailViewController.h"
#import "ConnectionsJourneyDetailViewController.h"

#import "SVSegmentedControl.h"

#import "SBBAPIController.h"

#import "ConnectionInfoViewController.h"
#import "FPPopoverController.h"

#import "ConnectionInfoCell.h"

#import "UIActionSheet+Blocks.h"

#import "NoticeviewMessages.h"

#import "NDHTMLtoPDF.h"

@class ConnectionsContainerViewController;

@protocol ConnectionsContainerViewControllerDelegate <NSObject>
- (void)didTriggerPushback:(ConnectionsContainerViewController *)controller;
@end

@interface ConnectionsContainerViewController : UIViewController <ConnectionsOverviewViewControllerDelegate, ConnectionsDetailViewControllerDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate, NDHTMLtoPDFDelegate>

@property (strong, nonatomic) StationsViewToolbar *stationsViewToolbar;

@property (strong, nonatomic) UIButton *backButton;
//@property (strong, nonatomic) UIButton *mapButton;
//@property (strong, nonatomic) UIButton *listButton;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UIButton *showJourneyDetailButton;

#ifdef IncludeAlarmAndAddToCalendar
@property (strong, nonatomic) UIButton *calendaralarmButton;
#endif

@property (strong, nonatomic) SVSegmentedControl *navSC;

@property (strong, nonatomic) UIView *connectionsViewControllerContainerView;
@property (strong, nonatomic) ConnectionsOverviewViewController *connectionsOverviewViewController;
@property (strong, nonatomic) ConnectionsDetailViewController *connectionsDetailViewController;
@property (strong, nonatomic) ConnectionsJourneyDetailViewController *connectionsJourneyDetailViewController;

@property (strong, nonatomic) UISwipeGestureRecognizer *swipeLeftGestureRecognizer;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeRightGestureRecognizer;

@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *startStationLabel;
@property (strong, nonatomic) UILabel *endStationLabel;

//@property (strong, nonatomic) MKMapView *mapView;

@property (assign) NSUInteger viewMode;
@property (assign) NSInteger selectedOverviewIndex;

@property (nonatomic, strong) NDHTMLtoPDF *PDFCreator;

@property (weak) id <ConnectionsContainerViewControllerDelegate> delegate;

- (void) updateConnectionsController;

- (void) dispatchViewAppearsAdjustments;
- (void) dispatchViewDisappearsAdjustments;

-(void) forcePushBackToPreviousViewController;

- (void) moveConnectionsResultOverviewtableviewToTopRow;

@end
