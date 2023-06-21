//
//  ConnectionsContainerViewController.m
//  Swiss Trains
//
//  Created by Alain on 28.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "ConnectionsResultContainerViewController.h"

//#define TOOLBARHEIGHT 36.0
#define BUTTONHEIGHT 36.0

//#define VIEWHEIGHT 256.0
//#define BUTTONHEIGHT 36.0
#define SEGMENTHEIGHT 18.0

@interface ConnectionsResultContainerViewController ()

@end

@implementation ConnectionsResultContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.viewMode = 1;
        self.selectedOverviewIndex = -1;
        self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
    }
    return self;
}

- (void) loadView {
    CGSize size = [UIApplication currentScreenSize];
    
    //NSLog(@"ConnectionsResultContainerViewController. Screen size: %.1f, %.1f", size.width, size.height);
    
    CGFloat viewHeight = size.height - TABBARHEIGHT - TOOLBARHEIGHTIPAD;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH, viewHeight)];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = view;
    
    //NSLog(@"ConnectionsResultContainer view init: %.1f, %.1f, %.1f, %.1f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    //self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
    self.view.backgroundColor = [UIColor listviewControllersBackgroundColor];
    
    self.selectedOverviewIndex = -1;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        //self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        self.view.backgroundColor = [UIColor listviewControllersBackgroundColor];
        
        self.selectedOverviewIndex = -1;
    }
    return self;
}

- (void) layoutSubviewsWithAnimated:(BOOL)animated beforeRotation:(BOOL)beforeRotation interfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //NSLog(@"ConnectionsResultContainerViewControlleriPad layoutSubviews");
	
	CGSize size = [UIApplication currentScreenSize];
    CGSize newSize;
    if (beforeRotation) {
        if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            newSize.width = MAX(size.width, size.height) + STATUSBARHEIGHT;
            newSize.height = MIN(size.width, size.height) - STATUSBARHEIGHT;
        } else {
            newSize.height = MAX(size.width, size.height) - STATUSBARHEIGHT;
            newSize.width = MIN(size.width, size.height) + STATUSBARHEIGHT;
        }
    } else {
        newSize.width = size.width;
        newSize.height = size.height;
    }
    
    newSize.width = size.width;
    newSize.height = size.height;
    
    //NSLog(@"ConnectionsResultContainerViewControlleriPad. New size: %.1f, %.1f", newSize.width, newSize.height);
    
    if (animated) {
        [UIView beginAnimations:@"ConnectionsResultContainerViewControlleriPad LayoutSubviewWithAnimation" context:NULL];
    }
    
    self.connectionsViewControllerContainerView.frame = CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH, newSize.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT);
    self.connectionsViewControllerContainerView.backgroundColor = [UIColor redColor];

    self.connectionsOverviewViewController.view.frame = CGRectMake(0, 0, 80, self.connectionsViewControllerContainerView.frame.size.height);
    self.connectionsDetailViewController.view.frame = CGRectMake(80, 0, SPLITVIEWMAINVIEWWIDTH - 80, self.connectionsViewControllerContainerView.frame.size.height);
    
    [self.connectionsOverviewViewController adjustTableViewHeightWithRect:CGRectMake(0, 0, 80, self.connectionsViewControllerContainerView.frame.size.height) reload:NO];
    [self.connectionsDetailViewController adjustTableViewHeightWithRect:CGRectMake(80, 0, SPLITVIEWMAINVIEWWIDTH - 80, self.connectionsViewControllerContainerView.frame.size.height) reload:NO];
    
    //NSLog(@"ConnectionsResultContainerOverview: %.1f, %.1f, %.1f, %.1f", self.connectionsOverviewViewController.view.frame.origin.x, self.connectionsOverviewViewController.view.frame.origin.y, self.connectionsOverviewViewController.view.frame.size.width, self.connectionsOverviewViewController.view.frame.size.height);
    //NSLog(@"ConnectionsResultContainerDetail: %.1f, %.1f, %.1f, %.1f", self.connectionsDetailViewController.view.frame.origin.x, self.connectionsDetailViewController.view.frame.origin.y, self.connectionsDetailViewController.view.frame.size.width, self.connectionsDetailViewController.view.frame.size.height);
    
    if (animated) {
        [UIView commitAnimations];
    }
    //[self.view setNeedsDisplay];
    //[self.view setNeedsLayout];
}

- (void) layoutSubviews:(BOOL)beforeRotation toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    [self layoutSubviewsWithAnimated:NO beforeRotation: beforeRotation interfaceOrientation: toInterfaceOrientation];
}

- (void) pushBackController:(id)sender {
    
    [self cancelCurrentRunningRequestsIfAny];
}

-(void) forcePushBackToPreviousViewController {
    #ifdef LOGOUTPUTON
    NSLog(@"ConnectionsResultContainerViewController force push back");
    #endif
    
    [self cancelCurrentRunningRequestsIfAny];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSLog(@"ConnectionsResultContainer viewdidload: %.1f, %.1f, %.1f, %.1f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
	// Do any additional setup after loading the view.
    //self.stationsViewToolbar = [[StationsViewToolbar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    /*
     self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
     //UIImage *backButtonImage = [UIImage newImageFromMaskImage: [UIImage backButtonImage] inColor: [UIColor selectStationsViewButtonColorNormal]];
     //UIImage *backButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage backButtonImage] inColor: [UIColor selectStationsViewButtonColorHighlighted]];
     UIImage *backButtonImage =  [UIImage newImageFromMaskImage: [[UIImage backButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
     UIImage *backButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage backButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
     [self.backButton setImage: backButtonImage forState: UIControlStateNormal];
     [self.backButton setImage: backButtonImage forState: UIControlStateNormal];
     [self.backButton setImage: backButtonImageHighlighted forState: UIControlStateHighlighted];
     self.backButton.imageView.contentMode = UIViewContentModeCenter;
     self.backButton.frame = CGRectMake(5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
     self.backButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
     self.backButton.showsTouchWhenHighlighted = YES;
     [self.backButton addTarget: self action: @selector(pushBackController:) forControlEvents:UIControlEventTouchUpInside];
     */
    
    self.timeLabel = [[UILabel alloc] initWithFrame: CGRectMake(BUTTONHEIGHT + 5 + 5 + 10, 2, 40, BUTTONHEIGHT / 2)];
    //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
    self.timeLabel.font = [UIFont boldSystemFontOfSize: 12.0];
    self.timeLabel.textColor = [UIColor toolbarTextColorNormal];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    
    self.dateLabel = [[UILabel alloc] initWithFrame: CGRectMake(BUTTONHEIGHT + 5 + 5 + 10, BUTTONHEIGHT / 2 - 2, 40, BUTTONHEIGHT / 2)];
    //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
    self.dateLabel.font = [UIFont boldSystemFontOfSize: 12.0];
    self.dateLabel.textColor = [UIColor toolbarTextColorNormal];
    self.dateLabel.backgroundColor = [UIColor clearColor];
    self.dateLabel.textAlignment = NSTextAlignmentLeft;
    
    self.startStationLabel = [[UILabel alloc] initWithFrame: CGRectMake(BUTTONHEIGHT + 5 + 5 + 40 + 5 + 10 - 5, 2, self.view.frame.size.width - BUTTONHEIGHT + 5 + 5 + 40 + 5 - BUTTONHEIGHT - 10 - 10 + 5, BUTTONHEIGHT / 2)];
    //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
    self.startStationLabel.font = [UIFont boldSystemFontOfSize: 12.0];
    self.startStationLabel.textColor = [UIColor toolbarTextColorNormal];
    self.startStationLabel.backgroundColor = [UIColor clearColor];
    self.startStationLabel.textAlignment = NSTextAlignmentLeft;
    
    self.endStationLabel = [[UILabel alloc] initWithFrame: CGRectMake(BUTTONHEIGHT + 5 + 5 + 40 + 5 + 10 - 5, BUTTONHEIGHT / 2 - 2, self.view.frame.size.width - BUTTONHEIGHT + 5 + 5 + 40 + 5 - BUTTONHEIGHT - 10 - 10 + 5, BUTTONHEIGHT / 2)];
    //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
    self.endStationLabel.font = [UIFont boldSystemFontOfSize: 12.0];
    self.endStationLabel.textColor = [UIColor toolbarTextColorNormal];
    self.endStationLabel.backgroundColor = [UIColor clearColor];
    self.endStationLabel.textAlignment = NSTextAlignmentLeft;
    
    /*
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
     self.navSC.changeHandler = ^(NSUInteger newIndex) {
     NSLog(@"segmentedControl did select index %i (via block handler)", newIndex);
     if (newIndex == 0) {
     [self.connectionsJourneyDetailViewController switchToMapViewAsConnectionJourneyDetailView];
     } else {
     [self.connectionsJourneyDetailViewController switchToListViewAsConnectionJourneyDetailView];
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
     self.showJourneyDetailButton.frame = CGRectMake(self.view.frame.size.width - 5 - BUTTONHEIGHT, 0, BUTTONHEIGHT, BUTTONHEIGHT);
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
     self.shareButton.frame = CGRectMake(self.view.frame.size.width - 5 - BUTTONHEIGHT - BUTTONHEIGHT - 5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
     self.shareButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
     self.shareButton.showsTouchWhenHighlighted = YES;
     [self.shareButton addTarget: self action: @selector(shareConnection:) forControlEvents:UIControlEventTouchUpInside];
     */
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
    
    /*
     float padding = -25;
     
     self.connectionsJourneyDetailViewController = [[ConnectionsJourneyDetailViewController alloc] init];
     self.connectionsJourneyDetailViewController.view.frame = CGRectMake(80 + padding, TOOLBARHEIGHT, 320 - 80 - padding, self.view.frame.size.height - TOOLBARHEIGHT);
     [self.view addSubview: self.connectionsJourneyDetailViewController.view];
     */
    /*
     self.mapView = [[MKMapView alloc] initWithFrame: CGRectMake(80 + padding, TOOLBARHEIGHT, 320 - 80 - padding, self.view.frame.size.height - TOOLBARHEIGHT)];
     [self.view addSubview: self.mapView];
     //CLLocationCoordinate2D zoomLocation;
     //zoomLocation.latitude = 40.7310;
     //zoomLocation.longitude= -73.9977;
     //MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 10000, 10000);
     //[self.mapView setRegion:viewRegion animated:NO];
     */
    
    self.connectionsViewControllerContainerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH, self.view.frame.size.height)];
    [self.view addSubview: self.connectionsViewControllerContainerView];
    
    self.connectionsOverviewViewController = [[ConnectionsOverviewViewControlleriPad alloc] init];
    //self.connectionsOverviewViewController.view.frame = CGRectMake(0, TOOLBARHEIGHT, 80, self.view.frame.size.height - TOOLBARHEIGHT);
    self.connectionsOverviewViewController.view.frame = CGRectMake(0, 0, 80, self.connectionsViewControllerContainerView.frame.size.height);
    [self.connectionsViewControllerContainerView addSubview: self.connectionsOverviewViewController.view];
    self.connectionsOverviewViewController.delegate = self;
    
    self.connectionsDetailViewController = [[ConnectionsDetailViewControlleriPad alloc] init];
    //self.connectionsDetailViewController = [[ConnectionsDetailViewController alloc] initWithFrame: CGRectMake(80, TOOLBARHEIGHT, 320 - 80, self.view.frame.size.height - TOOLBARHEIGHT)];
    //self.connectionsDetailViewController.view.frame = CGRectMake(80, TOOLBARHEIGHT, 320 - 80, self.view.frame.size.height - TOOLBARHEIGHT);
    self.connectionsDetailViewController.view.frame = CGRectMake(80, 0, SPLITVIEWMAINVIEWWIDTH - 80, self.connectionsViewControllerContainerView.frame.size.height);
    [self.connectionsViewControllerContainerView addSubview: self.connectionsDetailViewController.view];
    self.connectionsDetailViewController.delegate = self;
    [self.connectionsDetailViewController setSelectableStateOfTableView: YES];
    
    [self.connectionsOverviewViewController adjustTableViewHeightWithRect:CGRectMake(0, 0, 80, self.connectionsViewControllerContainerView.frame.size.height) reload:NO];
    [self.connectionsDetailViewController adjustTableViewHeightWithRect:CGRectMake(80, 0, SPLITVIEWMAINVIEWWIDTH - 80, self.connectionsViewControllerContainerView.frame.size.height) reload:NO];
    
    //[self.view addSubview: self.stationsViewToolbar];
    //[self.view addSubview: self.navSC];
    //[self.navSC setSelectedIndex: 0];
    //self.navSC.alpha = 0.0;
    //[self.view addSubview: self.backButton];
    //[self.view addSubview: self.timeLabel];
    //[self.view addSubview: self.dateLabel];
    //[self.view addSubview: self.startStationLabel];
    //[self.view addSubview: self.endStationLabel];
    //[self.view addSubview: self.showJourneyDetailButton];
    //[self.view addSubview: self.shareButton];
    //[self.view addSubview: self.mapButton];
    //self.mapButton.alpha = 0.0;
    //[self.view addSubview: self.listButton];
    //self.listButton.alpha = 0.0;
    
    /*
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
     */

}

- (void) moveConnectionsResultOverviewtableviewToTopRow {
    if (self.connectionsOverviewViewController) {
        [self.connectionsOverviewViewController moveTableviewToToRow];
    }
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

- (void) updateOverViewAndDetailViewWithConnectionIndex:(NSUInteger)index {
    self.selectedOverviewIndex = index;
    if ([[SBBAPIController sharedSBBAPIController] getNumberOfConnectionResults] > 0) {
        [self.connectionsOverviewViewController.overViewTableView reloadData];
        if (self.selectedOverviewIndex < 0) {
            self.selectedOverviewIndex = 0;
            self.connectionsDetailViewController.selectedIndex = 0;
            [self.connectionsOverviewViewController.overViewTableView selectRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection:0] animated: YES scrollPosition:UITableViewScrollPositionNone];
            
            [self.connectionsDetailViewController.detailViewTableView reloadData];
            [self.connectionsDetailViewController.detailViewTableView setContentOffset:CGPointZero animated:NO];
            
            ConOverview *overView = [[SBBAPIController sharedSBBAPIController] getOverviewForConnectionResultWithIndex: 0];
            ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: 0 consectionIndex: 0];
            
            self.timeLabel.text = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForConsection: conSection];
            self.dateLabel.text = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForOverview: overView];
            
            NSString *startStationName; NSString *endStationName;
            startStationName = [[SBBAPIController sharedSBBAPIController] getBetterDepartureStationNameForConnectionResultWithIndex: 0];
            endStationName = [[SBBAPIController sharedSBBAPIController] getBetterArrivalStationNameForConnectionResultWithIndex: 0];
            
            self.startStationLabel.text = [self shortenStationNameIfTooLong: startStationName maxLenth: 26];
            self.endStationLabel.text = [self shortenStationNameIfTooLong: endStationName maxLenth: 26];
            
            //self.startStationLabel.text = [self shortenStationNameIfTooLong:[[SBBAPIController sharedSBBAPIController] getDepartureStationNameForOverview: overView] maxLenth: 26];
            //self.endStationLabel.text = [self shortenStationNameIfTooLong:[[SBBAPIController sharedSBBAPIController] getArrivalStationNameForOverview: overView] maxLenth: 26];
            
        } else {
            [self.connectionsOverviewViewController.overViewTableView selectRowAtIndexPath: [NSIndexPath indexPathForRow: self.selectedOverviewIndex inSection:0] animated: YES scrollPosition:UITableViewScrollPositionNone];
            self.connectionsDetailViewController.selectedIndex = self.selectedOverviewIndex;
            
            [self.connectionsDetailViewController.detailViewTableView reloadData];
            [self.connectionsDetailViewController.detailViewTableView setContentOffset:CGPointZero animated:NO];
            
            ConOverview *overView = [[SBBAPIController sharedSBBAPIController] getOverviewForConnectionResultWithIndex: self.selectedOverviewIndex];
            
            ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.selectedOverviewIndex consectionIndex: 0];
            
            self.timeLabel.text = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForConsection: conSection];
            self.dateLabel.text = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForOverview: overView];
            
            NSString *startStationName; NSString *endStationName;
            startStationName = [[SBBAPIController sharedSBBAPIController] getBetterDepartureStationNameForConnectionResultWithIndex: self.selectedOverviewIndex];
            endStationName = [[SBBAPIController sharedSBBAPIController] getBetterArrivalStationNameForConnectionResultWithIndex: self.selectedOverviewIndex];
            
            self.startStationLabel.text = [self shortenStationNameIfTooLong: startStationName maxLenth: 26];
            self.endStationLabel.text = [self shortenStationNameIfTooLong: endStationName maxLenth: 26];
            
            //self.startStationLabel.text = [self shortenStationNameIfTooLong:[[SBBAPIController sharedSBBAPIController] getDepartureStationNameForOverview: overView] maxLenth: 26];
            //self.endStationLabel.text = [self shortenStationNameIfTooLong:[[SBBAPIController sharedSBBAPIController] getArrivalStationNameForOverview: overView] maxLenth: 26];
        }
        
    }
}

- (void)didSelectOverviewCellWithIndex:(ConnectionsOverviewViewControlleriPad *)controller index:(NSUInteger)index {
    //NSLog(@"ConnectionResultContainerViewController didSelectOverviewCellWithIndex received");
    
    [self cancelCurrentRunningRequestsIfAny];
    
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
    
    self.startStationLabel.text = [self shortenStationNameIfTooLong: startStationName maxLenth: 26];
    self.endStationLabel.text = [self shortenStationNameIfTooLong: endStationName maxLenth: 26];
    
    [self.connectionsDetailViewController updateDetailviewTableViewWithOverviewIndex: index];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectOverviewCellWithIndex:index:)])
	{
        [self.delegate didSelectOverviewCellWithIndex:controller index: index];
	}
}

- (void)didSelectDetailviewCellWithIndex:(ConnectionsDetailViewControlleriPad *)controller index:(NSUInteger)index {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectDetailviewCellWithIndex:index:)])
    {
        [self.delegate didSelectDetailviewCellWithIndex:controller index: index];
    }
}

- (void)didTriggerDetailviewCellWithIndexLongPress:(ConnectionsDetailViewControlleriPad *)controller index:(NSUInteger)index viewrect:(CGRect)viewrect {
    
    //NSLog(@"ConnectionsResultContainerView: detailview did trigger long press on cell: %d", index);

    if (self.delegate && [self.delegate respondsToSelector:@selector(didTriggerDetailviewCellWithIndexLongPress:index:viewrect:)])
    {
        [self.delegate didTriggerDetailviewCellWithIndexLongPress:controller index: index viewrect: viewrect];
    }
}

-(void) cancelCurrentRunningRequestsIfAny {
    
    [self.connectionsOverviewViewController resetTopLoadMoreViewWithNewRowsCount:0];
    [self.connectionsOverviewViewController resetBottomLoadMoreViewWithNewRowsCount:0];
    
    if ([[SBBAPIController sharedSBBAPIController] conreqRequestInProgress]) {
        [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIConreqOperations];
    }
}

- (void)didTriggerLoadMoreTop {
    [self cancelCurrentRunningRequestsIfAny];
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable)
    {
        [self.connectionsOverviewViewController resetTopLoadMoreViewWithNewRowsCount:0];
        
        //UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        //[[NoticeviewMessages sharedNoticeMessagesController] showNoNetworkErrorMessage: self.view.superview];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(showNoNetworkErrorMessage)]) {
            [self.delegate showNoNetworkErrorMessage];
        }
        
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
        
        //UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        //[[NoticeviewMessages sharedNoticeMessagesController] showNoNetworkErrorMessage: self.view.superview];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(showNoNetworkErrorMessage)]) {
            [self.delegate showNoNetworkErrorMessage];
        }
        
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

- (void)didTriggerOverviewCellWithIndexLongPress:(ConnectionsOverviewViewControlleriPad *)controller index:(NSUInteger)index {
    //NSLog(@"ConnectionsResultContainerView: overview did trigger long press on cell: %d", index);
    
    //BOOL connectionHasInfo = [[SBBAPIController sharedSBBAPIController] ConnectionResultWithIndexHasInfos: index];
    
    //NSLog(@"ConnectionsResultContainerView: connecton has info: %@", connectionHasInfo?@"Y":@"N");
    /*
    
    if (connectionHasInfo) {
        ConnectionInfoViewController *connectionInfoViewController = [[ConnectionInfoViewController alloc] init];
        [connectionInfoViewController updateConnectionInfoTableViewWithInfoFromConnectionWithIndex: index];
        
        FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController: connectionInfoViewController];
        
        popover.tint = FPPopoverDefaultTint;
        popover.contentSize = CGSizeMake(200, 300);
        popover.arrowDirection = FPPopoverArrowDirectionLeft;
        
        [popover presentPopoverFromView: [controller.overViewTableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow: index inSection:0]]];
    }
    */
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTriggerOverviewCellWithIndexLongPress:index:)])
    {
        [self.delegate didTriggerOverviewCellWithIndexLongPress:controller index: index];
    }
}

/*
- (void) shareConnection:(id) sender {
    //BlockActionSheet *shareActionSheet = [BlockActionSheet sheetWithTitle: NSLocalizedString(@"Share via", @"Share connection block action sheet title")];
    
    RIButtonItem *cancelButton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Cancel", @"Share connection cancel block action sheet title")];
    RIButtonItem *emailButton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Send via email", @"Share connection send per email block action sheet title")];
    emailButton.action = ^{
        [self shareViaEmail];
    };
    RIButtonItem *clipboardButton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Copy to clipboard", @"Share connection copy to clipboard block action sheet title")];
    clipboardButton.action = ^{
        [self shareByCopyingToClipboard];
    };
    
    if ([MFMailComposeViewController canSendMail]) {
        UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle: NSLocalizedString(@"Share via", @"Share connection block action sheet title") cancelButtonItem: cancelButton destructiveButtonItem: nil otherButtonItems: emailButton, clipboardButton , nil];
        [shareActionSheet showInView: self.view];
    } else {
        UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle: NSLocalizedString(@"Share via", @"Share connection block action sheet title") cancelButtonItem: cancelButton destructiveButtonItem: nil otherButtonItems: clipboardButton , nil];
        [shareActionSheet showInView: self.view];
    }
}

- (void) mailComposeController:(MFMailComposeViewController*) mailController didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	//AudioServicesPlaySystemSound (clickSoundID);
	
	[self becomeFirstResponder];
	[mailController dismissViewControllerAnimated: YES completion: ^{}];
}


- (void) shareViaEmail {
    NSString *plainTextString = [[SBBAPIController sharedSBBAPIController] getPlaintextSharetextForConnectionResultWithIndex: self.selectedOverviewIndex];
    NSString *plainTitleString = [[SBBAPIController sharedSBBAPIController] getShortPlaintextTitleForConnectionResultWithIndex: self.selectedOverviewIndex];
    
    NSLog(@"Got Email text and title: %@, %@", plainTitleString, plainTextString);
    
    if (plainTextString && plainTitleString) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.modalPresentationStyle = UIModalPresentationFullScreen;
        mailController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
		mailController.mailComposeDelegate = self;
		[mailController setSubject: plainTitleString];
                
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
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"ConnectionsResultContainerViewControlleriPad: should autororate");
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	NSLog(@"ConnectionsResultContainerViewControlleriPad: willRotateToInterfaceOrientation");
    //[self layoutSubviews:YES toInterfaceOrientation:toInterfaceOrientation];
    //[self.connectionsOverviewViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    //[self.connectionsDetailViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"ConnectionsResultContainerViewControlleriPad: didRotateToInterfaceOrientation");
    //[self.connectionsOverviewViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    //[self.connectionsDetailViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"ConnectionsResultContainerViewControlleriPad: willAnimateRotateToInterfaceOrientation");
    //[self layoutSubviews:YES toInterfaceOrientation:toInterfaceOrientation];
	//[self.connectionsOverviewViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration: duration];
    //[self.connectionsDetailViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration: duration];
}

- (void) viewWillAppear:(BOOL)animated {
    //NSLog(@"ConnectionsResultContainerViewControlleriPad: viewwillappear");
	[super viewWillAppear:animated];
	[self.connectionsOverviewViewController viewWillAppear:animated];
    [self.connectionsDetailViewController viewWillAppear:animated];
    [self.connectionsOverviewViewController.overViewTableView reloadData];
}

- (void) viewDidAppear:(BOOL)animated {
    //NSLog(@"ConnectionsResultContainerViewControlleriPad: viewdidappear");
	[super viewDidAppear:animated];
    //[self layoutSubviews: NO toInterfaceOrientation: [[UIDevice currentDevice] orientation]];
	[self.connectionsOverviewViewController viewDidAppear:animated];
    [self.connectionsDetailViewController viewDidAppear:animated];
    [self updateOverViewAndDetailViewWithConnectionIndex: 0];
}

- (void)viewWillDisappear:(BOOL)animated {
    //NSLog(@"ConnectionsResultContainerViewControlleriPad: viewwilldisappear");
	[super viewWillDisappear:animated];
	[self.connectionsOverviewViewController viewWillDisappear:animated];
    [self.connectionsDetailViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    //NSLog(@"ConnectionsResultContainerViewControlleriPad: viewdiddisappear");
	[super viewDidDisappear:animated];
	[self.connectionsOverviewViewController viewDidDisappear:animated];
    [self.connectionsDetailViewController viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
