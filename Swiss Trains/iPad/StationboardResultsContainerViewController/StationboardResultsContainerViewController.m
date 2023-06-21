//
//  StationboardConnectionsViewController.m
//  Swiss Trains
//
//  Created by Alain on 18.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "StationboardResultsContainerViewController.h"

#define BUTTONHEIGHT 36.0
#define SEGMENTHEIGHT 18.0

@interface StationboardResultsContainerViewController ()

@end

@implementation StationboardResultsContainerViewController

- (id)initWithFrame:(CGRect)viewFrame
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.view.frame = viewFrame;
        
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
    
    //NSLog(@"StationboardResultContainerViewController. Screen size: %.1f, %.1f", size.width, size.height);
    
    CGFloat viewHeight = size.height - TABBARHEIGHT - TOOLBARHEIGHTIPAD;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH, viewHeight)];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = view;
    
    //NSLog(@"StationboardResultContainer view init: %.1f, %.1f, %.1f, %.1f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
}


- (id)init
{
    self = [super init];
    if (self) {
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        //self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        self.view.backgroundColor = [UIColor listviewControllersBackgroundColor];
    }
    return self;
}

- (void) layoutSubviewsWithAnimated:(BOOL)animated beforeRotation:(BOOL)beforeRotation interfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //NSLog(@"StationboardResultsContainerViewControlleriPad layoutSubviews");
	
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
    
    //NSLog(@"StationboardResultsContainerViewControlleriPad layoutSubviews. Check point 1");
    newSize.width = size.width;
    newSize.height = size.height;
    
    if (animated) {
        [UIView beginAnimations:@"StationboardResultsContainerViewControlleriPad LayoutSubviewWithAnimation" context:NULL];
    }
    
    //NSLog(@"StationboardResultsContainerViewControlleriPad layoutSubviews. Check point 2");
    
    self.connectionsTableView.frame = CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH, newSize.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT);
    
    //NSLog(@"StationboardResultsContainerViewControlleriPad layoutSubviews. Check point 3");
    
    if (animated) {
        [UIView commitAnimations];
    }
    //NSLog(@"StationboardResultsContainerViewControlleriPad layoutSubviews. Check point 4");
}

- (void) layoutSubviews:(BOOL)beforeRotation toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    [self layoutSubviewsWithAnimated:NO beforeRotation: beforeRotation interfaceOrientation: toInterfaceOrientation];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
            }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
    self.view.backgroundColor = [UIColor listviewControllersBackgroundColor];
    
    self.connectionsTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    //self.listTableView.rowHeight = 50;
    //self.detailViewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.connectionsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.connectionsTableView.separatorColor = [UIColor lightGrayColor];
    
    //self.connectionsTableView.backgroundColor = [UIColor detailTableviewBackgroundColor];
    self.connectionsTableView.backgroundColor = [UIColor listviewControllersBackgroundColor];
    
    //self.detailViewTableView.backgroundColor = [UIColor darkGrayColor];
    [self.connectionsTableView registerClass:[StationboardTableViewCell class] forCellReuseIdentifier: @"StationboardTableViewCell"];
    [self.view addSubview: self.connectionsTableView];
    self.connectionsTableView.dataSource = self;
    self.connectionsTableView.delegate = self;
    
    UIView *dummyFooterView =  [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 1)];
    self.connectionsTableView.tableFooterView = dummyFooterView;
    dummyFooterView.hidden = YES;
    
    //[self.view addSubview: self.stationsViewToolbar];
    /*
     self.bottomStbSelectionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - CONJRNBOTTOMINFOBARHEIGHT, self.view.bounds.size.width, CONJRNBOTTOMINFOBARHEIGHT)];
     self.bottomStbSelectionView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
     self.bottomStbSelectionView.backgroundColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapBackgroundColor];
     self.bottomStbSelectionView.userInteractionEnabled = NO;
     [self.view addSubview:self.bottomStbSelectionView];
     */
    //-----------------
    self.headerView = [[StbHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    self.footerView = [[StbFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    [self addHeaderviewToTableView: self.headerView];
    [self addFooterviewToTableView: self.footerView];
    [self relocateFooterView];
    //-----------------
    
    self.appcamefrombackground = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appwillenterforeground:)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

- (void) appwillenterforeground:(id)sender {
    #ifdef LOGOUTPUTON
    NSLog(@"Appwillenterforeground notification received");
    #endif
    
    self.appcamefrombackground = YES;
}

- (void) setCurrentStationBoardProductCodesType:(NSUInteger)productCodeType {
    self.stationBoardResultProductType = productCodeType;
}

- (void) updateControllerWithStationBoardProductCodesType:(NSUInteger)productCodeTypes {
    
    __weak StationboardResultsContainerViewController *weakself = self;
    
    //[[SBBAPIController sharedSBBAPIController] resetStationboardResults];
    
    if (productCodeTypes == stbFastAndRegioTrain) {
        [weakself selectFastTrainResults];
    } else if (productCodeTypes == stbFastTrainAndTramBus) {
        [weakself selectFastTrainResults];
    } else if (productCodeTypes == stbRegioTrainAndTramBus) {
        [weakself selectRegioTrainResults];
    } else if (productCodeTypes == stbAll) {
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
}


-(void) cancelCurrentRunningRequestsIfAny {
    
    [self resetTopLoadMoreViewWithNewRowsCount:0];
    [self resetBottomLoadMoreViewWithNewRowsCount:0];
    
    [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIStbreqOperations];
    
    /*
    if ([[SBBAPIController sharedSBBAPIController] stbreqRequestInProgress]) {
        [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIStbreqOperations];
    }
    */
}

- (void) checkIfTableViewInLoadingStateCancelRequestsAndReset {
    
    [self cancelCurrentRunningRequestsIfAny];
    
    /*
    if (self.isLoadingMoreTop || self.isLoadingMoreBottom) {
        [self cancelCurrentRunningRequestsIfAny];
        if (self.isLoadingMoreBottom) {
            [self resetBottomLoadMoreViewWithNewRowsCount: 0];
        }
        if (self.isLoadingMoreTop) {
            [self resetTopLoadMoreViewWithNewRowsCount: 0];
        }
    }
    */
}

- (void) selectFastTrainResults {
    self.stationBoardResultProductType = stbOnlyFastTrain;
    [self checkIfTableViewInLoadingStateCancelRequestsAndReset];
    NSUInteger numberofcurrentResults = [[SBBAPIController sharedSBBAPIController] getNumberOfStationboardResultsWithProductType: self.stationBoardResultProductType];
    [self.connectionsTableView reloadData];
    if (numberofcurrentResults < 1) {
        [self executeStbRequestAndUpdateTableView];
    }
}

- (void) selectRegioTrainResults {
    self.stationBoardResultProductType = stbOnlyRegioTrain;
    [self checkIfTableViewInLoadingStateCancelRequestsAndReset];
    NSUInteger numberofcurrentResults = [[SBBAPIController sharedSBBAPIController] getNumberOfStationboardResultsWithProductType: self.stationBoardResultProductType];
    [self.connectionsTableView reloadData];
    if (numberofcurrentResults < 1) {
        [self executeStbRequestAndUpdateTableView];
    }
}

- (void) selectTramBusResults {
    self.stationBoardResultProductType = stbOnlyTramBus;
    [self checkIfTableViewInLoadingStateCancelRequestsAndReset];
    NSUInteger numberofcurrentResults = [[SBBAPIController sharedSBBAPIController] getNumberOfStationboardResultsWithProductType: self.stationBoardResultProductType];
    [self.connectionsTableView reloadData];
    if (numberofcurrentResults < 1) {
        [self executeStbRequestAndUpdateTableView];
    }
}

- (void) selectAllResults {
    self.stationBoardResultProductType = stbAll;
    [self checkIfTableViewInLoadingStateCancelRequestsAndReset];
    NSUInteger numberofcurrentResults = [[SBBAPIController sharedSBBAPIController] getNumberOfStationboardResultsWithProductType: self.stationBoardResultProductType];
    [self.connectionsTableView reloadData];
    if (numberofcurrentResults < 1) {
        [self executeStbRequestAndUpdateTableView];
    }
}

- (void) UpdateTableViewWithNumberOfResults:(NSUInteger) numberofresults {
    if (numberofresults > 0) {
        [self.connectionsTableView reloadData];
    }
}

- (void) executeStbRequestAndUpdateTableView {
    
    [self showLoadingIndicator];
    
    [self cancelCurrentRunningRequestsIfAny];
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable)
    {
        //UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        //[[NoticeviewMessages sharedNoticeMessagesController] showNoNetworkErrorMessage: currentWindow];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(showNoNetworkErrorMessage)]) {
            [self.delegate showNoNetworkErrorMessage];
        }
        
        return;
    }

    [[SBBAPIController sharedSBBAPIController] sendStbReqXMLStationboardRequestWithProductType:self.stbStation
                                                                                   destination:self.dirStation
                                                                                       stbDate:self.connectionTime
                                                                                 departureTime:self.isDepartureTime
                                                                                   productType:self.stationBoardResultProductType
                                                                                  successBlock:^(NSUInteger numberofresults){
                                                                                      [self hideLoadingIndicator];
                                                                                   
                                                                                      if (numberofresults > 0) {
                                                                                          self.lastRequestDate = [NSDate date];
                                                                                          [self.connectionsTableView reloadData];
                                                                                      } else {
                                                                                          [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqDidNotReturnAnyResultNotice: self.view];
                                                                                      }
                                                                                  }
                                                                                  failureBlock:^(NSUInteger errorcode){
                                                                                      
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
                                                                                            // Nothing to do
                                                                                      } else {
                                                                                          [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqOtherUndefinedErrorNotice:self.view];
                                                                                      }
                                                                                  }];
}

- (void) updateStationboardResult:(id)sender {
    [self cancelCurrentRunningRequestsIfAny];
    [self executeStbRequestAndUpdateTableView];
}

#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [[SBBAPIController sharedSBBAPIController] getNumberOfStationboardResults];
    return [[SBBAPIController sharedSBBAPIController] getNumberOfStationboardResultsWithProductType: self.stationBoardResultProductType];
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
    
    //Journey *journey = [[SBBAPIController sharedSBBAPIController] getJourneyForStationboardResultWithIndex: indexPath.row];
    Journey *journey = [[SBBAPIController sharedSBBAPIController] getJourneyForStationboardResultFWithProductTypeWithIndex: self.stationBoardResultProductType index: indexPath.row];
    BasicStop *mainstop = [[SBBAPIController sharedSBBAPIController] getMainBasicStopForStationboardJourney: journey];
    //JourneyHandle *handle = [[SBBAPIController sharedSBBAPIController] getJourneyhandleForStationboardJourney: journey];
    
    StationboardTableViewCell *stationboardcell = (StationboardTableViewCell *)cell;
        
    //NSString *stationName = [[SBBAPIController sharedSBBAPIController] getStationNameForBasicStop: mainstop];
    
    if ([[SBBAPIController sharedSBBAPIController] getStationboardJourneyDepartureArrivalForWithStationboardJourney: journey] == stbDepartureType) {
        NSString *departureTime = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForStationboardJourney: journey];
        stationboardcell.oneTimeLabel.text = departureTime;
    } else {
        NSString *arrivalTime = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForStationboardJourney: journey];
        stationboardcell.oneTimeLabel.text = arrivalTime;
    }
    
    NSString *platform = [[SBBAPIController sharedSBBAPIController] getPlatformForBasicStop: mainstop];
    
    NSString *direction = [[SBBAPIController sharedSBBAPIController] getDirectionNameForStationboardJourney: journey];
        
    UIImage *transportNameImage = [[SBBAPIController sharedSBBAPIController] renderTransportNameImageForStationboardJourney: journey];
    //UIImage *transportTypeImage = [[SBBAPIController sharedSBBAPIController] renderTransportTypeImageForStationboardJourney: journey];
    
    //stationboardcell.stationNameLabel.text = [self shortenStationNameIfTooLong:direction maxLenth: 26];
    
    stationboardcell.trackLabel.text = platform;
    
    if (platform && ([platform length] > 0)) {
        //[stationboardcell shortenStationNameLabelIfTrackInfo];
        [stationboardcell prolongStationNameLabelIfNoTrackInfo];
        stationboardcell.stationNameLabel.text = [self shortenStationNameIfTooLong:direction maxLenth: 23];
    } else {
        [stationboardcell prolongStationNameLabelIfNoTrackInfo];
        stationboardcell.stationNameLabel.text = [self shortenStationNameIfTooLong:direction maxLenth: 30];
    }
    /*
    #ifdef LOGOUTPUTON
    NSString *categoryName = [journey journeyCategoryName];
    NSString *categoryCode = [journey journeyCategoryCode];
    NSString *transportName = [journey journeyName];
    NSLog(@"Journey transport info: %@, %@, %@", transportName, categoryName, categoryCode);
    #endif
    */
    [stationboardcell.transportNameImageView setImage: transportNameImage];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StationboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StationboardTableViewCell"];
    [self configureCell: cell atIndexPath:indexPath];
    return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StationboardTableViewCell *selectedCell = (StationboardTableViewCell *)[tableView cellForRowAtIndexPath: indexPath];
    
    if ([selectedCell isKindOfClass:[StationboardTableViewCell class]]) {
        if (selectedCell.selected) {
            selectedCell.tableViewCellsIsSelectedAndShouldDeselect = YES;
        } else {
            selectedCell.tableViewCellsIsSelectedAndShouldDeselect = NO;
        }
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StationboardTableViewCell *selectedCell = (StationboardTableViewCell *)[tableView cellForRowAtIndexPath: indexPath];
    
    if ([selectedCell isKindOfClass:[StationboardTableViewCell class]]) {
        if (selectedCell.tableViewCellsIsSelectedAndShouldDeselect) {
            [tableView deselectRowAtIndexPath: indexPath animated: NO];
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectStationboardCellWithIndexAndProductType:index:producttype:)])
            {
                [self.delegate didSelectStationboardCellWithIndexAndProductType:self index: 9999 producttype: self.stationBoardResultProductType];
            }
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectStationboardCellWithIndexAndProductType:index:producttype:)])
            {
                [self.delegate didSelectStationboardCellWithIndexAndProductType:self index: indexPath.row producttype: self.stationBoardResultProductType];
            }
        }
    } else {
        [tableView deselectRowAtIndexPath: indexPath animated: NO];
    }
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

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isJourneyDetailViewControllerOnScreen = NO;
    [self relocateFooterView];
}
*/

- (void) pushBackController:(id)sender {
    [self cancelCurrentRunningRequestsIfAny];
    
    //if (self.stationboardJourneyDetailViewController) {
    //    self.stationboardJourneyDetailViewController = nil;
    //}
    [self.navigationController popViewControllerAnimated: YES];
}

-(void) forcePushBackToPreviousViewController {
    
    #ifdef LOGOUTPUTON
    NSLog(@"StationboardConnectionsViewController force push back");
    #endif

    [self cancelCurrentRunningRequestsIfAny];
    
    /*
    if (self.isJourneyDetailViewControllerOnScreen) {
    
       NSLog(@"StationboardConnectionsViewController force push back. Force also journey detail view controller"); 
    
        [self.stationboardJourneyDetailViewController forcePushBackToPreviousViewController];
        self.stationboardJourneyDetailViewController = nil;
        [self performSelector: @selector(pushBackWithDelay) withObject: self afterDelay: 0.3];
        return;
    }
    [self.navigationController popViewControllerAnimated: NO];
    */
}

- (void) pushBackWithDelay {
    [self.navigationController popViewControllerAnimated: NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//--------------------------------------------------------------------------------

- (void) addHeaderviewToTableView:(StbHeaderView *)headerView
{
    if (!self.connectionsTableView)
        return;
    /*
     if (self.headerView && [self.headerView isDescendantOfView:self.overViewTableView])
     [self.headerView removeFromSuperview];
     self.headerView = nil;
     */
    if (headerView) {
        //self.headerView = (HeaderView  *)headerView;
        
        CGRect f = self.headerView.frame;
        self.headerView.frame = CGRectMake(f.origin.x, 0 - f.size.height, f.size.width, f.size.height);
        self.headerViewFrame = self.headerView.frame;
        
        [self.connectionsTableView addSubview:self.headerView];
    }
}

- (void) addFooterviewToTableView:(StbFooterView *)footerView
{
    if (!self.connectionsTableView)
        return;
    
    /*
     self.overViewTableView.tableFooterView = nil;
     self.footerView = nil;
     */
    
    if (footerView) {
        //self.footerView = (FooterView *)footerView;
        
        CGRect f = self.footerView.frame;
        self.footerView.frame = CGRectMake(f.origin.x, self.connectionsTableView.contentSize.height, f.size.width, f.size.height);
        self.footerViewFrame = self.footerView.frame;
        
        [self.connectionsTableView addSubview:self.footerView];
        
        [self relocateFooterView];
    }
}

-(int) heightForCellAtIndexPath: (NSIndexPath *) indexPath {
    
    UITableViewCell *cell =  [self.connectionsTableView cellForRowAtIndexPath:indexPath];
    int cellHeight   =  cell.frame.size.height;
    
    //NSLog(@"Height for row at index path: %d, %d, %d", indexPath.section, indexPath.row, cellHeight);
    
    return cellHeight;
}

-(void) updateTableWithNewRowCountAtTop : (int) rowCount
{
    
    #ifdef LOGOUTPUTON
    NSLog(@"Update tableview at top. new rows: %d", rowCount);
    #endif
    
    NSUInteger apinumberofresults = [[SBBAPIController sharedSBBAPIController] getNumberOfStationboardResultsWithProductType: self.stationBoardResultProductType];
    NSUInteger tablenumberofresults = [self.connectionsTableView numberOfRowsInSection: 0];
    if (apinumberofresults != (tablenumberofresults + rowCount)) {
        #ifdef LOGOUTPUTON
        NSLog(@"Update tableview at top. Api and tableview rows don't match. Just reload. %d, %d, %d", apinumberofresults, tablenumberofresults, rowCount);
        #endif
        
        self.connectionsTableView.contentInset = UIEdgeInsetsZero;
        [self.connectionsTableView reloadData];
        
        return;
    }
    
    //Save the tableview content offset
    
    CGPoint tableViewOffset = [self.connectionsTableView contentOffset];
    
    //NSLog(@"Table offset: %.1f", tableViewOffset.y);
    
    //Turn of animations for the update block
    //to get the effect of adding rows on top of TableView
    [UIView setAnimationsEnabled:NO];
    
    [self.connectionsTableView beginUpdates];
    
    NSMutableArray *rowsInsertIndexPath = [[NSMutableArray alloc] init];
    
    int heightForNewRows = 0;
    
    for (NSInteger i = 0; i < rowCount; i++) {
        
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection: 0];
        [rowsInsertIndexPath addObject:tempIndexPath];
        
        //heightForNewRows = heightForNewRows + [self heightForCellAtIndexPath:tempIndexPath];
        heightForNewRows = heightForNewRows + [self heightForCellAtIndexPath: [NSIndexPath indexPathForRow:0 inSection: 0]];
    }
    
    #ifdef LOGOUTPUTON
    NSLog(@"Height for new rows: %d", heightForNewRows);
    #endif
    
    [self.connectionsTableView insertRowsAtIndexPaths:rowsInsertIndexPath withRowAnimation:UITableViewRowAnimationNone];
    
    tableViewOffset.y += heightForNewRows;
    
    #ifdef LOGOUTPUTON
    NSLog(@"Table offset: %.1f", tableViewOffset.y);
    #endif
    
    [self.connectionsTableView endUpdates];
        
    self.connectionsTableView.contentInset = UIEdgeInsetsZero;
    
    [UIView setAnimationsEnabled:YES];
    
    //return;
    
    [self.connectionsTableView setContentOffset:tableViewOffset animated:NO];
    
    [self relocateFooterView];
}

-(void) updateTableWithNewRowCountAtBottom : (int) rowCount
{
    
    #ifdef LOGOUTPUTON
    NSLog(@"update tableview at bottom");
    #endif
    
    NSUInteger apinumberofresults = [[SBBAPIController sharedSBBAPIController] getNumberOfStationboardResultsWithProductType: self.stationBoardResultProductType];
    NSUInteger tablenumberofresults = [self.connectionsTableView numberOfRowsInSection: 0];
    if (apinumberofresults != (tablenumberofresults + rowCount)) {
        #ifdef LOGOUTPUTON
        NSLog(@"Update tableview at bottom. Api and tableview rows don't match. Just reload. %d, %d, %d", apinumberofresults, tablenumberofresults, rowCount);
        #endif
        
        self.connectionsTableView.contentInset = UIEdgeInsetsZero;
        [self.connectionsTableView reloadData];
        [self relocateFooterView];
        
        return;
    }
    
    //Save the tableview content offset
    CGPoint tableViewOffset = [self.connectionsTableView contentOffset];
    CGSize tableViewSize = [self.connectionsTableView contentSize];
    
    //Turn of animations for the update block
    //to get the effect of adding rows on top of TableView
    [UIView setAnimationsEnabled:NO];
    
    [self.connectionsTableView beginUpdates];
    
    NSMutableArray *rowsInsertIndexPath = [[NSMutableArray alloc] init];
    
    int heightForNewRows = 0;
    
    NSUInteger numberofRowsNow = [self.connectionsTableView numberOfRowsInSection: 0];
    
    for (NSInteger i = numberofRowsNow; i < numberofRowsNow + rowCount; i++) {
        
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection: 0];
        [rowsInsertIndexPath addObject:tempIndexPath];
        
        heightForNewRows = heightForNewRows + [self heightForCellAtIndexPath:tempIndexPath];
    }
    
    [self.connectionsTableView insertRowsAtIndexPaths:rowsInsertIndexPath withRowAnimation:UITableViewRowAnimationNone];
    
    tableViewSize.height += heightForNewRows;
    
    [self.connectionsTableView endUpdates];
    
    
    CGFloat yOrigin = 0.0f;
    
    if (tableViewSize.height >= CGRectGetHeight([self.connectionsTableView frame])) {
        
        //NSLog(@"Add rows at botttom. Relocate footer view. Contentsize is higher than height");
        yOrigin = tableViewSize.height;
        
    } else {
        //NSLog(@"Add rows at botttom. Relocate footer view. Contentsize is smaller than height");
        yOrigin = CGRectGetHeight([self.connectionsTableView frame]);
    }
    
    yOrigin += [self.footerView fixedHeight];
    
    CGRect frame = [self.footerView frame];
    frame.origin.y = yOrigin;
    [self.footerView setFrame:frame];
    
    [self.footerView removeFromSuperview];
    [self.connectionsTableView addSubview:self.footerView];
    
    self.connectionsTableView.contentInset = UIEdgeInsetsZero;
    
    [UIView setAnimationsEnabled:YES];
    
    [self.connectionsTableView setContentOffset:tableViewOffset animated:NO];
}

- (void) topPullToLoadNewResultsTriggered
{
    
#ifdef LOGOUTPUTON
    NSLog(@"Top pull to load triggered");
#endif
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable)
    {
        [self resetTopLoadMoreViewWithNewRowsCount:0];
        
        //UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        //[[NoticeviewMessages sharedNoticeMessagesController] showNoNetworkErrorMessage: currentWindow];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(showNoNetworkErrorMessage)]) {
            [self.delegate showNoNetworkErrorMessage];
        }
        
        return;
    }
    
    self.isLoadingMoreTop = YES;
    
    //[self performSelector:@selector(topPullToLoadNewResultsCompleted) withObject:nil afterDelay:2.0f];
    
    [self cancelCurrentRunningRequestsIfAny];
    
    [[SBBAPIController sharedSBBAPIController] sendStbScrXMLStationboardRequestWithProductType:stbscrBackward
                                                                                       station:self.stbStation
                                                                                   destination:self.dirStation
                                                                                       stbDate:self.connectionTime
                                                                                 departureTime:self.isDepartureTime
                                                                                   productType:self.stationBoardResultProductType
                                                                                  successBlock:^(NSUInteger numberofnewresults){
                                                                                      
                                                                                      if (numberofnewresults > 0) {
                                                                                          NSLog(@"New rows at top received: %d", numberofnewresults);
                                                                                          [self resetTopLoadMoreViewWithNewRowsCount: numberofnewresults];
                                                                                      } else {
                                                                                          NSLog(@"New rows at top received. None");
                                                                                          [self resetTopLoadMoreViewWithNewRowsCount:0];
                                                                                          [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqDidNotReturnAnyResultNotice: self.view];
                                                                                      }
                                                                                      
                                                                                  }
                                                                                  failureBlock:^(NSUInteger errorcode){
                                                                                      [self resetTopLoadMoreViewWithNewRowsCount:0];
                                                                                      
                                                                                      //NSUInteger kConReqRequestFailureConnectionFailed = 85;
                                                                                      //NSUInteger kConScrRequestFailureConnectionFailed = 45;
                                                                                      //NSUInteger kStbReqRequestFailureConnectionFailed = 75;
                                                                                      //NSUInteger kStbScrRequestFailureConnectionFailed = 51;
                                                                                      //NSUInteger kJrnReqRequestFailureConnectionFailed = 65;
                                                                                      //NSUInteger kRssReqRequestFailureConnectionFailed = 95;
                                                                                      //NSUInteger kStbScrRequestFailureCancelled = 5599;
                                                                                      
                                                                                      //NSUInteger kSbbReqStationsNotDefined = 112;
                                                                                      
                                                                                      if (errorcode == kStbScrRequestFailureConnectionFailed) {
                                                                                          [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqFailedNotice:self.view];
                                                                                      } else if (errorcode == kSbbReqStationsNotDefined) {
                                                                                          [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqStationsNotAvailableNotice:self.view];
                                                                                      } else if (kStbScrRequestFailureCancelled ) {
                                                                                            // Nothing to do
                                                                                      } else {
                                                                                          [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqOtherUndefinedErrorNotice:self.view];
                                                                                      }
                                                                                  }];

}

- (void) topPullToLoadNewResultsCompleted
{
    
#ifdef LOGOUTPUTON
    NSLog(@"Top pull to load completed");
#endif
    
    self.isLoadingMoreTop = NO;
    
    //[UIView animateWithDuration:0.3 animations:^(void) {
    //    self.overViewTableView.contentInset = UIEdgeInsetsZero;
    //}];
    
    [self.headerView changeStateOfControl:StbPullToRefreshViewStateIdle offset:CGFLOAT_MAX];
    
}

- (void)bottomPullToLoadNewResultsTriggered {
    
    
#ifdef LOGOUTPUTON
    NSLog(@"Bottom pull to load triggered");
#endif
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable)
    {
        [self resetBottomLoadMoreViewWithNewRowsCount:0];
        
        //UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        //[[NoticeviewMessages sharedNoticeMessagesController] showNoNetworkErrorMessage: currentWindow];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(showNoNetworkErrorMessage)]) {
            [self.delegate showNoNetworkErrorMessage];
        }
        
        return;
    }
    
    self.isLoadingMoreBottom = YES;
    
    //[self performSelector:@selector(bottomPullToLoadNewResultsCompleted) withObject:nil afterDelay:2.0f];
    
    [self cancelCurrentRunningRequestsIfAny];
    
    [[SBBAPIController sharedSBBAPIController] sendStbScrXMLStationboardRequestWithProductType:stbscrForward
                                                                                       station:self.stbStation
                                                                                   destination:self.dirStation
                                                                                       stbDate:self.connectionTime
                                                                                 departureTime:self.isDepartureTime
                                                                                   productType:self.stationBoardResultProductType
                                                                                  successBlock:^(NSUInteger numberofnewresults){

                                                                                      if (numberofnewresults > 0) {
                                                                                          [self resetBottomLoadMoreViewWithNewRowsCount: numberofnewresults];
                                                                                      } else {
                                                                                          [self resetBottomLoadMoreViewWithNewRowsCount:0];
                                                                                          [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqDidNotReturnAnyResultNotice: self.view];
                                                                                      }
                                                                                  }
                                                                                  failureBlock:^(NSUInteger errorcode){
                                                                                      [self resetBottomLoadMoreViewWithNewRowsCount:0];
                                                                                      
                                                                                      //NSUInteger kConReqRequestFailureConnectionFailed = 85;
                                                                                      //NSUInteger kConScrRequestFailureConnectionFailed = 45;
                                                                                      //NSUInteger kStbReqRequestFailureConnectionFailed = 75;
                                                                                      //NSUInteger kStbScrRequestFailureConnectionFailed = 51;
                                                                                      //NSUInteger kJrnReqRequestFailureConnectionFailed = 65;
                                                                                      //NSUInteger kRssReqRequestFailureConnectionFailed = 95;
                                                                                      //NSUInteger kStbScrRequestFailureCancelled = 5599;
                                                                                      
                                                                                      //NSUInteger kSbbReqStationsNotDefined = 112;
                                                                                      
                                                                                      if (errorcode == kStbScrRequestFailureConnectionFailed) {
                                                                                          [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqFailedNotice:self.view];
                                                                                      } else if (errorcode == kSbbReqStationsNotDefined) {
                                                                                          [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqStationsNotAvailableNotice:self.view];
                                                                                      } else if (errorcode == kStbScrRequestFailureCancelled) {
                                                                                            // Nothing to do
                                                                                      } else {
                                                                                          [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqOtherUndefinedErrorNotice:self.view];
                                                                                      }
                                                                                  }];
    

}

-(void )bottomPullToLoadNewResultsCompleted {
    //[self tableViewReloadFinished];
    
    
#ifdef LOGOUTPUTON
    NSLog(@"Bottom pull to load completed");
#endif
    
    self.isLoadingMoreBottom = NO;
    
    //[UIView animateWithDuration:0.3 animations:^(void) {
    //    self.overViewTableView.contentInset = UIEdgeInsetsZero;
    //}];
    
    //[self.overViewTableView setContentInset:UIEdgeInsetsZero];
    
    //[self relocateFooterView];
    
    [self.footerView changeStateOfControl:StbPullToRefreshViewStateIdle offset:CGFLOAT_MAX];
}

- (void) resetTopLoadMoreViewWithNewRowsCount:(NSUInteger)rowsCount {
    [self topPullToLoadNewResultsCompleted];
    //[self.overViewTableView setNeedsDisplay];
    //[self.overViewTableView reloadData];
    if (rowsCount > 0) {
        [self updateTableWithNewRowCountAtTop: rowsCount];
    } else {
        [UIView animateWithDuration:0.3 animations:^(void) {
            self.connectionsTableView.contentInset = UIEdgeInsetsZero;
        }];
    }
    
}
- (void) resetBottomLoadMoreViewWithNewRowsCount:(NSUInteger)rowsCount {
    [self bottomPullToLoadNewResultsCompleted];
    //[self.overViewTableView setNeedsDisplay];
    if (rowsCount > 0) {
        [self updateTableWithNewRowCountAtBottom: rowsCount];
    } else {
        [UIView animateWithDuration:0.3 animations:^(void) {
            self.connectionsTableView.contentInset = UIEdgeInsetsZero;
        }];
    }
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.isLoadingMoreTop || self.isLoadingMoreBottom)
        return;
    
    self.initialContentOffset = scrollView.contentOffset.y;
    
    self.isDragging = YES;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isDragging) {
        //NSLog(@"Scroll view did scoll. Is dragging");
        
        [self relocateFooterView];
        
        CGPoint currentOffset = scrollView.contentOffset;
        if (currentOffset.y < self.initialContentOffset) {
            //NSLog(@"Scroll view did scoll. Is dragging up");
            
            if (!self.isLoadingMoreTop && ![self.headerView isHidden]) {
                //NSLog(@"Is dragging header view");
                CGFloat offset = scrollView.contentOffset.y;
                
                if (offset >= 0.0f) {
                    //NSLog(@"Is dragging header view. State idle");
                    [self.headerView changeStateOfControl:StbPullToRefreshViewStateIdle offset:offset];
                    
                } else if (offset >= 0 - [self.headerView fixedHeight]) {
                    //NSLog(@"Is dragging header view. State pull");
                    [self.headerView changeStateOfControl:StbPullToRefreshViewStatePull offset:offset];
                    
                } else {
                    //NSLog(@"Is dragging header view. State load more.");
                    [self.headerView changeStateOfControl:StbPullToRefreshViewStateRelease offset:offset];
                }
                
            }
        } else {
            //NSLog(@"Scroll view did scoll. Is dragging down");
            if (!self.isLoadingMoreBottom  && ![self.footerView isHidden]) {
                //NSLog(@"Is dragging footer view");
                //[self tableViewScrolled];
                
                //NSLog(@"Is dragging footer view. offset: %.1f, footer: %.1f", scrollView.contentOffset.y, self.footerViewFrame.size.height);
                
                CGFloat offset = [self tableScrollOffset];
                
                if (offset >= 0.0f) {
                    //NSLog(@"Is dragging footer view. State idle");
                    [self.footerView changeStateOfControl:StbPullToRefreshViewStateIdle offset:offset];
                    //[self footerViewDidScroll:NO scrollView:scrollView];
                    
                } else if (offset <= 0.0f && offset >= -[self.footerView fixedHeight]) {
                    //NSLog(@"Is dragging footer view. State pull");
                    [self.footerView changeStateOfControl:StbPullToRefreshViewStatePull offset:offset];
                    //[self footerViewDidScroll:NO scrollView:scrollView];
                    
                } else {
                    //NSLog(@"Is dragging footer view. State load more.");
                    [self.footerView changeStateOfControl:StbPullToRefreshViewStateRelease offset:offset];
                    //[self footerViewDidScroll:YES scrollView:scrollView];
                }
            }
        }
        self.initialContentOffset = currentOffset.y;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    
    self.isDragging = NO;
    
    CGFloat offset = [self tableScrollOffset];
    CGFloat height = -[self.footerView fixedHeight];
    
    if (scrollView.contentOffset.y <= 0 - [self.headerView fixedHeight]) {
        if (self.isLoadingMoreTop || [self.headerView isHidden])
            return;
        
        //NSLog(@"Trigger top load more");
        
        [self topPullToLoadNewResultsTriggered];
        
        [self.headerView changeStateOfControl:StbPullToRefreshViewStateLoading offset:offset];
        
        [UIView animateWithDuration:0.3 animations:^(void) {
            //NSLog(@"Top load more inset animation");
            self.connectionsTableView.contentInset = UIEdgeInsetsMake([self.headerView fixedHeight], 0, 0, 0);
        }];
        
    } else if (offset <= 0.0f && offset < height) {
        
        if (self.isLoadingMoreBottom || [self.footerView isHidden])
            return;
        
        //NSLog(@"Trigger bottom load more");
        [self bottomPullToLoadNewResultsTriggered];
        
        [self.footerView changeStateOfControl:StbPullToRefreshViewStateLoading offset:offset];
        
        [UIView animateWithDuration:0.3f animations:^{
            
            //NSLog(@"Bottom load more inset animation");
            
            if ([self.connectionsTableView contentSize].height >= CGRectGetHeight([self.connectionsTableView frame])) {
                
                [self.connectionsTableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, -height, 0.0f)];
                
            } else {
                
                [self.connectionsTableView setContentInset:UIEdgeInsetsMake(height, 0.0f, 0.0f, 0.0f)];
            }
        }];
    }
    
    //[self tableViewReleased];
}

#pragma mark -
#pragma mark Visuals

/*
 * Returns the correct offset to apply to the pull-to-refresh view, depending on contentSize
 */
- (CGFloat)tableScrollOffset {
    
    CGFloat offset = 0.0f;
    
    if ([self.connectionsTableView contentSize].height < CGRectGetHeight([self.connectionsTableView frame])) {
        
        offset = -[self.connectionsTableView contentOffset].y;
        
    } else {
        
        offset = ([self.connectionsTableView contentSize].height - [self.connectionsTableView contentOffset].y) - CGRectGetHeight([self.connectionsTableView frame]);
    }
    
    return offset;
}

/*
 * Relocate pull-to-refresh view
 */
- (void)relocateFooterView {
    
    CGFloat yOrigin = 0.0f;
    
    //NSLog(@"Relocate footer view. Content height: %.1f, height: %.1f", [self.connectionsTableView contentSize].height, CGRectGetHeight([self.connectionsTableView frame]));
    
    if ([self.connectionsTableView contentSize].height >= CGRectGetHeight([self.connectionsTableView frame])) {
        
        //NSLog(@"Relocate footer view. Contentsize is higher than height");
        yOrigin = [self.connectionsTableView contentSize].height;
        
    } else {
        //NSLog(@"Relocate footer view. Contentsize is smaller than height");
        yOrigin = CGRectGetHeight([self.connectionsTableView frame]);
    }
    
    CGRect frame = [self.footerView frame];
    frame.origin.y = yOrigin;
    [self.footerView setFrame:frame];
    
    
    [self.footerView removeFromSuperview];
    [self.connectionsTableView addSubview:self.footerView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"StationboardResultContainerViewControlleriPad: should autororate");
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	NSLog(@"StationboardResultContainerViewControlleriPad: willRotateToInterfaceOrientation");
    //[self layoutSubviews:YES toInterfaceOrientation:toInterfaceOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"StationboardResultContainerViewControlleriPad: didRotateToInterfaceOrientation");
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"StationboardResultContainerViewControlleriPad: willAnimateRotateToInterfaceOrientation");
    //[self layoutSubviews:YES toInterfaceOrientation:toInterfaceOrientation];
}

- (void) viewWillAppear:(BOOL)animated {
    //NSLog(@"StationboardResultContainerViewControlleriPad: viewwillappear");
	[super viewWillAppear:animated];
    //self.isJourneyDetailViewControllerOnScreen = NO;
    
    [self relocateFooterView];
}

- (void) viewDidAppear:(BOOL)animated {
    //NSLog(@"StationboardResultContainerViewControlleriPad: viewdidappear");
	[super viewDidAppear:animated];
    //[self layoutSubviews: NO toInterfaceOrientation: [[UIDevice currentDevice] orientation]];
    
    if (self.appcamefrombackground) {
        self.appcamefrombackground = NO;
        
        #ifdef LOGOUTPUTON
        NSLog(@"App came from background. viewdidappear.");
        #endif
        
        if (self.lastRequestDate) {
            NSTimeInterval howRecent = [self.lastRequestDate timeIntervalSinceNow];
            if (abs(howRecent) > MIN_OLD_MAX) {
                #ifdef LOGOUTPUTON
                NSLog(@"App came from background stb result is older than 5 min. update.");
                #endif
                
                [self executeStbRequestAndUpdateTableView];
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    //NSLog(@"StationboardResultContainerViewControlleriPad: viewwilldisappear");
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    //NSLog(@"StationboardResultContainerViewControlleriPad: viewdiddisappear");
	[super viewDidDisappear:animated];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
