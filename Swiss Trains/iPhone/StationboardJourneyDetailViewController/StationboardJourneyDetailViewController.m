//
//  StationboardJourneyDetailViewController.m
//  Swiss Trains
//
//  Created by Alain on 18.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "StationboardJourneyDetailViewController.h"

#define BUTTONHEIGHT 36.0
#define SEGMENTHEIGHT 18.0


enum connectionJourneyDetailViewType {
 mapViewType = 1,
 listViewType = 2
};
 

@interface StationboardJourneyDetailViewController ()

@end

@implementation StationboardJourneyDetailViewController

- (id)initWithFrame:(CGRect)viewFrame
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.view.frame = viewFrame;
        
        self.trainlinebuttonvisible = NO;
        
        //self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        self.view.backgroundColor = [UIColor listviewControllersBackgroundColor];
        
        /*
         self.detailViewTableView = [[UITableView alloc] initWithFrame: self.view.bounds style:UITableViewStylePlain];
         self.detailViewTableView.rowHeight = 142;
         //self.detailViewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
         self.detailViewTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
         self.detailViewTableView.separatorColor = [UIColor lightGrayColor];
         self.detailViewTableView.backgroundColor = [UIColor detailTableviewBackgroundColor];
         //self.detailViewTableView.backgroundColor = [UIColor darkGrayColor];
         [self.detailViewTableView registerClass:[ConnectionsDetailviewCell class] forCellReuseIdentifier: @"ConnectionsDetailviewCell"];
         [self.view addSubview: self.detailViewTableView];
         self.detailViewTableView.dataSource = self;
         self.detailViewTableView.delegate = self;
         
         self.view.clipsToBounds = NO;
         self.view.layer.masksToBounds = NO;
         self.view.layer.shadowColor = [UIColor blackColor].CGColor;
         self.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
         self.view.layer.shadowOpacity = 1.0f;
         self.view.layer.shadowRadius = 2.5f;
         self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
         */
    }
    return self;
}

- (void) loadView {
    CGSize size = [UIApplication currentScreenSize];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = view;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //float padding = -25;
        
        //self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        self.view.backgroundColor = [UIColor listviewControllersBackgroundColor];
        
        self.stationsViewToolbar = [[StationsViewToolbar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        self.journeyDetailTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, TOOLBARHEIGHT, self.view.frame.size.width, self.view.frame.size.height - TOOLBARHEIGHT + 1) style:UITableViewStylePlain];
        //self.listTableView.rowHeight = 50;
        //self.detailViewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.journeyDetailTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.journeyDetailTableView.separatorColor = [UIColor lightGrayColor];
        //self.journeyDetailTableView.backgroundColor = [UIColor detailTableviewBackgroundColor];
        self.journeyDetailTableView.backgroundColor = [UIColor listviewControllersBackgroundColor];
        //self.detailViewTableView.backgroundColor = [UIColor darkGrayColor];
        [self.journeyDetailTableView registerClass:[ConnectionsJourneyDetailPasslistCell class] forCellReuseIdentifier: @"ConnectionsJourneyDetailPasslistCell"];
        [self.view addSubview: self.journeyDetailTableView];
        self.journeyDetailTableView.dataSource = self;
        self.journeyDetailTableView.delegate = self;
        
        UIView *dummyFooterView =  [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 1)];
        self.journeyDetailTableView.tableFooterView = dummyFooterView;
        dummyFooterView.hidden = YES;
        
        self.mapView = [[MTDMapView alloc] initWithFrame: CGRectMake(0, TOOLBARHEIGHT, self.view.frame.size.width, self.view.frame.size.height - TOOLBARHEIGHT)];
        [self.view addSubview: self.mapView];
        //CLLocationCoordinate2D zoomLocation;
        //zoomLocation.latitude = 40.7310;
        //zoomLocation.longitude= -73.9977;
        //MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 10000, 10000);
        //[self.mapView setRegion:viewRegion animated:NO];
        self.mapView.delegate = self;
        self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(46.897739, 8.426514),
                                                     MKCoordinateSpanMake(4.026846,4.032959));
        self.mapView.alpha = 0.0;
        self.connectionJourneyDetailViewTypeSelected = listViewType;
        
        [self.view addSubview: self.stationsViewToolbar];
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //UIImage *backButtonImage = [UIImage newImageFromMaskImage: [UIImage backButtonImage] inColor: [UIColor selectStationsViewButtonColorNormal]];
        //UIImage *backButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage backButtonImage] inColor: [UIColor selectStationsViewButtonColorHighlighted]];
        UIImage *backButtonImage =  [UIImage newImageFromMaskImage: [[UIImage backButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
        UIImage *backButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage backButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
        [self.backButton setImage: backButtonImage forState: UIControlStateNormal];
        [self.backButton setImage: backButtonImageHighlighted forState: UIControlStateHighlighted];
        self.backButton.imageView.contentMode = UIViewContentModeCenter;
        self.backButton.frame = CGRectMake(5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
        self.backButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.backButton.showsTouchWhenHighlighted = YES;
        [self.backButton addTarget: self action: @selector(pushBackController:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: self.backButton];
        
        //CGFloat scaleFactorTrainlineButton = 1.0;
        self.trainlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *trainlineButtonImage =  [UIImage renderCircleButtonImage: [UIImage trainlineNormalButtonImage] backgroundColor:[UIColor detailTableViewCellJourneyInfoImageBackgroundColor] imageColor:[UIColor detailTableViewCellJourneyInfoImageColor]];
        UIImage *trainlineButtonImageHighlighted =  [UIImage renderCircleButtonImage: [UIImage trainlineNormalButtonImage] backgroundColor:[UIColor detailTableViewCellJourneyInfoImageBackgroundColor] imageColor:[UIColor detailTableViewCellJourneyInfoImageColor]];
        UIImage *trainlineButtonImageSelected =  [UIImage renderCircleButtonImage: [UIImage trainlineDetailedButtonImage] backgroundColor:[UIColor detailTableViewCellJourneyInfoImageBackgroundColor] imageColor:[UIColor detailTableViewCellJourneyInfoImageColor]];
        [self.trainlineButton setImage: trainlineButtonImage forState: UIControlStateNormal];
        [self.trainlineButton setImage: trainlineButtonImageHighlighted forState: UIControlStateHighlighted];
        [self.trainlineButton setImage: trainlineButtonImageSelected forState: UIControlStateSelected];
        //self.trainlineButton.imageView.contentMode = UIViewContentModeCenter;
        //self.trainlineButton.frame = CGRectMake(320 - BUTTONHEIGHT - 15, CONJRNBOTTOMINFOBARHEIGHT + 15, BUTTONHEIGHT, BUTTONHEIGHT);
        self.trainlineButton.frame = CGRectMake(320 - BUTTONHEIGHT - 8, self.view.frame.size.height - BUTTONHEIGHT - 8, BUTTONHEIGHT, BUTTONHEIGHT);
        self.trainlineButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.trainlineButton.showsTouchWhenHighlighted = YES;
        [self.trainlineButton addTarget: self action: @selector(switchtrainlinemode:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: self.trainlineButton];
        self.trainlineButton.alpha = 0.0;
    
        self.transportNameImageView = [[UIImageView alloc] initWithFrame: CGRectMake(5 + BUTTONHEIGHT + 12, 8, 80, 20)];
        self.transportNameImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview: self.transportNameImageView];
        
        /*
        self.startStationLabel = [[UILabel alloc] initWithFrame: CGRectMake(5 + BUTTONHEIGHT + 10 + 80 + 10, 9, self.view.frame.size.width - 5 - BUTTONHEIGHT -5  - 80 - 5 - 5 - 10, BUTTONHEIGHT / 2)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.startStationLabel.font = [UIFont boldSystemFontOfSize: 14.0];
        self.startStationLabel.textColor = [UIColor selectStationsViewButtonColorNormal];
        self.startStationLabel.backgroundColor = [UIColor clearColor];
        self.startStationLabel.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview: self.startStationLabel];
        */
        
        self.navSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"", @"", nil]];
        //navSC.height = BUTTONHEIGHT;
        //CGRect navFrame = navSC.frame;
        //CGRect newNavFrame = CGRectMake(self.view.frame.size.width - navFrame.size.width * 2, 0, navFrame.size.width, navFrame.size.width);
        //navSC.frame = newNavFrame;
        CGFloat scaleFactor = 1.5;
        UIImage *listImage =  [[UIImage listButtonImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactor, SEGMENTHEIGHT * scaleFactor) interpolationQuality: kCGInterpolationDefault];
        UIImage *mapImage = [[UIImage mapButtonImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactor, SEGMENTHEIGHT * scaleFactor) interpolationQuality: kCGInterpolationDefault];
        self.navSC.sectionImages = [NSArray arrayWithObjects: listImage, mapImage, nil];
        //navSC.sectionTitles = nil;
        __weak StationboardJourneyDetailViewController *weakself = self;
        self.navSC.changeHandler = ^(NSUInteger newIndex) {
            //NSLog(@"segmentedControl did select index %i (via block handler)", newIndex);
            if (newIndex == 0) {
                [weakself switchToListViewAsConnectionJourneyDetailView];
            } else {
                [weakself switchToMapViewAsConnectionJourneyDetailView];
            }
        };
        //self.listButton.frame = CGRectMake(self.view.frame.size.width - 5 - BUTTONHEIGHT * 2 - 5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
        self.navSC.center = CGPointMake(self.view.frame.size.width - 5 - BUTTONHEIGHT * 2 - 5 + 20, TOOLBARHEIGHT / 2 + 1);
        
        [self.view addSubview: self.navSC];
        [self.navSC setSelectedIndex: 0];
        
        self.notificationView = [[GCDiscreetNotificationView alloc] initWithText:NSLocalizedString(@"Loading walking directions...", @"Loading walking directions notification view title")
                                                                    showActivity:YES
                                                              inPresentationMode:GCDiscreetNotificationViewPresentationModeBottom
                                                                          inView:self.mapView];
        
        self.notificationView.frame = CGRectMake(self.view.frame.size.width / 2 - 220 / 2, self.view.frame.size.height, 220, 15);
    }
    return self;
}

- (void) switchToMapViewAsConnectionJourneyDetailView {
    #ifdef LOGOUTPUTON
    NSLog(@"Journey detail: switch to map view");
    #endif
        
    if (self.trainlinebuttonvisible) {
        self.trainlineButton.alpha = 1.0;
    }
    
    self.journeyDetailTableView.alpha = 0.0;
    self.connectionJourneyDetailViewTypeSelected = mapViewType;

    [UIView animateWithDuration: 0.3 animations: ^{
        self.mapView.alpha = 1.0;
    }];
    
}
- (void) switchToListViewAsConnectionJourneyDetailView {
    #ifdef LOGOUTPUTON
    NSLog(@"Journey detail: switch to list view");
    #endif
    
    self.trainlineButton.alpha = 0.0;
        
    self.mapView.alpha = 0.0;
    self.connectionJourneyDetailViewTypeSelected = listViewType;

    [self.journeyDetailTableView reloadData];
    [UIView animateWithDuration: 0.3 animations: ^{
        self.journeyDetailTableView.alpha = 1.0;
    }];
}

- (void) setDetailedRouteDetaillevelForTrainlines:(NSUInteger)detaillevel {
    if (detaillevel <= 4) {
        self.detaillevelForTrainlinesForDetailedRoutes = detaillevel;
    }
}

- (void)showTrainlineButton {
    #ifdef LOGOUTPUTON
    NSLog(@"Show train line button");
    #endif

    if (self.trainlinebuttonvisible &&  self.connectionJourneyDetailViewTypeSelected == mapViewType) {
        self.trainlineButton.selected = NO;
        self.trainlineButton.alpha = 1.0;
    } else if (self.trainlinebuttonvisible) {
        self.trainlineButton.selected = NO;
    }
}

- (void)hideTrainlineButton {
    self.trainlinebuttonvisible = NO;
    self.trainlineButton.alpha = 0.0;
    self.trainlineButton.selected = NO;
}

- (void) switchtrainlinemode:(id)sender {
    if (!self.trainlineButton.selected) {
        [self switchToNormalTrainline:YES];
        self.trainlineButton.selected = YES;
    } else {
        [self switchToNormalTrainline:NO];
        self.trainlineButton.selected = NO;
    }
}

- (void) switchToNormalTrainline:(BOOL)normalline {
    
    if (normalline) {
        MTDDirectionsSetActiveAPI(MTDDirectionsAPICustom);
        MTDDirectionsAPIRegisterCustomParserClass([MTDJourneyParser class]);
        MTDDirectionsAPIRegisterCustomRequestClass([MTDJourneyRequest class]);
        
        [self.mapView removeDirectionsOverlay];
        
        Journey *journey = [[SBBAPIController sharedSBBAPIController] journeyResult];
        
        MTDDirectionsSetActiveAPI(MTDDirectionsAPICustom);
        
        MTDOverrideClass([MTDDirectionsOverlayView class], [MTDJourneyOverlayView class]);
        
        [self.mapView removeDirectionsOverlay];
        
        //[self showLoadingIndicator];
        
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            
            MTDRoute *route = [[SBBAPIController sharedSBBAPIController] getMTDRouteForJourney: journey];
            
            NSArray *routesArray = [NSArray arrayWithObject: route];
            
            [self.mapView loadRoutes: routesArray zoomToShowDirections: YES];
            
        });
        
    } else {
        self.detaillevelForTrainlinesForDetailedRoutes = 2;
        
        MTDDirectionsSetActiveAPI(MTDDirectionsAPICustom);
        MTDDirectionsAPIRegisterCustomParserClass([MTDJourneyParser class]);
        MTDDirectionsAPIRegisterCustomRequestClass([MTDJourneyRequest class]);
        
        [self.mapView removeDirectionsOverlay];
        
        MTDDirectionsSetActiveAPI(MTDDirectionsAPICustom);
        
        MTDOverrideClass([MTDDirectionsOverlayView class], [MTDJourneyOverlayView class]);
        
        [self.mapView removeDirectionsOverlay];
        
        //[self showLoadingIndicator];
        
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            
            Journey *selectedjourney = [[SBBAPIController sharedSBBAPIController] getJourneyForStationboardResultFWithProductTypeWithIndex: self.stbSelectedJourneyProducttype index: self.selectedStationboardJourney];
            
            if (selectedjourney && selectedjourney.routes && selectedjourney.routes.count > 0) {
                [self.mapView loadRoutes: selectedjourney.routes zoomToShowDirections: YES];
                return;
            }
            
        });
    }
}

- (void) loadMapviewDirections {
    
    self.detaillevelForTrainlinesForDetailedRoutes = 2;
    
#ifdef IncludeDetailedTrainlinesiPhone
    [[TrainLinesController sharedTrainLinesController] cancelStbReqTrainlineOperations];
#endif
    
    MTDDirectionsSetActiveAPI(MTDDirectionsAPICustom);
    MTDDirectionsAPIRegisterCustomParserClass([MTDJourneyParser class]);
    MTDDirectionsAPIRegisterCustomRequestClass([MTDJourneyRequest class]);
    
    [self.mapView removeDirectionsOverlay];
    
    Journey *journey = [[SBBAPIController sharedSBBAPIController] journeyResult];
    
    #ifdef LOGOUTPUTON
    NSLog(@"Journey detail: load map view directions. Is journey type.");
    #endif
    
    MTDDirectionsSetActiveAPI(MTDDirectionsAPICustom);
    
    MTDOverrideClass([MTDDirectionsOverlayView class], [MTDJourneyOverlayView class]);
    
    [self.mapView removeDirectionsOverlay];
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        
        MTDRoute *route = [[SBBAPIController sharedSBBAPIController] getMTDRouteForJourney: journey];
        
        if (!route) return;
        
        NSArray *routesArray = [NSArray arrayWithObject: route];
        
        [self.mapView loadRoutes: routesArray zoomToShowDirections: YES];
        
#ifdef IncludeDetailedTrainlinesiPhone
        
        Journey *selectedjourney = [[SBBAPIController sharedSBBAPIController] getJourneyForStationboardResultFWithProductTypeWithIndex: self.stbSelectedJourneyProducttype index: self.selectedStationboardJourney];
        
        if (selectedjourney && selectedjourney.routes && selectedjourney.routes.count > 0) {
            [self.mapView loadRoutes: selectedjourney.routes zoomToShowDirections: YES];
            
            self.trainlinebuttonvisible = YES;
            [self showTrainlineButton];
            
            return;
        }
        
        //[self showLoadingIndicator];
        
        [[TrainLinesController sharedTrainLinesController] cancelStbReqTrainlineOperations];
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSString *trainlinedetailsenabledstring = [defaults objectForKey: @"trainlineSwitch"];
        BOOL trainlinedetailsenabled = [defaults boolForKey: @"trainlineSwitch"];
        if (!trainlinedetailsenabledstring) {
            trainlinedetailsenabled = YES;
        }
        if (!trainlinedetailsenabled) {
            return;
        }
        NSString *trainlinedetaillevelstring = [defaults objectForKey: @"trainlinedetailvalues"];
        NSUInteger trainlinedetaillevel = [defaults integerForKey: @"trainlinedetailvalues"];
        if (!trainlinedetaillevelstring) {
            trainlinedetaillevel = 2;
        }
        [[TrainLinesController sharedTrainLinesController] setRouteleadsawaysfromdestinationtolerancelevel: trainlinedetaillevel];
        
        [[TrainLinesController sharedTrainLinesController] sendStbReqTrainlineDetailsRequest:journey detaillevel: self.detaillevelForTrainlinesForDetailedRoutes stationboardresults:nil successBlock:^(NSArray *routes){
            
            [self hideLoadingIndicator];
            
            if (routes && routes.count > 0) {
                
                if (selectedjourney && journey) {
                    //NSLog(@"Names: '%@', '%@'", [selectedjourney journeyName], [journey journeyName]);
                    if ([[selectedjourney journeyName] isEqualToString: [journey journeyName]]) {
                        //NSLog(@"Settings journey route found from result");
                        selectedjourney.routes = [journey.routes copy];
                    }
                }

                self.trainlinebuttonvisible = YES;
                [self showTrainlineButton];
                
                [self.mapView loadRoutes: routes zoomToShowDirections: NO];
            }

            
        } failureBlock:^(NSUInteger errorcode) {
            //#ifdef LOGOUTPUTON
            //NSLog(@"Detailed trainline for journey result failed %d, %d", self.connectionIndex, self.consectionIndex);
            //#endif
            
            [self hideLoadingIndicator];
            
        } routesavailableandprocessingblock:^(Journey *journey, BOOL detailsavailable) {
            [self showLoadingIndicatorForTrainlines];
        }];
        
#endif
    });
}

- (void)hideLoadingIndicator {
    
    //[MBProgressHUD hideAllHUDsForView: self.view animated: NO];
    /*
     [self.activityView removeFromSuperview];
     self.activityView = nil;
     */
    
    [UIView animateWithDuration: 0.3 animations: ^{
        CGRect viewframe = self.notificationView.frame;
        viewframe.origin.y = self.view.frame.size.height;
        self.notificationView.frame = viewframe;
        
    }];
    
    [self.notificationView.activityIndicator stopAnimating];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)showLoadingIndicatorForTrainlines {
    
    [self.notificationView setTextLabel: NSLocalizedString(@"Loading trainline ...", @"Loading trainline notification view title")];
    [self.notificationView setUserInteractionEnabled: NO];
    
    CGFloat viewadjustment = 0;
    
    self.notificationView.frame = CGRectMake(self.view.frame.size.width / 2 - 220 / 2, self.view.frame.size.height, 220, 15);
    
    [self.notificationView.activityIndicator startAnimating];
    [UIView animateWithDuration: 0.3 animations: ^{
        CGRect viewframe = self.notificationView.frame;
        viewframe.origin.y = self.view.frame.size.height - CONJRNBOTTOMINFOBARHEIGHT - 22 - viewadjustment;
        self.notificationView.frame = viewframe;
        
    }];
    
    //[self.notificationView setOrigin: self.view.frame];
    //[self.notificationView show:YES];
    
    /*
     [self hideLoadingIndicator];
     
     [MBProgressHUD hideAllHUDsForView: self.view animated: NO];
     
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     hud.removeFromSuperViewOnHide = YES;
     hud.userInteractionEnabled = NO;
     */
    
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[SBBAPIController sharedSBBAPIController] journeyResult]) {
        Journey *journey = [[SBBAPIController sharedSBBAPIController] journeyResult];
        NSArray *basicstopList = [[SBBAPIController sharedSBBAPIController] getBasicStopsForStationboardJourneyRequestResult: journey];
        //NSLog(@"Journey detail view. Jounrey. %d", [basicstopList count]);
        return [basicstopList count];
    }
    return  0;
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

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    ConnectionsJourneyDetailPasslistCell *passlistcell = (ConnectionsJourneyDetailPasslistCell *)cell;

    Journey *journey = [[SBBAPIController sharedSBBAPIController] journeyResult];
    NSArray *basicStopList = [[SBBAPIController sharedSBBAPIController] getBasicStopsForStationboardJourneyRequestResult: journey];
    
    NSString *stationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
    NSString *arrivalTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
    NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
    NSString *platform = [[SBBAPIController sharedSBBAPIController] getPlatformForBasicStop: [basicStopList objectAtIndex: indexPath.row]];
        
    //passlistcell.stationNameLabel.text = [self shortenStationNameIfTooLong:stationName maxLenth: 22];
    passlistcell.arrivalTimeLabel.text = arrivalTime;
    passlistcell.departureTimeLabel.text = departureTime;
    
    if (platform && ([platform length] > 0)) {
        [passlistcell shortenStationNameLabelIfTrackInfo];
        passlistcell.stationNameLabel.text = [self shortenStationNameIfTooLong: stationName maxLenth: 28];
    } else {
        [passlistcell prolongStationNameLabelIfNoTrackInfo];
        passlistcell.stationNameLabel.text = [self shortenStationNameIfTooLong: stationName maxLenth: 30];
    }
    
    passlistcell.trackLabel.text = platform;
    
    //NSString *arrTime4 = [arrivalTime substringToIndex: 1];
    //NSString *depTime4 = [departureTime substringToIndex: 1];
    //NSLog(@"arr, dep 4: %@, %@", arrTime4, depTime4);
    
    if ((indexPath.row == 0) && !(indexPath.row == ([basicStopList count] - 1))) {
        passlistcell.oneTimeLabel.text = departureTime;
        passlistcell.arrivalTimeLabel.text = nil;
        passlistcell.departureTimeLabel.text = nil;
    } else if (!(indexPath.row == 0) && indexPath.row == ([basicStopList count] - 1)) {
        passlistcell.oneTimeLabel.text = arrivalTime;
        passlistcell.arrivalTimeLabel.text = nil;
        passlistcell.departureTimeLabel.text = nil;
    } else {
        if (!arrivalTime && departureTime) {
            passlistcell.oneTimeLabel.text = departureTime;
            passlistcell.arrivalTimeLabel.text = nil;
            passlistcell.departureTimeLabel.text = nil;
        } else if (arrivalTime && !departureTime) {
            passlistcell.oneTimeLabel.text = arrivalTime;
            passlistcell.arrivalTimeLabel.text = nil;
            passlistcell.departureTimeLabel.text = nil;
        } else if (!arrivalTime && !departureTime) {
            passlistcell.oneTimeLabel.text = nil;
            passlistcell.arrivalTimeLabel.text = nil;
            passlistcell.departureTimeLabel.text = nil;
        } else if (arrivalTime && departureTime) {
            if ([arrivalTime isEqualToString:departureTime]) {
                passlistcell.oneTimeLabel.text = departureTime;
                passlistcell.arrivalTimeLabel.text = nil;
                passlistcell.departureTimeLabel.text = nil;
            } else {
                passlistcell.oneTimeLabel.text = nil;
                passlistcell.arrivalTimeLabel.text = arrivalTime;
                passlistcell.departureTimeLabel.text = departureTime;
            }
        }
    }
    
    BOOL topLine = NO; BOOL bottomLine = NO;
    
    if ((indexPath.row == 0) && !(indexPath.row == ([basicStopList count] - 1))) {
        topLine = NO; bottomLine = YES;
    } else if (!(indexPath.row == 0) && indexPath.row == ([basicStopList count] - 1)) {
        topLine = YES; bottomLine = NO;
    } else if ((indexPath.row == 0) && (indexPath.row == ([basicStopList count] - 1))) {
        topLine = NO; bottomLine = NO;
    } else {
        topLine = YES; bottomLine = YES;
    }
    
    UIImage *passlistImage = [[SBBAPIController sharedSBBAPIController] renderPasslistImageWithSize:CGSizeMake(30, 50)  topLine: topLine bottomLine: bottomLine];
    [passlistcell.passlistImage setImage: passlistImage];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConnectionsJourneyDetailPasslistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConnectionsJourneyDetailPasslistCell"];
    [self configureCell: cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
}

// override to support editing the table view
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return  NO;
}

- (void) updateJourneyTableViewWithStationboardIndex:(NSUInteger)index {
    
    [self hideTrainlineButton];
    
    self.selectedStationboardJourney = index;
    [self.journeyDetailTableView reloadData];
    [self.journeyDetailTableView setContentOffset:CGPointZero animated:NO];
    
    if ([[SBBAPIController sharedSBBAPIController] journeyResult]) {
        Journey *journey = [[SBBAPIController sharedSBBAPIController] journeyResult];
        NSArray *basicStopList = [[SBBAPIController sharedSBBAPIController] getBasicStopsForStationboardJourneyRequestResult: journey];
        if (basicStopList && (basicStopList.count > 0)) {
            NSString *stationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList objectAtIndex: 0]];
            self.startStationLabel.text = [self shortenStationNameIfTooLong: stationName maxLenth: 22];
        }
        
        UIImage *transportNameImage = [[SBBAPIController sharedSBBAPIController] renderTransportNameImageForStationboardJourney: journey];
        [self.transportNameImageView setImage: transportNameImage];
        
        [self loadMapviewDirections];
    }

    //[UIView beginAnimations: @"Showdetailtableview" context: NULL];
    //[UIView animateWithDuration: 0.3 animations: ^{ self.detailViewTableView.alpha = 1.0;}];
    //self.detailViewTableView.alpha = 1.0;
    //[UIView commitAnimations];
    //[self performSelector: @selector(reloadAndUpdateTableView) withObject: nil afterDelay: 0.4];
    
}

////////////////////////////////////////////////////////////////////////
#pragma mark - MTDDirectionsDelegate
////////////////////////////////////////////////////////////////////////

- (void)mapView:(MTDMapView *)mapView willStartLoadingRoutes:(NSArray *)routes {
    
}

- (void)mapView:(MTDMapView *)mapView willStartLoadingDirectionsFrom:(MTDWaypoint *)from to:(MTDWaypoint *)to routeType:(MTDDirectionsRouteType)routeType {
    /*
    NSLog(@"MapView %@ willStartLoadingDirectionsFrom:%@ to:%@ routeType:%d",
          mapView,
          from,
          to,
          routeType);
    */
    //[self showLoadingIndicator];
}

- (MTDDirectionsOverlay *)mapView:(MTDMapView *)mapView didFinishLoadingDirectionsOverlay:(MTDDirectionsOverlay *)directionsOverlay {
    
#ifdef LOGOUTPUTON
    NSLog(@"MapView %@ didFinishLoadingDirectionsOverlay: %@ (fromAddress:%@, toAddress:%@)",
          mapView, directionsOverlay, directionsOverlay.fromAddress, directionsOverlay.toAddress);
#endif
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    NSArray *routesArray;
    NSArray *basicStopList;
    
    
    Journey *journey = [[SBBAPIController sharedSBBAPIController] journeyResult];
    MTDRoute *route = [[SBBAPIController sharedSBBAPIController] getMTDRouteForJourney: journey];
    routesArray = [NSArray arrayWithObject: route];
    basicStopList = [[SBBAPIController sharedSBBAPIController] getBasicStopsForStationboardJourneyRequestResult: journey];
    
    if (routesArray && basicStopList && routesArray.count > 0 && basicStopList.count >= 2) {
        MTDRoute *firstRoute = [routesArray objectAtIndex: 0];
        MTDRoute *lastRoute = [routesArray lastObject];
        
        self.fromAnnotation = [[StationAnnotation alloc] initWithCoordinate: firstRoute.from.coordinate];
        self.toAnnotation = [[StationAnnotation alloc] initWithCoordinate: lastRoute.to.coordinate];
        
        self.fromAnnotation.title = firstRoute.from.name;
        self.fromAnnotation.subtitle = firstRoute.from.departuretime;
        
        self.toAnnotation.title = lastRoute.to.name;
        self.toAnnotation.subtitle = lastRoute.to.arrivaltime;
        
        [self.mapView addAnnotation:self.fromAnnotation];
        [self.mapView addAnnotation:self.toAnnotation];
        
        if (basicStopList.count >= 3) {
            for (int i = 1; i < [basicStopList count] - 1; i++) {
                
                Station *currentStation = [[SBBAPIController sharedSBBAPIController] getStationForBasicStop: [basicStopList objectAtIndex: i]];
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([currentStation.latitude doubleValue], [currentStation.longitude doubleValue]);
                
                StationAnnotation *annotation = [[StationAnnotation alloc] initWithCoordinate:coordinate];
                
                NSString *stationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: [basicStopList objectAtIndex: i]];
                NSString *arrivalTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForBasicStop: [basicStopList objectAtIndex: i]];
                NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForBasicStop: [basicStopList objectAtIndex: i]];
                
                annotation.title = stationName;
                
                if (departureTime && arrivalTime) {
                    annotation.subtitle = [NSString stringWithFormat:@"%@ / %@", arrivalTime, departureTime];
                }
                
                [self.mapView addAnnotation:annotation];
                
                
            }
        }
    }
    
    //[self hideLoadingIndicator];
    
    return directionsOverlay;
}

- (void)mapView:(MTDMapView *)mapView didFailLoadingDirectionsOverlayWithError:(NSError *)error {
    //NSLog(@"MapView %@ didFailLoadingDirectionsOverlayWithError: %@", mapView, error);
    
    //[self setDirectionsInfoText:[error.userInfo objectForKey:MTDDirectionsKitErrorMessageKey]];
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.fromAnnotation = nil;
    self.toAnnotation = nil;
    
    //[self hideLoadingIndicator];
    
}

- (void)mapView:(MTDMapView *)mapView didActivateRoute:(MTDRoute *)route ofDirectionsOverlay:(MTDDirectionsOverlay *)directionsOverlay {
    //[self setDirectionsInfoFromRoute:route];
    //NSLog(@"User taped on route: %@", [[directionsOverlay activeRoute] description]);
}

- (UIColor *)mapView:(MTDMapView *)mapView colorForDirectionsOverlay:(MTDDirectionsOverlay *)directionsOverlay {
    //NSLog(@"MapView %@ colorForDirectionsOverlay: %@", mapView, directionsOverlay);
    
    return [UIColor detailTableViewCellJourneyLineColor];
    return [UIColor darkGrayColor];
}

- (CGFloat)mapView:(MTDMapView *)mapView lineWidthFactorForDirectionsOverlay:(MTDDirectionsOverlay *)directionsOverlay {
    
    return 1.0f;
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //NSLog(@"Region did change.");
    
    //NSLog(@"Region did change. Map. Execute table list reload with delay");
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    //NSLog(@"Region will change.");
}

////////////////////////////////////////////////////////////////////////
#pragma mark - MKMapViewDelegate
////////////////////////////////////////////////////////////////////////


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    //NSLog(@"mapView:%@ viewForAnnotation:%@", mapView, annotation);
    
    static NSString *const kAnnotationIdentifier = @"StationAnnotation";
    StationsAnnotationView *annotationView = (StationsAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kAnnotationIdentifier];
    if (! annotationView) {
        annotationView = [[StationsAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kAnnotationIdentifier];
    }
    
    annotationView.canShowCallout = YES;
    
    if (annotation == self.fromAnnotation) {
        annotationView.annotationType = startStation;
    } else if (annotation == self.toAnnotation) {
        annotationView.annotationType = endStation;
    } else {
        annotationView.annotationType = middleStation;
    }
    [annotationView setAnnotationImageForType: annotationView.annotationType];
    
    //[annotationView setNeedsDisplay];
    
    [annotationView setAnnotation:annotation];
    
    return annotationView;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    self.mapView.delegate = nil;
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.mapView.delegate = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) pushBackController:(id)sender {
    
#ifdef IncludeDetailedTrainlinesiPhone
    [[TrainLinesController sharedTrainLinesController] cancelStbReqTrainlineOperations];
#endif

    [self hideTrainlineButton];
    
    [self.mapView cancelLoadOfDirections];
    [self.mapView removeDirectionsOverlay];
    [self.mapView removeAnnotations: self.mapView.annotations];
    [self.navigationController popViewControllerAnimated: YES];
}

-(void) forcePushBackToPreviousViewController {
    
#ifdef IncludeDetailedTrainlinesiPhone
    [[TrainLinesController sharedTrainLinesController] cancelStbReqTrainlineOperations];
#endif
    
    [self hideTrainlineButton];
    
    #ifdef LOGOUTPUTON
    NSLog(@"StationboardJourneyDetailViewController force push back");
    #endif
    
    [self.mapView cancelLoadOfDirections];
    [self.mapView removeDirectionsOverlay];
    [self.mapView removeAnnotations: self.mapView.annotations];
    [self.navigationController popViewControllerAnimated: NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
