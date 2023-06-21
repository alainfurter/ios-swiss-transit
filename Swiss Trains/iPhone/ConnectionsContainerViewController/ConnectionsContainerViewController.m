//
//  ConnectionsContainerViewController.m
//  Swiss Trains
//
//  Created by Alain on 28.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "ConnectionsContainerViewController.h"

//#define TOOLBARHEIGHT 36.0
#define BUTTONHEIGHT 36.0

//#define VIEWHEIGHT 256.0
//#define BUTTONHEIGHT 36.0
#define SEGMENTHEIGHT 18.0

@interface ConnectionsContainerViewController ()

@end

@implementation ConnectionsContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.viewMode = 1;
        self.selectedOverviewIndex = -1;
        
        //self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        self.view.backgroundColor = [UIColor listviewControllersBackgroundColor];
        
        self.stationsViewToolbar = [[StationsViewToolbar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //UIImage *backButtonImage = [UIImage newImageFromMaskImage: [UIImage backButtonImage] inColor: [UIColor selectStationsViewButtonColorNormal]];
        //UIImage *backButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage backButtonImage] inColor: [UIColor selectStationsViewButtonColorHighlighted]];
        UIImage *backButtonImage =  [UIImage newImageFromMaskImage: [[UIImage backButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
        UIImage *backButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage backButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
        [self.backButton setImage: backButtonImage forState: UIControlStateNormal];
        [self.backButton setImage: backButtonImage forState: UIControlStateNormal];
        [self.backButton setImage: backButtonImageHighlighted forState: UIControlStateHighlighted];
        self.backButton.imageView.contentMode = UIViewContentModeCenter;
        self.backButton.frame = CGRectMake(2, 0, BUTTONHEIGHT, BUTTONHEIGHT);
        self.backButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.backButton.showsTouchWhenHighlighted = YES;
        [self.backButton addTarget: self action: @selector(pushBackController:) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.timeLabel = [[UILabel alloc] initWithFrame: CGRectMake(BUTTONHEIGHT + 5 + 5 + 10-10, 2, 40, BUTTONHEIGHT / 2)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.timeLabel.font = [UIFont boldSystemFontOfSize: 12.0];
        self.timeLabel.textColor = [UIColor toolbarTextColorNormal];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        
        self.dateLabel = [[UILabel alloc] initWithFrame: CGRectMake(BUTTONHEIGHT + 5 + 5 + 10-10, BUTTONHEIGHT / 2 - 2, 40, BUTTONHEIGHT / 2)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.dateLabel.font = [UIFont boldSystemFontOfSize: 12.0];
        self.dateLabel.textColor = [UIColor toolbarTextColorNormal];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.textAlignment = NSTextAlignmentLeft;
        
        self.startStationLabel = [[UILabel alloc] initWithFrame: CGRectMake(BUTTONHEIGHT + 5 + 5 + 40 + 5 + 10 - 5-12, 2, self.view.frame.size.width - BUTTONHEIGHT + 5 + 5 + 40 + 5 - BUTTONHEIGHT - 10 - 10 + 5, BUTTONHEIGHT / 2)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.startStationLabel.font = [UIFont boldSystemFontOfSize: 12.0];
        self.startStationLabel.textColor = [UIColor toolbarTextColorNormal];
        self.startStationLabel.backgroundColor = [UIColor clearColor];
        self.startStationLabel.textAlignment = NSTextAlignmentLeft;
        
        self.endStationLabel = [[UILabel alloc] initWithFrame: CGRectMake(BUTTONHEIGHT + 5 + 5 + 40 + 5 + 10 - 5-12, BUTTONHEIGHT / 2 - 2, self.view.frame.size.width - BUTTONHEIGHT + 5 + 5 + 40 + 5 - BUTTONHEIGHT - 10 - 10 + 5, BUTTONHEIGHT / 2)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.endStationLabel.font = [UIFont boldSystemFontOfSize: 12.0];
        self.endStationLabel.textColor = [UIColor toolbarTextColorNormal];
        self.endStationLabel.backgroundColor = [UIColor clearColor];
        self.endStationLabel.textAlignment = NSTextAlignmentLeft;
        
        self.navSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"", @"", nil]];
        //navSC.height = BUTTONHEIGHT;
        //CGRect navFrame = navSC.frame;
        //CGRect newNavFrame = CGRectMake(self.view.frame.size.width - navFrame.size.width * 2, 0, navFrame.size.width, navFrame.size.width);
        //navSC.frame = newNavFrame;
        CGFloat scaleFactor = 1.5;
        UIImage *listImage =  [[UIImage listButtonImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactor, SEGMENTHEIGHT * scaleFactor) interpolationQuality: kCGInterpolationDefault];
        UIImage *mapImage = [[UIImage mapButtonImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactor, SEGMENTHEIGHT * scaleFactor) interpolationQuality: kCGInterpolationDefault];
        self.navSC.sectionImages = [NSArray arrayWithObjects: mapImage, listImage, nil];
        //navSC.sectionTitles = nil;
        
        __weak ConnectionsContainerViewController *weakself = self;
        self.navSC.changeHandler = ^(NSUInteger newIndex) {
            //NSLog(@"segmentedControl did select index %i (via block handler)", newIndex);
            if (newIndex == 0) {
                [weakself.connectionsJourneyDetailViewController switchToMapViewAsConnectionJourneyDetailView];
            } else {
                [weakself.connectionsJourneyDetailViewController switchToListViewAsConnectionJourneyDetailView];
            }
        };
        //self.listButton.frame = CGRectMake(self.view.frame.size.width - 5 - BUTTONHEIGHT * 2 - 5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
        self.navSC.center = CGPointMake(self.view.frame.size.width - 5 - BUTTONHEIGHT * 2 - 5 + 20, TOOLBARHEIGHT / 2 + 1);
        
        CGFloat scaleFactorArrowRightButton = 0.7;
        self.showJourneyDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //UIImage *backButtonImage = [UIImage newImageFromMaskImage: [UIImage backButtonImage] inColor: [UIColor selectStationsViewButtonColorNormal]];
        //UIImage *backButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage backButtonImage] inColor: [UIColor selectStationsViewButtonColorHighlighted]];
        UIImage *arrowrightButtonImage =  [UIImage newImageFromMaskImage: [[UIImage gorightButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * scaleFactorArrowRightButton, BUTTONHEIGHT * scaleFactorArrowRightButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
        UIImage *arrowrightButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage gorightButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * scaleFactorArrowRightButton, BUTTONHEIGHT * scaleFactorArrowRightButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
        [self.showJourneyDetailButton setImage: arrowrightButtonImage forState: UIControlStateNormal];
        //[self.showJourneyDetailButton setImage: backButtonImage forState: UIControlStateNormal];
        [self.showJourneyDetailButton setImage: arrowrightButtonImageHighlighted forState: UIControlStateHighlighted];
        self.showJourneyDetailButton.imageView.contentMode = UIViewContentModeCenter;
        self.showJourneyDetailButton.frame = CGRectMake(self.view.frame.size.width - 5 - BUTTONHEIGHT+8, 0, BUTTONHEIGHT, BUTTONHEIGHT);
        self.showJourneyDetailButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.showJourneyDetailButton.showsTouchWhenHighlighted = YES;
        [self.showJourneyDetailButton addTarget: self action: @selector(didSwipeLeft:) forControlEvents:UIControlEventTouchUpInside];
        
        self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //UIImage *backButtonImage = [UIImage newImageFromMaskImage: [UIImage backButtonImage] inColor: [UIColor selectStationsViewButtonColorNormal]];
        //UIImage *backButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage backButtonImage] inColor: [UIColor selectStationsViewButtonColorHighlighted]];
        UIImage *shareButtonImage =  [UIImage newImageFromMaskImage: [[UIImage shareButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
        UIImage *shareButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage shareButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
        [self.shareButton setImage: shareButtonImage forState: UIControlStateNormal];
        //[self.showJourneyDetailButton setImage: backButtonImage forState: UIControlStateNormal];
        [self.shareButton setImage: shareButtonImageHighlighted forState: UIControlStateHighlighted];
        self.shareButton.imageView.contentMode = UIViewContentModeCenter;
        self.shareButton.frame = CGRectMake(self.view.frame.size.width - 5 - BUTTONHEIGHT - BUTTONHEIGHT - 5+12, 0, BUTTONHEIGHT, BUTTONHEIGHT);
        self.shareButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.shareButton.showsTouchWhenHighlighted = YES;
        [self.shareButton addTarget: self action: @selector(shareConnection:) forControlEvents:UIControlEventTouchUpInside];
        
        #ifdef IncludeAlarmAndAddToCalendar
        self.calendaralarmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //UIImage *backButtonImage = [UIImage newImageFromMaskImage: [UIImage backButtonImage] inColor: [UIColor selectStationsViewButtonColorNormal]];
        //UIImage *backButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage backButtonImage] inColor: [UIColor selectStationsViewButtonColorHighlighted]];
        UIImage *calendaralarmButtonImage =  [UIImage newImageFromMaskImage: [[UIImage addtocalendarandalarmButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
        UIImage *calendaralarmButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage addtocalendarandalarmButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
        [self.calendaralarmButton setImage: calendaralarmButtonImage forState: UIControlStateNormal];
        //[self.showJourneyDetailButton setImage: backButtonImage forState: UIControlStateNormal];
        [self.calendaralarmButton setImage: calendaralarmButtonImageHighlighted forState: UIControlStateHighlighted];
        self.calendaralarmButton.imageView.contentMode = UIViewContentModeCenter;
        self.calendaralarmButton.frame = CGRectMake(self.view.frame.size.width - 5 - BUTTONHEIGHT - BUTTONHEIGHT - 5+12 - BUTTONHEIGHT - 5+3, 0, BUTTONHEIGHT, BUTTONHEIGHT);
        self.calendaralarmButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.calendaralarmButton.showsTouchWhenHighlighted = YES;
        [self.calendaralarmButton addTarget: self action: @selector(showcalendarAlarmActionSheet:) forControlEvents:UIControlEventTouchUpInside];
        #endif
        
        /*
         self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
         UIImage *mapButtonImage = [UIImage newImageFromMaskImage: [UIImage mapButtonImage] inColor: [UIColor selectStationsViewButtonColorNormal]];
         UIImage *mapButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage mapButtonImage] inColor: [UIColor selectStationsViewButtonColorHighlighted]];
         [self.mapButton setImage: mapButtonImage forState: UIControlStateNormal];
         [self.mapButton setImage: mapButtonImageHighlighted forState: UIControlStateHighlighted];
         self.mapButton.imageView.contentMode = UIViewContentModeCenter;
         self.mapButton.frame = CGRectMake(self.view.frame.size.width - 5 - BUTTONHEIGHT, 0, BUTTONHEIGHT, BUTTONHEIGHT);
         self.mapButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
         self.mapButton.showsTouchWhenHighlighted = YES;
         [self.mapButton addTarget: self action: @selector(selectConnectionsJourneyDetailMapView:) forControlEvents:UIControlEventTouchUpInside];
         
         self.listButton = [UIButton buttonWithType:UIButtonTypeCustom];
         UIImage *listButtonImage = [UIImage newImageFromMaskImage: [UIImage listButtonImage] inColor: [UIColor selectStationsViewButtonColorNormal]];
         UIImage *listButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage listButtonImage] inColor: [UIColor selectStationsViewButtonColorHighlighted]];
         [self.listButton setImage: listButtonImage forState: UIControlStateNormal];
         [self.listButton setImage: listButtonImageHighlighted forState: UIControlStateHighlighted];
         self.listButton.imageView.contentMode = UIViewContentModeCenter;
         self.listButton.frame = CGRectMake(self.view.frame.size.width - 5 - BUTTONHEIGHT * 2 - 5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
         self.listButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
         self.listButton.showsTouchWhenHighlighted = YES;
         [self.listButton addTarget: self action: @selector(selectConnectionsJourneyDetailListView:) forControlEvents:UIControlEventTouchUpInside];
         */
        
        float padding = -25;
        
        self.connectionsJourneyDetailViewController = [[ConnectionsJourneyDetailViewController alloc] init];
        self.connectionsJourneyDetailViewController.view.frame = CGRectMake(80 + padding, TOOLBARHEIGHT, 320 - 80 - padding, self.view.frame.size.height - TOOLBARHEIGHT);
        [self.view addSubview: self.connectionsJourneyDetailViewController.view];
        
        /*
         self.mapView = [[MKMapView alloc] initWithFrame: CGRectMake(80 + padding, TOOLBARHEIGHT, 320 - 80 - padding, self.view.frame.size.height - TOOLBARHEIGHT)];
         [self.view addSubview: self.mapView];
         //CLLocationCoordinate2D zoomLocation;
         //zoomLocation.latitude = 40.7310;
         //zoomLocation.longitude= -73.9977;
         //MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 10000, 10000);
         //[self.mapView setRegion:viewRegion animated:NO];
         */
        
        self.connectionsViewControllerContainerView = [[UIView alloc] initWithFrame: CGRectMake(0, TOOLBARHEIGHT, 320, self.view.frame.size.height - TOOLBARHEIGHT)];
        [self.view addSubview: self.connectionsViewControllerContainerView];
        
        self.connectionsOverviewViewController = [[ConnectionsOverviewViewController alloc] init];
        //self.connectionsOverviewViewController.view.frame = CGRectMake(0, TOOLBARHEIGHT, 80, self.view.frame.size.height - TOOLBARHEIGHT);
        self.connectionsOverviewViewController.view.frame = CGRectMake(0, 0, 80, self.connectionsViewControllerContainerView.frame.size.height);
        [self.connectionsViewControllerContainerView addSubview: self.connectionsOverviewViewController.view];
        self.connectionsOverviewViewController.delegate = self;
        
        
        self.connectionsDetailViewController = [[ConnectionsDetailViewController alloc] init];
        //self.connectionsDetailViewController = [[ConnectionsDetailViewController alloc] initWithFrame: CGRectMake(80, TOOLBARHEIGHT, 320 - 80, self.view.frame.size.height - TOOLBARHEIGHT)];
        //self.connectionsDetailViewController.view.frame = CGRectMake(80, TOOLBARHEIGHT, 320 - 80, self.view.frame.size.height - TOOLBARHEIGHT);
        self.connectionsDetailViewController.view.frame = CGRectMake(80, 0, 320 - 80, self.connectionsViewControllerContainerView.frame.size.height);
        [self.connectionsViewControllerContainerView addSubview: self.connectionsDetailViewController.view];
        self.connectionsDetailViewController.delegate = self;
        
        [self.view addSubview: self.stationsViewToolbar];
        [self.view addSubview: self.navSC];
        [self.navSC setSelectedIndex: 0];
        self.navSC.alpha = 0.0;
        [self.view addSubview: self.backButton];
        [self.view addSubview: self.timeLabel];
        [self.view addSubview: self.dateLabel];
        [self.view addSubview: self.startStationLabel];
        [self.view addSubview: self.endStationLabel];
        [self.view addSubview: self.showJourneyDetailButton];
        [self.view addSubview: self.shareButton];
        
        #ifdef IncludeAlarmAndAddToCalendar
        [self.view addSubview: self.calendaralarmButton];
        #endif
        
        
        //[self.view addSubview: self.mapButton];
        //self.mapButton.alpha = 0.0;
        //[self.view addSubview: self.listButton];
        //self.listButton.alpha = 0.0;
        UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                                  action:@selector(didSwipeLeft:)];
        leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        leftSwipeRecognizer.delegate = self;
        [self.view addGestureRecognizer:leftSwipeRecognizer];
        [self.connectionsDetailViewController.view addGestureRecognizer:leftSwipeRecognizer];
        
        UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(didSwipeRight:)];
        rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        rightSwipeRecognizer.delegate = self;
        [self.connectionsDetailViewController.view addGestureRecognizer:rightSwipeRecognizer];
        
    }
    return self;
}

- (void) moveConnectionsResultOverviewtableviewToTopRow {
    if (self.connectionsOverviewViewController) {
        [self.connectionsOverviewViewController moveTableviewToToRow];
    }
}

- (void) pushBackController:(id)sender {
    
#ifdef IncludeDetailedTrainlinesiPhone
    [[TrainLinesController sharedTrainLinesController] cancelConReqTrainlineOperations];
#endif
    
    [self cancelCurrentRunningRequestsIfAny];
    
    if (self.viewMode == 1) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didTriggerPushback:)]) {
            [self.delegate didTriggerPushback: self];
        }
        
        //[self.navigationController popViewControllerAnimated: YES];
    } else if (self.viewMode == 2) {
        [self didSwipeRight: nil];
    }
    
}

-(void) forcePushBackToPreviousViewController {
#ifdef LOGOUTPUTON
    NSLog(@"ConnectionsContainerViewController force push back");
#endif
    
#ifdef IncludeDetailedTrainlinesiPhone
    [[TrainLinesController sharedTrainLinesController] cancelConReqTrainlineOperations];
#endif
    
    [self cancelCurrentRunningRequestsIfAny];
    
    if (self.viewMode == 1) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didTriggerPushback:)]) {
            [self.delegate didTriggerPushback: self];
        }
        
        //[self.navigationController popViewControllerAnimated: NO];
    } else if (self.viewMode == 2) {
#ifdef LOGOUTPUTON
        NSLog(@"ConnectionsContainerViewController force push back. Swipe journey detail view controller left.");
#endif
        
        [self didSwipeRight: nil];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didTriggerPushback:)]) {
            [self.delegate didTriggerPushback: self];
        }
        
        //[self.navigationController popViewControllerAnimated: NO];
    }
}

/*
 - (void)  selectConnectionsJourneyDetailMapView:(id)sender {
 [self.connectionsJourneyDetailViewController switchToMapViewAsConnectionJourneyDetailView];
 }
 
 - (void)  selectConnectionsJourneyDetailListView:(id)sender {
 [self.connectionsJourneyDetailViewController switchToListViewAsConnectionJourneyDetailView];
 }
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (NSString *) shortenStationNameIfTooLong:(NSString *)stationName maxLenth:(NSUInteger)maxLength {
    if (!stationName) return  nil; if (maxLength == 0) return  nil;
    NSString *shortenStationName;
    if ([stationName length] > maxLength) {
        shortenStationName = [stationName substringToIndex: maxLength - 3];
        return [NSString stringWithFormat:@"%@...", shortenStationName];
    }
    return stationName;
}

- (void) dispatchViewAppearsAdjustments {
    [self.connectionsOverviewViewController adjustForViewWillAppear];
    [self.connectionsDetailViewController adjustForViewWillAppear];
    [self.connectionsJourneyDetailViewController adjustForViewWillAppear];
}

- (void) dispatchViewDisappearsAdjustments {
    [self.connectionsOverviewViewController adjustForViewWillDisappear];
    [self.connectionsDetailViewController adjustForViewWillDisappear];
    [self.connectionsJourneyDetailViewController adjustForViewWillDisappear];
}

- (void) updateConnectionsController {
    if ([[SBBAPIController sharedSBBAPIController] getNumberOfConnectionResults] > 0) {
        
        //double delayInSeconds = 0.1;
        //dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        //dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            [self.connectionsOverviewViewController.overViewTableView reloadData];
        //});
        
        if (self.selectedOverviewIndex < 0) {
            self.selectedOverviewIndex = 0;
            self.connectionsDetailViewController.selectedIndex = 0;
            [self.connectionsOverviewViewController.overViewTableView selectRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection:0] animated: YES scrollPosition:UITableViewScrollPositionNone];
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                [self.connectionsDetailViewController.detailViewTableView reloadData];
                [self.connectionsDetailViewController.detailViewTableView setContentOffset:CGPointZero animated:NO];
            });
            
            ConOverview *overView = [[SBBAPIController sharedSBBAPIController] getOverviewForConnectionResultWithIndex: 0];
            ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: 0 consectionIndex: 0];
            
            self.timeLabel.text = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForConsection: conSection];
            self.dateLabel.text = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForOverview: overView];
            
            NSString *startStationName; NSString *endStationName;
            startStationName = [[SBBAPIController sharedSBBAPIController] getBetterDepartureStationNameForConnectionResultWithIndex: 0];
            endStationName = [[SBBAPIController sharedSBBAPIController] getBetterArrivalStationNameForConnectionResultWithIndex: 0];
            
            self.startStationLabel.text = [self shortenStationNameIfTooLong: startStationName maxLenth: 21];
            self.endStationLabel.text = [self shortenStationNameIfTooLong: endStationName maxLenth: 21];
            
            //self.startStationLabel.text = [self shortenStationNameIfTooLong:[[SBBAPIController sharedSBBAPIController] getDepartureStationNameForOverview: overView] maxLenth: 26];
            //self.endStationLabel.text = [self shortenStationNameIfTooLong:[[SBBAPIController sharedSBBAPIController] getArrivalStationNameForOverview: overView] maxLenth: 26];
            
        } else {
            self.selectedOverviewIndex = 0;
            [self.connectionsOverviewViewController.overViewTableView selectRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection:0] animated: YES scrollPosition:UITableViewScrollPositionNone];
            
            //[self.connectionsOverviewViewController.overViewTableView selectRowAtIndexPath: [NSIndexPath indexPathForRow: self.selectedOverviewIndex inSection:0] animated: YES scrollPosition:UITableViewScrollPositionNone];
            
            self.connectionsDetailViewController.selectedIndex = self.selectedOverviewIndex;
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                [self.connectionsDetailViewController.detailViewTableView reloadData];
                [self.connectionsDetailViewController.detailViewTableView setContentOffset:CGPointZero animated:NO];
            });
            
            ConOverview *overView = [[SBBAPIController sharedSBBAPIController] getOverviewForConnectionResultWithIndex: self.selectedOverviewIndex];
            
            ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.selectedOverviewIndex consectionIndex: 0];
            
            self.timeLabel.text = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForConsection: conSection];
            self.dateLabel.text = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForOverview: overView];
            
            NSString *startStationName; NSString *endStationName;
            startStationName = [[SBBAPIController sharedSBBAPIController] getBetterDepartureStationNameForConnectionResultWithIndex: self.selectedOverviewIndex];
            endStationName = [[SBBAPIController sharedSBBAPIController] getBetterArrivalStationNameForConnectionResultWithIndex: self.selectedOverviewIndex];
            
            self.startStationLabel.text = [self shortenStationNameIfTooLong: startStationName maxLenth: 21];
            self.endStationLabel.text = [self shortenStationNameIfTooLong: endStationName maxLenth: 21];
            
            //self.startStationLabel.text = [self shortenStationNameIfTooLong:[[SBBAPIController sharedSBBAPIController] getDepartureStationNameForOverview: overView] maxLenth: 26];
            //self.endStationLabel.text = [self shortenStationNameIfTooLong:[[SBBAPIController sharedSBBAPIController] getArrivalStationNameForOverview: overView] maxLenth: 26];
        }
        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self performSelector: @selector(selectOverviewcellAndLoadDetailview) withObject: self afterDelay: 0.1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    #ifdef LOGOUTPUTON
    NSLog(@"ConnectionsContainerViewController: viewwillappear");
    #endif
    
    //[self.connectionsOverviewViewController.overViewTableView reloadData];
}


- (void)didSelectOverviewCellWithIndex:(ConnectionsOverviewViewController *)controller index:(NSUInteger)index {
    //NSLog(@"ConnectionContainerViewController didSelectOverviewCellWithIndex received");
    
    [self cancelCurrentRunningRequestsIfAny];
    
    [self.connectionsJourneyDetailViewController leaveLocationHeadingMode];
    
    self.selectedOverviewIndex = index;
    
    ConOverview *overView = [[SBBAPIController sharedSBBAPIController] getOverviewForConnectionResultWithIndex: index];
    ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: index consectionIndex: 0];
    
    self.timeLabel.text = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForConsection: conSection];
    self.dateLabel.text = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForOverview: overView];
    
    //self.startStationLabel.text = [self shortenStationNameIfTooLong:[[SBBAPIController sharedSBBAPIController] getDepartureStationNameForOverview: overView] maxLenth: 26];
    //self.endStationLabel.text = [self shortenStationNameIfTooLong:[[SBBAPIController sharedSBBAPIController] getArrivalStationNameForOverview: overView] maxLenth: 26];
    
    NSString *startStationName; NSString *endStationName;
    startStationName = [[SBBAPIController sharedSBBAPIController] getBetterDepartureStationNameForConnectionResultWithIndex: index];
    endStationName = [[SBBAPIController sharedSBBAPIController] getBetterArrivalStationNameForConnectionResultWithIndex: index];
    
    self.startStationLabel.text = [self shortenStationNameIfTooLong: startStationName maxLenth: 21];
    self.endStationLabel.text = [self shortenStationNameIfTooLong: endStationName maxLenth: 21];
    
    [self.connectionsDetailViewController updateDetailviewTableViewWithOverviewIndex: index];
}

- (void)didSelectDetailviewCellWithIndex:(ConnectionsDetailViewController *)controller index:(NSUInteger)index {
    
    [self.connectionsJourneyDetailViewController leaveLocationHeadingMode];
    
    [self.connectionsJourneyDetailViewController stopAllMapTransactions];
    [self.connectionsJourneyDetailViewController setJourneyDetailWithConnectionAndConsectionIndex: self.selectedOverviewIndex consectionIndex: index];
}

- (void)didTriggerDetailviewCellWithIndexLongPress:(ConnectionsDetailViewController *)controller index:(NSUInteger)index {
    
    [self.connectionsJourneyDetailViewController leaveLocationHeadingMode];
    
    //NSLog(@"ConnectionsContainerView: detailview did trigger long press on cell: %d", index);
    if (self.viewMode == 2) {
        [self.connectionsJourneyDetailViewController openMapsAppForRoutingIfWalkTypeWithConnectionAndConsectionIndex: self.selectedOverviewIndex consectionIndex: index];
    }
}

- (IBAction)didSwipeLeft:(id)sender {
    
    [self cancelCurrentRunningRequestsIfAny];
    
    [self.connectionsJourneyDetailViewController switchToMapViewAsConnectionJourneyDetailView];
    
    [self.connectionsDetailViewController setSelectableStateOfTableViewAndReload: YES];
    self.viewMode = 2;
    self.showJourneyDetailButton.alpha = 0.0;
    self.shareButton.alpha = 0.0;
    self.calendaralarmButton.alpha = 0.0;
    [self.connectionsViewControllerContainerView showOrigamiTransitionWith: self.connectionsJourneyDetailViewController.view
                                                             NumberOfFolds:2
                                                                  Duration:0.3
                                                                 Direction:XYOrigamiDirectionFromRight
                                                                completion:^(BOOL finished) {
                                                                    //self.closeBtn.hidden = NO;
                                                                    //self.connectionsOverviewViewController.view.hidden = YES;
                                                                    //self.mapButton.alpha = 1.0;
                                                                    //self.listButton.alpha = 1.0;
                                                                    self.navSC.alpha = 1.0;

                                                                    //[self.connectionsDetailViewController.detailViewTableView selectRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection:0] animated: NO scrollPosition: UITableViewScrollPositionTop];
                                                                    //[self.connectionsJourneyDetailViewController setJourneyDetailWithConnectionAndConsectionIndex: self.selectedOverviewIndex consectionIndex: 0];
                                                                    
                                                                    [self.connectionsJourneyDetailViewController setJourneyDetailWithConnectionAndConsectionIndex: self.selectedOverviewIndex consectionIndex: 9999];
                                                                    
                                                                    NSString *startStationName; NSString *endStationName;
                                                                    startStationName = [[SBBAPIController sharedSBBAPIController] getBetterDepartureStationNameForConnectionResultWithIndex: self.selectedOverviewIndex];
                                                                    endStationName = [[SBBAPIController sharedSBBAPIController] getBetterArrivalStationNameForConnectionResultWithIndex: self.selectedOverviewIndex];
                                                                    
                                                                    self.startStationLabel.text = [self shortenStationNameIfTooLong: startStationName maxLenth: 18];
                                                                    self.endStationLabel.text = [self shortenStationNameIfTooLong: endStationName maxLenth: 18];
                                                                    
                                                                }];
    
    
}

- (IBAction)didSwipeRight:(id)sender {
    
#ifdef IncludeDetailedTrainlinesiPhone
    [[TrainLinesController sharedTrainLinesController] cancelConReqTrainlineOperations];
#endif
    
    [self.connectionsJourneyDetailViewController stopAllMapTransactionsAndRemoveOverlayAndAnnotations];
    [self.connectionsDetailViewController setSelectableStateOfTableViewAndReload: NO];
    [self.connectionsJourneyDetailViewController leaveLocationHeadingMode];
    self.viewMode = 1;
    //self.mapButton.alpha = 0.0;
    //self.listButton.alpha = 0.0;
    self.navSC.alpha = 0.0;

    [self.connectionsViewControllerContainerView hideOrigamiTransitionWith:self.connectionsJourneyDetailViewController.view
                                                             NumberOfFolds:2
                                                                  Duration:0.3
                                                                 Direction:XYOrigamiDirectionFromRight
                                                                completion:^(BOOL finished) {
                                                                    self.showJourneyDetailButton.alpha = 1.0;
                                                                    self.shareButton.alpha = 1.0;
                                                                    self.calendaralarmButton.alpha = 1.0;
                                                                    //self.connectionsOverviewViewController.view.hidden = NO;
                                                                    NSString *startStationName; NSString *endStationName;
                                                                    startStationName = [[SBBAPIController sharedSBBAPIController] getBetterDepartureStationNameForConnectionResultWithIndex: self.selectedOverviewIndex];
                                                                    endStationName = [[SBBAPIController sharedSBBAPIController] getBetterArrivalStationNameForConnectionResultWithIndex: self.selectedOverviewIndex];
                                                                    
                                                                    self.startStationLabel.text = [self shortenStationNameIfTooLong: startStationName maxLenth: 21];
                                                                    self.endStationLabel.text = [self shortenStationNameIfTooLong: endStationName maxLenth: 21];
                                                                }];
    
}

-(void) cancelCurrentRunningRequestsIfAny {
    
    [self.connectionsOverviewViewController resetTopLoadMoreViewWithNewRowsCount:0];
    [self.connectionsOverviewViewController resetBottomLoadMoreViewWithNewRowsCount:0];
    
    [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIConreqOperations];
    
    /*
     if ([[SBBAPIController sharedSBBAPIController] conreqRequestInProgress]) {
     [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIConreqOperations];
     }
     */
}

- (void)didTriggerLoadMoreTop {
    [self cancelCurrentRunningRequestsIfAny];
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable)
    {
        [self.connectionsOverviewViewController resetTopLoadMoreViewWithNewRowsCount:0];
        
        UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        [[NoticeviewMessages sharedNoticeMessagesController] showNoNetworkErrorMessage: currentWindow];
        
        return;
    }
    
    [[SBBAPIController sharedSBBAPIController] sendConScrXMLConnectionRequest: conscrBackward
                                                                 successBlock: ^(NSUInteger numberofnewresults){
                                                                     
                                                                     if (numberofnewresults > 0) {
                                                                         [self.connectionsOverviewViewController resetTopLoadMoreViewWithNewRowsCount: numberofnewresults];
                                                                         NSUInteger indexsave = self.selectedOverviewIndex;
                                                                         self.selectedOverviewIndex = indexsave + numberofnewresults;
                                                                     } else {
                                                                         [self.connectionsOverviewViewController resetTopLoadMoreViewWithNewRowsCount:0];
                                                                         [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqDidNotReturnAnyResultNotice: self.view];
                                                                     }
                                                                 }
                                                                 failureBlock: ^(NSUInteger errorcode){
                                                                     [self.connectionsOverviewViewController resetTopLoadMoreViewWithNewRowsCount:0];
                                                                     
                                                                     //NSUInteger kConReqRequestFailureConnectionFailed = 85;
                                                                     //NSUInteger kConScrRequestFailureConnectionFailed = 45;
                                                                     //NSUInteger kStbReqRequestFailureConnectionFailed = 75;
                                                                     //NSUInteger kStbScrRequestFailureConnectionFailed = 51;
                                                                     //NSUInteger kJrnReqRequestFailureConnectionFailed = 65;
                                                                     //NSUInteger kRssReqRequestFailureConnectionFailed = 95;
                                                                     //NSUInteger kConScrRequestFailureCancelled = 4599;
                                                                     //NSUInteger kConScrRequestFailureNoNewResults = 4566;
                                                                     
                                                                     //NSUInteger kSbbReqStationsNotDefined = 112;
                                                                     
                                                                     if (errorcode == kConScrRequestFailureConnectionFailed) {
                                                                         [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqFailedNotice:self.view];
                                                                     } else if (errorcode == kSbbReqStationsNotDefined) {
                                                                         [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqStationsNotAvailableNotice:self.view];
                                                                     } else if (errorcode == kConScrRequestFailureCancelled) {
                                                                         // Nothing to do
                                                                     } else if (errorcode == kConScrRequestFailureNoNewResults) {
                                                                         // Nothing to do
                                                                     } else {
                                                                         [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqOtherUndefinedErrorNotice:self.view];
                                                                     }
                                                                 }];
    
}

- (void)didTriggerLoadMoreBottom {
    [self cancelCurrentRunningRequestsIfAny];
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable)
    {
        
        [self.connectionsOverviewViewController resetBottomLoadMoreViewWithNewRowsCount:0];
        
        UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        [[NoticeviewMessages sharedNoticeMessagesController] showNoNetworkErrorMessage: currentWindow];
        
        return;
    }
    
    [[SBBAPIController sharedSBBAPIController] sendConScrXMLConnectionRequest: conscrForward
                                                                 successBlock: ^(NSUInteger numberofnewresults){
                                                                     
                                                                     
                                                                     if (numberofnewresults > 0) {
                                                                         [self.connectionsOverviewViewController resetBottomLoadMoreViewWithNewRowsCount:numberofnewresults];
                                                                         NSUInteger indexsave = self.selectedOverviewIndex;
                                                                         self.selectedOverviewIndex = indexsave;
                                                                     } else {
                                                                         [self.connectionsOverviewViewController resetBottomLoadMoreViewWithNewRowsCount:0];
                                                                         [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqDidNotReturnAnyResultNotice: self.view];
                                                                     }
                                                                 }
                                                                 failureBlock: ^(NSUInteger errorcode){
                                                                     [self.connectionsOverviewViewController resetBottomLoadMoreViewWithNewRowsCount:0];
                                                                     
                                                                     //NSUInteger kConReqRequestFailureConnectionFailed = 85;
                                                                     //NSUInteger kConScrRequestFailureConnectionFailed = 45;
                                                                     //NSUInteger kStbReqRequestFailureConnectionFailed = 75;
                                                                     //NSUInteger kStbScrRequestFailureConnectionFailed = 51;
                                                                     //NSUInteger kJrnReqRequestFailureConnectionFailed = 65;
                                                                     //NSUInteger kRssReqRequestFailureConnectionFailed = 95;
                                                                     //NSUInteger kConScrRequestFailureCancelled = 4599;
                                                                     //NSUInteger kConScrRequestFailureNoNewResults = 4566;
                                                                     
                                                                     //NSUInteger kSbbReqStationsNotDefined = 112;
                                                                     
                                                                     if (errorcode == kConScrRequestFailureConnectionFailed) {
                                                                         [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqFailedNotice:self.view];
                                                                     } else if (errorcode == kSbbReqStationsNotDefined) {
                                                                         [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqStationsNotAvailableNotice:self.view];
                                                                     } else if (errorcode == kConScrRequestFailureCancelled) {
                                                                         // Nothing to do
                                                                     } else if (errorcode == kConScrRequestFailureNoNewResults) {
                                                                         // Nothing to do
                                                                     } else {
                                                                         [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqOtherUndefinedErrorNotice:self.view];
                                                                     }
                                                                     
                                                                 }];
    
}

- (void)didTriggerOverviewCellWithIndexLongPress:(ConnectionsOverviewViewController *)controller index:(NSUInteger)index {
#ifdef LOGOUTPUTON
    NSLog(@"ConnectionsContainerView: overview did trigger long press on cell: %d", index);
#endif
    
    BOOL connectionHasInfo = [[SBBAPIController sharedSBBAPIController] ConnectionResultWithIndexHasInfos: index];
    
#ifdef LOGOUTPUTON
    NSLog(@"ConnectionsContainerView: connecton has info: %@", connectionHasInfo?@"Y":@"N");
#endif
    
    if (connectionHasInfo) {
        ConnectionInfoViewController *connectionInfoViewController = [[ConnectionInfoViewController alloc] init];
        [connectionInfoViewController updateConnectionInfoTableViewWithInfoFromConnectionWithIndex: index];
        
        FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController: connectionInfoViewController];
        
        popover.tint = FPPopoverDefaultTint;
        popover.contentSize = CGSizeMake(200, 300);
        popover.arrowDirection = FPPopoverArrowDirectionLeft;
        
        [popover presentPopoverFromView: [controller.overViewTableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow: index inSection:0]]];
    }
}

-(void) cancelAlarm:(UILocalNotification *)alarm {
    
	NSDate *alarmDate = [alarm.userInfo valueForKey:@"date"];
    NSNumber *alarmType = [alarm.userInfo valueForKey:@"title"];
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *alarmArray = [app scheduledLocalNotifications];
    
    NSLog(@"Trying to cancel alarm %@ date date:%@, type:%@", alarm.alertBody, alarmDate, alarmType);
    for (int i=0; i<[alarmArray count]; i++) {
        UILocalNotification* oneAlarm = [alarmArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneAlarm.userInfo;
        NSDate *dateCurrent = [userInfoCurrent valueForKey:@"date"];
        NSNumber *typeCurrent = [userInfoCurrent valueForKey:@"title"];
        NSLog(@"Found scheduled alarm with date:%@, type:%@", dateCurrent,typeCurrent);
        if (dateCurrent == nil || typeCurrent == nil) continue;
        if (oneAlarm == alarm || ([dateCurrent compare:alarmDate] == NSOrderedSame && [typeCurrent compare:alarmType] == NSOrderedSame)) {
            NSLog(@"Cancelling alarm: %@", oneAlarm.alertBody);
            [app cancelLocalNotification:oneAlarm];
        }
    }
    
}

- (void) cancelAllAlarms {
    UIApplication* app = [UIApplication sharedApplication];
    NSArray *alarmNotifications = [app scheduledLocalNotifications];
    
    if ([alarmNotifications count] > 0)
        [app cancelAllLocalNotifications];
}

- (void)showcalendarAlarmActionSheet:(id) sender {
    
    __block BOOL accessGranted = NO;
    
    EKEventStore *store = [[EKEventStore alloc] init];
    
    if([store respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    } else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    NSArray *basicStopList = [[SBBAPIController sharedSBBAPIController] getAllBasicStopsForConnectionResultWithIndex: self.selectedOverviewIndex];
    ConOverview *overview = [[SBBAPIController sharedSBBAPIController] getOverviewForConnectionResultWithIndex: self.selectedOverviewIndex];
    NSUInteger durationhours = [overview getHoursFromDuration];
    NSUInteger durationminutes = [overview getMinutesFromDuration];
    NSUInteger durationseconds = durationminutes * 60 + durationhours * 60 * 60;
    
    NSString *plainTextString = [[SBBAPIController sharedSBBAPIController] getPlaintextSharetextForConnectionResultWithIndex: self.selectedOverviewIndex];
    
    if ([basicStopList count] >= 2) {
        NSString *fromStationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList objectAtIndex: 0]];
        NSString *toStationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList lastObject]];
        //NSString *arrivalTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForBasicStop: [basicStopList lastObject]];
        NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForBasicStop: [basicStopList objectAtIndex: 0]];
        
        ConOverview *overview = [[SBBAPIController sharedSBBAPIController] getOverviewForConnectionResultWithIndex: self.selectedOverviewIndex];
        NSString *overviewConnectionDateString = [[SBBAPIController sharedSBBAPIController] getConnectionDateStringForOverview: overview];
        //NSDate *connectiondate = [[SBBAPIController sharedSBBAPIController] getConnectionDateForConnectionResultWithIndex: self.selectedOverviewIndex];
        //BOOL isDepartureTime = [[SBBAPIController sharedSBBAPIController] getConnectionDateIsDepartureFlagForConnectionResultWithIndex: self.selectedOverviewIndex];
        
        NSString *title = [NSString stringWithFormat: NSLocalizedString(@"Journey: %@ - %@", @"Journey calendar title"), fromStationName, toStationName];
        
        //NSDate *connectiondate = [[SBBAPIController sharedSBBAPIController] getConnectionDateForConnectionResultWithIndex: self.selectedOverviewIndex];
        //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateFormat:@"yyyyMMdd"];
        //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
        //NSString *dateString = [dateFormatter stringFromDate: connectiondate];
        
        NSString *dateString = [NSString stringWithFormat: @"%@ %@", overviewConnectionDateString, departureTime];
        
        /*
        if (!isDepartureTime) {
            //NSLog(@"Is arrival time");
            dateString = [NSString stringWithFormat: @"%@ %@", overviewConnectionDateString, arrivalTime];
        }
        */
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"yyyyMMdd HH:mm"];
        //[timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
        NSDate *startdate = [timeFormatter dateFromString: dateString];
        
        //NSDateFormatter *dateFormattercheck = [[NSDateFormatter alloc] init];
        //[dateFormattercheck setDateFormat:@"dd/MM/YYYY HH:mm"];
        //NSString *stdate = [dateFormattercheck stringFromDate: startdate];
        
        //NSLog(@"Fire date: %@", stdate);
        
        RIButtonItem *cancelButton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Cancel", @"Share connection cancel block action sheet title")];
        
        RIButtonItem *addalarm5minbutton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Alarm only: - 5 min", @"Add alarm with alarm 5 min block action sheet title")];
        addalarm5minbutton.action = ^{
            NSDate *alarmdate = [startdate dateByAddingTimeInterval: -5*60];
            NSString *alarmbody = [NSString stringWithFormat: NSLocalizedString(@"Connection is leaving in %d minutes", @"Alarm leaving message"), 5];
            NSString *body = alarmbody;
            UILocalNotification *localNotification = [[UILocalNotification alloc] init]; //Create the localNotification object
            [localNotification setFireDate:alarmdate]; //Set the date when the alert will be launched using the date adding the time the user selected on the timer
            [localNotification setAlertAction:title]; //The button's text that launches the application and is shown in the alert
            [localNotification setAlertBody:body]; //Set the message in the notification from the textField's text
            [localNotification setHasAction: NO]; //Set that pushing the button will launch the application
            //[localNotification setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber]+1]; //Set the Application Icon Badge Number of the application's icon to the current Application Icon Badge Number plus 1
            [localNotification setApplicationIconBadgeNumber:0];
            
            //localNotification.timeZone = [NSTimeZone defaultTimeZone];
            //localNotification.repeatInterval = 5;
            localNotification.soundName = @"Ambient.caf";
            localNotification.userInfo = [NSDictionary
                                          dictionaryWithObjects:[NSArray arrayWithObjects:alarmdate,title,nil]
                                          forKeys:[NSArray arrayWithObjects: @"date",@"title",nil]];
            //localNotification.alertBody = @"Staff meeting in 30 minutes";
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification]; //Schedule the notification with the system
            [[NoticeviewMessages sharedNoticeMessagesController] showAlarmEntryAdded: self.view];
        };
        
        
        RIButtonItem *addalarm15minbutton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Alarm only: - 15 min", @"Add alarm with alarm 15 min block action sheet title")];
        addalarm15minbutton.action = ^{
            NSDate *alarmdate = [startdate dateByAddingTimeInterval: -15*60];
            NSString *alarmbody = [NSString stringWithFormat: NSLocalizedString(@"Connection is leaving in %d minutes", @"Alarm leaving message"), 15];
            NSString *body = alarmbody;;
            UILocalNotification *localNotification = [[UILocalNotification alloc] init]; //Create the localNotification object
            [localNotification setFireDate:alarmdate]; //Set the date when the alert will be launched using the date adding the time the user selected on the timer
            [localNotification setAlertAction:title]; //The button's text that launches the application and is shown in the alert
            [localNotification setAlertBody:body]; //Set the message in the notification from the textField's text
            [localNotification setHasAction: NO]; //Set that pushing the button will launch the application
            //[localNotification setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber]+1]; //Set the Application Icon Badge Number of the application's icon to the current Application Icon Badge Number plus 1
            [localNotification setApplicationIconBadgeNumber:0];
            //localNotification.repeatInterval = 5;
            localNotification.soundName = @"Ambient.caf";
            localNotification.userInfo = [NSDictionary
                                          dictionaryWithObjects:[NSArray arrayWithObjects:alarmdate,title,nil]
                                          forKeys:[NSArray arrayWithObjects: @"date",@"title",nil]];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification]; //Schedule the notification with the system
            [[NoticeviewMessages sharedNoticeMessagesController] showAlarmEntryAdded: self.view];
        };
        
        RIButtonItem *addalarm30minbutton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Alarm only: - 30 min", @"Add alarm with alarm 30 min block action sheet title")];
        addalarm30minbutton.action = ^{
            NSDate *alarmdate = [startdate dateByAddingTimeInterval: -30*60];
            NSString *alarmbody = [NSString stringWithFormat: NSLocalizedString(@"Connection is leaving in %d minutes", @"Alarm leaving message"), 30];
            NSString *body = alarmbody;
            UILocalNotification *localNotification = [[UILocalNotification alloc] init]; //Create the localNotification object
            [localNotification setFireDate:alarmdate]; //Set the date when the alert will be launched using the date adding the time the user selected on the timer
            [localNotification setAlertAction:title]; //The button's text that launches the application and is shown in the alert
            [localNotification setAlertBody:body]; //Set the message in the notification from the textField's text
            [localNotification setHasAction: NO]; //Set that pushing the button will launch the application
            //[localNotification setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber]+1]; //Set the Application Icon Badge Number of the application's icon to the current Application Icon Badge Number plus 1
            [localNotification setApplicationIconBadgeNumber:0];
            //localNotification.repeatInterval = 5;
            localNotification.soundName = @"Ambient.caf";
            localNotification.userInfo = [NSDictionary
                                          dictionaryWithObjects:[NSArray arrayWithObjects:alarmdate,title,nil]
                                          forKeys:[NSArray arrayWithObjects: @"date",@"title",nil]];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification]; //Schedule the notification with the system
            [[NoticeviewMessages sharedNoticeMessagesController] showAlarmEntryAdded: self.view];
        };
        
        RIButtonItem *addalarm60minbutton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Alarm only: - 60 min", @"Add alarm with alarm 60 min block action sheet title")];
        addalarm60minbutton.action = ^{
            NSDate *alarmdate = [startdate dateByAddingTimeInterval: -60*60];
            NSString *alarmbody = [NSString stringWithFormat: NSLocalizedString(@"Connection is leaving in %d minutes", @"Alarm leaving message"), 60];
            NSString *body = alarmbody;
            UILocalNotification *localNotification = [[UILocalNotification alloc] init]; //Create the localNotification object
            [localNotification setFireDate:alarmdate]; //Set the date when the alert will be launched using the date adding the time the user selected on the timer
            [localNotification setAlertAction:title]; //The button's text that launches the application and is shown in the alert
            [localNotification setAlertBody:body]; //Set the message in the notification from the textField's text
            [localNotification setHasAction: NO]; //Set that pushing the button will launch the application
            //[localNotification setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber]+1]; //Set the Application Icon Badge Number of the application's icon to the current Application Icon Badge Number plus 1
            [localNotification setApplicationIconBadgeNumber:0];
            //localNotification.repeatInterval = 5;
            localNotification.soundName = @"Ambient.caf";
            localNotification.userInfo = [NSDictionary
                                          dictionaryWithObjects:[NSArray arrayWithObjects:alarmdate,title,nil]
                                          forKeys:[NSArray arrayWithObjects: @"date",@"title",nil]];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification]; //Schedule the notification with the system
            [[NoticeviewMessages sharedNoticeMessagesController] showAlarmEntryAdded: self.view];
        };
        
        if (accessGranted) {
            NSString *fromStationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList objectAtIndex: 0]];
            NSString *toStationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList lastObject]];
            //NSString *arrivalTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForBasicStop: [basicStopList lastObject]];
            NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForBasicStop: [basicStopList objectAtIndex: 0]];
            
            ConOverview *overview = [[SBBAPIController sharedSBBAPIController] getOverviewForConnectionResultWithIndex: self.selectedOverviewIndex];
            NSString *overviewConnectionDateString = [[SBBAPIController sharedSBBAPIController] getConnectionDateStringForOverview: overview];
            //NSDate *connectiondate = [[SBBAPIController sharedSBBAPIController] getConnectionDateForConnectionResultWithIndex: self.selectedOverviewIndex];
            //BOOL isDepartureTime = [[SBBAPIController sharedSBBAPIController] getConnectionDateIsDepartureFlagForConnectionResultWithIndex: self.selectedOverviewIndex];
            
            NSString *title = [NSString stringWithFormat: @"%@ - %@", fromStationName, toStationName];
            //NSLog(@"Calendar entry title: %@", title);
            
            //NSDate *connectiondate = [[SBBAPIController sharedSBBAPIController] getConnectionDateForConnectionResultWithIndex: self.selectedOverviewIndex];
            //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //[dateFormatter setDateFormat:@"yyyyMMdd"];
            //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
            //NSString *dateString = [dateFormatter stringFromDate: connectiondate];
            
            NSString *dateString = [NSString stringWithFormat: @"%@ %@", overviewConnectionDateString, departureTime];
            
            /*
            if (!isDepartureTime) {
                //NSLog(@"Is arrival time");
                dateString = [NSString stringWithFormat: @"%@ %@", overviewConnectionDateString, arrivalTime];
            }
            */
            
            NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
            [timeFormatter setDateFormat:@"yyyyMMdd HH:mm"];
            //[timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
            NSDate *startdate = [timeFormatter dateFromString: dateString];
            
            //NSLog(@"dt: %@", dateString);
            //NSString *dateandtimestring = [NSString stringWithFormat: @"%@ %@", dateString, departureTime];
            //NSLog(@"dte: %@", dateandtimestring);
            
            NSDate *enddate = [startdate dateByAddingTimeInterval: durationseconds];
            
            //NSDateFormatter *dateFormattercheck = [[NSDateFormatter alloc] init];
            //[dateFormattercheck setDateFormat:@"dd/MM/YYYY HH:mm"];
            //NSString *stdate = [dateFormattercheck stringFromDate: startdate];
            //NSString *endate = [dateFormattercheck stringFromDate: enddate];
            //NSString *cndate = [dateFormattercheck stringFromDate: connectiondate];
            //NSLog(@"Dates: %@, %@", stdate, endate);
            //NSLog(@"Condate: %@", cndate);
            
            RIButtonItem *addtocalendarbutton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Calendar: add only", @"Add to calendar block action sheet title")];
            addtocalendarbutton.action = ^{
                // To implement
                
                EKEvent *addEvent=[EKEvent eventWithEventStore:store];
                addEvent.title=title;
                addEvent.startDate=startdate;
                addEvent.endDate=enddate;
                addEvent.notes = plainTextString;
                [addEvent setCalendar:[store defaultCalendarForNewEvents]];
                //addEvent.notes = notes;
                [store saveEvent:addEvent span:EKSpanThisEvent error:nil];
                [[NoticeviewMessages sharedNoticeMessagesController] showCalendarEntryAdded: self.view];
            };
            
            RIButtonItem *addtocalendarwithalarm15minbutton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Calendar & alarm: -15 min", @"Add to calendar with alarm 15 min block action sheet title")];
            addtocalendarwithalarm15minbutton.action = ^{
                EKEvent *addEvent=[EKEvent eventWithEventStore:store];
                addEvent.title=title;
                addEvent.startDate=startdate;
                addEvent.endDate=enddate;
                addEvent.notes = plainTextString;
                [addEvent setCalendar:[store defaultCalendarForNewEvents]];
                //addEvent.notes = notes;
                NSDate *alarmdate = [startdate dateByAddingTimeInterval: -15*60];
                addEvent.alarms=[NSArray arrayWithObject:[EKAlarm alarmWithAbsoluteDate:alarmdate]];
                [store saveEvent:addEvent span:EKSpanThisEvent error:nil];
                [[NoticeviewMessages sharedNoticeMessagesController] showCalendarEntryAdded: self.view];
            };
            
            RIButtonItem *addtocalendarwithalarm30minbutton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Calendar & alarm: -30 min", @"Add to calendar with alarm 30 min block action sheet title")];
            addtocalendarwithalarm30minbutton.action = ^{
                EKEvent *addEvent=[EKEvent eventWithEventStore:store];
                addEvent.title=title;
                addEvent.startDate=startdate;
                addEvent.endDate=enddate;
                addEvent.notes = plainTextString;
                [addEvent setCalendar:[store defaultCalendarForNewEvents]];
                //addEvent.notes = notes;
                NSDate *alarmdate = [startdate dateByAddingTimeInterval: -30*60];
                addEvent.alarms=[NSArray arrayWithObject:[EKAlarm alarmWithAbsoluteDate:alarmdate]];
                [store saveEvent:addEvent span:EKSpanThisEvent error:nil];
                [[NoticeviewMessages sharedNoticeMessagesController] showCalendarEntryAdded: self.view];
            };
            
            RIButtonItem *addtocalendarwithalarm60minbutton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Calendar & alarm: -60 min", @"Add to calendar with alarm 60 min block action sheet title")];
            addtocalendarwithalarm60minbutton.action = ^{
                EKEvent *addEvent=[EKEvent eventWithEventStore:store];
                addEvent.title=title;
                addEvent.startDate=startdate;
                addEvent.endDate=enddate;
                addEvent.notes = plainTextString;
                [addEvent setCalendar:[store defaultCalendarForNewEvents]];
                //addEvent.notes = notes;
                NSDate *alarmdate = [startdate dateByAddingTimeInterval: -60*60];
                addEvent.alarms=[NSArray arrayWithObject:[EKAlarm alarmWithAbsoluteDate:alarmdate]];
                [store saveEvent:addEvent span:EKSpanThisEvent error:nil];
                [[NoticeviewMessages sharedNoticeMessagesController] showCalendarEntryAdded: self.view];
            };
            
            UIActionSheet *addalarmActionSheet = [[UIActionSheet alloc] initWithTitle: NSLocalizedString(@"Add alarm / to calendar", @"Add alarm block action sheet title") cancelButtonItem: cancelButton destructiveButtonItem: nil otherButtonItems: addtocalendarbutton, addtocalendarwithalarm15minbutton, addtocalendarwithalarm30minbutton, addtocalendarwithalarm60minbutton, addalarm5minbutton, addalarm15minbutton, addalarm30minbutton, addalarm60minbutton, nil];
            
            addalarmActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            
            [addalarmActionSheet showInView: self.view];
            
            if(addalarmActionSheet.subviews.count > 0 && [[addalarmActionSheet.subviews objectAtIndex:0] isKindOfClass:[UILabel class]]) {
                UILabel* l = (UILabel*) [addalarmActionSheet.subviews objectAtIndex:0];
                [l setFont:[UIFont boldSystemFontOfSize:16]];
                [l setTextColor: [UIColor whiteColor]];
            }

        } else {
            [[NoticeviewMessages sharedNoticeMessagesController] showCalendarAccessDenied: self.view];
            
            UIActionSheet *addalarmActionSheet = [[UIActionSheet alloc] initWithTitle: NSLocalizedString(@"Add alarm / to calendar", @"Add alarm block action sheet title") cancelButtonItem: cancelButton destructiveButtonItem: nil otherButtonItems: addalarm5minbutton, addalarm15minbutton, addalarm30minbutton, addalarm60minbutton,nil];
            
            addalarmActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            
            [addalarmActionSheet showInView: self.view];
            
            if(addalarmActionSheet.subviews.count > 0 && [[addalarmActionSheet.subviews objectAtIndex:0] isKindOfClass:[UILabel class]]) {
                UILabel* l = (UILabel*) [addalarmActionSheet.subviews objectAtIndex:0];
                [l setFont:[UIFont boldSystemFontOfSize:16]];
                [l setTextColor: [UIColor whiteColor]];
            }

        }
    }
}

- (void) shareConnection:(id) sender {
    //BlockActionSheet *shareActionSheet = [BlockActionSheet sheetWithTitle: NSLocalizedString(@"Share via", @"Share connection block action sheet title")];
    
    [self cancelCurrentRunningRequestsIfAny];
    
    RIButtonItem *cancelButton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Cancel", @"Share connection cancel block action sheet title")];
    
    RIButtonItem *emailPDFButton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Send as PDF via email", @"Share connection send per email as PDF block action sheet title")];
    emailPDFButton.action = ^{
        [self shareViaPDFEmail];
    };
    
    RIButtonItem *emailHtmlButton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Send as HTML via email", @"Share connection send per email as PDF block action sheet title")];
    emailHtmlButton.action = ^{
        [self shareViaHTMLEmail];
    };
    
    RIButtonItem *printButton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Print", @"Print block action sheet title")];
    printButton.action = ^{
        [self printConnection];
    };
        
    RIButtonItem *emailButton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Send via email", @"Share connection send per email block action sheet title")];
    emailButton.action = ^{
        [self shareViaEmail];
    };
    RIButtonItem *clipboardButton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Copy to clipboard", @"Share connection copy to clipboard block action sheet title")];
    clipboardButton.action = ^{
        [self shareByCopyingToClipboard];
    };
    
    if ([MFMailComposeViewController canSendMail]) {
        UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle: NSLocalizedString(@"Share via", @"Share connection block action sheet title") cancelButtonItem: cancelButton destructiveButtonItem: nil otherButtonItems: emailHtmlButton, emailPDFButton, printButton, emailButton, clipboardButton , nil];
        [shareActionSheet showInView: self.view];
    } else {
        UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle: NSLocalizedString(@"Share via", @"Share connection block action sheet title") cancelButtonItem: cancelButton destructiveButtonItem: nil otherButtonItems: printButton,clipboardButton , nil];
        [shareActionSheet showInView: self.view];
    }
}

- (void) mailComposeController:(MFMailComposeViewController*) mailController didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	//AudioServicesPlaySystemSound (clickSoundID);
	
	[self becomeFirstResponder];
	[mailController dismissViewControllerAnimated: YES completion: ^{}];
}

- (void) shareViaPDFEmail {
    NSString *htmlTextString = [[SBBAPIController sharedSBBAPIController] getHtmlSharetextForConnectionResultWithIndex: self.selectedOverviewIndex];
    
    //NSLog(@"Got Email text and title: %@, %@", plainTitleString, plainTextString);
    
    if (htmlTextString) {
        
        //NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *tempDirectory = NSTemporaryDirectory();
        NSString *pdfoutputPath = [tempDirectory stringByAppendingPathComponent: @"Connection.pdf"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:pdfoutputPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:pdfoutputPath error:NULL];
        }
        
        self.PDFCreator = [NDHTMLtoPDF createPDFWithHTML:htmlTextString
                                              pathForPDF:pdfoutputPath
                                                delegate:self
                                                pageSize:kPaperSizeA4
                                                 margins:UIEdgeInsetsMake(10, 5, 10, 5)];
        
        self.PDFCreator.PDFAction = [NSNumber numberWithInt: pdfActionEmail];
    }
}

- (void) shareViaHTMLEmail {
    NSString *plainTextString = [[SBBAPIController sharedSBBAPIController] getHtmlSharetextForConnectionResultWithIndex: self.selectedOverviewIndex];
    NSString *plainTitleString = [[SBBAPIController sharedSBBAPIController] getShortPlaintextTitleForConnectionResultWithIndex: self.selectedOverviewIndex];
    
    //NSLog(@"Got Email text and title: %@, %@", plainTitleString, plainTextString);
    
    if (plainTextString && plainTitleString) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.modalPresentationStyle = UIModalPresentationFullScreen;
        mailController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
		mailController.mailComposeDelegate = self;
		[mailController setSubject: plainTitleString];
        
		[mailController setMessageBody: plainTextString isHTML: YES];
		//[mailController setToRecipients:  [NSArray arrayWithObject: kSupportEmail]];
		[self presentViewController: mailController animated: YES completion: ^{}];
    }
}

- (void)HTMLtoPDFDidSucceed:(NDHTMLtoPDF*)htmlToPDF
{
    #ifdef LOGOUTPUTON
    NSLog(@"HTMLtoPDF did succeed (%@ / %@)", htmlToPDF, htmlToPDF.PDFpath);
    #endif
    
    if (htmlToPDF && htmlToPDF.PDFpath) {
        
        if ([htmlToPDF.PDFAction integerValue] == pdfActionPrint) {
            
            NSData *pdfData = [NSData dataWithContentsOfFile: htmlToPDF.PDFpath];
            
            UIPrintInteractionController *printController;
            
            Class printControllerClass = NSClassFromString(@"UIPrintInteractionController");
            if (printControllerClass) {
                printController = [printControllerClass sharedPrintController];
            } else {
                // To implement;
            }
            
            void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
            ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
                if (!completed && error) NSLog(@"Print error: %@", error);
            };
            
            printController.printingItem = pdfData;
            
            [printController presentAnimated:YES completionHandler:completionHandler];
            
        } else if ([htmlToPDF.PDFAction integerValue] == pdfActionEmail) {
            
            NSString *plainTitleString = [[SBBAPIController sharedSBBAPIController] getShortPlaintextTitleForConnectionResultWithIndex: self.selectedOverviewIndex];
            
            MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
            mailController.modalPresentationStyle = UIModalPresentationFullScreen;
            mailController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            mailController.mailComposeDelegate = self;
            [mailController setSubject: plainTitleString];
            
            NSData *pdfData = [NSData dataWithContentsOfFile:htmlToPDF.PDFpath];
            [mailController addAttachmentData:pdfData mimeType:@"application/pdf" fileName:@"Connection.pdf"];
            
            [self presentViewController: mailController animated: YES completion: ^{}];
        }
    }
    
    self.PDFCreator = nil;
}

- (void)HTMLtoPDFDidFail:(NDHTMLtoPDF*)htmlToPDF
{
    #ifdef LOGOUTPUTON
    NSLog(@"HTMLtoPDF did fail (%@)", htmlToPDF);
    #endif
    
    self.PDFCreator = nil;
}

- (void) startPrinting {
    NSString *htmlTextString = [[SBBAPIController sharedSBBAPIController] getHtmlSharetextForConnectionResultWithIndex: self.selectedOverviewIndex];
    
    //NSLog(@"Got Email text and title: %@, %@", plainTitleString, plainTextString);
    
    //NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *tempDirectory = NSTemporaryDirectory();
    NSString *pdfoutputPath = [tempDirectory stringByAppendingPathComponent: @"Connection.pdf"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:pdfoutputPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:pdfoutputPath error:NULL];
    }
    
    self.PDFCreator = [NDHTMLtoPDF createPDFWithHTML: htmlTextString
                                          pathForPDF:pdfoutputPath
                                            delegate:self
                                            pageSize:kPaperSizeA4
                                             margins:UIEdgeInsetsMake(10, 5, 10, 5)];
    
    self.PDFCreator.PDFAction = [NSNumber numberWithInt: pdfActionPrint];
}


- (void) printConnection {
    [self startPrinting];
}

- (void) shareViaEmail {
    NSString *plainTextString = [[SBBAPIController sharedSBBAPIController] getPlaintextSharetextForConnectionResultWithIndex: self.selectedOverviewIndex];
    NSString *plainTitleString = [[SBBAPIController sharedSBBAPIController] getShortPlaintextTitleForConnectionResultWithIndex: self.selectedOverviewIndex];
    
    //NSLog(@"Got Email text and title: %@, %@", plainTitleString, plainTextString);
    
    if (plainTextString && plainTitleString) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.modalPresentationStyle = UIModalPresentationFullScreen;
        mailController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
		mailController.mailComposeDelegate = self;
        mailController.wantsFullScreenLayout = YES;
		[mailController setSubject: plainTitleString];
        
        //UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        
		[mailController setMessageBody: plainTextString isHTML: NO];
		//[mailController setToRecipients:  [NSArray arrayWithObject: kSupportEmail]];
		[self presentViewController: mailController animated: YES completion: ^{}];
    }
}

- (void) shareByCopyingToClipboard {
    NSString *plainTextString = [[SBBAPIController sharedSBBAPIController] getPlaintextSharetextForConnectionResultWithIndex: self.selectedOverviewIndex];
    if (plainTextString) {
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:plainTextString];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
