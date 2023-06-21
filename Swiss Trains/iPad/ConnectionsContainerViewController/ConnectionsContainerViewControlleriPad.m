//
//  ConnectionsContainerViewControlleriPad.m
//  Swiss Trains
//
//  Created by Alain on 01.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

const NSTimeInterval kGHRevealSidebarDefaultAnimationDuration = 0.25;
const CGFloat kGHRevealSidebarWidth = 320.0f;
const CGFloat kGHRevealSidebarFlickVelocity = 1000.0f;

#import "ConnectionsContainerViewControlleriPad.h"

@interface ConnectionsContainerViewControlleriPad ()

@end

@implementation ConnectionsContainerViewControlleriPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadView {
    CGSize size = [UIApplication currentScreenSize];
    
    //NSLog(@"ConnectionsContainerViewController. Screen size: %.1f, %.1f", size.width, size.height);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height - TABBARHEIGHT)];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = view;
    
    //NSLog(@"ConnectionsContainer view init: %.1f, %.1f, %.1f, %.1f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
}

- (id)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Connections", "Select stations conreq flash message title");
        
        CGFloat scaleFactor = TABBARICONIMAGESCALEFACTOR;
        UIImage *conreqImage =  [UIImage newImageFromMaskImage: [[UIImage conreqButtonImage] resizedImage: CGSizeMake(TABBARICONIMAGEHEIGHT * scaleFactor, TABBARICONIMAGEHEIGHT * scaleFactor) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlItemImageColor]];

        self.tabBarItem.image = [conreqImage grayTabBarItemFilter];
        self.tabBarItem.selectedImage = [conreqImage blueTabBarItemFilter];
        
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight  | UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void) layoutSubviewsWithAnimated:(BOOL)animated beforeRotation:(BOOL)beforeRotation interfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //NSLog(@"ConnectionsContainerViewControlleriPad layoutSubviews");
	
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
    
    //NSLog(@"ConnectionsContainerViewControlleriPad. New size: %.1f, %.1f", newSize.width, newSize.height);
    
    if (animated) {
        [UIView beginAnimations:@"ConnectionsContainerViewControlleriPad LayoutSubviewWithAnimation" context:NULL];
    }
    
    //self.statusToolBar.frame = CGRectMake(0, 0, newSize.width, TOOLBARHEIGHTIPAD);
    
    self.connectionsSelectionViewControlleriPad.view.frame = CGRectMake(0, TOOLBARHEIGHTIPAD, SPLITVIEWMAINVIEWWIDTH, newSize.height - TOOLBARHEIGHTIPAD);
    
    if (self.connectionsResultContainerViewController.view.frame.origin.x < 0) {
        self.connectionsResultContainerViewController.view.frame = CGRectMake(-320, TOOLBARHEIGHTIPAD, SPLITVIEWMAINVIEWWIDTH, newSize.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT);
    } else {
        self.connectionsResultContainerViewController.view.frame = CGRectMake(0, TOOLBARHEIGHTIPAD, SPLITVIEWMAINVIEWWIDTH, newSize.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT);
    }
    
    self.divider.frame = CGRectMake(SPLITVIEWMAINVIEWWIDTH, TOOLBARHEIGHTIPAD, SPLITVIEWDIVIDERWIDTH, newSize.height - TOOLBARHEIGHTIPAD);
    
    
    //TEST
    self.connectionsMapViewController.view.frame = CGRectMake(SPLITVIEWMAINVIEWWIDTH + SPLITVIEWDIVIDERWIDTH, TOOLBARHEIGHTIPAD, newSize.width - SPLITVIEWMAINVIEWWIDTH - SPLITVIEWDIVIDERWIDTH, newSize.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT);
    
    //TEST
    

    //self.connectionsListViewController.view.frame = CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH, newSize.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT - LISTVIEWCONTROLLERHEIGHTPAD);
    self.goButton.frame = CGRectMake(5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.backButton.frame = CGRectMake(5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.infoButton.frame = CGRectMake(newSize.width - BUTTONHEIGHT - 5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.listButton.frame = CGRectMake(newSize.width - BUTTONHEIGHT*2  - 5 * 2, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.shareButton.frame = CGRectMake(newSize.width - BUTTONHEIGHT*3 - 5 * 3, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.closestStationsButton.frame = CGRectMake(newSize.width - BUTTONHEIGHT*2 - 5*2, 0, BUTTONHEIGHT, BUTTONHEIGHT);

    int startPositionInfoView = (newSize.width - 350) / 2;
    int infoViewWidth = 350;
    self.topInfoView.frame = CGRectMake(startPositionInfoView, 0, infoViewWidth, TOOLBARHEIGHTIPAD);
    //self.topInfoTransportTypeImageView.frame = CGRectMake(8, 8, 30, 30);
    //self.topInfoTransportNameImageView.frame = CGRectMake(newSize.width - SPLITVIEWMAINVIEWWIDTH + SPLITVIEWDIVIDERWIDTH - 80 - 8, 13, 80, 20);
    
    //CGRect viewFrame = newSize.width - SPLITVIEWMAINVIEWWIDTH + SPLITVIEWDIVIDERWIDTH;
    //int viewWith = viewFrame.size.width - 8 - 30 - 10 - 80 - 8 - 10;
    //int startPosition = (newSize.width - SPLITVIEWMAINVIEWWIDTH + SPLITVIEWDIVIDERWIDTH - 150) / 2;
    //int labelWith = 150;
    
    //self.bottomInfoStartStationLabel.frame = CGRectMake(startPosition, 8, labelWith, 14);
    //self.bottomInfoEndStationLabel.frame = CGRectMake(startPosition, 25, labelWith, 14);
    //self.bottomInfoDepartureTimeLabel.frame = CGRectMake(startPosition - 45, 8, 40, 14);
    //self.bottomInfoArrivalTimeLabel.frame = CGRectMake(startPosition - 45, 25, 40, 14);
    
    if (animated) {
        [UIView commitAnimations];
    }
    //[self.view setNeedsDisplay];
    //[self.view setNeedsLayout];
}

- (void) layoutSubviews:(BOOL)beforeRotation toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    [self layoutSubviewsWithAnimated:NO beforeRotation: beforeRotation interfaceOrientation: toInterfaceOrientation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedOverviewIndex = 0;
    self.selectedDetailIndex = 9999;
    
    self.viaStationIsVisible = NO;
    
    self.showIntroFlag = NO;
    self.skipIntroFlag = NO;
    
    //NSLog(@"ConnectionsContainer viewdidload: %.1f, %.1f, %.1f, %.1f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
    
    self.statusToolBar = [[StatusToolbariPad alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, TOOLBARHEIGHTIPAD)];
    
    self.connectionsSelectionViewControlleriPad = [[ConnectionsSelectionViewControlleriPad alloc] init];
    self.connectionsSelectionViewControlleriPad.view.frame = CGRectMake(0, TOOLBARHEIGHTIPAD, SPLITVIEWMAINVIEWWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD);
    self.connectionsSelectionViewControlleriPad.delegate = self;
    
    //Start image
    [self.view addSubview: self.connectionsSelectionViewControlleriPad.view];
    
    self.connectionsResultContainerViewController = [[ConnectionsResultContainerViewController alloc] init];
    self.connectionsResultContainerViewController.view.frame = CGRectMake(-320, TOOLBARHEIGHTIPAD, SPLITVIEWMAINVIEWWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD);
    //self.connectionsResultContainerViewController.view.frame = CGRectMake(0, TOOLBARHEIGHTIPAD, SPLITVIEWMAINVIEWWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT);
    [self.view addSubview: self.connectionsResultContainerViewController.view];
    //self.connectionsResultContainerViewController.view.frame = CGRectMake(0, TOOLBARHEIGHTIPAD, SPLITVIEWMAINVIEWWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT);
    self.connectionsResultContainerViewController.delegate = self;
    //[self moveConnectionsResultContainerViewOffScreen];
    
    /*
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(dragContentView:)];
    panGesture.cancelsTouchesInView = YES;
    panGesture.delegate = self;
    [self.connectionsResultContainerViewController.view addGestureRecognizer:panGesture];
    */
    
    self.divider = [[SplitSeparatorView alloc] initWithFrame: CGRectMake(SPLITVIEWMAINVIEWWIDTH, TOOLBARHEIGHTIPAD, SPLITVIEWDIVIDERWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD)];
    self.divider.backgroundColor = [UIColor lightGrayColor];
    self.divider.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
    
    //Start image
    [self.view addSubview: self.divider];
    
    /*
    UIImage *image = [UIImage imageNamed:@"split-divider.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(-4, 0, image.size.width, image.size.height);
    [self.divider addSubview:imageView];
    */

    // Test
    self.connectionsMapViewController = [[ConnectionsMapViewController alloc] init];
    self.connectionsMapViewController.view.frame = CGRectMake(SPLITVIEWMAINVIEWWIDTH + SPLITVIEWDIVIDERWIDTH, TOOLBARHEIGHTIPAD, self.view.frame.size.width - SPLITVIEWMAINVIEWWIDTH - SPLITVIEWDIVIDERWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD);
    self.connectionsMapViewController.delegate = self;
    
    //Start image
    [self.view addSubview: self.connectionsMapViewController.view];
    
    /*
    self.mapView = [[MKMapView alloc] initWithFrame: CGRectMake(SPLITVIEWMAINVIEWWIDTH + SPLITVIEWDIVIDERWIDTH, TOOLBARHEIGHTIPAD, self.view.frame.size.width - SPLITVIEWMAINVIEWWIDTH - SPLITVIEWDIVIDERWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT)];
    //self.mapView.directionsEdgePadding = UIEdgeInsetsMake(CONJRNTOPINFOBARHEIGHT + 20.0f, 20.0f, 20.0f, 20.0f);
    [self.view addSubview: self.mapView];
    //self.mapView.delegate = self;
    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(46.897739, 8.426514),
                                                 MKCoordinateSpanMake(4.026846,4.032959));    
    */
     // Test

    
    self.connectionsListViewController = [[ConnectionsListViewController alloc] init];
    self.connectionsListViewController.view.frame = CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT - LISTVIEWCONTROLLERHEIGHTPAD);

    [self.view addSubview: self.statusToolBar];
    
    //CGFloat SCALEFACTORREQSEQCONTROLGO = 1.0;
    self.goButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *goButtonImage =  [UIImage newImageFromMaskImage: [[UIImage searchButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLGO, BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLGO) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
    UIImage *goButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage searchButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLGO, BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLGO) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
    
    [self.goButton setImage: goButtonImage forState: UIControlStateNormal];
    [self.goButton setImage: goButtonImageHighlighted forState: UIControlStateHighlighted];
    self.goButton.imageView.contentMode = UIViewContentModeCenter;
    self.goButton.frame = CGRectMake(5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.goButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.goButton.showsTouchWhenHighlighted = YES;
    [self.goButton addTarget: self action: @selector(executeSBBAPIRequest:) forControlEvents:UIControlEventTouchUpInside];
    
    // Startimage
    [self.view addSubview: self.goButton];
        
    //CGFloat scaleFactorReqSegControlInfo = 0.6;
    self.infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //UIImage *infoButtonImage = [UIImage newImageFromMaskImage: [UIImage infoButtonImage] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
    //UIImage *infoButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage infoButtonImage] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
    UIImage *infoButtonImage =  [UIImage newImageFromMaskImage: [[UIImage infoButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLINFO, BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLINFO) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
    UIImage *infoButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage infoButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLINFO, BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLINFO) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
    [self.infoButton setImage: infoButtonImage forState: UIControlStateNormal];
    [self.infoButton setImage: infoButtonImageHighlighted forState: UIControlStateHighlighted];
    self.infoButton.imageView.contentMode = UIViewContentModeCenter;
    //self.infoButton.frame = CGRectMake(5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.infoButton.frame = CGRectMake(self.view.frame.size.width - BUTTONHEIGHT - 5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.infoButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.infoButton.showsTouchWhenHighlighted = YES;
    [self.infoButton addTarget: self action: @selector(showSettingsPush:) forControlEvents:UIControlEventTouchUpInside];
    
    //Start image
    [self.view addSubview: self.infoButton];
    
    CGFloat scaleFactorListButton = 1.5;
    self.listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //UIImage *infoButtonImage = [UIImage newImageFromMaskImage: [UIImage infoButtonImage] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
    //UIImage *infoButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage infoButtonImage] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
    UIImage *listButtonImage =  [UIImage newImageFromMaskImage: [[UIImage listButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLINFO * scaleFactorListButton, BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLINFO * scaleFactorListButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
    UIImage *listButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage listButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLINFO * scaleFactorListButton, BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLINFO * scaleFactorListButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
    [self.listButton setImage: listButtonImage forState: UIControlStateNormal];
    [self.listButton setImage: listButtonImageHighlighted forState: UIControlStateHighlighted];
    self.listButton.imageView.contentMode = UIViewContentModeCenter;
    self.listButton.frame = CGRectMake(5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.listButton.frame = CGRectMake(self.view.frame.size.width - BUTTONHEIGHT*2 - 5*2, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.listButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.listButton.showsTouchWhenHighlighted = YES;
    [self.listButton addTarget: self action: @selector(showListViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.listButton];
    self.listButton.alpha = 0.0;
    
    CGFloat scaleFactorShareButton = 1.0;
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //UIImage *backButtonImage = [UIImage newImageFromMaskImage: [UIImage backButtonImage] inColor: [UIColor selectStationsViewButtonColorNormal]];
    //UIImage *backButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage backButtonImage] inColor: [UIColor selectStationsViewButtonColorHighlighted]];
    UIImage *shareButtonImage =  [UIImage newImageFromMaskImage: [[UIImage shareButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON* scaleFactorShareButton, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorShareButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
    UIImage *shareButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage shareButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorShareButton, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorShareButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
    [self.shareButton setImage: shareButtonImage forState: UIControlStateNormal];
    //[self.showJourneyDetailButton setImage: backButtonImage forState: UIControlStateNormal];
    [self.shareButton setImage: shareButtonImageHighlighted forState: UIControlStateHighlighted];
    self.shareButton.imageView.contentMode = UIViewContentModeCenter;
    self.shareButton.frame = CGRectMake(self.view.frame.size.width - BUTTONHEIGHT*3 - 5*3, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.shareButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.shareButton.showsTouchWhenHighlighted = YES;
    [self.shareButton addTarget: self action: @selector(shareConnection:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.shareButton];
    self.shareButton.alpha = 0.0;
    
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
     [self.backButton addTarget: self action: @selector(pushOutConnectionsResultController:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview: self.backButton];
      self.backButton.alpha = 0.0;
    
    
    CGFloat scaleFactorClosestStationsButton = 1.8;
    self.closestStationsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //UIImage *infoButtonImage = [UIImage newImageFromMaskImage: [UIImage infoButtonImage] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
    //UIImage *infoButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage infoButtonImage] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
    UIImage *pinButtonImage =  [UIImage newImageFromMaskImage: [[UIImage pinButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLINFO * scaleFactorClosestStationsButton, BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLINFO * scaleFactorClosestStationsButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
    UIImage *pinButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage pinButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLINFO * scaleFactorClosestStationsButton, BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLINFO * scaleFactorClosestStationsButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
    [self.closestStationsButton setImage: pinButtonImage forState: UIControlStateNormal];
    [self.closestStationsButton setImage: pinButtonImageHighlighted forState: UIControlStateHighlighted];
    self.closestStationsButton.imageView.contentMode = UIViewContentModeCenter;
    self.closestStationsButton.frame = CGRectMake(5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.closestStationsButton.frame = CGRectMake(self.view.frame.size.width - BUTTONHEIGHT*2 - 5*2, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.closestStationsButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.closestStationsButton.showsTouchWhenHighlighted = YES;
    [self.closestStationsButton addTarget: self action: @selector(showClosestStations:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.closestStationsButton];
    self.closestStationsButton.alpha = 1.0;
    
    #ifdef IncludeAlarmAndAddToCalendar
    CGFloat scaleFactorAlarmButton = 1.0;
    self.setalarmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *alarmButtonImage =  [UIImage newImageFromMaskImage: [[UIImage alarmButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON* scaleFactorAlarmButton, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorAlarmButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
    UIImage *alarmButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage alarmButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorAlarmButton, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorAlarmButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
    [self.setalarmButton setImage: alarmButtonImage forState: UIControlStateNormal];
    [self.setalarmButton setImage: alarmButtonImageHighlighted forState: UIControlStateHighlighted];
    self.setalarmButton.imageView.contentMode = UIViewContentModeCenter;
    self.setalarmButton.frame = CGRectMake(self.view.frame.size.width - BUTTONHEIGHT*4 - 5*4, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.setalarmButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.setalarmButton.showsTouchWhenHighlighted = YES;
    [self.setalarmButton addTarget: self action: @selector(setAlarmForConnection:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.setalarmButton];
    self.setalarmButton.alpha = 0.0;
    
    CGFloat scaleFactorCalendarButton = 1.0;
    self.addtocalendarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *calendarButtonImage =  [UIImage newImageFromMaskImage: [[UIImage addtocalendarButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON* scaleFactorCalendarButton, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorCalendarButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
    UIImage *calendarButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage addtocalendarButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorCalendarButton, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorCalendarButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
    [self.addtocalendarButton setImage: calendarButtonImage forState: UIControlStateNormal];
    [self.addtocalendarButton setImage: calendarButtonImageHighlighted forState: UIControlStateHighlighted];
    self.addtocalendarButton.imageView.contentMode = UIViewContentModeCenter;
    self.addtocalendarButton.frame = CGRectMake(self.view.frame.size.width - BUTTONHEIGHT*5 - 5*5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.addtocalendarButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.addtocalendarButton.showsTouchWhenHighlighted = YES;
    [self.addtocalendarButton addTarget: self action: @selector(addConnectionToCalendar:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.addtocalendarButton];
    self.addtocalendarButton.alpha = 0.0;
    #endif
    
    CGFloat scaleFactorLocationheadingButton = 1.0;
    self.locationheadingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *locationheadingButtonImage =  [UIImage newImageFromMaskImage: [[UIImage locationheadingButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON* scaleFactorLocationheadingButton, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorLocationheadingButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor lightGrayColor]];
    UIImage *locationheadingImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage locationheadingButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorLocationheadingButton, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorLocationheadingButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
    UIImage *locationheadingButtonImageSelected =  [UIImage newImageFromMaskImage: [[UIImage locationheadingButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON* scaleFactorLocationheadingButton, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorLocationheadingButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
    [self.locationheadingButton setImage: locationheadingButtonImage forState: UIControlStateNormal];
    [self.locationheadingButton setImage: locationheadingImageHighlighted forState: UIControlStateHighlighted];
    [self.locationheadingButton setImage: locationheadingButtonImageSelected forState: UIControlStateSelected];
    self.locationheadingButton.imageView.contentMode = UIViewContentModeCenter;
    self.locationheadingButton.frame = CGRectMake(self.view.frame.size.width - BUTTONHEIGHT*6 - 5*6, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.locationheadingButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.locationheadingButton.showsTouchWhenHighlighted = YES;
    [self.locationheadingButton addTarget: self action: @selector(enterLocationHeadingMode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.locationheadingButton];
    self.locationheadingButton.alpha = 0.0;
    
    CGFloat scaleFactorTrainlineButton = 1.0;
    self.trainlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *trainlineButtonImage =  [UIImage newImageFromMaskImage: [[UIImage trainlineNormalButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON* scaleFactorTrainlineButton, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorTrainlineButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
    UIImage *trainlineButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage trainlineNormalButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorTrainlineButton, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorTrainlineButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
    UIImage *trainlineButtonImageSelected =  [UIImage newImageFromMaskImage: [[UIImage trainlineDetailedButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON* scaleFactorTrainlineButton, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorTrainlineButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
    [self.trainlineButton setImage: trainlineButtonImage forState: UIControlStateNormal];
    [self.trainlineButton setImage: trainlineButtonImageHighlighted forState: UIControlStateHighlighted];
    [self.trainlineButton setImage: trainlineButtonImageSelected forState: UIControlStateSelected];
    self.trainlineButton.imageView.contentMode = UIViewContentModeCenter;
    self.trainlineButton.frame = CGRectMake(self.view.frame.size.width - BUTTONHEIGHT*6 - 5*6, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.trainlineButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.trainlineButton.showsTouchWhenHighlighted = YES;
    [self.trainlineButton addTarget: self action: @selector(switchtrainlinemode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.trainlineButton];
    self.trainlineButton.alpha = 0.0;

    #ifdef IncludeCalendarView
    CGFloat scaleFactorCalendarViewButton = 1.0;
    self.calendarviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *calendarViewButtonImage =  [UIImage newImageFromMaskImage: [[UIImage calendarViewButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON* scaleFactorCalendarViewButton, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorCalendarViewButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
    UIImage *calendarViewButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage calendarViewButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorCalendarViewButton, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorCalendarViewButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
    [self.calendarviewButton setImage: calendarViewButtonImage forState: UIControlStateNormal];
    [self.calendarviewButton setImage: calendarViewButtonImageHighlighted forState: UIControlStateHighlighted];
    self.calendarviewButton.imageView.contentMode = UIViewContentModeCenter;
    self.calendarviewButton.frame = CGRectMake(self.view.frame.size.width - BUTTONHEIGHT*7 - 5*7, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.calendarviewButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.calendarviewButton.showsTouchWhenHighlighted = YES;
    [self.calendarviewButton addTarget: self action: @selector(showcalendarview:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.calendarviewButton];
    self.calendarviewButton.alpha = 0.0;
    #endif
    
    // Test
    /*
    self.stationPickerViewController = [[StationPickerViewControlleriPad alloc] init];
    [self.stationPickerViewController.stationTextField resignFirstResponder];
    self.stationPickerViewController.view.alpha = 0.0;
    
    self.stationPickerViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.stationPickerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    if (!self.managedObjectContext) {
        NSLog(@"WARNING CC");
    }
    
    self.stationPickerViewController.managedObjectContext = self.managedObjectContext;
    self.stationPickerViewController.stationTypeIndex = startStationTypeiPad;
    self.stationPickerViewController.delegate = self;
    self.stationPickerViewController.view.frame = self.view.bounds;
    [self.stationPickerViewController.stationTextField resignFirstResponder];
    
    [self.view addSubview: self.stationPickerViewController.view];
    */
    
    // Top infoview
    CGRect viewFrameInfo = self.view.frame;
    int startPositionInfoView = (viewFrameInfo.size.width - 350) / 2;
    int infoViewWidth = 350;
    self.topInfoView = [[UIView alloc] initWithFrame:CGRectMake(startPositionInfoView, 0, infoViewWidth, TOOLBARHEIGHTIPAD)];
    self.topInfoView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.topInfoView.backgroundColor = [UIColor clearColor];
    self.topInfoView.userInteractionEnabled = NO;
    self.topInfoView.alpha = 0.0;

    self.topInfoTransportTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 3, 30, 30)];
    //self.topInfoTransportTypeImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.topInfoTransportTypeImageView.backgroundColor = [UIColor clearColor];
    self.topInfoTransportTypeImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.topInfoView addSubview:self.topInfoTransportTypeImageView];
    
    self.topInfoTransportNameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(infoViewWidth - 80 - 8, 7, 80, 20)];
    //self.topInfoTransportNameImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.topInfoTransportNameImageView.backgroundColor = [UIColor clearColor];
    self.topInfoTransportNameImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.topInfoView addSubview:self.topInfoTransportNameImageView];
    
    CGRect viewFrame = self.topInfoView.frame;
    int startPosition = (viewFrame.size.width - 150) / 2;
    int labelWith = 150;
    
    self.bottomInfoStartStationLabel = [[UILabel alloc] initWithFrame: CGRectMake(startPosition, 4, labelWith, 14)];
    self.bottomInfoStartStationLabel.font = [UIFont systemFontOfSize: 12.0];
    self.bottomInfoStartStationLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
    self.bottomInfoStartStationLabel.backgroundColor = [UIColor clearColor];
    self.bottomInfoStartStationLabel.textAlignment = NSTextAlignmentLeft;
    [self.topInfoView addSubview:self.bottomInfoStartStationLabel];
    
    self.bottomInfoEndStationLabel = [[UILabel alloc] initWithFrame: CGRectMake(startPosition, 18, labelWith, 14)];
    self.bottomInfoEndStationLabel.font = [UIFont systemFontOfSize: 12.0];
    self.bottomInfoEndStationLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
    self.bottomInfoEndStationLabel.backgroundColor = [UIColor clearColor];
    self.bottomInfoEndStationLabel.textAlignment = NSTextAlignmentLeft;
    [self.topInfoView addSubview:self.bottomInfoEndStationLabel];
    
    self.bottomInfoDepartureTimeLabel = [[UILabel alloc] initWithFrame: CGRectMake(startPosition - 45, 4, 40, 14)];
    self.bottomInfoDepartureTimeLabel.font = [UIFont systemFontOfSize: 12.0];
    self.bottomInfoDepartureTimeLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
    self.bottomInfoDepartureTimeLabel.backgroundColor = [UIColor clearColor];
    self.bottomInfoDepartureTimeLabel.textAlignment = NSTextAlignmentLeft;
    [self.topInfoView addSubview:self.bottomInfoDepartureTimeLabel];
    
    self.bottomInfoArrivalTimeLabel = [[UILabel alloc] initWithFrame: CGRectMake(startPosition - 45, 18, 40, 14)];
    self.bottomInfoArrivalTimeLabel.font = [UIFont systemFontOfSize: 12.0];
    self.bottomInfoArrivalTimeLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
    self.bottomInfoArrivalTimeLabel.backgroundColor = [UIColor clearColor];
    self.bottomInfoArrivalTimeLabel.textAlignment = NSTextAlignmentLeft;
    [self.topInfoView addSubview:self.bottomInfoArrivalTimeLabel];
    
    [self.view addSubview:self.topInfoView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appisenteringbackgroundaction:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    /*
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(appdidbecomeactiveaction:)
     name:UIApplicationDidBecomeActiveNotification object:nil];
     */
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *introPath = [documentsDirectory stringByAppendingPathComponent: INTROSHOWNFLAGFILE];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
#ifdef FORCESHOWINTRO
    [fileManager removeItemAtPath: introPath error:NULL];
#endif
    
    if (![fileManager fileExistsAtPath:introPath]) {
        [@"Introrun" writeToFile: introPath atomically: YES encoding: NSUTF8StringEncoding error: NULL];
        self.showIntroFlag = YES;
    }
}

- (void) goToStore:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DTOpenStore" object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"ConnectionsContainerViewControlleriPad: should autororate");
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	NSLog(@"ConnectionsContainerViewControlleriPad: willRotateToInterfaceOrientation");
    //[self layoutSubviews:YES toInterfaceOrientation:toInterfaceOrientation];
    //[self.connectionsMapViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    //[self.connectionsSelectionViewControlleriPad willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    //[self.stationPickerViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    //[self.connectionsResultContainerViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"ConnectionsContainerViewControlleriPad: didRotateToInterfaceOrientation");
    //[self.connectionsMapViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    //[self.connectionsSelectionViewControlleriPad didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    //[self.stationPickerViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    //[self.connectionsResultContainerViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"ConnectionsContainerViewControlleriPad: willAnimateRotateToInterfaceOrientation");
    //[self layoutSubviews:YES toInterfaceOrientation:toInterfaceOrientation];
	//[self.connectionsMapViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration: duration];
    //[self.connectionsSelectionViewControlleriPad willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration: duration];
    //[self.stationPickerViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration: duration];
    //[self.connectionsResultContainerViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration: duration];
}

- (void) viewWillAppear:(BOOL)animated {
    //NSLog(@"ConnectionsContainerViewControlleriPad: viewwillappear");
	[super viewWillAppear:animated];
	//[self.connectionsMapViewController viewWillAppear:animated];
    [self.connectionsSelectionViewControlleriPad viewWillAppear:animated];
    //[self.stationPickerViewController viewWillAppear:animated];
    [self.connectionsResultContainerViewController viewWillAppear:animated];
}

- (void)showMoviePlayerController {
    IntroMoviePlayerControlleriPad *introMoviePlayerControlleriPad = [[IntroMoviePlayerControlleriPad alloc] init];
    introMoviePlayerControlleriPad.modalPresentationStyle = UIModalPresentationFormSheet;
    introMoviePlayerControlleriPad.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    introMoviePlayerControlleriPad.wantsFullScreenLayout = NO;
    introMoviePlayerControlleriPad.delegate = self;
    self.currentlyPushedViewController = introViewControllerConnectionsContaineriPad;
    
    [self presentViewController: introMoviePlayerControlleriPad animated: YES completion: nil];
        
    introMoviePlayerControlleriPad.view.superview.bounds = CGRectMake(0, 0, IPADMOVIEWIDTH * IPADMOVIESCALEFACTOR, IPADMOVIEHEIGHT * IPADMOVIESCALEFACTOR);
}

- (void)movieDidFinish:(IntroMoviePlayerControlleriPad *)controller {
    self.currentlyPushedViewController = noViewControllerConnectionsContaineriPad;
    [self startGettingUserLocation];
}

- (void) viewDidAppear:(BOOL)animated {
    //NSLog(@"ConnectionsContainerViewControlleriPad: viewdidappear");
	[super viewDidAppear:animated];
    //[self layoutSubviews: NO toInterfaceOrientation: [[UIDevice currentDevice] orientation]];
	//[self.connectionsMapViewController viewDidAppear:animated];
    [self.connectionsSelectionViewControlleriPad viewDidAppear:animated];
    //[self.stationPickerViewController viewDidAppear:animated];
    [self.connectionsResultContainerViewController viewDidAppear:animated];
    
    if (self.showIntroFlag) {
        self.showIntroFlag = NO;
        [self showMoviePlayerController];
    } else {
        [self startGettingUserLocation];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    //NSLog(@"ConnectionsContainerViewControlleriPad: viewwilldisappear");
	[super viewWillDisappear:animated];
	//[self.connectionsMapViewController viewWillDisappear:animated];
    [self.connectionsSelectionViewControlleriPad viewWillDisappear:animated];
    //[self.stationPickerViewController viewWillDisappear:animated];
    [self.connectionsResultContainerViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    //NSLog(@"ConnectionsContainerViewControlleriPad: viewdiddisappear");
	[super viewDidDisappear:animated];
	//[self.connectionsMapViewController viewDidDisappear:animated];
    [self.connectionsSelectionViewControlleriPad viewDidDisappear:animated];
    //[self.stationPickerViewController viewDidDisappear:animated];
    [self.connectionsResultContainerViewController viewDidDisappear:animated];
}

-(void) cancelCurrentRunningRequestsIfAny {
    if ([[SBBAPIController sharedSBBAPIController] conreqRequestInProgress]) {
        [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIConreqOperations];
    }
    #ifdef IncludeDetailedTrainlinesiPad
    [[TrainLinesController sharedTrainLinesController] cancelConReqTrainlineOperations];
    #endif
    
    //[self hideLoadingIndicator];
}

- (void)selectStartStationButtonPressed:(ConnectionsSelectionViewControlleriPad *)controller fromrect:(CGRect)rect {
    //NSLog(@"ConnectionsContainerViewControlleriPad: selectStartStationButtonPressed delegate");
    [self cancelCurrentRunningRequestsIfAny];
    
    [self showStationPickerControllerWithType: startStationTypeiPad fromrect:rect];
}

- (void)selectEndStationButtonPressed:(ConnectionsSelectionViewControlleriPad *)controller fromrect:(CGRect)rect{
    //NSLog(@"ConnectionsContainerViewControlleriPad: selectEndStationButtonPressed delegate");
    [self cancelCurrentRunningRequestsIfAny];
    
    [self showStationPickerControllerWithType: endStationTypeiPad fromrect:rect];
}

- (void)selectViaStationButtonPressed:(ConnectionsSelectionViewControlleriPad *)controller fromrect:(CGRect)rect {
    //NSLog(@"ConnectionsContainerViewControlleriPad: selectViaStationButtonPressed delegate");
    [self cancelCurrentRunningRequestsIfAny];
    
    [self showStationPickerControllerWithType: viaStationTypeiPad fromrect:rect];
}

- (void)didTriggerOpenShowViaStationWithVisibleFlag:(ConnectionsSelectionViewControlleriPad *)controller visible:(BOOL)visible {
    [self cancelCurrentRunningRequestsIfAny];
    self.viaStationIsVisible = visible;
}

- (void)showStationPickerControllerWithType:(NSUInteger)stationtype fromrect:(CGRect)rect {    
    CGFloat viewHeight =  self.view.frame.size.height - KEYBOARDHEIGHTLANDSCAPE;
    
    if (!self.searchStationPickerController) {
        self.searchStationPickerController = [[SearchStationPickerControlleriPad alloc] init];
        [self.searchStationPickerController.stationTextField resignFirstResponder];
        self.searchStationPickerController.managedObjectContext = self.managedObjectContext;
        self.searchStationPickerController.stationTypeIndex = stationtype;
        self.searchStationPickerController.delegate = self;
        self.searchStationPickerController.view.frame = CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH * 2, viewHeight);
        [self.searchStationPickerController.stationTextField resignFirstResponder];
        
        self.searchStationPickerController.managedObjectContext = self.managedObjectContext;
    }
    
    if (!self.searchStationPickerPopOverController) {
        UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH * 2, viewHeight)];
        popoverView.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        UIViewController* popoverContent = [[UIViewController alloc] init];
        [popoverView addSubview: self.searchStationPickerController.view];
        popoverContent.view = popoverView;
        
        popoverContent.contentSizeForViewInPopover = CGSizeMake(SPLITVIEWMAINVIEWWIDTH * 2, viewHeight);
        
        self.searchStationPickerPopOverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        
    }
    
    [self.searchStationPickerController.stationTextField resignFirstResponder];
    self.searchStationPickerController.stationTypeIndex = stationtype;
    self.searchStationPickerController.managedObjectContext = self.managedObjectContext;
    [self.searchStationPickerController clearStationSetting];
    [self.searchStationPickerController updateStationPickerWithData];
    self.searchStationPickerController.stationpickerType = connectionsStationpickerType;
    
    //self.currentlyPushedViewController = stationsPickerViewControllerConnectionsContaineriPad;
    CGRect buttonRectinView = [self.view convertRect: rect fromView: self.connectionsSelectionViewControlleriPad.view];
    
    [self.searchStationPickerPopOverController presentPopoverFromRect: buttonRectinView inView: self.view permittedArrowDirections: UIPopoverArrowDirectionLeft animated: YES];

    /*
    StationPickerViewControlleriPad  *stationPickerViewController = [[StationPickerViewControlleriPad alloc] init];
    [stationPickerViewController.stationTextField resignFirstResponder];
    stationPickerViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    stationPickerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    stationPickerViewController.managedObjectContext = self.managedObjectContext;
    stationPickerViewController.stationTypeIndex = stationtype;
    stationPickerViewController.delegate = self;
    stationPickerViewController.view.frame = self.view.bounds;
    [stationPickerViewController.stationTextField resignFirstResponder];
        
    stationPickerViewController.stationTypeIndex = stationtype;
    stationPickerViewController.managedObjectContext = self.managedObjectContext;

    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController: stationPickerViewController];
    naviController.navigationBarHidden = YES;
    [self.view addSubview: naviController.view];
    
    [self presentViewController: naviController animated: YES completion: ^{}];
    
    [stationPickerViewController updateStationPickerWithMapData];
    */ 
}

- (void)didSelectStationWithStationTypeIndex:(SearchStationPickerControlleriPad *)controller stationTypeIndex:(NSUInteger)index station:(Station *)station {
    
    //NSLog(@"ConnectionsContainerViewControlleriPad: didSelectStationWithStationTypeIndex delegate");
    
    self.currentlyPushedViewController = noViewControllerConnectionsContaineriPad;
    if (station) {
        if ((station.stationName && station.stationId) || (station.stationName && !station.stationId && station.latitude && station.longitude)) {
            //NSLog(@"Name only: %@, Id: %@, %.6f, %.6f", station.stationName, station.stationId, [station.latitude doubleValue], [station.longitude doubleValue]);
            if (index == startStationTypeiPad) {
                if (self.connectionsSelectionViewControlleriPad) {
                    [self.connectionsSelectionViewControlleriPad setStartLocationWithStation: station];
                }
            } else if (index == endStationTypeiPad) {
                if (self.connectionsSelectionViewControlleriPad) {
                    [self.connectionsSelectionViewControlleriPad setEndLocationWithStation: station];
                }
            } else if (index == viaStationTypeiPad) {
                if (self.connectionsSelectionViewControlleriPad) {
                    [self.connectionsSelectionViewControlleriPad setViaLocationWithStation: station];
                }
            }
        }
    }
    if (self.searchStationPickerPopOverController) {
        [self.searchStationPickerPopOverController dismissPopoverAnimated: YES];
    }
     
    //[self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didPressPushBackViewController:(SearchStationPickerControlleriPad *)controller {
    //NSLog(@"ConnectionsContainerViewControlleriPad: didPressPushBackViewController delegate");
    
    /*
    [UIView animateWithDuration: 0.2 animations:^{
        CGRect stationPickerAnimationFrame = self.stationPickerViewController.view.frame;
        stationPickerAnimationFrame.origin.y = self.view.frame.size.height;
        self.stationPickerViewController.view.frame = stationPickerAnimationFrame;
    } completion:^(BOOL finished){
        self.stationPickerViewController.view.alpha = 0.0;
    }];
    */
    
    if (self.searchStationPickerPopOverController) {
        [self.searchStationPickerPopOverController dismissPopoverAnimated: YES];
    }
    
    //[self dismissViewControllerAnimated:YES completion:^{}];

}

- (void) showInfoViewController:(id)sender {

}

- (void) showClosestStations:(id)sender {
    
    [self cancelCurrentRunningRequestsIfAny];
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable)
    {
        [self hideLoadingIndicator];
        [[NoticeviewMessages sharedNoticeMessagesController] showNoNetworkErrorMessage: self.view];
        return;
    }
    
    if (self.connectionsMapViewController) {
        [self.connectionsMapViewController stopAllMapTransactionsAndRemoveOverlayAndAnnotations];
        self.connectionsMapViewController.managedObjectContext = self.managedObjectContext;
        [self.connectionsMapViewController getStationsAndUpdateMapView];
    }
}

- (void) showcalendarview:(id)sender {
    
    CGFloat calendarviewwidth = SPLITVIEWMAINVIEWWIDTH * 2.0;
    if (!self.calendarViewController) {
        self.calendarViewController = [[MSCalendarViewController alloc] init];
        self.calendarViewController.view.frame = CGRectMake(0, 0, calendarviewwidth, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT - LISTVIEWCONTROLLERHEIGHTPAD);
    }
    if (!self.calendarViewPopOverController) {
        self.calendarViewController.view.frame = CGRectMake(0, 0, calendarviewwidth, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT - LISTVIEWCONTROLLERHEIGHTPAD);
        UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, calendarviewwidth, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT - LISTVIEWCONTROLLERHEIGHTPAD)];
        popoverView.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        UIViewController* popoverContent = [[UIViewController alloc] init];
        [popoverView addSubview:self.calendarViewController.view];
        popoverContent.view = popoverView;
        
        popoverContent.contentSizeForViewInPopover = CGSizeMake(calendarviewwidth, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT - LISTVIEWCONTROLLERHEIGHTPAD);
            
        self.calendarViewPopOverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    }

    CGRect rect = self.calendarviewButton.frame;
    [self.calendarViewController setJourneyDetailWithConnectionAndConsectionIndex: self.selectedOverviewIndex consectionIndex: self.selectedDetailIndex];
    [self.calendarViewPopOverController presentPopoverFromRect: rect inView: self.view permittedArrowDirections: UIPopoverArrowDirectionUp animated: YES];
    [self.calendarViewController updateViewData];
}

- (void) showListViewController:(id)sender {
    if (!self.connectionsListViewController) {
        self.connectionsListViewController = [[ConnectionsListViewController alloc] init];
        self.connectionsListViewController.view.frame = CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT - LISTVIEWCONTROLLERHEIGHTPAD);
    }
    if (!self.listViewPopOverController) {
        self.connectionsListViewController.view.frame = CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT - LISTVIEWCONTROLLERHEIGHTPAD);
        UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT - LISTVIEWCONTROLLERHEIGHTPAD)];
        //popoverView.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        popoverView.backgroundColor = [UIColor listviewControllersBackgroundColor];
        UIViewController* popoverContent = [[UIViewController alloc] init];
        [popoverView addSubview:self.connectionsListViewController.view];
        popoverContent.view = popoverView;
        
        popoverContent.contentSizeForViewInPopover = CGSizeMake(SPLITVIEWMAINVIEWWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT - LISTVIEWCONTROLLERHEIGHTPAD);
        
        //popoverContent.contentSizeForViewInPopover = self.connectionsListViewController.tableView.contentSize;
        
        self.listViewPopOverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        
        /*
        self.connectionsListViewController.view.frame = CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT - LISTVIEWCONTROLLERHEIGHTPAD);
        self.connectionsListViewController.contentSizeForViewInPopover = CGSizeMake(SPLITVIEWMAINVIEWWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT - LISTVIEWCONTROLLERHEIGHTPAD);
        //self.listViewPopOverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        self.listViewPopOverController = [[UIPopoverController alloc] initWithContentViewController:self.connectionsListViewController];
        */ 
    }
    self.connectionsListViewController.mapViewControllerReference = self.connectionsMapViewController;
    //self.currentlyPushedViewController = connectionsListViewControllerConnectionsContaineriPad;
    CGRect rect = self.listButton.frame;
    [self.connectionsListViewController setJourneyDetailWithConnectionAndConsectionIndex: self.selectedOverviewIndex consectionIndex: self.selectedDetailIndex];
    [self.listViewPopOverController presentPopoverFromRect: rect inView: self.view permittedArrowDirections: UIPopoverArrowDirectionUp animated: YES];
    [self.connectionsListViewController.tableView reloadData];
}

- (void)dateAndTimePickerButtonPressedFromRect:(CGRect)rect withdate:(NSDate *)date deparr:(BOOL)deparr {
    //NSLog(@"Show date time picker pop over");
    
    [self cancelCurrentRunningRequestsIfAny];
    
    if (!self.dtPickerPopOverController) {
        UIViewController* popoverContent = [[UIViewController alloc] init];
        UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 336)];
        popoverView.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        
        UIButton *goButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *goButtonImage = [UIImage newImageFromMaskImage: [UIImage goButtonImage] inColor: [UIColor selectStationsViewButtonColorNormal]];
        UIImage *goButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage goButtonImage] inColor: [UIColor selectStationsViewButtonColorHighlighted]];
        [goButton setImage: goButtonImage forState: UIControlStateNormal];
        [goButton setImage: goButtonImageHighlighted forState: UIControlStateHighlighted];
        goButton.imageView.contentMode = UIViewContentModeCenter;
        goButton.frame = CGRectMake(5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
        goButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        goButton.showsTouchWhenHighlighted = YES;
        [goButton addTarget: self action: @selector(takeNewRequestTime:) forControlEvents:UIControlEventTouchUpInside];
        [popoverView addSubview: goButton];
        
        UIButton *timenowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *timenowButtonImage = [UIImage newImageFromMaskImage: [UIImage timenowButtonImage] inColor: [UIColor selectStationsViewButtonColorNormal]];
        UIImage *timenowButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage timenowButtonImage] inColor: [UIColor selectStationsViewButtonColorHighlighted]];
        [timenowButton setImage: timenowButtonImage forState: UIControlStateNormal];
        [timenowButton setImage: timenowButtonImageHighlighted forState: UIControlStateHighlighted];
        timenowButton.imageView.contentMode = UIViewContentModeCenter;
        timenowButton.frame = CGRectMake(5 + BUTTONHEIGHT + 20, 0, BUTTONHEIGHT, BUTTONHEIGHT);
        timenowButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        timenowButton.showsTouchWhenHighlighted = YES;
        [timenowButton addTarget:self action: @selector(updatePickerWithTimeNow:) forControlEvents:UIControlEventTouchUpInside];
        [popoverView addSubview: timenowButton];
        
        self.dtDatePicker = [[UIDatePicker alloc] init];
        self.dtDatePicker.frame = CGRectMake(0, 36, 320, 300);
        
        //[popoverView addSubview:toolbar];
        [popoverView addSubview:self.dtDatePicker];
        popoverContent.view = popoverView;
        
        popoverContent.contentSizeForViewInPopover = CGSizeMake(320, 244);
    
        self.dtPickerPopOverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    }
    
    self.dtDatePicker.date = date;
    //present the popover view non-modal with a
    //refrence to the button pressed within the current view
    

    //NSLog(@"Time button rect: %.1f, %.1f, %.1f, %.1f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    //self.currentlyPushedViewController = dateAndTimePickerViewControllerConnectionsContaineriPad;
    self.dtPickerDepArr = deparr;
    [self.dtPickerPopOverController presentPopoverFromRect: rect inView: self.view permittedArrowDirections: UIPopoverArrowDirectionLeft animated: YES];
    
    //NSLog(@"Pop over is visible");
}

- (void) updatePickerWithTimeNow:(id)sender {
    //NSLog(@"Set time now");
    [self.dtDatePicker setDate: [NSDate date] animated: YES];
}

- (void) takeNewRequestTime:(id)sender {
    //NSLog(@"Set time");
    self.currentlyPushedViewController = noViewControllerConnectionsContaineriPad;
    [self.dtPickerPopOverController dismissPopoverAnimated: YES];
    if (self.connectionsSelectionViewControlleriPad) {
        [self.connectionsSelectionViewControlleriPad setConnectionDate: self.dtDatePicker.date depArr: self.dtPickerDepArr];
    }
}

- (void) pushOutConnectionsResultController:(id)sender {
    [self cancelCurrentRunningRequestsIfAny];
    [self moveConnectionsResultContainerViewOffScreen];
    
}

- (void)hideLoadingIndicator {
    
    [MBProgressHUD hideAllHUDsForView: self.view animated: NO];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)showLoadingIndicator {
    [self hideLoadingIndicator];
    
    [MBProgressHUD hideAllHUDsForView: self.view animated: NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)didTriggerStartSearch:(ConnectionsSelectionViewControlleriPad *)controller {
    [self executeSBBAPIRequest: nil];
}

-(void) executeSBBAPIRequest:(id) sender {
    
    [self.connectionsMapViewController stopAllMapTransactionsAndRemoveOverlayAndAnnotations];
    [self cancelCurrentRunningRequestsIfAny];
    [self getConnections: sender];
}

- (BOOL) checkIfInCH: (CLLocationCoordinate2D) coordinate {
    if (coordinate.latitude > 47.818688) return NO;
    if (coordinate.latitude < 45.79817) return NO;
    if (coordinate.longitude > 10.508423) return NO;
    if (coordinate.longitude < 5.921631) return NO;
    return YES;
}

-(void) getConnections:(id) sender {
    
    [self showLoadingIndicator];
    
    if (!self.connectionsSelectionViewControlleriPad) {
        return;
    }
    
    Station *startStation = [self.connectionsSelectionViewControlleriPad getStartLocation];
    Station *endStation = [self.connectionsSelectionViewControlleriPad getEndLocation];
    
    Station *viaStation = nil;
    
    Station *tempViaStation = [self.connectionsSelectionViewControlleriPad getViaLocation];
    if (tempViaStation.stationName && tempViaStation.stationId) {
        viaStation = [[Station alloc] init];
        [viaStation setStationName: tempViaStation.stationName];
        [viaStation setStationId: tempViaStation.stationId];
    }
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable)
    {
        
        [self hideLoadingIndicator];
        
        //UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        //[[NoticeviewMessages sharedNoticeMessagesController] showNoNetworkErrorMessage: currentWindow];
        
        [[NoticeviewMessages sharedNoticeMessagesController] showNoNetworkErrorMessage: self.view];
        
        return;
    }
    
    if ((!startStation.stationName && !endStation.stationName) || [startStation.stationName isEqualToString: endStation.stationName])
	{
		[self hideLoadingIndicator];
        
        //UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        //[[NoticeviewMessages sharedNoticeMessagesController] showConStationsIdenticalMessage: currentWindow];
        
        [[NoticeviewMessages sharedNoticeMessagesController] showConStationsIdenticalMessage: self.view];
        
		return;
	}
    /*
     if (!self.startStationName || !self.endStationName)
     {
     [self.activityIndicatorView stopAnimating];
     self.activityIndicatorView.alpha = 0.0;
     
     WBInfoNoticeView *notice = [WBInfoNoticeView infoNoticeInWindow:NSLocalizedString(@"Current location used", @"Selectstationsviewcontroller current location used title") message: NSLocalizedString(@"One of the stations is the current location. This is not yet supported.", @"Selectstationsviewcontroller current location used message")];
     [notice show];
     
     return;
     }
     */
    
    NSDate *connectionTime; BOOL isDepartureTime = YES;
    
    connectionTime = [self.connectionsSelectionViewControlleriPad getConnectionDate];
    isDepartureTime = [self.connectionsSelectionViewControlleriPad getConnectionDateDepArr];
    
    /*
    if (isDepartureTime) {
        NSLog(@"Search with startdate");
    } else {
        NSLog(@"Search with enddate");
    }
    */
    
    if (!connectionTime) {
        connectionTime = [NSDate date];
        isDepartureTime = YES;
    }
        
    if (!startStation.stationName || !endStation.stationName) {
             
        BKLocationManager *manager = [BKLocationManager sharedManager];
    
        [manager setDidUpdateLocationBlock:^(CLLocationManager *manager, CLLocation *newLocation, CLLocation *oldLocation) {
            //NSLog(@"didUpdateLocation: lat: %.6f, %.6f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
            self.userLocation = newLocation;
            self.userLocationDate = [NSDate date];
                        
            if (![self checkIfInCH: newLocation.coordinate]) {
                
                //UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
                //[[NoticeviewMessages sharedNoticeMessagesController] showLocationOutsideSwitzerland: currentWindow];
                [[NoticeviewMessages sharedNoticeMessagesController] showLocationOutsideSwitzerland: self.view];
            }
            
            if (!startStation.stationName) {
                //startStation = [[Station alloc] init];
                startStation.latitude = [NSNumber numberWithFloat: newLocation.coordinate.latitude];
                startStation.longitude = [NSNumber numberWithFloat: newLocation.coordinate.longitude];
                startStation.stationName = nil;
                startStation.stationId = nil;
                
                //NSLog(@"Set start station: lat: %@, %@", [startStation latitude], [startStation longitude]);
                
            } else {
                //endStation = [[Station alloc] init];
                endStation.latitude = [NSNumber numberWithFloat: newLocation.coordinate.latitude];
                endStation.longitude = [NSNumber numberWithFloat: newLocation.coordinate.longitude];
                endStation.stationName = nil;
                endStation.stationId = nil;
                //NSLog(@"Set start station: lat: %@, %@", [endStation latitude], [endStation longitude]);
            }
            
            [manager stopUpdatingLocation];
            manager = nil;
            
            if ([[SBBAPIController sharedSBBAPIController] conreqRequestInProgress]) {
                [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIConreqOperations];
            }
            
            //if (self.connectionsContainerViewController) {
            //    self.connectionsContainerViewController = nil;
            //}
            
            [[SBBAPIController sharedSBBAPIController] sendConReqXMLConnectionRequest: startStation
                                                                           endStation: endStation
                                                                           viaStation: viaStation
                                                                              conDate: connectionTime
                                                                        departureTime: isDepartureTime
                                                                         successBlock: ^(NSUInteger numberofresults){
                                                                             [self hideLoadingIndicator];
                                                                             
                                                    
                                                                             if (numberofresults > 0) {
                                                                                 //NSLog(@"Con req request got results with gps loc");
                                                                                 //self.connectionsContainerViewController = [[ConnectionsContainerViewController alloc] init];
                                                                                 self.currentlyPushedViewController = connectionsViewControllerConnectionsContaineriPad;
                                                                                 //[self.navigationController pushViewController: self.connectionsContainerViewController animated: YES];
                                                                                 [self moveConnectionsResultContainerViewOnScreen];
                                                                                 self.selectedOverviewIndex = 0;
                                                                                 self.selectedDetailIndex = 9999;
                                                                                 [self.connectionsResultContainerViewController updateOverViewAndDetailViewWithConnectionIndex:0];
                                                                                 [self.connectionsMapViewController setJourneyDetailWithConnectionAndConsectionIndex: self.selectedOverviewIndex consectionIndex: 9999];
                                                                                 [self setJourneyDetailWithConnectionAndConsectionIndex: self.selectedOverviewIndex consectionIndex: 9999];
                                                                             } else {
                                                                                 [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqDidNotReturnAnyResultNotice: self.view];
                                                                             }
                                                                         }
                                                                         failureBlock: ^(NSUInteger errorcode){
                                                                             [self hideLoadingIndicator];
                                                                             //NSUInteger kConReqRequestFailureConnectionFailed = 85;
                                                                             //NSUInteger kConScrRequestFailureConnectionFailed = 45;
                                                                             //NSUInteger kStbReqRequestFailureConnectionFailed = 75;
                                                                             //NSUInteger kStbScrRequestFailureConnectionFailed = 51;
                                                                             //NSUInteger kJrnReqRequestFailureConnectionFailed = 65;
                                                                             //NSUInteger kRssReqRequestFailureConnectionFailed = 95;
                                                                             //NSUInteger kConReqRequestFailureCancelled = 8599;
                                                                             
                                                                             //NSUInteger kSbbReqStationsNotDefined = 112;
                                                                             
                                                                             if (errorcode == kConReqRequestFailureConnectionFailed) {
                                                                                 [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqFailedNotice:self.view];
                                                                             } else if (errorcode == kSbbReqStationsNotDefined) {
                                                                                 [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqStationsNotAvailableNotice:self.view];
                                                                             } else if (errorcode == kConReqRequestFailureCancelled) {
                                                                               // Nothing to do
                                                                             } else if (errorcode == kConRegRequestFailureNoNewResults) {
                                                                                 [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqDidNotReturnAnyResultNotice: self.view];
                                                                             } else {
                                                                                 [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqOtherUndefinedErrorNotice:self.view];
                                                                             }
                                                                             
                                                                         }];
            
        }];
        
        [manager setDidFailBlock:^(CLLocationManager *manager, NSError *error) {
            //NSLog(@"didFailUpdateLocation");
                        
            [self hideLoadingIndicator];
            
            [manager stopUpdatingLocation];
            manager = nil;
            
            NSString * errorMessage;
            NSUInteger errorCode = 0;
            
            switch ([error code]) {
                    
                case kCLErrorLocationUnknown:
                    errorMessage =
                    NSLocalizedString(@"We could not determine your location. Please try again later.", nil);
                    errorCode = 1;
                    break;
                    
                case kCLErrorDenied:
                    errorMessage =
                    NSLocalizedString(@"We could not access your current location.", nil);
                    errorCode = 2;
                    break;
                    
                default:
                    errorMessage =
                    NSLocalizedString(@"An unexpected error occured when trying to determine your location.", nil);
                    errorCode = 1;
                    break;
                    
            };
            
            NSLog(@"Error: %@", errorMessage);
            
            if (errorCode == 2) {
                //UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
                //[[NoticeviewMessages sharedNoticeMessagesController] showLocationManagerDenied: currentWindow];
                [[NoticeviewMessages sharedNoticeMessagesController] showLocationManagerDenied: self.view];
            } else {
                //UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
                //[[NoticeviewMessages sharedNoticeMessagesController] showLocationManagerError:currentWindow];
                [[NoticeviewMessages sharedNoticeMessagesController] showLocationManagerError:self.view];
            }
        }];
                
        [manager stopUpdatingLocationAndRestManager];
        [manager startUpdatingLocationWithAccuracy:kCLLocationAccuracyHundredMeters];
        return;
    }
        
    if ([[SBBAPIController sharedSBBAPIController] conreqRequestInProgress]) {
        [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIConreqOperations];
    }
    
    //if (self.connectionsContainerViewController) {
    //    self.connectionsContainerViewController = nil;
    //}
        
    [[SBBAPIController sharedSBBAPIController] sendConReqXMLConnectionRequest: startStation
                                                                   endStation: endStation
                                                                   viaStation: viaStation
                                                                      conDate: connectionTime
                                                                departureTime: isDepartureTime
                                                                 successBlock: ^(NSUInteger numberofresults){
                                                                     [self hideLoadingIndicator];
                                                                     
                                                                     if (numberofresults > 0) {
                                                                         //NSLog(@"Con req request got results with stations");
                                                                         //self.connectionsContainerViewController = [[ConnectionsContainerViewController alloc] init];
                                                                         self.currentlyPushedViewController = connectionsViewControllerConnectionsContaineriPad;
                                                                         
                                                                         //[self.navigationController pushViewController: self.connectionsContainerViewController animated: YES];
                                                                         [self moveConnectionsResultContainerViewOnScreen];
                                                                         self.selectedOverviewIndex = 0;
                                                                         self.selectedDetailIndex = 9999;
                                                                         [self.connectionsResultContainerViewController updateOverViewAndDetailViewWithConnectionIndex:0];
                                                                         [self.connectionsMapViewController setJourneyDetailWithConnectionAndConsectionIndex: self.selectedOverviewIndex consectionIndex: 9999];
                                                                         [self setJourneyDetailWithConnectionAndConsectionIndex: self.selectedOverviewIndex consectionIndex: 9999];
                                                                         
                                                                     } else {
                                                                         [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqDidNotReturnAnyResultNotice: self.view];
                                                                     }
                                                                 }
                                                                 failureBlock: ^(NSUInteger errorcode){
                                                                     [self hideLoadingIndicator];
                                                                     //NSUInteger kConReqRequestFailureConnectionFailed = 85;
                                                                     //NSUInteger kConScrRequestFailureConnectionFailed = 45;
                                                                     //NSUInteger kStbReqRequestFailureConnectionFailed = 75;
                                                                     //NSUInteger kStbScrRequestFailureConnectionFailed = 51;
                                                                     //NSUInteger kJrnReqRequestFailureConnectionFailed = 65;
                                                                     //NSUInteger kRssReqRequestFailureConnectionFailed = 95;
                                                                     //NSUInteger kConReqRequestFailureCancelled = 8599;
                                                                     
                                                                     //NSUInteger kSbbReqStationsNotDefined = 112;
                                                                     
                                                                     if (errorcode == kConReqRequestFailureConnectionFailed) {
                                                                         [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqFailedNotice:self.view];
                                                                     } else if (errorcode == kSbbReqStationsNotDefined) {
                                                                         [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqStationsNotAvailableNotice:self.view];
                                                                     } else if (errorcode == kConReqRequestFailureCancelled) {
                                                                         // Nothing to do
                                                                     } else if (errorcode == kConRegRequestFailureNoNewResults) {
                                                                         [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqDidNotReturnAnyResultNotice: self.view];
                                                                     } else {
                                                                         [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqOtherUndefinedErrorNotice:self.view];
                                                                     }
                                                                 }];
    
    //ConnectionsContainerViewController *connectionsContainerViewController = [[ConnectionsContainerViewController alloc] init];
    //[self.navigationController pushViewController: connectionsContainerViewController animated: YES];
}

- (void) setJourneyDetailWithConnectionAndConsectionIndex:(NSUInteger)connectionIndex consectionIndex:(NSUInteger)consectionIndex {
    
    //NSLog(@"ConectionContainerViewController: setJourneyDetailWithConnectionIndex. Show Top info view");
    
    //CGRect viewFrame = self.topInfoView.frame;
    
    //NSLog(@"TopInfoView frame: %.1f, %.1f, %.1f, %.1f", viewFrame.origin.x, viewFrame.origin.y, viewFrame.size.width, viewFrame.size.height);
    
    int startPositionInfoView = (self.view.frame.size.width - 350) / 2;
    int infoViewWidth = 350;
    self.topInfoView.frame = CGRectMake(startPositionInfoView, 0, infoViewWidth, TOOLBARHEIGHTIPAD);
    
    self.topInfoView.alpha = 1.0;
    
    if (consectionIndex == 9999) {
        
        //NSLog(@"ConectionContainerViewController: setJourneyDetailWithConnectionIndex. Show Top info view. All type");
        
        NSArray *basicStopList = [[SBBAPIController sharedSBBAPIController] getAllBasicStopsForConnectionResultWithIndex: connectionIndex];
        
        if ([basicStopList count] >= 2) {
            NSString *fromStationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList objectAtIndex: 0]];
            NSString *toStationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList lastObject]];
            NSString *arrivalTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForBasicStop: [basicStopList lastObject]];
            NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForBasicStop: [basicStopList objectAtIndex: 0]];
            self.bottomInfoStartStationLabel.text = fromStationName;
            self.bottomInfoEndStationLabel.text = toStationName;
            self.bottomInfoDepartureTimeLabel.text = departureTime;
            self.bottomInfoArrivalTimeLabel.text = arrivalTime;
        } else {
            self.bottomInfoStartStationLabel.text = nil;
            self.bottomInfoEndStationLabel.text = nil;
            self.bottomInfoDepartureTimeLabel.text = nil;
            self.bottomInfoArrivalTimeLabel.text = nil;
        }
        
        
        [self.topInfoTransportTypeImageView setImage: nil];
        [self.topInfoTransportNameImageView setImage: nil];
        
    } else {
        //NSLog(@"Journey detail: set connection and consection index: %d, %d", connectionIndex, consectionIndex);
        
        //ConResult *conResult = [[[[SBBAPIController sharedSBBAPIController] connectionsResult] conResults] objectAtIndex: self.connectionIndex];
        //ConSection *conSection = [[[conResult conSectionList] conSections] objectAtIndex: self.consectionIndex];
        
        ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: connectionIndex consectionIndex: consectionIndex];
        //NSUInteger journeyTypeFlag = [conSection conSectionType];
        
        UIImage *transportTypeImage = [[SBBAPIController sharedSBBAPIController] renderTransportTypeImageForConsection: conSection];
        UIImage *transportNameImage = [[SBBAPIController sharedSBBAPIController] renderTransportNameImageForConsection: conSection];
        
        NSArray *basicStopList = [[SBBAPIController sharedSBBAPIController] getBasicStopsForConsection:conSection];
        
        if ([basicStopList count] >= 2) {
            NSString *fromStationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList objectAtIndex: 0]];
            NSString *toStationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList lastObject]];
            NSString *arrivalTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForBasicStop: [basicStopList lastObject]];
            NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForBasicStop: [basicStopList objectAtIndex: 0]];
            self.bottomInfoStartStationLabel.text = fromStationName;
            self.bottomInfoEndStationLabel.text = toStationName;
            self.bottomInfoDepartureTimeLabel.text = departureTime;
            self.bottomInfoArrivalTimeLabel.text = arrivalTime;
        } else {
            self.bottomInfoStartStationLabel.text = nil;
            self.bottomInfoEndStationLabel.text = nil;
            self.bottomInfoDepartureTimeLabel.text = nil;
            self.bottomInfoArrivalTimeLabel.text = nil;
        }
        
        [self.topInfoTransportTypeImageView setImage: transportTypeImage];
        [self.topInfoTransportNameImageView setImage: transportNameImage];
                
        //NSLog(@"Set type: %@", (journeyTypeFlag == walkType)?@"WALK":@"JOURNEY");
    }
    
    //self.topInfoView.backgroundColor = [UIColor connectionsJourneyDetailViewTopInfoViewMapBackgroundColoriPad];
    self.bottomInfoStartStationLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
    self.bottomInfoEndStationLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
    self.bottomInfoDepartureTimeLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
    self.bottomInfoArrivalTimeLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
}

- (void) moveConnectionsResultContainerViewOffScreen {
    #ifdef LOGOUTPUTON
    NSLog(@"moveConnectionsContainerViewOffScreen");
    #endif
    
    [self forceLeaveLocationHeadingModeIfNecessary];
    self.locationheadingButton.alpha = 0.0;
    self.trainlineButton.alpha = 0.0;
        
    CGRect currentFrame = self.connectionsResultContainerViewController.view.frame;
    //NSLog(@"Origin: %.1f", currentFrame.origin.x);
    currentFrame.origin.x = -320;
    self.goButton.alpha = 0.0;
    self.backButton.alpha = 0.0;
    self.listButton.alpha = 0.0;
    self.topInfoView.alpha = 0.0;
    self.shareButton.alpha = 0.0;
    self.closestStationsButton.alpha = 0.0;
    
    #ifdef IncludeAlarmAndAddToCalendar
    self.setalarmButton.alpha = 0.0;
    self.addtocalendarButton.alpha = 0.0;
    #endif
    
    #ifdef IncludeCalendarView
    self.calendarviewButton.alpha = 0.0;
    #endif
    
    [self.listViewPopOverController dismissPopoverAnimated: YES];
    [self.connectionsMapViewController stopAllMapTransactionsAndRemoveOverlayAndAnnotations];
    [UIView animateWithDuration: 0.3 animations: ^{
        self.connectionsResultContainerViewController.view.frame = currentFrame;
        
        self.goButton.alpha = 1.0;

        self.closestStationsButton.alpha = 1.0;
        //NSLog(@"Origin: %.1f", self.connectionsResultContainerViewController.view.frame.origin.x);
    } completion:^(BOOL finished){
    
    }];
}

- (void) moveConnectionsResultContainerViewOnScreen {
    #ifdef LOGOUTPUTON
    NSLog(@"moveConnectionsContainerViewOnScreen");
    #endif
    
    CGRect currentFrame = self.connectionsResultContainerViewController.view.frame;
    //NSLog(@"Origin: %.1f", currentFrame.origin.x);
    currentFrame.origin.x = 0;
    self.goButton.alpha = 0.0;
    self.backButton.alpha = 0.0;
    self.listButton.alpha = 0.0;
    self.shareButton.alpha = 0.0;
    self.closestStationsButton.alpha = 0.0;
    
    #ifdef IncludeAlarmAndAddToCalendar
    self.setalarmButton.alpha = 0.0;
    self.addtocalendarButton.alpha = 0.0;
    #endif
    
    #ifdef IncludeCalendarView
    self.calendarviewButton.alpha = 0.0;
    #endif
        
    if (self.connectionsResultContainerViewController) {
        [self.connectionsResultContainerViewController moveConnectionsResultOverviewtableviewToTopRow];
    }
    
    [UIView animateWithDuration: 0.3 animations: ^{
        self.connectionsResultContainerViewController.view.frame = currentFrame;
        self.backButton.alpha = 1.0;
        self.listButton.alpha = 1.0;
        self.shareButton.alpha = 1.0;
        
        #ifdef IncludeAlarmAndAddToCalendar
        self.setalarmButton.alpha = 1.0;
        self.addtocalendarButton.alpha = 1.0;
        #endif
        
        #ifdef IncludeCalendarView
        self.calendarviewButton.alpha = 1.0;
        #endif
        
        //NSLog(@"Origin: %.1f", self.connectionsResultContainerViewController.view.frame.origin.x);
    } completion:^(BOOL finished){
        
    }];
}

- (void)showNoNetworkErrorMessage {
    [[NoticeviewMessages sharedNoticeMessagesController] showNoNetworkErrorMessage: self.view];
}

- (void)showGeocodingErrorMessage {
    [[NoticeviewMessages sharedNoticeMessagesController] showGeocodingErrorMessage: self.view];
}

- (void)didSelectOverviewCellWithIndex:(ConnectionsOverviewViewControlleriPad *)controller index:(NSUInteger)index {
    //NSLog(@"ConnectionsContainerViewControlleriPad: didSelectOverviewCellWithIndex: %d", index);
    self.selectedOverviewIndex = index;
    self.selectedDetailIndex = 9999;
    [self.connectionsMapViewController setJourneyDetailWithConnectionAndConsectionIndex: self.selectedOverviewIndex consectionIndex: 9999];
    [self.connectionsListViewController setJourneyDetailWithConnectionAndConsectionIndex: self.selectedOverviewIndex consectionIndex: 9999];
    [self setJourneyDetailWithConnectionAndConsectionIndex: self.selectedOverviewIndex consectionIndex: 9999];
    self.locationheadingButton.alpha = 0.0;
    self.trainlineButton.alpha = 0.0;
        
    [self forceLeaveLocationHeadingModeIfNecessary];
}

- (void)didTriggerOverviewCellWithIndexLongPress:(ConnectionsOverviewViewControlleriPad *)controller index:(NSUInteger)index {
    //NSLog(@"ConnectionsContainerViewControlleriPad: didTriggerOverviewCellWithIndexLongPress");
    [self forceLeaveLocationHeadingModeIfNecessary];
}

- (void)didSelectDetailviewCellWithIndex:(ConnectionsDetailViewControlleriPad *)controller index:(NSUInteger)index {
    //NSLog(@"ConnectionsContainerViewControlleriPad: didSelectDetailviewCellWithIndex");

    self.trainlineButton.alpha = 0.0;
        
    self.selectedDetailIndex = index;
    [self.connectionsMapViewController stopAllMapTransactions];
    [self.connectionsMapViewController setJourneyDetailWithConnectionAndConsectionIndex: self.selectedOverviewIndex consectionIndex: index];
    [self.connectionsListViewController setJourneyDetailWithConnectionAndConsectionIndex: self.selectedOverviewIndex consectionIndex: index];
    [self setJourneyDetailWithConnectionAndConsectionIndex: self.selectedOverviewIndex consectionIndex: index];
    
    ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.selectedOverviewIndex consectionIndex: index];
    NSUInteger journeyTypeFlag = [conSection conSectionType];
    if (journeyTypeFlag == walkType) {
        if ([CLLocationManager locationServicesEnabled] && [CLLocationManager headingAvailable]) {
            self.locationheadingButton.alpha = 1.0;
        } else {
            self.locationheadingButton.alpha = 0.0;
        }
    } else {
        self.locationheadingButton.alpha = 0.0;
    }
    
    [self forceLeaveLocationHeadingModeIfNecessary];
}

- (void)didTriggerDetailviewCellWithIndexLongPress:(ConnectionsDetailViewControlleriPad *)controller index:(NSUInteger)index viewrect:(CGRect)viewrect {
    //NSLog(@"ConnectionsContainerViewControlleriPad: didTriggerDetailviewCellWithIndexLongPress: %d", index);

    ConSection *conSection =  [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: self.selectedOverviewIndex consectionIndex: index];
    if ([conSection conSectionType] == walkType) {
        RIButtonItem *cancelButton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Cancel", @"Open maps app cancel block action sheet title")];
        RIButtonItem *openButton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Open in maps", @"Open maps app open block action sheet title")];
        openButton.action = ^{
            MKMapItem *arrivalItem = [[SBBAPIController sharedSBBAPIController] getArrivalMapItemForConsection: conSection];
            MKMapItem *departureItem = [[SBBAPIController sharedSBBAPIController] getDepartureMapItemNameForConsection: conSection];
            if (arrivalItem && departureItem) {
                NSArray *mapItems = @[departureItem, arrivalItem];
                NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
                [MKMapItem openMapsWithItems:mapItems launchOptions:launchOptions];
            }
        };
        UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle: NSLocalizedString(@"Maps", @"Open maps app block action sheet title") cancelButtonItem: cancelButton destructiveButtonItem: nil otherButtonItems: openButton , nil];
        //[shareActionSheet showInView: self.view.superview];
        shareActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [shareActionSheet showFromRect: viewrect inView: self.view animated: YES];
    }
    
    [self forceLeaveLocationHeadingModeIfNecessary];
}

- (void)didTriggerMapViewJourneyWithLongPress:(ConnectionsMapViewController *)controller startitem:(MKMapItem *)startitem enditem:(MKMapItem *)enditem viewrect:(CGRect)viewrect {
    //NSLog(@"ConnectionsContainerViewControlleriPad: didTriggerMapViewJourneyWith long press");
    if (startitem && enditem) {
        //NSLog(@"ConnectionsContainerViewControlleriPad: didTriggerMapViewJourneyWith long press. Items there");
        RIButtonItem *cancelButton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Cancel", @"Open maps app cancel block action sheet title")];
        RIButtonItem *openButton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Open in maps", @"Open maps app open block action sheet title")];
        openButton.action = ^{
            NSArray *mapItems = @[startitem, enditem];
            NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
            [MKMapItem openMapsWithItems:mapItems launchOptions:launchOptions];
        };
        UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle: NSLocalizedString(@"Maps", @"Open maps app block action sheet title") cancelButtonItem: cancelButton destructiveButtonItem: nil otherButtonItems: openButton , nil];
        //[shareActionSheet showInView: self.view.superview];
        shareActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        
        CGRect overlerayRectinView = [self.view convertRect: viewrect fromView: self.connectionsMapViewController.view];
        
        //NSLog(@"ConnectionsContainerViewControlleriPad: view frame: %.1f %.1f, %.1f. %.1f", viewrect.origin.x, viewrect.origin.y, viewrect.size.width, viewrect.size.height);
        //NSLog(@"ConnectionsContainerViewControlleriPad: view frame of overlay: %.1f %.1f, %.1f. %.1f", overlerayRectinView.origin.x, overlerayRectinView.origin.y, overlerayRectinView.size.width, overlerayRectinView.size.height);
        
        [shareActionSheet showFromRect: overlerayRectinView inView: self.view animated: YES];
    }
    
    [self forceLeaveLocationHeadingModeIfNecessary];
}

- (void)didSelectStationPickerAnnotaton:(ConnectionsMapViewController *)controller station:(Station *)station viewrect:(CGRect)viewrect {
    //NSLog(@"ConnectionsContainerViewControlleriPad: didSelectStationPickerPinAnnotation");
    if (station && station.stationName && station.stationId) {
        
        //NSLog(@"ConnectionsContainerViewControlleriPad: didSelectStationPickerPinAnnotation: %@", station.stationName);
        
        //RIButtonItem *cancelButton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Cancel", @"Open maps app cancel block action sheet title")];
        RIButtonItem *stationAsStart = [RIButtonItem itemWithLabel: NSLocalizedString(@"From here", @"Select as start station block action sheet title")];
        stationAsStart.action = ^{
            //NSLog(@"Station as start");
            [self.connectionsSelectionViewControlleriPad setStartLocationWithStation: station];
        };
        RIButtonItem *stationAsEnd = [RIButtonItem itemWithLabel: NSLocalizedString(@"To here", @"Select as end station block action sheet title")];
        stationAsEnd.action = ^{
            //NSLog(@"Station as end");
            [self.connectionsSelectionViewControlleriPad setEndLocationWithStation: station];
        };
        UIActionSheet *stationActionSheet;
        if (self.viaStationIsVisible) {
            RIButtonItem *stationAsVia = [RIButtonItem itemWithLabel: NSLocalizedString(@"Via", @"Select as via station block action sheet title")];
            stationAsVia.action = ^{
                //NSLog(@"Station as via");
                [self.connectionsSelectionViewControlleriPad setViaLocationWithStation: station];
            };
            stationActionSheet = [[UIActionSheet alloc] initWithTitle: station.stationName cancelButtonItem: nil destructiveButtonItem: nil otherButtonItems: stationAsStart, stationAsEnd, stationAsVia ,nil];
        } else {
            stationActionSheet = [[UIActionSheet alloc] initWithTitle: station.stationName cancelButtonItem: nil destructiveButtonItem: nil otherButtonItems: stationAsStart, stationAsEnd, nil];
        }
        
        //[shareActionSheet showInView: self.view.superview];
        stationActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;

        CGRect overlerayRectinView = [self.view convertRect: viewrect fromView: self.connectionsMapViewController.view];
        
        //NSLog(@"ConnectionsContainerViewControlleriPad: view frame: %.1f %.1f, %.1f. %.1f", viewrect.origin.x, viewrect.origin.y, viewrect.size.width, viewrect.size.height);
        //NSLog(@"ConnectionsContainerViewControlleriPad: view frame of overlay: %.1f %.1f, %.1f. %.1f", overlerayRectinView.origin.x, overlerayRectinView.origin.y, overlerayRectinView.size.width, overlerayRectinView.size.height);
        
        [stationActionSheet showFromRect: overlerayRectinView inView: self.view animated: YES];
        
        if(stationActionSheet.subviews.count > 0 && [[stationActionSheet.subviews objectAtIndex:0] isKindOfClass:[UILabel class]]) {
            UILabel* l = (UILabel*) [stationActionSheet.subviews objectAtIndex:0];
            [l setFont:[UIFont boldSystemFontOfSize:16]];
            [l setTextColor: [UIColor whiteColor]];
        }
    }
}

- (void) cancelAllAlarms {
    UIApplication* app = [UIApplication sharedApplication];
    NSArray *alarmNotifications = [app scheduledLocalNotifications];
    
    if ([alarmNotifications count] > 0)
        [app cancelAllLocalNotifications];
}

- (void)showTrainlineButton {
    #ifdef LOGOUTPUTON
    NSLog(@"Show train line button");
    #endif
    
    self.trainlineButton.selected = NO;
    self.trainlineButton.alpha = 1.0;
}

- (void)hideTrainlineButton {
    self.trainlineButton.alpha = 0.0;
    self.trainlineButton.selected = NO;
}

- (void) switchtrainlinemode:(id)sender {
    if (!self.trainlineButton.selected) {
        if (self.connectionsMapViewController) {
            [self.connectionsMapViewController switchToNormalTrainline:YES];
            self.trainlineButton.selected = YES;
        }
    } else {
        if (self.connectionsMapViewController) {
            [self.connectionsMapViewController switchToNormalTrainline:NO];
            self.trainlineButton.selected = NO;
        }
    }
}

- (void) enterLocationHeadingMode:(id)sender {
    
    if (!self.locationheadingButton.selected) {
        if (self.connectionsMapViewController) {
            [self.connectionsMapViewController enterLocationHeadingMode];
            self.locationheadingButton.selected = YES;
        }
    } else {
        if (self.connectionsMapViewController) {
            [self.connectionsMapViewController leaveLocationHeadingMode];
            self.locationheadingButton.selected = NO;
        }
    }
}

- (void) forceLeaveLocationHeadingModeIfNecessary {
    if (self.locationheadingButton.selected) {
        if (self.connectionsMapViewController) {
            [self.connectionsMapViewController leaveLocationHeadingMode];
            self.locationheadingButton.selected = NO;
        }
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

-(void) setAlarmForConnection:(id)sender {
    
    NSArray *basicStopList = [[SBBAPIController sharedSBBAPIController] getAllBasicStopsForConnectionResultWithIndex: self.selectedOverviewIndex];
    //ConOverview *overview = [[SBBAPIController sharedSBBAPIController] getOverviewForConnectionResultWithIndex: self.selectedOverviewIndex];
    //NSUInteger durationhours = [overview getHoursFromDuration];
    //NSUInteger durationminutes = [overview getMinutesFromDuration];
    //NSUInteger durationseconds = durationminutes * 60 + durationhours * 60 * 60;
    
    if ([basicStopList count] >= 2) {
        NSString *fromStationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList objectAtIndex: 0]];
        NSString *toStationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList lastObject]];
        //NSString *arrivalTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForBasicStop: [basicStopList lastObject]];
        NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForBasicStop: [basicStopList objectAtIndex: 0]];

        ConOverview *overview = [[SBBAPIController sharedSBBAPIController] getOverviewForConnectionResultWithIndex: self.selectedOverviewIndex];
        NSString *overviewConnectionDateString = [[SBBAPIController sharedSBBAPIController] getConnectionDateStringForOverview: overview];
        //NSDate *connectiondate = [[SBBAPIController sharedSBBAPIController] getConnectionDateForConnectionResultWithIndex: self.selectedOverviewIndex];
        //BOOL isDepartureTime = [[SBBAPIController sharedSBBAPIController] getConnectionDateIsDepartureFlagForConnectionResultWithIndex: self.selectedOverviewIndex];
        
        NSString *title = [NSString stringWithFormat: @"%@ - %@", fromStationName, toStationName];
        
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
        
        //return;

        RIButtonItem *addalarm5minbutton = [RIButtonItem itemWithLabel: NSLocalizedString(@"5 min before departure", @"Add alarm with alarm 5 min block action sheet title")];
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
            //localNotification.alertBody = @"Staff meeting in 30 minutes";
            localNotification.userInfo = [NSDictionary
                              dictionaryWithObjects:[NSArray arrayWithObjects:alarmdate,title,nil]
                              forKeys:[NSArray arrayWithObjects: @"date",@"title",nil]];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification]; //Schedule the notification with the system
            [[NoticeviewMessages sharedNoticeMessagesController] showAlarmEntryAdded: self.view];
        };
        
        
        RIButtonItem *addalarm15minbutton = [RIButtonItem itemWithLabel: NSLocalizedString(@"15 min before departure", @"Add alarm with alarm 15 min block action sheet title")];
        addalarm15minbutton.action = ^{
            NSDate *alarmdate = [startdate dateByAddingTimeInterval: -15*60];
            NSString *alarmbody = [NSString stringWithFormat: NSLocalizedString(@"Connection is leaving in %d minutes", @"Alarm leaving message"), 15];
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
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification]; //Schedule the notification with the system
            [[NoticeviewMessages sharedNoticeMessagesController] showAlarmEntryAdded: self.view];
        };
        
        RIButtonItem *addalarm30minbutton = [RIButtonItem itemWithLabel: NSLocalizedString(@"30 min before departure", @"Add alarm with alarm 30 min block action sheet title")];
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
        
        RIButtonItem *addalarm60minbutton = [RIButtonItem itemWithLabel: NSLocalizedString(@"60 min before departure", @"Add alarm with alarm 60 min block action sheet title")];
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
        
        UIActionSheet *addalarmActionSheet = [[UIActionSheet alloc] initWithTitle: NSLocalizedString(@"Add alarm", @"Add alarm block action sheet title") cancelButtonItem: nil destructiveButtonItem: nil otherButtonItems: addalarm5minbutton, addalarm15minbutton, addalarm30minbutton, addalarm60minbutton,nil];
        
        addalarmActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        
        [addalarmActionSheet showFromRect: self.setalarmButton.frame inView: self.view animated: YES];
        
        if(addalarmActionSheet.subviews.count > 0 && [[addalarmActionSheet.subviews objectAtIndex:0] isKindOfClass:[UILabel class]]) {
            UILabel* l = (UILabel*) [addalarmActionSheet.subviews objectAtIndex:0];
            [l setFont:[UIFont boldSystemFontOfSize:16]];
            [l setTextColor: [UIColor whiteColor]];
        }
    }
}

-(void) addConnectionToCalendar:(id)sender {
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
    
    if (accessGranted) {
        
        //NSLog(@"Access granted to calendar");
        
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
            //NSLog(@"Calendar entry title: %@", title);
            
            /*
            NSDate *connectiondate = [[SBBAPIController sharedSBBAPIController] getConnectionDateForConnectionResultWithIndex: self.selectedOverviewIndex];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMdd"];
            //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
            NSString *dateString = [dateFormatter stringFromDate: connectiondate];
            */
            
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
            
            
            //BOOL connectiondateisdeparturedate = [[SBBAPIController sharedSBBAPIController] getConnectionDateIsDepartureFlagForConnectionResultWithIndex: self.selectedOverviewIndex];
            
            RIButtonItem *addtocalendarbutton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Add only", @"Add to calendar block action sheet title")];
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
            
            RIButtonItem *addtocalendarwithalarm15minbutton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Alarm 15 min before", @"Add to calendar with alarm 15 min block action sheet title")];
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
            
            RIButtonItem *addtocalendarwithalarm30minbutton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Alarm 30 min before", @"Add to calendar with alarm 30 min block action sheet title")];
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
            
            RIButtonItem *addtocalendarwithalarm60minbutton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Alarm 60 min before", @"Add to calendar with alarm 60 min block action sheet title")];
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
            
            UIActionSheet *addtocalendarActionSheet = [[UIActionSheet alloc] initWithTitle: NSLocalizedString(@"Add to calendar with", @"Add to calendar block action sheet title") cancelButtonItem: nil destructiveButtonItem: nil otherButtonItems: addtocalendarbutton, addtocalendarwithalarm15minbutton, addtocalendarwithalarm30minbutton, addtocalendarwithalarm60minbutton,nil];
            
            addtocalendarActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            
            [addtocalendarActionSheet showFromRect: self.addtocalendarButton.frame inView: self.view animated: YES];
            
            if(addtocalendarActionSheet.subviews.count > 0 && [[addtocalendarActionSheet.subviews objectAtIndex:0] isKindOfClass:[UILabel class]]) {
                UILabel* l = (UILabel*) [addtocalendarActionSheet.subviews objectAtIndex:0];
                [l setFont:[UIFont boldSystemFontOfSize:16]];
                [l setTextColor: [UIColor whiteColor]];
            }
        } 
    } else {
        [[NoticeviewMessages sharedNoticeMessagesController] showCalendarAccessDenied: self.view];
    }
}

- (void)showLocationOutsideSwitzerlandMessage {
    [[NoticeviewMessages sharedNoticeMessagesController] showLocationOutsideSwitzerland: self.view];
}

- (void)showLocationManagerDeniedMessage {
    [[NoticeviewMessages sharedNoticeMessagesController] showLocationManagerDenied: self.view];
}

- (void)showLocationManagerErrorMessage {
    [[NoticeviewMessages sharedNoticeMessagesController] showLocationManagerError: self.view];
}

- (void)headingManagerDidLeaveAllTrackingModes {
    self.locationheadingButton.selected = NO;
}

/*
#pragma mark - Gesture Recognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //return (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation));
    return YES;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

#pragma mark Gesture Recognizer Methods
- (void)dragContentView:(UIPanGestureRecognizer *)panGesture {
	
    NSLog(@"DragContentView: init");
    CGFloat translation = [panGesture translationInView:self.view].x;
    NSLog(@"Translation: %.1f", translation);
	if (panGesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"DragContentView: state changed");
		if (!self.connectionsResultContainerViewIsOut) {
            NSLog(@"DragContentView: detailview is right");
			if (translation > 0.0f) {
                NSLog(@"DragContentView: detailview is right: trans bigger 0");
				self.connectionsResultContainerViewController.view.frame = CGRectOffset(self.connectionsResultContainerViewController.view.bounds, 0, 0.0f);
                self.connectionsResultContainerViewController.view.layer.shadowOpacity = 1.0f;
				self.connectionsResultContainerViewIsOut = YES;
			} else if (translation < 0) {
                NSLog(@"DragContentView: detailview is right: trans negative width");
                self.connectionsResultContainerViewController.view.frame = CGRectOffset(self.connectionsResultContainerViewController.view.bounds, 0 + translation, 0.0f);
                self.connectionsResultContainerViewController.view.layer.shadowOpacity = 1.0f;
				self.connectionsResultContainerViewIsOut = NO;
                
                
				//self.connectionsResultContainerViewController.view.frame = self.connectionsResultContainerViewController.view.bounds;
                //self.connectionsResultContainerViewController.view.layer.shadowOpacity = 0.0f;
				//self.connectionsResultContainerViewIsOut = NO;
			} else {
                NSLog(@"DragContentView: detailview is right: trans other");
				self.connectionsResultContainerViewController.view.frame = CGRectOffset(self.connectionsResultContainerViewController.view.bounds, (0 + translation), 0.0f);
                self.connectionsResultContainerViewController.view.layer.shadowOpacity = 1.0f;
			}
		} else {
            NSLog(@"DragContentView: detailview is left");
			if (translation < 0.0f) {
                NSLog(@"DragContentView: detailview is left: trans negative");
				self.connectionsResultContainerViewController.view.frame = self.connectionsResultContainerViewController.view.bounds;
                self.connectionsResultContainerViewController.view.layer.shadowOpacity = 0.0f;
				self.connectionsResultContainerViewIsOut = NO;
			} else if (translation > 0) {
                NSLog(@"DragContentView: detailview is left: trans bigger width");
				self.connectionsResultContainerViewController.view.frame = CGRectOffset(self.connectionsResultContainerViewController.view.bounds, 0, 0.0f);
                self.connectionsResultContainerViewController.view.layer.shadowOpacity = 1.0f;
				self.connectionsResultContainerViewIsOut = YES;
			} else {
                NSLog(@"DragContentView: detailview is left: trans other");
                self.connectionsResultContainerViewController.view.frame = CGRectOffset(self.connectionsResultContainerViewController.view.bounds, 0 + translation, 0.0f);
                self.connectionsResultContainerViewController.view.layer.shadowOpacity = 1.0f;
				//self.detailView.frame = CGRectOffset(self.detailView.bounds, translation, 0.0f);
			}
		}
	} else if (panGesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"DragContentView: state ended");
		CGFloat velocity = [panGesture velocityInView:self.view].x;
		BOOL show = (fabs(velocity) > kGHRevealSidebarFlickVelocity)
        ? (velocity > 0)
        : (abs(translation) > (SPLITVIEWMAINVIEWWIDTH / 2));
		[self toggleSidebar:show duration:kGHRevealSidebarDefaultAnimationDuration];
		
	}
}

- (void)toggleSidebar:(BOOL)show duration:(NSTimeInterval)duration {
    NSLog(@"Toggle sidebar duration");
	[self toggleSidebar:show duration:duration completion:^(BOOL finshed){}];
}

- (void)toggleSidebar:(BOOL)show duration:(NSTimeInterval)duration completion:(void (^)(BOOL finsihed))completion {
    NSLog(@"Toggle sidebar duration block");
	void (^animations)(void) = ^{
		if (show) {
            NSLog(@"Toggle sidebar duration block: show");
            self.connectionsResultContainerViewController.view.layer.shadowOpacity = 1.0f;
			self.connectionsResultContainerViewController.view.frame = CGRectOffset(self.connectionsResultContainerViewController.view.bounds, 0, 0.0f);
		} else {
            NSLog(@"Toggle sidebar duration block: hide");

            self.connectionsResultContainerViewController.view.layer.shadowOpacity = 0.0f;
            self.connectionsResultContainerViewController.view.frame = CGRectOffset(self.connectionsResultContainerViewController.view.bounds, -320, 0.0f);
		}
		self.connectionsResultContainerViewIsOut = show;
	};
	if (duration > 0.0) {
		[UIView animateWithDuration:duration
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:animations
						 completion:completion];
	} else {
		animations();
		completion(YES);
	}
}

- (void)hideSidebar {
	[self toggleSidebar:NO duration:kGHRevealSidebarDefaultAnimationDuration];
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"ConnectionsContainerViewController: did receive memory warning.");
}

//--------------------------------------------------------------------------------

- (void) shareConnection:(id) sender {
    
    [self cancelCurrentRunningRequestsIfAny];
    
    //BlockActionSheet *shareActionSheet = [BlockActionSheet sheetWithTitle: NSLocalizedString(@"Share via", @"Share connection block action sheet title")];
    
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
        //[shareActionSheet showInView: self.view];
        shareActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [shareActionSheet showFromRect: self.shareButton.frame inView: self.view animated: YES];
    } else {
        UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle: NSLocalizedString(@"Share via", @"Share connection block action sheet title") cancelButtonItem: cancelButton destructiveButtonItem: nil otherButtonItems: printButton,clipboardButton , nil];
        //[shareActionSheet showInView: self.view];
        shareActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [shareActionSheet showFromRect: self.shareButton.frame inView: self.view animated: YES];
    }
}

- (void) mailComposeController:(MFMailComposeViewController*) mailController didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	//AudioServicesPlaySystemSound (clickSoundID);
    
    if ( error != nil ) {
        // handle error here
    }
    
    if ( result == MFMailComposeResultSent ) {
        // your code here to handle this result
    }
    else if ( result == MFMailComposeResultCancelled ) {
        // ...
    }
    else if ( result == MFMailComposeResultSaved ) {
        // ...
    }
    else if ( result == MFMailComposeResultFailed ) {
        // ...
    }
    
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
    
            [printController presentFromRect:self.shareButton.frame inView:self.view
                                    animated:YES completionHandler:completionHandler];
            
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

//--------------------------------------------------------------------------------

- (void) setLocationsFromMapAppInitAndPushBackToCurrentVCIfRequired:(Station *)from to:(Station *)to push:(BOOL)push searchinit:(BOOL)searchinit {
    #ifdef LOGOUTPUTON
    NSLog(@"Set locations from map init. check if selection controller on screen");
    #endif
    
    self.showIntroFlag = NO;
    
    if (self.connectionsSelectionViewControlleriPad) {
        [self.connectionsSelectionViewControlleriPad setLocationsFromMapAppInitAndPushBackToCurrentVCIfRequired:from to:to push:push searchinit:searchinit];
        
        // To implement
        // Check currently active view controller and push back
        
        //NSLog(@"Set locations from map init. dismiss pop overs");
        
        [self.dtPickerPopOverController dismissPopoverAnimated: NO];
        [self.listViewPopOverController dismissPopoverAnimated: NO];
        [self.shareViewPopOverController dismissPopoverAnimated: NO];
        [self.searchStationPickerPopOverController dismissPopoverAnimated: NO];
        
        if (self.currentlyPushedViewController != noViewControllerConnectionsContaineriPad) {
            if (self.currentlyPushedViewController == connectionsViewControllerConnectionsContaineriPad) {
                #ifdef LOGOUTPUTON
                NSLog(@"Connections result view controller is on screen. Force push back.");
                #endif
                [self moveConnectionsResultContainerViewOffScreen];
            } else if (self.currentlyPushedViewController == stationsPickerViewControllerConnectionsContaineriPad) {
                #ifdef LOGOUTPUTON
                NSLog(@"Stations picker view controller is on screen. Force push back.");
                #endif
                //
                [self dismissViewControllerAnimated:YES completion:^{}];
                
                //if (self.stationPickerViewController) {
                //    [self.stationPickerViewController forcePushBackToPreviousViewController];
                //}
            } else if (self.currentlyPushedViewController == appSettingsViewControllerConnectionsContaineriPad) {
                #ifdef LOGOUTPUTON
                NSLog(@"Settings view controller is on screen. Force push back.");
                #endif
                if (self.appSettingsViewController) {
                    [self.appSettingsViewController dismissViewControllerAnimated: NO completion: nil];
                }
            }
        }
    } else {
        #ifdef LOGOUTPUTON
        NSLog(@"ConnectionscontainerviewcontrolleriPad: setLocationsFromMapInit. Selection controller not set");
        #endif
    }
    
}

//--------------------------------------------------------------------------------

#pragma mark -
#pragma mark App Settings methods


- (IBAction)showSettingsPush:(id)sender {
    
    [self cancelCurrentRunningRequestsIfAny];
    
    if (!self.appSettingsViewController) {
		self.appSettingsViewController = [[IASKAppSettingsViewController alloc] initWithNibName:@"IASKAppSettingsView" bundle:nil];
		self.appSettingsViewController.delegate = self;
	}
        
	[self.appSettingsViewController setShowCreditsFooter:NO];   // Uncomment to not display InAppSettingsKit credits for creators.
	// But we encourage you no to uncomment. Thank you!
	//self.appSettingsViewController.showDoneButton = NO;
    
    UINavigationController *aNavController = [[UINavigationController alloc] initWithRootViewController:self.appSettingsViewController];
    
    aNavController.navigationBar.barStyle=UIBarStyleBlack;
        
    aNavController.modalPresentationStyle = UIModalPresentationFormSheet;
    self.appSettingsViewController.showDoneButton = YES;
    self.currentlyPushedViewController = appSettingsViewControllerConnectionsContaineriPad;
    [self presentViewController: aNavController animated: YES completion: nil];
    
	//[self.navigationController pushViewController:self.appSettingsViewController animated:YES];
}

#pragma mark -
#pragma mark IASKAppSettingsViewControllerDelegate protocol
- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {    
    self.currentlyPushedViewController = noViewControllerConnectionsContaineriPad;
    
    [sender dismissViewControllerAnimated: YES completion: nil];
    
	// your code here to reconfigure the app for changed settings
}


/*
// optional delegate method for handling mail sending result
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    if ( error != nil ) {
        // handle error here
    }
    
    if ( result == MFMailComposeResultSent ) {
        // your code here to handle this result
    }
    else if ( result == MFMailComposeResultCancelled ) {
        // ...
    }
    else if ( result == MFMailComposeResultSaved ) {
        // ...
    }
    else if ( result == MFMailComposeResultFailed ) {
        // ...
    }
}
*/ 

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderForKey:(NSString*)key {
	if ([key isEqualToString:@"IASKLogo"]) {
		return [UIImage imageNamed:@"IconSettings.png"].size.height + 25;
	}
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderForKey:(NSString*)key {
	if ([key isEqualToString:@"IASKLogo"]) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconSettings.png"]];
		imageView.contentMode = UIViewContentModeCenter;
		return imageView;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView*)tableView heightForSpecifier:(IASKSpecifier*)specifier {
	if ([specifier.key isEqualToString:@"customCell"]) {
		return 44*3;
	}
	return 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForSpecifier:(IASKSpecifier*)specifier {
    
    UITableViewCell *customCell = [[UITableViewCell alloc] initWithFrame: CGRectMake(0, 0, 320, 50)];
    [customCell setNeedsLayout];
	return customCell;
}

#pragma mark UITextViewDelegate (for CustomViewCell)
- (void)textViewDidChange:(UITextView *)textView {
    [[NSUserDefaults standardUserDefaults] setObject:textView.text forKey:@"customCell"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kIASKAppSettingChanged object:@"customCell"];
}

#pragma mark -
- (void)settingsViewController:(IASKAppSettingsViewController*)sender buttonTappedForKey:(NSString*)key {
	if ([key isEqualToString:@"SHOWINTROKEY"]) {
		[sender dismissViewControllerAnimated: YES completion: nil];
        [self performSelector: @selector(showMoviePlayerController) withObject:self afterDelay: 2];
	}
}

- (NSString *) machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
	
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

- (NSString *) iPhoneDevice
{
	NSString *deviceType = [NSString stringWithString: [self machineName]];
	
	//NSLog(@"Device: %@", deviceType);
    
    if ([deviceType isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([deviceType isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([deviceType isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([deviceType isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([deviceType isEqualToString:@"iPhone3,3"]) return @"Verizon iPhone 4";
    if ([deviceType isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([deviceType isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (GSM/LTE US&CA)";
    if ([deviceType isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (CDMA/LTE or GSM/LTE Int)";
    if ([deviceType isEqualToString:@"iPhone5,3"]) return @"iPhone 5 (CDMA/LTE or GSM/LTE Int)";
    if ([deviceType isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceType isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceType isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceType isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceType isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([deviceType isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceType isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceType isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceType isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMAV)";
    if ([deviceType isEqualToString:@"iPad2,4"])      return @"iPad 2 (CDMAS)";
    if ([deviceType isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceType isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceType isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceType isEqualToString:@"iPad3,1"])      return @"iPad-3G (WiFi)";
    if ([deviceType isEqualToString:@"iPad3,2"])      return @"iPad-3G (4G GSM)";
    if ([deviceType isEqualToString:@"iPad3,3"])      return @"iPad-3G (4G CDMA)";
    if ([deviceType isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceType isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceType isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceType isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceType isEqualToString:@"x86_64"])       return @"Simulator";
    
    return (@"Unknown device");
}

- (NSString *) systemVersion
{
    return ([[UIDevice currentDevice] systemVersion]);
}


- (NSString*)mailComposeBody:(NSString *)key {
    //NSLog(@"Key: %@", key);
    if ([key isEqualToString:@"SUPPORTEMAILKEY"]) {        
        NSString *messageId;
        messageId = [[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];

        NSString *UTApName  = kUTControllerAppNameiPad;

		NSString *messageText = [NSString stringWithFormat: @"%@\n\n\n\n\n\n\n\n\n\n\nMessage id: %@\niPhone: %@\niOS Version: %@\nApp version: %@\nLanguage: %@",NSLocalizedString(@"Dear Support, ", @"Swiss Transit settings support email draft text"), messageId, [self iPhoneDevice], [self systemVersion], UTApName, [[NSLocale currentLocale] localeIdentifier]];
        return messageText;
    } else if ([key isEqualToString:@"TELLAFRIENDEMAILKEY"]) {
        
        NSString *description =  NSLocalizedString(@"Check out this app!", @"Recommend Swiss Transit Share Item Description");
        //NSString *shortdescription = NSLocalizedString(@"Check out this app!", @"Recommend Swiss Transit Share Item Description");

        NSString *appStoreIDString = [NSString stringWithFormat: @"%d", AppStoreIDIPAD];
        NSString *appStoreURL =  [NSString stringWithFormat: @"http://itunes.apple.com/ch/app/%@/id%@?mt=8&uo=4", AppStoreURLAPIPAD,appStoreIDString];;

        NSString *imageURLString = kITellAFriendImageURLSmall;
        //NSString *imageNameFromBundle = kBundleIconImage;
        
        NSString *emailBody = [NSMutableString stringWithFormat:@"<div> \n"
                                      "<p style=\"font:17px Helvetica,Arial,sans-serif\">%@</p> \n"
                                      "<table border=\"0\"> \n"
                                      "<tbody> \n"
                                      "<tr> \n"
                                      "<td style=\"padding-right:10px;vertical-align:top\"> \n"
                                      "<a target=\"_blank\" href=\"%@\"><img height=\"120\" border=\"0\" src=\"%@\" alt=\"Cover Art\"></a> \n"
                                      "</td> \n"
                                      "<td style=\"vertical-align:top\"> \n"
                                      "<a target=\"_blank\" href=\"%@\" style=\"color: Black;text-decoration:none\"> \n"
                                      "<h1 style=\"font:bold 16px Helvetica,Arial,sans-serif\">%@</h1> \n"
                                      "<p style=\"font:14px Helvetica,Arial,sans-serif;margin:0 0 2px\">By: %@</p> \n"
                                      "<p style=\"font:14px Helvetica,Arial,sans-serif;margin:0 0 2px\">Category: %@</p> \n"
                                      "</a> \n"
                                      "<p style=\"font:14px Helvetica,Arial,sans-serif;margin:0\"> \n"
                                      "<a target=\"_blank\" href=\"%@\"><img src=\"http://ax.phobos.apple.com.edgesuite.net/email/images_shared/view_item_button.png\"></a> \n"
                                      "</p> \n"
                                      "</td> \n"
                                      "</tr> \n"
                                      "</tbody> \n"
                                      "</table> \n"
                                      "<br> \n"
                                      "<br> \n"
                                      "<table align=\"center\"> \n"
                                      "<tbody> \n"
                                      "<tr> \n"
                                      "<td valign=\"top\" align=\"center\"> \n"
                                      "<span style=\"font-family:Helvetica,Arial;font-size:11px;color:#696969;font-weight:bold\"> \n"
                                      "</td> \n"
                                      "</tr> \n"
                                      "<tr> \n"
                                      "<td align=\"center\"> \n"
                                      "<span style=\"font-family:Helvetica,Arial;font-size:11px;color:#696969\"> \n"
                                      "Please note that you have not been added to any email lists. \n"
                                      "</span> \n"
                                      "</td> \n"
                                      "</tr> \n"
                                      "</tbody> \n"
                                      "</table> \n"
                                      "</div>",
                                      description,
                                      appStoreURL,
                                      imageURLString,
                                      appStoreURL,
                                      kAppNameiPad,
                                      kAppSeller,
                                      kAppCategory,
                                      appStoreURL];
        return emailBody;
        
    } else if ([key isEqualToString:@"STREPORTERREMAILKEY"]) {
        NSString *messageId;
        messageId = [[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        NSString *description =  NSLocalizedString(@"There is an error with the following station:", @"Report station error message description");

        NSString *UTApName  = kUTControllerAppNameiPad;

		NSString *messageText = [NSString stringWithFormat: @"%@\n\n%@\n\n\n\n\n\n\n\n\nMessage id: %@\niPhone: %@\niOS Version: %@\nApp version: %@\nLanguage: %@",NSLocalizedString(@"Dear Support, ", @"Swiss Transit settings support email draft text"), description, messageId, [self iPhoneDevice], [self systemVersion], UTApName, [[NSLocale currentLocale] localeIdentifier]];
        return messageText;
        
    } else if ([key isEqualToString:@"APREPORTERREMAILKEY"]) {
        NSString *messageId;
        messageId = [[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
		NSString *description =  NSLocalizedString(@"There is an error in the app:", @"Report app error message description");
        
        NSString *UTApName  = kUTControllerAppNameiPad;

		NSString *messageText = [NSString stringWithFormat: @"%@\n\n%@\n\n\n\n\n\n\n\n\nMessage id: %@\niPhone: %@\niOS Version: %@\nApp version: %@\nLanguage: %@",NSLocalizedString(@"Dear Support, ", @"Swiss Transit settings support email draft text"), description, messageId, [self iPhoneDevice], [self systemVersion], UTApName, [[NSLocale currentLocale] localeIdentifier]];
        return messageText;
        
    }
    return @"";
}

//--------------------------------------------------------------------------------

- (void) viewControllerSelectedFromTabbar {
    #ifdef LOGOUTPUTON
    NSLog(@"Connections Container controller selected from tabbar");
    #endif
}

- (void) startGettingUserLocation {
    #ifdef LOGOUTPUTON
    NSLog(@"Start getting the users location");
    #endif
    
    BKLocationManager *manager = [BKLocationManager sharedManager];
    
    [manager setDidUpdateLocationBlock:^(CLLocationManager *manager, CLLocation *newLocation, CLLocation *oldLocation) {
        
        #ifdef LOGOUTPUTON
        NSLog(@"didUpdateLocation: lat: %.6f, %.6f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
        #endif
        
        self.userLocation = newLocation;
        self.userLocationDate = [NSDate date];
        
        [manager stopUpdatingLocation];
        manager = nil;
    }];
    
    [manager setDidFailBlock:^(CLLocationManager *manager, NSError *error) {
        NSLog(@"didFailUpdateLocation");
        
        [manager stopUpdatingLocation];
        manager = nil;
    }];
    
    [manager stopUpdatingLocationAndRestManager];
    [manager startUpdatingLocationWithAccuracy:kCLLocationAccuracyHundredMeters];
}

- (void) appdidbecomeactiveaction:(id)sender {
    #if LOGOUTPUTON
    NSLog(@"App did become active notificatoin received");
    #endif
    
    [self startGettingUserLocation];
}

- (void) appisenteringbackgroundaction:(id)sender {
    #if LOGOUTPUTON
    NSLog(@"App is entering background notificatoin received");
    #endif
    
    [self.listViewPopOverController dismissPopoverAnimated:NO];
    [self.dtPickerPopOverController dismissPopoverAnimated:NO];
    [self.searchStationPickerPopOverController dismissPopoverAnimated:NO];
    [self.shareViewPopOverController dismissPopoverAnimated: NO];
    
    [self cancelCurrentRunningRequestsIfAny];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
