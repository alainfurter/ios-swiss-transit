//
//  StationboardContainerViewControlleriPad.m
//  Swiss Trains
//
//  Created by Alain on 01.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "StationboardContainerViewControlleriPad.h"



@interface StationboardContainerViewControlleriPad ()

@end

@implementation StationboardContainerViewControlleriPad

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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height - TABBARHEIGHT)];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = view;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Timetable", "Select stations stbreq flash message title");
        
        CGFloat scaleFactor = TABBARICONIMAGESCALEFACTOR;
        UIImage *stbImage = [UIImage newImageFromMaskImage: [[UIImage stboardButtonImage] resizedImage: CGSizeMake(TABBARICONIMAGEHEIGHT * scaleFactor, TABBARICONIMAGEHEIGHT * scaleFactor) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlItemImageColor]];

        self.tabBarItem.image = [stbImage grayTabBarItemFilter];
        self.tabBarItem.selectedImage = [stbImage blueTabBarItemFilter];
        
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight  | UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void) layoutSubviewsWithAnimated:(BOOL)animated beforeRotation:(BOOL)beforeRotation interfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //NSLog(@"StationboardContainerViewControlleriPad layoutSubviews");
	
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
    
    if (animated) {
        [UIView beginAnimations:@"StationboardContainerViewControlleriPad LayoutSubviewWithAnimation" context:NULL];
    }
    
    self.stationboardSelectionViewControlleriPad.view.frame = CGRectMake(0, TOOLBARHEIGHTIPAD, SPLITVIEWMAINVIEWWIDTH, newSize.height - TOOLBARHEIGHTIPAD);
    
    if (self.stationboardResultContainerViewController.view.frame.origin.x < 0) {
        //self.stationboardResultContainerViewController.view.frame = CGRectMake(-320, TOOLBARHEIGHTIPAD, SPLITVIEWMAINVIEWWIDTH, newSize.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT);
    } else {
        //self.stationboardResultContainerViewController.view.frame = CGRectMake(0, TOOLBARHEIGHTIPAD, SPLITVIEWMAINVIEWWIDTH, newSize.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT);
    }
    
    self.divider.frame = CGRectMake(SPLITVIEWMAINVIEWWIDTH, TOOLBARHEIGHTIPAD, SPLITVIEWDIVIDERWIDTH, newSize.height - TOOLBARHEIGHTIPAD);
    
    //TEST
    self.stationboardMapViewController.view.frame = CGRectMake(SPLITVIEWMAINVIEWWIDTH + SPLITVIEWDIVIDERWIDTH, TOOLBARHEIGHTIPAD, newSize.width - SPLITVIEWMAINVIEWWIDTH - SPLITVIEWDIVIDERWIDTH, newSize.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT);
    //TEST
    
    //self.connectionsListViewController.view.frame = CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH, newSize.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT - LISTVIEWCONTROLLERHEIGHTPAD);
    
    self.goButton.frame = CGRectMake(5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.backButton.frame = CGRectMake(5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.infoButton.frame = CGRectMake(newSize.width - BUTTONHEIGHT - 5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.listButton.frame = CGRectMake(newSize.width - BUTTONHEIGHT*2  - 5 * 2, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.closestStationsButton.frame = CGRectMake(newSize.width - BUTTONHEIGHT*2  - 5 * 2, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    
    //int startPositionInfoView = (newSize.width - 350) / 2;
    int startPositionInfoView = (newSize.width - SPLITVIEWMAINVIEWWIDTH - 350) / 2 + SPLITVIEWMAINVIEWWIDTH + 50;
    int infoViewWidth = 350;
    self.topInfoView.frame = CGRectMake(startPositionInfoView, 0, infoViewWidth, TOOLBARHEIGHTIPAD);
    
    
    //CGRect viewFrameStation = self.view.frame;
    int startPositionStationView = BUTTONHEIGHT + 5;
    int stationViewWidth = 350;
    self.topStationView.frame = CGRectMake(startPositionStationView, 0, stationViewWidth, TOOLBARHEIGHTIPAD);

    //self.statusToolBar.frame = CGRectMake(0, 0, newSize.width, TOOLBARHEIGHTIPAD);
        
    if (self.navSC) {
        self.navSC.center = CGPointMake(100 - 3, size.height - TABBARHEIGHT / 2 - 1);
    }
    
    if (animated) {
        [UIView commitAnimations];
    }
}

- (void) layoutSubviews:(BOOL)beforeRotation toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    [self layoutSubviewsWithAnimated:NO beforeRotation: beforeRotation interfaceOrientation: toInterfaceOrientation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
    self.view.backgroundColor = [UIColor selectionControllerBackgroundColor];
    
    self.stbCurrentStationIsPrechecked = NO;
    self.stbIsPreCheckingStation = NO;
    self.stbPushStationboardViewControllerAfterPreCheck = NO;
    
    self.dirStationIsVisible = NO;
    self.navBarVisible = NO;
    
    self.statusToolBar = [[StatusToolbariPad alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, TOOLBARHEIGHTIPAD)];
    
    self.selectedConnectionIndex = 0;
    
    //NSLog(@"ConnectionsContainer viewdidload: %.1f, %.1f, %.1f, %.1f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
    
    self.statusToolBar = [[StatusToolbariPad alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, TOOLBARHEIGHTIPAD)];
    
    self.stationboardSelectionViewControlleriPad = [[StationboardSelectionViewControlleriPad alloc] init];
    self.stationboardSelectionViewControlleriPad.view.frame = CGRectMake(0, TOOLBARHEIGHTIPAD, SPLITVIEWMAINVIEWWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD);
    [self.view addSubview: self.stationboardSelectionViewControlleriPad.view];
    self.stationboardSelectionViewControlleriPad.delegate = self;
    
    
    self.stationboardResultContainerViewController = [[StationboardResultsContainerViewController alloc] init];
    self.stationboardResultContainerViewController.view.frame = CGRectMake(-320, TOOLBARHEIGHTIPAD, SPLITVIEWMAINVIEWWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD);
    
    [self.view addSubview: self.stationboardResultContainerViewController.view];
    //self.stationboardResultContainerViewController.view.frame = CGRectMake(0, TOOLBARHEIGHTIPAD, SPLITVIEWMAINVIEWWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT);
    //self.stationboardResultContainerViewController.view.frame = CGRectMake(-320, TOOLBARHEIGHTIPAD, SPLITVIEWMAINVIEWWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT);
    self.stationboardResultContainerViewController.delegate = self;
    //[self moveStationboardResultContainerViewOffScreen];
    
    
    
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
    [self.view addSubview: self.divider];
    
    /*
    UIImage *image = [UIImage imageNamed:@"split-divider.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(-4, 0, image.size.width, image.size.height);
    [self.divider addSubview:imageView];
    */

    // TEST
    self.stationboardMapViewController = [[StationboardMapViewController alloc] init];
    self.stationboardMapViewController.view.frame = CGRectMake(SPLITVIEWMAINVIEWWIDTH + SPLITVIEWDIVIDERWIDTH, TOOLBARHEIGHTIPAD, self.view.frame.size.width - SPLITVIEWMAINVIEWWIDTH - SPLITVIEWDIVIDERWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD);
    [self.view addSubview: self.stationboardMapViewController.view];
    self.stationboardMapViewController.delegate = self;
    // TEST
    
    /*
    self.mapView = [[MKMapView alloc] initWithFrame: CGRectMake(SPLITVIEWMAINVIEWWIDTH + SPLITVIEWDIVIDERWIDTH, TOOLBARHEIGHTIPAD, self.view.frame.size.width - SPLITVIEWMAINVIEWWIDTH - SPLITVIEWDIVIDERWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT)];
    //self.mapView.alpha = 0.0;
    //self.mapView.directionsEdgePadding = UIEdgeInsetsMake(CONJRNTOPINFOBARHEIGHT + 20.0f, 20.0f, 20.0f, 20.0f);
    [self.view addSubview: self.mapView];
    //self.mapView.delegate = self;
    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(46.897739, 8.426514),
                                                 MKCoordinateSpanMake(4.026846,4.032959));
    
    //self.mapView.directionsEdgePadding = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f);
    */ 
    //TEST
    
    
    self.stationboardListViewController = [[StationboardListViewController alloc] init];
    self.stationboardListViewController.view.frame = CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT - LISTVIEWCONTROLLERHEIGHTPAD);
    
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
    [self.view addSubview: self.infoButton];
    
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
    
    CGFloat scaleFactorTrainlineButton = 1.0;
    self.trainlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *trainlineButtonImage =  [UIImage newImageFromMaskImage: [[UIImage trainlineNormalButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON* scaleFactorTrainlineButton, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorTrainlineButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
    UIImage *trainlineButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage trainlineNormalButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorTrainlineButton, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorTrainlineButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
    UIImage *trainlineButtonImageSelected =  [UIImage newImageFromMaskImage: [[UIImage trainlineDetailedButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON* scaleFactorTrainlineButton, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON * scaleFactorTrainlineButton) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
    [self.trainlineButton setImage: trainlineButtonImage forState: UIControlStateNormal];
    [self.trainlineButton setImage: trainlineButtonImageHighlighted forState: UIControlStateHighlighted];
    [self.trainlineButton setImage: trainlineButtonImageSelected forState: UIControlStateSelected];
    self.trainlineButton.imageView.contentMode = UIViewContentModeCenter;
    self.trainlineButton.frame = CGRectMake(self.view.frame.size.width - BUTTONHEIGHT*3 - 5*3, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.trainlineButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.trainlineButton.showsTouchWhenHighlighted = YES;
    [self.trainlineButton addTarget: self action: @selector(switchtrainlinemode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.trainlineButton];
    self.trainlineButton.alpha = 0.0;
    
    // Top infoview
    CGRect viewFrameInfo = self.view.frame;
    int startPositionInfoView = (viewFrameInfo.size.width - SPLITVIEWMAINVIEWWIDTH - 350) / 2 + SPLITVIEWMAINVIEWWIDTH + 50;
    int infoViewWidth = 350;
    self.topInfoView = [[UIView alloc] initWithFrame:CGRectMake(startPositionInfoView, 0, infoViewWidth, TOOLBARHEIGHTIPAD)];
    self.topInfoView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.topInfoView.backgroundColor = [UIColor clearColor];
    self.topInfoView.userInteractionEnabled = NO;
    self.topInfoView.alpha = 0.0;
    
    /*
    self.topInfoTransportTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 3, 30, 30)];
    //self.topInfoTransportTypeImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.topInfoTransportTypeImageView.backgroundColor = [UIColor clearColor];
    self.topInfoTransportTypeImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.topInfoView addSubview:self.topInfoTransportTypeImageView];
    */
    
    self.topInfoTransportNameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 7, 80, 20)];
    //self.topInfoTransportNameImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.topInfoTransportNameImageView.backgroundColor = [UIColor clearColor];
    self.topInfoTransportNameImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.topInfoView addSubview:self.topInfoTransportNameImageView];
    
    //CGRect viewFrame = self.topInfoView.frame;
    int startPosition = 8 + 80 + 5 + 40 + 5 + 2;
    int labelWith = infoViewWidth - (8 + 80 + 5 + 40 + 5 + 2);
    
    self.bottomInfoStartStationLabel = [[UILabel alloc] initWithFrame: CGRectMake(startPosition, 10, labelWith, 14)];
    self.bottomInfoStartStationLabel.font = [UIFont boldSystemFontOfSize: 14.0];
    self.bottomInfoStartStationLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
    self.bottomInfoStartStationLabel.backgroundColor = [UIColor clearColor];
    self.bottomInfoStartStationLabel.textAlignment = NSTextAlignmentLeft;
    [self.topInfoView addSubview:self.bottomInfoStartStationLabel];
    
    /*
    self.bottomInfoEndStationLabel = [[UILabel alloc] initWithFrame: CGRectMake(startPosition, 18, labelWith, 14)];
    self.bottomInfoEndStationLabel.font = [UIFont systemFontOfSize: 12.0];
    self.bottomInfoEndStationLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
    self.bottomInfoEndStationLabel.backgroundColor = [UIColor clearColor];
    self.bottomInfoEndStationLabel.textAlignment = NSTextAlignmentLeft;
    [self.topInfoView addSubview:self.bottomInfoEndStationLabel];
    */
    
    self.bottomInfoDepartureTimeLabel = [[UILabel alloc] initWithFrame: CGRectMake(8 + 80 + 5 + 3, 10, 40, 14)];
    self.bottomInfoDepartureTimeLabel.font = [UIFont boldSystemFontOfSize: 14.0];
    self.bottomInfoDepartureTimeLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
    self.bottomInfoDepartureTimeLabel.backgroundColor = [UIColor clearColor];
    self.bottomInfoDepartureTimeLabel.textAlignment = NSTextAlignmentLeft;
    [self.topInfoView addSubview:self.bottomInfoDepartureTimeLabel];
    
    /*
    self.bottomInfoArrivalTimeLabel = [[UILabel alloc] initWithFrame: CGRectMake(startPosition - 45, 18, 40, 14)];
    self.bottomInfoArrivalTimeLabel.font = [UIFont systemFontOfSize: 12.0];
    self.bottomInfoArrivalTimeLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
    self.bottomInfoArrivalTimeLabel.backgroundColor = [UIColor clearColor];
    self.bottomInfoArrivalTimeLabel.textAlignment = NSTextAlignmentLeft;
    [self.topInfoView addSubview:self.bottomInfoArrivalTimeLabel];
    */
    
    [self.view addSubview:self.topInfoView];
    
    //CGRect viewFrameStation = self.view.frame;
    int startPositionStationView = BUTTONHEIGHT + 5;
    int stationViewWidth = 350;
    self.topStationView = [[UIView alloc] initWithFrame:CGRectMake(startPositionStationView, 0, stationViewWidth, TOOLBARHEIGHTIPAD)];
    self.topStationView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.topStationView.backgroundColor = [UIColor clearColor];
    self.topStationView.userInteractionEnabled = NO;
    self.topStationView.alpha = 0.0;
    
    self.timeLabel = [[UILabel alloc] initWithFrame: CGRectMake(5 + 10, 9, 40, BUTTONHEIGHT / 2)];
    //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
    self.timeLabel.font = [UIFont boldSystemFontOfSize: 14.0];
    self.timeLabel.textColor = [UIColor toolbarTextColorNormal];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    
    self.startStationLabel = [[UILabel alloc] initWithFrame: CGRectMake(5 + 40 + 5 + 10 - 5, 9, self.topStationView.frame.size.width - BUTTONHEIGHT + 5 + 5 + 40 + 5 - BUTTONHEIGHT - 10 - 10 + 5, BUTTONHEIGHT / 2)];
    //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
    self.startStationLabel.font = [UIFont boldSystemFontOfSize: 14.0];
    self.startStationLabel.textColor = [UIColor toolbarTextColorNormal];
    self.startStationLabel.backgroundColor = [UIColor clearColor];
    self.startStationLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.topStationView addSubview: self.timeLabel];
    [self.topStationView addSubview: self.startStationLabel];
    
    [self.view addSubview: self.topStationView];
    
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
        if (self.stationboardMapViewController) {
            [self.stationboardMapViewController switchToNormalTrainline:YES];
            self.trainlineButton.selected = YES;
        }
    } else {
        if (self.stationboardMapViewController) {
            [self.stationboardMapViewController switchToNormalTrainline:NO];
            self.trainlineButton.selected = NO;
        }
    }
}

- (void) goToStore:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DTOpenStore" object:nil];
}

- (void) moveStationboardResultContainerViewOffScreen {
    
    
#ifdef LOGOUTPUTON
    NSLog(@"moveStationboardResultsContainerViewOffScreen");
#endif
    
    CGRect currentFrame = self.stationboardResultContainerViewController.view.frame;
    //NSLog(@"Origin: %.1f", currentFrame.origin.x);
    currentFrame.origin.x = -320;
    self.goButton.alpha = 0.0;
    self.backButton.alpha = 0.0;
    self.listButton.alpha = 0.0;
    self.topInfoView.alpha = 0.0;
    self.topStationView.alpha = 0.0;
    self.closestStationsButton.alpha = 0.0;
    self.trainlineButton.alpha = 0.0;
    
    if (self.navSC) {
        self.navSC.alpha = 0.0;
        self.navSC = nil;
    }
    
    self.navBarVisible = NO;
    
    [self.listViewPopOverController dismissPopoverAnimated: YES];
    // TEST
    [self.stationboardMapViewController stopAllMapTransactionsAndRemoveOverlayAndAnnotations];
    
    [UIView animateWithDuration: 0.3 animations: ^{
        self.stationboardResultContainerViewController.view.frame = currentFrame;
        
        self.goButton.alpha = 1.0;

        self.closestStationsButton.alpha = 1.0;
        //NSLog(@"Origin: %.1f", self.stationboardResultContainerViewController.view.frame.origin.x);
    } completion:^(BOOL finished){
        
    }];
}

- (void) moveStationboardResultContainerViewOnScreen {
    
#ifdef LOGOUTPUTON
    NSLog(@"moveStationboardResultsContainerViewOnScreen");
#endif
    
    CGRect currentFrame = self.stationboardResultContainerViewController.view.frame;
    //NSLog(@"Origin: %.1f", currentFrame.origin.x);
    currentFrame.origin.x = 0;
    self.goButton.alpha = 0.0;
    self.backButton.alpha = 0.0;
    self.listButton.alpha = 0.0;
    self.closestStationsButton.alpha = 0.0;
    
    self.navBarVisible = YES;
        
    [UIView animateWithDuration: 0.3 animations: ^{
        self.stationboardResultContainerViewController.view.frame = currentFrame;
        self.backButton.alpha = 1.0;
        //self.listButton.alpha = 1.0;
        //NSLog(@"Origin: %.1f", self.stationboardResultContainerViewController.view.frame.origin.x);
    } completion:^(BOOL finished){
        
    }];
}

-(void) cancelCurrentRunningRequestsIfAny {
    if ([[SBBAPIController sharedSBBAPIController] stbreqRequestInProgress]) {
        [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIStbreqOperations];
    }
    
    //[self hideLoadingIndicator];
}

- (void)didSelectStationPickerAnnotaton:(StationboardMapViewController *)controller station:(Station *)station viewrect:(CGRect)viewrect {
    //NSLog(@"StatioboardContainerViewControlleriPad: didSelectStationPickerPinAnnotation");
    if (station && station.stationName && station.stationId) {
        
        //NSLog(@"StatioboardContainerViewControlleriPad: didSelectStationPickerPinAnnotation: %@", station.stationName);
        
        //RIButtonItem *cancelButton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Cancel", @"Open maps app cancel block action sheet title")];
        RIButtonItem *stationAsStart = [RIButtonItem itemWithLabel: NSLocalizedString(@"As station", @"Select as stb start station block action sheet title")];
        stationAsStart.action = ^{
            //NSLog(@"Station as stb start");
            [self.stationboardSelectionViewControlleriPad setStbStartLocationWithStation: station];
            [self preCheckStationboardProductTypesForStationAndPushStationboardViewControllerIfFlagSet];
        };
        UIActionSheet *stationActionSheet;
        if (self.dirStationIsVisible) {
            RIButtonItem *stationAsDir = [RIButtonItem itemWithLabel: NSLocalizedString(@"As direction", @"Select as stb direction station block action sheet title")];
            stationAsDir.action = ^{
                //NSLog(@"Station as stb direction");
                [self.stationboardSelectionViewControlleriPad setStbDirLocationWithStation: station];
            };
            stationActionSheet = [[UIActionSheet alloc] initWithTitle: station.stationName cancelButtonItem: nil destructiveButtonItem: nil otherButtonItems: stationAsStart, stationAsDir, nil];
        } else {
            stationActionSheet = [[UIActionSheet alloc] initWithTitle: station.stationName cancelButtonItem: nil destructiveButtonItem: nil otherButtonItems: stationAsStart, nil];
        }
        
        //[shareActionSheet showInView: self.view.superview];
        stationActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        
        CGRect overlerayRectinView = [self.view convertRect: viewrect fromView: self.stationboardMapViewController.view];
        
        //NSLog(@"StationboardContainerViewControlleriPad: view frame: %.1f %.1f, %.1f. %.1f", viewrect.origin.x, viewrect.origin.y, viewrect.size.width, viewrect.size.height);
        //NSLog(@"StationboardContainerViewControlleriPad: view frame of overlay: %.1f %.1f, %.1f. %.1f", overlerayRectinView.origin.x, overlerayRectinView.origin.y, overlerayRectinView.size.width, overlerayRectinView.size.height);
        
        [stationActionSheet showFromRect: overlerayRectinView inView: self.view animated: YES];
        
        if(stationActionSheet.subviews.count > 0 && [[stationActionSheet.subviews objectAtIndex:0] isKindOfClass:[UILabel class]]) {
            UILabel* l = (UILabel*) [stationActionSheet.subviews objectAtIndex:0];
            [l setFont:[UIFont boldSystemFontOfSize:16]];
            [l setTextColor: [UIColor whiteColor]];
        }
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


- (void)selectStbStartStationButtonPressed:(StationboardSelectionViewControlleriPad *)controller fromrect:(CGRect)rect {
    //NSLog(@"ConnectionsContainerViewControlleriPad: selectStartStationButtonPressed delegate");
    [self cancelCurrentRunningRequestsIfAny];
    
    [self showStationPickerControllerWithType: startStationTypeiPad fromrect:rect];
}

- (void)selectStbDirStationButtonPressed:(StationboardSelectionViewControlleriPad *)controller fromrect:(CGRect)rect{
    //NSLog(@"ConnectionsContainerViewControlleriPad: selectEndStationButtonPressed delegate");
    [self cancelCurrentRunningRequestsIfAny];
    
    [self showStationPickerControllerWithType: endStationTypeiPad fromrect:rect];
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
    self.searchStationPickerController.stationpickerType = stationboardStationpickerType;
    
    self.currentlyPushedViewController = stationsPickerViewControllerConnectionsContaineriPad;
    CGRect buttonRectinView = [self.view convertRect: rect fromView: self.stationboardSelectionViewControlleriPad.view];
    
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

- (void)didModifyStartOrDirStation:(StationboardSelectionViewControlleriPad *)controller {
    [self cancelCurrentRunningRequestsIfAny];
    self.stbCurrentStationIsPrechecked = NO;
}

- (void)didTriggerOpenShowDirStationWithVisibleFlag:(StationboardSelectionViewControlleriPad *)controller visible:(BOOL)visible {
    [self cancelCurrentRunningRequestsIfAny];
    self.dirStationIsVisible = visible;
}

- (void)didSelectStationWithStationTypeIndex:(SearchStationPickerControlleriPad *)controller stationTypeIndex:(NSUInteger)index station:(Station *)station {
    //NSLog(@"ConnectionsContainerViewControlleriPad: didSelectStationWithStationTypeIndex delegate");
    self.stbCurrentStationIsPrechecked = NO;
    self.currentlyPushedViewController = noViewControllerStationboardContaineriPad;
    if (station) {
        if (station.stationName && station.stationId) {
            if (index == startStationTypeiPad) {
                if (self.stationboardSelectionViewControlleriPad) {
                    [self.stationboardSelectionViewControlleriPad setStbStartLocationWithStation: station];
                }
            } else if (index == endStationTypeiPad) {
                if (self.stationboardSelectionViewControlleriPad) {
                    [self.stationboardSelectionViewControlleriPad setStbDirLocationWithStation: station];
                }
            } 
        }
        [self preCheckStationboardProductTypesForStationAndPushStationboardViewControllerIfFlagSet];
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
    
    [self cancelCurrentRunningRequestsIfAny];
    
    if (self.searchStationPickerPopOverController) {
        [self.searchStationPickerPopOverController dismissPopoverAnimated: YES];
    }
    
    //[self dismissViewControllerAnimated:YES completion:^{}];
    
}

- (void)dateAndTimePickerButtonPressedFromRect:(CGRect)rect withdate:(NSDate *)date deparr:(BOOL)deparr {
    //NSLog(@"StationboardContainerViewControlleriPad: selection date station");
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
    
    self.currentlyPushedViewController = dateAndTimePickerViewControllerConnectionsContaineriPad;
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
    
    self.stbCurrentStationIsPrechecked = NO;
    
    self.currentlyPushedViewController = noViewControllerConnectionsContaineriPad;
    [self.dtPickerPopOverController dismissPopoverAnimated: YES];
    if (self.stationboardSelectionViewControlleriPad) {
        [self.stationboardSelectionViewControlleriPad setConnectionDate: self.dtDatePicker.date depArr: self.dtPickerDepArr];
    }
}

- (void) pushOutConnectionsResultController:(id)sender {
    [self moveStationboardResultContainerViewOffScreen];
    
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

- (void)didTriggerStartSearch:(StationboardSelectionViewControlleriPad *)controller {
    [self executeSBBAPIRequest: nil];
}

-(void) executeSBBAPIRequest:(id) sender {
    
    [self.stationboardMapViewController stopAllMapTransactionsAndRemoveOverlayAndAnnotations];
    [self getStationBoard:sender];
}

- (void) preCheckStationboardProductTypesForStationAndPushStationboardViewControllerIfFlagSet {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable)
    {
        return;
    }
    
    /*
    Station *stbStation = [[Station alloc] init];
    [stbStation setStationName: self.stbStationName];
    [stbStation setStationId: self.stbStationID];
    
    Station *dirStation = [[Station alloc] init];
    [dirStation setStationName: self.dirStationName];
    [dirStation setStationId: self.dirStationID];
    */
    
    Station *stbStation = [self.stationboardSelectionViewControlleriPad getStbStartLocation];
    Station *dirStation = [self.stationboardSelectionViewControlleriPad getStbDirLocation];
    
    if ((!stbStation.stationName && !dirStation.stationName) || [stbStation.stationName isEqualToString: dirStation.stationName])  return;
    
    
    NSDate *connectionTime; BOOL isDepartureTime = YES;
    
    connectionTime = [self.stationboardSelectionViewControlleriPad getConnectionDate];
    isDepartureTime = [self.stationboardSelectionViewControlleriPad getConnectionDateDepArr];
    
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

    
    if ([[SBBAPIController sharedSBBAPIController] stbreqRequestInProgress]) {
        [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIStbreqOperations];
    }
    
    self.stbIsPreCheckingStation = YES;
    self.stbCurrentStationIsPrechecked = NO;
    
    //if (self.stationboardConnectionsViewController) {
    //    self.stationboardConnectionsViewController = nil;
    //}
    
    [[SBBAPIController sharedSBBAPIController] getProductTypesWithQuickCheckStbReqXMLStationboardRequestWithProductCode: stbStation
                                                                                                            destination: dirStation
                                                                                                                stbDate: connectionTime
                                                                                                          departureTime:isDepartureTime
                                                                                                   gotProductTypesBlock:^(NSUInteger productTypes){
                                                                                                       
                                                                                                        #ifdef LOGOUTPUTON
                                                                                                       NSLog(@"Prechecked product types after selecting station");
                                                                                                        #endif
                                                                                                       
                                                                                                       [self hideLoadingIndicator];
                                                                                                       
                                                                                                       if (productTypes != stbNone) {
                                                                                                           self.stbIsPreCheckingStation = NO;
                                                                                                           self.stbStationboardCurrentPrecheckedProductType = productTypes;
                                                                                                           self.stbCurrentStationIsPrechecked = YES;
                                                                                                           
                                                                                                           if (self.stbPushStationboardViewControllerAfterPreCheck) {
                                                                                                               #ifdef LOGOUTPUTON
                                                                                                               NSLog(@"Prechecked product types. Push flag set. Push view controller");
                                                                                                               #endif
                                                                                                               self.stbPushStationboardViewControllerAfterPreCheck = NO;
                                                                                                               [self getStationBoardConnectionsForProductType: productTypes];
                                                                                                               
                                                                                                           }
                                                                                                       } else {
                                                                                                           [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqNoProductsForStbStation:self.view];
                                                                                                       }
                                                                                                   }
                                                                                           failedToGetProductTypesBlock:^(NSUInteger errorcode){
                                                                                               #ifdef LOGOUTPUTON
                                                                                               NSLog(@"Prechecked product types after selecting station failed.");
                                                                                               #endif
                                                                                               self.stbIsPreCheckingStation = NO;
                                                                                               self.stbCurrentStationIsPrechecked = NO;
                                                                                               
                                                                                               [self hideLoadingIndicator];
                                                                                               
                                                                                               //NSUInteger kConReqRequestFailureConnectionFailed = 85;
                                                                                               //NSUInteger kConScrRequestFailureConnectionFailed = 45;
                                                                                               //NSUInteger kStbReqRequestFailureConnectionFailed = 75;
                                                                                               //NSUInteger kStbScrRequestFailureConnectionFailed = 51;
                                                                                               //NSUInteger kJrnReqRequestFailureConnectionFailed = 65;
                                                                                               //NSUInteger kRssReqRequestFailureConnectionFailed = 95;
                                                                                               //NSUInteger kStbReqRequestFailureCancelled = 7599;
                                                                                               
                                                                                               //NSUInteger kSbbReqStationsNotDefined = 112;
                                                                                               
                                                                                               if (errorcode == kStbReqRequestFailureConnectionFailed) {
                                                                                                   [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqFailedNotice:self.view];
                                                                                               } else if (errorcode == kSbbReqStationsNotDefined) {
                                                                                                   [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqStationsNotAvailableNotice:self.view];
                                                                                               } else if (errorcode == kStbReqRequestFailureCancelled) {
                                                                                                    //Nothing to do
                                                                                               } else {
                                                                                                   [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqOtherUndefinedErrorNotice:self.view];
                                                                                               }
                                                                                               
                                                                                           }];
    
}

-(void) getStationBoard:(id) sender {
    
    if (self.stbIsPreCheckingStation) {
        #ifdef LOGOUTPUTON
        NSLog(@"Precheck is currently running. Set push view controller flag");
        #endif
        self.stbPushStationboardViewControllerAfterPreCheck = YES;
        [self showLoadingIndicator];
        return;
    }
    
    #ifdef LOGOUTPUTON
    NSLog(@"No precheck is currently running. Precheck and push when done");
    #endif
    
    Station *stbStation = [self.stationboardSelectionViewControlleriPad getStbStartLocation];
    Station *dirStation = [self.stationboardSelectionViewControlleriPad getStbDirLocation];
    
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
    
    if (!stbStation.stationName || !stbStation.stationId)
	{
		[self hideLoadingIndicator];
        
        //UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        //[[NoticeviewMessages sharedNoticeMessagesController] showNoStationSelected: currentWindow];
        [[NoticeviewMessages sharedNoticeMessagesController] showNoStationSelected: self.view];
        
		return;
	}
    
    
    if ((!stbStation.stationName && !dirStation.stationName) || [stbStation.stationName isEqualToString: dirStation.stationName])
	{
		[self hideLoadingIndicator];
        
        //UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        //[[NoticeviewMessages sharedNoticeMessagesController] showStbStationsIdenticalMessage: currentWindow];
        [[NoticeviewMessages sharedNoticeMessagesController] showStbStationsIdenticalMessage: self.view];
        
		return;
	}
    
    NSDate *connectionTime; BOOL isDepartureTime = YES;
    
    connectionTime = [self.stationboardSelectionViewControlleriPad getConnectionDate];
    isDepartureTime = [self.stationboardSelectionViewControlleriPad getConnectionDateDepArr];
    
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
    
    if ([[SBBAPIController sharedSBBAPIController] stbreqRequestInProgress]) {
        [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIStbreqOperations];
    }
    
    if (self.stbCurrentStationIsPrechecked) {
        
        [self getStationBoardConnectionsForProductType: self.stbStationboardCurrentPrecheckedProductType];
        
        /*
        self.stationboardResultContainerViewController.stbStation = stbStation;
        self.stationboardResultContainerViewController.dirStation = dirStation;
        self.stationboardResultContainerViewController.connectionTime = connectionTime;
        self.stationboardResultContainerViewController.isDepartureTime = isDepartureTime;
        
        [self.stationboardResultContainerViewController updateControllerWithStationBoardProductCodesType: self.stbStationboardCurrentPrecheckedProductType];
        self.currentlyPushedViewController = stationboardResultViewControllerStationboardContaineriPad;
        
        [self moveStationboardResultContainerViewOnScreen];
        [self setStationViewDetailInTopView];
        [self setStationboardNavigationBarWithProductType: self.stbStationboardCurrentPrecheckedProductType];
         */
        
        return;
    }
    
    [self showLoadingIndicator];
    
    //if (self.stationboardConnectionsViewController) {
    //    self.stationboardConnectionsViewController = nil;
    //}
    
    [[SBBAPIController sharedSBBAPIController] getProductTypesWithQuickCheckStbReqXMLStationboardRequestWithProductCode:stbStation
                                                                                                            destination:dirStation
                                                                                                                stbDate:connectionTime
                                                                                                          departureTime:isDepartureTime
                                                                                                   gotProductTypesBlock:^(NSUInteger productTypes){
                                                                                                       [self hideLoadingIndicator];
                                                                                                       
                                                                                                       if (productTypes != stbNone) {
                                                                                                           [self getStationBoardConnectionsForProductType: productTypes];
                                                                                                       } else {
                                                                                                           [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqNoProductsForStbStation:self.view];
                                                                                                       }
                                                                                                   }
                                                                                           failedToGetProductTypesBlock:^(NSUInteger errorcode){
                                                                                               
                                                                                               [self hideLoadingIndicator];
                                                                                               
                                                                                               //NSUInteger kConReqRequestFailureConnectionFailed = 85;
                                                                                               //NSUInteger kConScrRequestFailureConnectionFailed = 45;
                                                                                               //NSUInteger kStbReqRequestFailureConnectionFailed = 75;
                                                                                               //NSUInteger kStbScrRequestFailureConnectionFailed = 51;
                                                                                               //NSUInteger kJrnReqRequestFailureConnectionFailed = 65;
                                                                                               //NSUInteger kRssReqRequestFailureConnectionFailed = 95;
                                                                                               //NSUInteger kStbReqRequestFailureCancelled = 7599;
                                                                                               
                                                                                               //NSUInteger kSbbReqStationsNotDefined = 112;
                                                                                               
                                                                                               if (errorcode == kStbReqRequestFailureConnectionFailed) {
                                                                                                   [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqFailedNotice:self.view];
                                                                                               } else if (errorcode == kSbbReqStationsNotDefined) {
                                                                                                   [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqStationsNotAvailableNotice:self.view];
                                                                                               } else if (errorcode == kStbRegRequestFailureNoNewResults) {
                                                                                                   [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqDidNotReturnAnyResultNotice: self.view];
                                                                                               } else if (errorcode == kStbReqRequestFailureCancelled) {
                                                                                                    // Nothing to do
                                                                                               } else {
                                                                                                   [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqOtherUndefinedErrorNotice:self.view];
                                                                                               }
                                                                                               
                                                                                           }];
    
}

- (void) getStationBoardConnectionsForProductType:(NSUInteger)productCodeTypes {

    NSUInteger selectedProductTypeForRequest = stbAll;
    
    [[SBBAPIController sharedSBBAPIController] resetStationboardResults];
    
    if (productCodeTypes == stbFastAndRegioTrain) {
        selectedProductTypeForRequest = stbOnlyFastTrain;
    } else if (productCodeTypes == stbFastTrainAndTramBus) {
        selectedProductTypeForRequest = stbOnlyFastTrain;
    } else if (productCodeTypes == stbRegioTrainAndTramBus) {
        selectedProductTypeForRequest = stbOnlyRegioTrain;
    } else if (productCodeTypes == stbAll) {
        selectedProductTypeForRequest = stbOnlyFastTrain;
    } else if (productCodeTypes == stbOnlyFastTrain) {
        selectedProductTypeForRequest = stbOnlyFastTrain;
    } else if (productCodeTypes == stbOnlyRegioTrain) {
        selectedProductTypeForRequest = stbOnlyRegioTrain;
    } else if (productCodeTypes == stbOnlyTramBus) {
        selectedProductTypeForRequest = stbOnlyTramBus;
    } else {
        selectedProductTypeForRequest = stbAll;
    }
    
    Station *stbStation = [self.stationboardSelectionViewControlleriPad getStbStartLocation];
    Station *dirStation = [self.stationboardSelectionViewControlleriPad getStbDirLocation];
    
    if (!stbStation.stationName || !stbStation.stationId)
	{
		[self hideLoadingIndicator];
        
        //UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        //[[NoticeviewMessages sharedNoticeMessagesController] showNoStationSelected: currentWindow];
        [[NoticeviewMessages sharedNoticeMessagesController] showNoStationSelected: self.view];
        
		return;
	}
    
    
    if ((!stbStation.stationName && !dirStation.stationName) || [stbStation.stationName isEqualToString: dirStation.stationName])
	{
		[self hideLoadingIndicator];
        
        //UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        //[[NoticeviewMessages sharedNoticeMessagesController] showStbStationsIdenticalMessage: currentWindow];
        [[NoticeviewMessages sharedNoticeMessagesController] showStbStationsIdenticalMessage: self.view];
        
		return;
	}
    
    NSDate *connectionTime; BOOL isDepartureTime = YES;
    
    connectionTime = [self.stationboardSelectionViewControlleriPad getConnectionDate];
    isDepartureTime = [self.stationboardSelectionViewControlleriPad getConnectionDateDepArr];
    
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
    
    if (self.stationboardResultContainerViewController) {
        [self.stationboardResultContainerViewController showLoadingIndicator];
    }
        
    [self cancelCurrentRunningRequestsIfAny];
    
    [[SBBAPIController sharedSBBAPIController] sendStbReqXMLStationboardRequestWithProductType:stbStation
                                                                                   destination:dirStation
                                                                                       stbDate:connectionTime
                                                                                 departureTime:isDepartureTime
                                                                                   productType:selectedProductTypeForRequest
                                                                                  successBlock:^(NSUInteger numberofresults){
                                                                                      if (self.stationboardResultContainerViewController) {
                                                                                          [self.stationboardResultContainerViewController hideLoadingIndicator];
                                                                                          if (numberofresults > 0) {
                                                                                              
                                                                                            #ifdef LOGOUTPUTON
                                                                                              NSLog(@"Stb req results got: %d", numberofresults);
                                                                                            #endif
                                                                                              
                                                                                              self.stationboardResultContainerViewController.stbStation = stbStation;
                                                                                              self.stationboardResultContainerViewController.dirStation = dirStation;
                                                                                              self.stationboardResultContainerViewController.connectionTime = connectionTime;
                                                                                              self.stationboardResultContainerViewController.isDepartureTime = isDepartureTime;
                                                                                              [self.stationboardResultContainerViewController setStationBoardResultProductType:selectedProductTypeForRequest];
                                                                                              [self.stationboardResultContainerViewController UpdateTableViewWithNumberOfResults: numberofresults];
                                                                                              
                                                                                              self.currentlyPushedViewController = stationboardResultViewControllerStationboardContaineriPad;
                                                                                              [self moveStationboardResultContainerViewOnScreen];
                                                                                              
                                                                                              /*
                                                                                              if (self.currentlyPushedViewController != stationboardResultViewControllerStationboardContaineriPad) {
                                                                                                  self.currentlyPushedViewController = stationboardResultViewControllerStationboardContaineriPad;
                                                                                               
                                                                                              }
                                                                                              */
                                                                                              
                                                                                              [self setStationViewDetailInTopView];
                                                                                              [self setStationboardNavigationBarWithProductType: productCodeTypes];
                                                                                              
                                                                                          } else {
                                                                                              [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqDidNotReturnAnyResultNotice: self.view];
                                                                                          }
                                                                                      }
                                                                                  }
                                                                                  failureBlock:^(NSUInteger errorcode){
                                                                                      
                                                                                      if (self.stationboardResultContainerViewController) {
                                                                                          [self.stationboardResultContainerViewController hideLoadingIndicator];
                                                                                      }
                                                                                      
                                                                                      //NSUInteger kConReqRequestFailureConnectionFailed = 85;
                                                                                      //NSUInteger kConScrRequestFailureConnectionFailed = 45;
                                                                                      //NSUInteger kStbReqRequestFailureConnectionFailed = 75;
                                                                                      //NSUInteger kStbScrRequestFailureConnectionFailed = 51;
                                                                                      //NSUInteger kJrnReqRequestFailureConnectionFailed = 65;
                                                                                      //NSUInteger kRssReqRequestFailureConnectionFailed = 95;
                                                                                      //NSUInteger kStbReqRequestFailureCancelled = 7599;
                                                                                      
                                                                                      //NSUInteger kSbbReqStationsNotDefined = 112;
                                                                                      
                                                                                      if (errorcode == kStbReqRequestFailureConnectionFailed) {
                                                                                          [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqFailedNotice:self.view];
                                                                                      } else if (errorcode == kSbbReqStationsNotDefined) {
                                                                                          [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqStationsNotAvailableNotice:self.view];
                                                                                      } else if (errorcode == kStbReqRequestFailureCancelled) {
                                                                                          // Nothing to do
                                                                                      } else if (errorcode == kStbRegRequestFailureNoNewResults) {
                                                                                          [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqDidNotReturnAnyResultNotice: self.view];
                                                                                      } else {
                                                                                          [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqOtherUndefinedErrorNotice:self.view];
                                                                                      }
                                                                                  }];

    
}

- (void) selectFastTrainResults {
    if (self.stationboardResultContainerViewController) {
        [self.stationboardResultContainerViewController selectFastTrainResults];
    }
}

- (void) selectRegioTrainResults {
    if (self.stationboardResultContainerViewController) {
        [self.stationboardResultContainerViewController selectRegioTrainResults];
    }
}

- (void) selectTramBusResults {
    if (self.stationboardResultContainerViewController) {
        [self.stationboardResultContainerViewController selectTramBusResults];
    }
}

- (void) selectAllResults {
    if (self.stationboardResultContainerViewController) {
        [self.stationboardResultContainerViewController selectAllResults];
    }
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
    
    if (self.stationboardMapViewController) {
        [self.stationboardMapViewController stopAllMapTransactionsAndRemoveOverlayAndAnnotations];
        self.stationboardMapViewController.managedObjectContext = self.managedObjectContext;
        [self.stationboardMapViewController getStationsAndUpdateMapView];
    }
}

- (void) showListViewController:(id)sender {
    if (!self.stationboardListViewController) {
        self.stationboardListViewController = [[StationboardListViewController alloc] init];
        self.stationboardListViewController.view.frame = CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT - LISTVIEWCONTROLLERHEIGHTPAD);
    }
    if (!self.listViewPopOverController) {
        self.stationboardListViewController.view.frame = CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT - LISTVIEWCONTROLLERHEIGHTPAD);
        UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT - LISTVIEWCONTROLLERHEIGHTPAD)];
        //popoverView.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        popoverView.backgroundColor = [UIColor listviewControllersBackgroundColor];
        UIViewController* popoverContent = [[UIViewController alloc] init];
        [popoverView addSubview:self.stationboardListViewController.view];
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

    self.currentlyPushedViewController = stationboardListViewControllerStationboardContaineriPad;
    CGRect rect = self.listButton.frame;
    [self.stationboardListViewController updateJourneyTableView];
    [self.listViewPopOverController presentPopoverFromRect: rect inView: self.view permittedArrowDirections: UIPopoverArrowDirectionUp animated: YES];
    //[self.stationboardListViewController.tableView reloadData];
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

- (void) setTopJourneyInfoView {
    
    self.topInfoView.alpha = 1.0;
    
    CGRect viewFrameInfo = self.view.frame;
    int startPositionInfoView = (viewFrameInfo.size.width - SPLITVIEWMAINVIEWWIDTH - 350) / 2 + SPLITVIEWMAINVIEWWIDTH + 50;
    int infoViewWidth = 350;
    self.topInfoView.frame = CGRectMake(startPositionInfoView, 0, infoViewWidth, TOOLBARHEIGHTIPAD);
        
    if ([[SBBAPIController sharedSBBAPIController] journeyResult]) {
        Journey *journey = [[SBBAPIController sharedSBBAPIController] journeyResult];
        NSArray *basicStopList = [[SBBAPIController sharedSBBAPIController] getBasicStopsForStationboardJourneyRequestResult: journey];
        if (basicStopList && (basicStopList.count > 0)) {
            NSString *stationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList objectAtIndex: 0]];
            NSString *startTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForBasicStop: [basicStopList objectAtIndex: 0]];
            self.bottomInfoStartStationLabel.text = [self shortenStationNameIfTooLong: stationName maxLenth: 22];
            self.bottomInfoDepartureTimeLabel.text = startTime;
        }
        
        UIImage *transportNameImage = [[SBBAPIController sharedSBBAPIController] renderTransportNameImageForStationboardJourney: journey];
        [self.topInfoTransportNameImageView setImage: transportNameImage];
        

    }
    
    self.bottomInfoStartStationLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
    self.bottomInfoDepartureTimeLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
}

- (void) setStationboardNavigationBarWithProductType:(NSUInteger)productCodeTypes {
    
    //NSLog(@"Set navigation bar at bottom with product type.");
    
    CGFloat scaleFactor = 1.5;
    UIImage *fastTrainImage =  [[UIImage stationBoardFastTrainImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactor, SEGMENTHEIGHT ) interpolationQuality: kCGInterpolationDefault];
    UIImage *regioTrainImage = [[UIImage stationBoardRegioTrainImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactor, SEGMENTHEIGHT) interpolationQuality: kCGInterpolationDefault];
    UIImage *busTramImage = [[UIImage stationBoardBusTramImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactor, SEGMENTHEIGHT) interpolationQuality: kCGInterpolationDefault];
    
    __weak StationboardContainerViewControlleriPad *weakself = self;
    
    if (self.navSC) {
        self.navSC.alpha = 0.0;
        self.navSC = nil;
    }
    
    if (productCodeTypes == stbFastAndRegioTrain) {
        
        self.navSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"", @"", nil]];
        self.navSC.sectionImages = [NSArray arrayWithObjects: fastTrainImage, regioTrainImage, nil];
        //navSC.sectionTitles = nil;
        self.navSC.changeHandler = ^(NSUInteger newIndex) {
            //NSLog(@"segmentedControl did select index %i (via block handler)", newIndex);
            if (newIndex == 0) {
                [weakself selectFastTrainResults];
            } else if (newIndex == 1) {
                [weakself selectRegioTrainResults];
            }
        };
        [weakself selectFastTrainResults];
    } else if (productCodeTypes == stbFastTrainAndTramBus) {
        
        self.navSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"", @"", nil]];
        self.navSC.sectionImages = [NSArray arrayWithObjects: fastTrainImage, busTramImage, nil];
        //navSC.sectionTitles = nil;
        self.navSC.changeHandler = ^(NSUInteger newIndex) {
            //NSLog(@"segmentedControl did select index %i (via block handler)", newIndex);
            if (newIndex == 0) {
                [weakself selectFastTrainResults];
            } else if (newIndex == 1) {
                [weakself selectTramBusResults];
            }
        };
        [weakself selectFastTrainResults];
    } else if (productCodeTypes == stbRegioTrainAndTramBus) {
        
        self.navSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"", @"", nil]];
        self.navSC.sectionImages = [NSArray arrayWithObjects: regioTrainImage, busTramImage, nil];
        //navSC.sectionTitles = nil;
        self.navSC.changeHandler = ^(NSUInteger newIndex) {
            //NSLog(@"segmentedControl did select index %i (via block handler)", newIndex);
            if (newIndex == 0) {
                [weakself selectRegioTrainResults];
            } else if (newIndex == 1) {
                [weakself selectTramBusResults];
            }
        };
        [weakself selectRegioTrainResults];
    } else if (productCodeTypes == stbAll) {
        
        self.navSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"", @"", @"", nil]];
        self.navSC.sectionImages = [NSArray arrayWithObjects: fastTrainImage, regioTrainImage, busTramImage, nil];
        //navSC.sectionTitles = nil;
        self.navSC.changeHandler = ^(NSUInteger newIndex) {
            //NSLog(@"segmentedControl did select index %i (via block handler)", newIndex);
            if (newIndex == 0) {
                [weakself selectFastTrainResults];
            } else if (newIndex == 1) {
                [weakself selectRegioTrainResults];
            } else if (newIndex == 2) {
                [weakself selectTramBusResults];
            }
        };
        [weakself selectFastTrainResults];
    } else if (productCodeTypes == stbOnlyFastTrain) {
        [weakself selectFastTrainResults];
    } else if (productCodeTypes == stbOnlyRegioTrain) {
        [weakself selectRegioTrainResults];
    } else if (productCodeTypes == stbOnlyTramBus) {
        [weakself selectTramBusResults];
    } else {
        [weakself selectAllResults];
    }
    
    //UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
    
    if (self.tabbarControllerReference) {
        [self.tabbarControllerReference addCustomViewToTabbar: self.navSC];
        self.navSC.alpha = 1.0;
        CGSize size = [UIApplication currentScreenSize];
        //NSLog(@"Nav bar screen size: %.1f, %.1f", size.width, size.height);
        
        self.navSC.center = CGPointMake(100 - 3, size.height - TABBARHEIGHT / 2 - 1);
    } else {
        //NSLog(@"tabbar controller reference not set");
    }
    
    
    //[currentWindow addSubview: self.navSC];
    [self.navSC setSelectedIndex: 0];
    
    //CGSize size = [UIApplication currentScreenSize];
    //self.navSC.alpha = 1.0;
    //self.navSC.center = CGPointMake(50, size.height - TABBARHEIGHT);
}


- (void) setStationViewDetailInTopView {
    
    self.topStationView.alpha = 1.0;
    
    int startPositionStationView = BUTTONHEIGHT + 5;
    int stationViewWidth = 350;
    self.topStationView.frame = CGRectMake(startPositionStationView, 0, stationViewWidth, TOOLBARHEIGHTIPAD);
        
    Station *stbStation = [self.stationboardSelectionViewControlleriPad getStbStartLocation];
    //Station *dirStation = [self.stationboardSelectionViewControlleriPad getStbDirLocation];
    
    NSDate *connectionTime; BOOL isDepartureTime = YES;
    
    connectionTime = [self.stationboardSelectionViewControlleriPad getConnectionDate];
    isDepartureTime = [self.stationboardSelectionViewControlleriPad getConnectionDateDepArr];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    //[timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *timeString = [timeFormatter stringFromDate: connectionTime];
    
    self.timeLabel.text = timeString;
    self.startStationLabel.text = stbStation.stationName;
    self.timeLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
    self.startStationLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
}

- (void)showNoNetworkErrorMessage {
    [[NoticeviewMessages sharedNoticeMessagesController] showNoNetworkErrorMessage: self.view];
}

- (void)showGeocodingErrorMessage {
    [[NoticeviewMessages sharedNoticeMessagesController] showGeocodingErrorMessage: self.view];
}

- (void)didSelectStationboardCellWithIndexAndProductType:(StationboardResultsContainerViewController *)controller index:(NSUInteger)index producttype:(NSUInteger)producttype {
    
    //NSLog(@"StationboardContainerViewController: didSelectStationboardCellWithIndexAndProductType: %d, %d", index, producttype);
    
    self.trainlineButton.alpha = 0.0;
    
    if (index == 9999) {
        // test
        if (self.stationboardMapViewController) {
            self.listButton.alpha = 0.0;
            self.topInfoView.alpha = 0.0;
            [self.stationboardMapViewController stopAllMapTransactionsAndRemoveOverlayAndAnnotations];
            self.stationboardMapViewController.stbSelectedJourneyIndex = index;
            self.stationboardMapViewController.stbSelectedJourneyProducttype = producttype;
        }
    } else {
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus internetStatus = [reachability currentReachabilityStatus];
        
        if (internetStatus == NotReachable)
        {
            //UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
            [[NoticeviewMessages sharedNoticeMessagesController] showNoNetworkErrorMessage: self.view];
            
            return;
        }
        
        //[self showLoadingIndicator];
        
        //Journey *journey = [[SBBAPIController sharedSBBAPIController] getJourneyForStationboardResultWithIndex: indexPath.row];
        Journey *journey = [[SBBAPIController sharedSBBAPIController] getJourneyForStationboardResultFWithProductTypeWithIndex: producttype index: index];
        
        if ([[SBBAPIController sharedSBBAPIController] stationboardJourneyHasValidPasslist: journey]) {
            if ([[SBBAPIController sharedSBBAPIController] setStationboardJourneyResultWithJourney: journey]) {
                
                //NSLog(@"Statioboard journey has already passlist. Set it");
                
                if (self.stationboardListViewController) {
                    self.listButton.alpha =  1.0;
                }
                
                if (self.stationboardMapViewController) {
                    self.stationboardMapViewController.stbSelectedJourneyIndex = index;
                    self.stationboardMapViewController.stbSelectedJourneyProducttype = producttype;
                    [self.stationboardMapViewController updateJourneyMapViewController];
                }
                [self setTopJourneyInfoView];
            }
        }
        
        JourneyHandle *handle = [[SBBAPIController sharedSBBAPIController] getJourneyhandleForStationboardJourney: journey];
        
        NSString *transportOperator = [[SBBAPIController sharedSBBAPIController] getTransportOperatorForJourney: journey];
        
        NSString *time = nil;
        BOOL isDepartureTime = YES;
        if ([[SBBAPIController sharedSBBAPIController] getStationboardJourneyDepartureArrivalForWithStationboardJourney: journey] == stbDepartureType) {
            time = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForStationboardJourney: journey];
            isDepartureTime = YES;
        } else {
            time = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForStationboardJourney: journey];
            isDepartureTime = NO;
        }
        
        NSDate *connectionTime = [self.stationboardSelectionViewControlleriPad getConnectionDate];
        
        BasicStop *mainstop = [[SBBAPIController sharedSBBAPIController] getMainBasicStopForStationboardJourney: journey];
        Station *mainStation = [[SBBAPIController sharedSBBAPIController] getStationForBasicStop: mainstop];
        
        //NSDate *dateNow = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
        NSString *dateString = [dateFormatter stringFromDate: connectionTime];
        
        dateString = [NSString stringWithFormat: @"%@ %@", dateString, time];
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"yyyyMMdd HH:mm"];
        //[timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
        NSDate *journeyDate = [timeFormatter dateFromString: dateString];
        
        #ifdef LOGOUTPUTON
        NSLog(@"Selected journey: %@", mainStation.stationName);
        NSLog(@"Selected journey time: %@", dateString);
        NSLog(@"Selected journey handle: %@, %@, %@", handle.tnr, handle.puic, handle.cycle);
        #endif
        
        //Test
        if (self.stationboardMapViewController) {
            [self.stationboardMapViewController stopAllMapTransactionsAndRemoveOverlayAndAnnotations];
            [self.stationboardMapViewController showLoadingIndicator];
        }
        
        self.topInfoView.alpha = 0.0;
                
        [[SBBAPIController sharedSBBAPIController] sendJourneyReqXMLJourneyRequest:mainStation
                                                                     journeyhandle:handle
                                                                           jrnDate:journeyDate
                                                                     departureTime:isDepartureTime
                                                                      successBlock:^(NSUInteger numberofresults){
                                                                          // test
                                                                          if (self.stationboardMapViewController) {
                                                                              //NSLog(@"Hide map view loading indicator");
                                                                              [self.stationboardMapViewController hideLoadingIndicator];
                                                                          }
                                                                          
                                                                          if (numberofresults > 0) {
                                                                              if (self.stationboardListViewController) {
                                                                                  self.listButton.alpha =  1.0;
                                                                              }
                                                                              //Test
                                                                              
                                                                              Journey *journeydetails = [[SBBAPIController sharedSBBAPIController] getJourneyRequestResult];
                                                                              if (journeydetails && journeydetails.passList) {
                                                                                  journey.passList = [journeydetails.passList copy];
                                                                              }
                                                                              
                                                                              if (journeydetails) {
                                                                                  //NSLog(@"Operator: %@", transportOperator);
                                                                                  journeydetails.journeyOperator = transportOperator;
                                                                              }
                                                                              
                                                                              if (self.stationboardMapViewController) {
                                                                                  self.stationboardMapViewController.stbSelectedJourneyIndex = index;
                                                                                  self.stationboardMapViewController.stbSelectedJourneyProducttype = producttype;
                                                                                  [self.stationboardMapViewController updateJourneyMapViewController];
                                                                              }
                                                                              [self setTopJourneyInfoView];
                                                                              
                                                                          } else {
                                                                              [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqDidNotReturnAnyResultNotice: self.view];
                                                                          }
                                                                      }
                                                                      failureBlock:^(NSUInteger errorcode){
                                                                          // Test
                                                                          if (self.stationboardMapViewController) {
                                                                              [self.stationboardMapViewController hideLoadingIndicator];
                                                                          }
                                                                          
                                                                          //NSUInteger kConReqRequestFailureConnectionFailed = 85;
                                                                          //NSUInteger kConScrRequestFailureConnectionFailed = 45;
                                                                          //NSUInteger kStbReqRequestFailureConnectionFailed = 75;
                                                                          //NSUInteger kStbScrRequestFailureConnectionFailed = 51;
                                                                          //NSUInteger kJrnReqRequestFailureConnectionFailed = 65;
                                                                          //NSUInteger kRssReqRequestFailureConnectionFailed = 95;
                                                                          //NSUInteger kJrnReqRequestFailureCancelled = 6599;
                                                                          
                                                                          //NSUInteger kSbbReqStationsNotDefined = 112;
                                                                          
                                                                          if (errorcode == kJrnReqRequestFailureConnectionFailed) {
                                                                              [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqFailedNotice:self.view];
                                                                          } else if (errorcode == kSbbReqStationsNotDefined) {
                                                                              [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqStationsNotAvailableNotice:self.view];
                                                                          } else if (errorcode == kJrnReqRequestFailureCancelled) {
                                                                              // Nothing to do
                                                                          } else {
                                                                              [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqOtherUndefinedErrorNotice:self.view];
                                                                          }
                                                                          
                                                                      }];

    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"StationboardContainerViewControlleriPad: should autororate");
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	NSLog(@"StationboardContainerViewControlleriPad: willRotateToInterfaceOrientation");
    //[self layoutSubviews:YES toInterfaceOrientation:toInterfaceOrientation];
    //Test
    //[self.stationboardMapViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    //[self.stationboardSelectionViewControlleriPad willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    //[self.stationPickerViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    //[self.stationboardResultContainerViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"StationboardContainerViewControlleriPad: didRotateToInterfaceOrientation");
    //Test
    //[self.stationboardMapViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    //[self.stationboardSelectionViewControlleriPad didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    //[self.stationPickerViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    //[self.stationboardResultContainerViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"StationboardContainerViewControlleriPad: willAnimateRotateToInterfaceOrientation");
    //[self layoutSubviews:YES toInterfaceOrientation:toInterfaceOrientation];
	// Test
    //[self.stationboardMapViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration: duration];
    //[self.stationboardSelectionViewControlleriPad willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration: duration];
    //[self.stationPickerViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration: duration];
    //[self.stationboardResultContainerViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration: duration];
}

- (void) viewWillAppear:(BOOL)animated {
    //NSLog(@"StationboardContainerViewControlleriPad: viewwillappear");
	[super viewWillAppear:animated];
	//Test
    //[self.stationboardMapViewController viewWillAppear:animated];
    [self.stationboardSelectionViewControlleriPad viewWillAppear:animated];
    //[self.stationPickerViewController viewWillAppear:animated];
    [self.stationboardResultContainerViewController viewWillAppear:animated];
    
    if (self.navBarVisible) {
        if (self.navSC) {
            self.navSC.alpha = 1.0;
        }
    }
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
}

- (void) viewDidAppear:(BOOL)animated {
    //NSLog(@"StationboardContainerViewControlleriPad: viewdidappear");
	[super viewDidAppear:animated];
    //[self layoutSubviews: NO toInterfaceOrientation: [[UIDevice currentDevice] orientation]];
	//Test
    //[self.stationboardMapViewController viewDidAppear:animated];
    [self.stationboardSelectionViewControlleriPad viewDidAppear:animated];
    //[self.stationPickerViewController viewDidAppear:animated];
    [self.stationboardResultContainerViewController viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    //NSLog(@"StationboardContainerViewControlleriPad: viewwilldisappear");
	[super viewWillDisappear:animated];
	// Test
    //[self.stationboardMapViewController viewWillDisappear:animated];
    [self.stationboardSelectionViewControlleriPad viewWillDisappear:animated];
    //[self.stationPickerViewController viewWillDisappear:animated];
    [self.stationboardResultContainerViewController viewWillDisappear:animated];
    
    if (self.navSC) {
        self.navSC.alpha = 0.0;
    }

}

- (void)viewDidDisappear:(BOOL)animated {
    //NSLog(@"StationboardContainerViewControlleriPad: viewdiddisappear");
	[super viewDidDisappear:animated];
	// Test
    //[self.stationboardMapViewController viewDidDisappear:animated];
    [self.stationboardSelectionViewControlleriPad viewDidDisappear:animated];
    //[self.stationPickerViewController viewDidDisappear:animated];
    [self.stationboardResultContainerViewController viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"StationboardContainerViewController: did receive memory warning.");
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
    NSLog(@"Stationboard Container controller selected from tabbar");
    #endif
}

@end
