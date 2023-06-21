//
//  RSSTransportNewContainerViewControlleriPad.m
//  Swiss Trains
//
//  Created by Alain on 01.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "RSSTransportNewContainerViewControlleriPad.h"

@interface RSSTransportNewContainerViewControlleriPad ()

@end

@implementation RSSTransportNewContainerViewControlleriPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Infos", "Select stations rssreq flash message title");
        
        CGFloat scaleFactor = TABBARICONIMAGESCALEFACTOR;
        UIImage *infoImage = [UIImage newImageFromMaskImage: [[UIImage delayinfoButtonImage] resizedImage: CGSizeMake(TABBARICONIMAGEHEIGHT * scaleFactor, TABBARICONIMAGEHEIGHT * scaleFactor) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlItemImageColor]];
        
        self.tabBarItem.image = [infoImage grayTabBarItemFilter];
        self.tabBarItem.selectedImage = [infoImage blueTabBarItemFilter];
        
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight  | UIViewAutoresizingFlexibleWidth;
        
        NSString *paths = [[NSBundle mainBundle] resourcePath];
        NSString *htmlPath = [paths stringByAppendingPathComponent:@"rssitem.html"];
        self.rsshtmlsource = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:NULL];
    }
    return self;
}

- (void) loadView {
    CGSize size = [UIApplication currentScreenSize];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = view;
}

- (void) layoutSubviewsWithAnimated:(BOOL)animated beforeRotation:(BOOL)beforeRotation interfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"RssTransportNewsContainerViewControlleriPad layoutSubviews");
	
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
    
    self.delayInfoTableView.frame = CGRectMake(0, TOOLBARHEIGHTIPAD, SPLITVIEWMAINVIEWWIDTH, newSize.height - TOOLBARHEIGHTIPAD);
    
    self.divider.frame = CGRectMake(SPLITVIEWMAINVIEWWIDTH, TOOLBARHEIGHTIPAD, SPLITVIEWDIVIDERWIDTH, newSize.height - TOOLBARHEIGHTIPAD);
    self.descriptionDetailView.frame = CGRectMake(SPLITVIEWMAINVIEWWIDTH + SPLITVIEWDIVIDERWIDTH, TOOLBARHEIGHTIPAD, newSize.width - SPLITVIEWMAINVIEWWIDTH - SPLITVIEWDIVIDERWIDTH, newSize.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT);
    
    int startPositionInfoView = (newSize.width - 350) / 2;
    int infoViewWidth = 350;
    self.topInfoView.frame = CGRectMake(startPositionInfoView, 0, infoViewWidth, TOOLBARHEIGHTIPAD);
    
    self.infoButton.frame = CGRectMake(newSize.width - BUTTONHEIGHT - 5, 0, BUTTONHEIGHT, BUTTONHEIGHT);

    if (animated) {
        [UIView beginAnimations:@"RssTransportNewsContainerViewControlleriPad LayoutSubviewWithAnimation" context:NULL];
    }
    
    //self.statusToolBar.frame = CGRectMake(0, 0, newSize.width, TOOLBARHEIGHTIPAD);
    
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
    self.view.backgroundColor = [UIColor rssDetailBackgroundColor];

    self.statusToolBar = [[StatusToolbariPad alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, TOOLBARHEIGHTIPAD)];
    
    self.delayInfoTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, TOOLBARHEIGHTIPAD, SPLITVIEWMAINVIEWWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT)  style: UITableViewStylePlain];
    self.delayInfoTableView.rowHeight = 50;
    self.delayInfoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.delayInfoTableView.separatorColor = [UIColor lightGrayColor];
    //self.delayInfoTableView.backgroundColor = [UIColor overviewTableviewBackgroundColor];
    self.delayInfoTableView.backgroundColor = [UIColor rssDetailBackgroundColor];
    [self.delayInfoTableView registerClass:[RssInfoCell class] forCellReuseIdentifier: @"RssInfoCell"];
    self.delayInfoTableView.dataSource = self;
    self.delayInfoTableView.delegate = self;
    [self.view addSubview: self.delayInfoTableView];
    
    self.headerView = [[RssHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    [self addHeaderviewToTableView: self.headerView];
    
    UIView *dummyFooterView =  [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 0)];
    self.delayInfoTableView.tableFooterView = dummyFooterView;
    dummyFooterView.hidden = YES;
    
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
    
    self.descriptionDetailView = [[UIWebView alloc] initWithFrame: CGRectMake(SPLITVIEWMAINVIEWWIDTH + SPLITVIEWDIVIDERWIDTH, TOOLBARHEIGHTIPAD, self.view.frame.size.width - SPLITVIEWMAINVIEWWIDTH - SPLITVIEWDIVIDERWIDTH, self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT)];
    self.descriptionDetailView.backgroundColor = [UIColor clearColor];
    [self.descriptionDetailView setOpaque: NO];
    self.descriptionDetailView.delegate = self;
    
    [[self.descriptionDetailView scrollView] setBounces: YES];
    
    for (id subview in self.descriptionDetailView.subviews)
        if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
            for (UIView *scrollSubview in [subview subviews])
                if ([[scrollSubview class] isSubclassOfClass:[UIImageView class]])
                    scrollSubview.hidden = YES;
        }
    
    [self.view addSubview: self.descriptionDetailView];
    
    
    //CGFloat targetHeight = self.view.frame.size.height - TOOLBARHEIGHTIPAD - TABBARHEIGHT;
    //NSLog(@"Th: %.1f vs %.1f, %.1f", targetHeight, self.delayInfoTableView.frame.size.height, self.descriptionDetailView.frame.size.height);
    
    // Top infoview
    CGRect viewFrameInfo = self.view.frame;
    int startPositionInfoView = (viewFrameInfo.size.width - 350) / 2;
    int infoViewWidth = 350;
    self.topInfoView = [[UIView alloc] initWithFrame:CGRectMake(startPositionInfoView, 0, infoViewWidth, TOOLBARHEIGHTIPAD)];
    self.topInfoView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.topInfoView.backgroundColor = [UIColor clearColor];
    self.topInfoView.userInteractionEnabled = NO;
    self.topInfoView.alpha = 0.0;
    
    //CGRect viewFrame = self.topInfoView.frame;
    int startPosition = 0;
    int labelWith = 350;
    
    self.lastUpdateLabel = [[UILabel alloc] initWithFrame: CGRectMake(startPosition, 10, labelWith, 14)];
    self.lastUpdateLabel.font = [UIFont boldSystemFontOfSize: 14.0];
    self.lastUpdateLabel.textColor = [UIColor connectionsJourneyDetailViewBottomInfoViewMapTextColor];
    self.lastUpdateLabel.backgroundColor = [UIColor clearColor];
    self.lastUpdateLabel.textAlignment = NSTextAlignmentCenter;
    [self.topInfoView addSubview:self.lastUpdateLabel];
    
    [self.view addSubview: self.statusToolBar];
    
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
        
    [self.view addSubview: self.topInfoView];
}

- (void) updateTopInfoView {
    int startPositionInfoView = (self.view.frame.size.width - 350) / 2;
    int infoViewWidth = 350;
    self.topInfoView.frame = CGRectMake(startPositionInfoView, 0, infoViewWidth, TOOLBARHEIGHTIPAD);
    
    self.topInfoView.alpha = 1.0;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setDateFormat:@"HH:mm dd/MM/YYYY"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *dateString = [dateFormatter stringFromDate: [NSDate date]];
    self.lastUpdateLabel.text = [NSString stringWithFormat: @"%@ %@",  NSLocalizedString(@"Last update:", @"Rss info last update text"), dateString];
    self.topInfoView.alpha = 1.0;
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

-(void) cancelCurrentRunningRequestsIfAny {
    if ([[SBBAPIController sharedSBBAPIController] rssreqRequestInProgress]) {
        [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIRSSOperations];
    }
    
    [self hideLoadingIndicator];
}

- (void) getSBBRssFeedInfoUpdate {
    
    [self cancelCurrentRunningRequestsIfAny];
    
    //[self.activityIndicatorView startAnimating];
    //self.activityIndicatorView.alpha = 1.0;
    //self.delayInfoTableView.alpha = 0.0;
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable)
    {
        //UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        [[NoticeviewMessages sharedNoticeMessagesController] showNoNetworkErrorMessage: self.view];
        
        return;
    }
    
    NSString *languageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSUInteger apiLanguageCode = reqEnglish;
    if ([languageCode isEqualToString:@"en"]) {
        apiLanguageCode = reqEnglish;
    } else if ([languageCode isEqualToString:@"de"]) {
        apiLanguageCode = reqGerman;
    } else if ([languageCode isEqualToString:@"fr"]) {
        apiLanguageCode = reqFrench;
    } else if ([languageCode isEqualToString:@"it"]) {
        apiLanguageCode = reqItalian;
    }
    
    [[SBBAPIController sharedSBBAPIController] getSbbRssXMLInfoRequest: apiLanguageCode
                                                          successBlock: ^(NSUInteger numberofresults){
                                                              //[self.activityIndicatorView stopAnimating];
                                                              //self.activityIndicatorView.alpha = 0.0;
                                                              //self.delayInfoTableView.alpha = 1.0;
                                                              
                                                              [self topPullToLoadNewResultsCompleted];
                                                              
                                                              if (numberofresults > 0) {
                                                                  [self.delayInfoTableView reloadData];
                                                                  [self updateTopInfoView];
                                                              } else {
                                                                  [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqDidNotReturnAnyResultNotice: self.view];
                                                              }
                                                          }
                                                          failureBlock:^(NSUInteger errorcode){
                                                              //[self.activityIndicatorView stopAnimating];
                                                              //self.activityIndicatorView.alpha = 0.0;
                                                              [self topPullToLoadNewResultsCompleted];
                                                              
                                                              //NSUInteger kConReqRequestFailureConnectionFailed = 85;
                                                              //NSUInteger kConScrRequestFailureConnectionFailed = 45;
                                                              //NSUInteger kStbReqRequestFailureConnectionFailed = 75;
                                                              //NSUInteger kStbScrRequestFailureConnectionFailed = 51;
                                                              //NSUInteger kJrnReqRequestFailureConnectionFailed = 65;
                                                              //NSUInteger kRssReqRequestFailureConnectionFailed = 95;
                                                              //NSUInteger kRssReqRequestFailureCancelled = 9955;
                                                              
                                                              //NSUInteger kSbbReqStationsNotDefined = 112;
                                                              
                                                              if (errorcode == kRssReqRequestFailureConnectionFailed) {
                                                                  [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqFailedNotice:self.view];
                                                              } else if (errorcode == kRssReqRequestFailureCancelled) {
                                                                  // Nothing to do
                                                              } else {
                                                                  [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqOtherUndefinedErrorNotice:self.view];
                                                              }
                                                              
                                                          }];
}

- (void) getSBBRssFeedInfo {
    
    [self cancelCurrentRunningRequestsIfAny];
    
    //[self.activityIndicatorView startAnimating];
    //self.activityIndicatorView.alpha = 1.0;
    ///self.delayInfoTableView.alpha = 0.0;
    
    [self showLoadingIndicator];
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable)
    {
        [self hideLoadingIndicator];
        
        //UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        [[NoticeviewMessages sharedNoticeMessagesController] showNoNetworkErrorMessage: self.view];
        
        return;
    }
    
    NSString *languageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSUInteger apiLanguageCode = reqEnglish;
    if ([languageCode isEqualToString:@"en"]) {
        apiLanguageCode = reqEnglish;
    } else if ([languageCode isEqualToString:@"de"]) {
        apiLanguageCode = reqGerman;
    } else if ([languageCode isEqualToString:@"fr"]) {
        apiLanguageCode = reqFrench;
    } else if ([languageCode isEqualToString:@"it"]) {
        apiLanguageCode = reqItalian;
    }
    
    [[SBBAPIController sharedSBBAPIController] getSbbRssXMLInfoRequest: apiLanguageCode
                                                          successBlock: ^(NSUInteger numberofresults){
                                                              [self hideLoadingIndicator];
                                                              //[self topPullToLoadNewResultsCompleted];
                                                              
                                                              if (numberofresults > 0) {
                                                                  [self.delayInfoTableView reloadData];
                                                                  [self updateTopInfoView];
                                                                  [self.delayInfoTableView selectRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection:0] animated: YES scrollPosition: UITableViewScrollPositionTop];
                                                                  RssInfoItem *rssInfoItem = [[SBBAPIController sharedSBBAPIController] getSbbRssInfoResultWithIndex: 0];
                                                                  
                                                                  [self loadDescriptionIntoDetailView: rssInfoItem];
                                                              } else {
                                                                  [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqDidNotReturnAnyResultNotice: self.view];
                                                              }
                                                          }
                                                          failureBlock:^(NSUInteger errorcode){
                                                              [self hideLoadingIndicator];
                                                              //[self topPullToLoadNewResultsCompleted];
                                                              
                                                              //NSUInteger kConReqRequestFailureConnectionFailed = 85;
                                                              //NSUInteger kConScrRequestFailureConnectionFailed = 45;
                                                              //NSUInteger kStbReqRequestFailureConnectionFailed = 75;
                                                              //NSUInteger kStbScrRequestFailureConnectionFailed = 51;
                                                              //NSUInteger kJrnReqRequestFailureConnectionFailed = 65;
                                                              //NSUInteger kRssReqRequestFailureConnectionFailed = 95;
                                                              //NSUInteger kRssReqRequestFailureCancelled = 9955;
                                                              
                                                              //NSUInteger kSbbReqStationsNotDefined = 112;
                                                              
                                                              if (errorcode == kRssReqRequestFailureConnectionFailed) {
                                                                  [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqFailedNotice:self.view];
                                                              } else if (errorcode == kRssReqRequestFailureCancelled) {
                                                                  // Nothing to do
                                                              } else {
                                                                  [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqOtherUndefinedErrorNotice:self.view];
                                                              }
                                                          }];
}

- (void) updatesbbrssinfoResult:(id)sender {
    [self getSBBRssFeedInfo];
}

- (void) showSbbReqDidNotReturnAnyResultNotice {
    [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqDidNotReturnAnyResultNotice: self.view];
}

- (void) showSbbReqFailedNotice {
    [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqFailedNotice: self.view];
}

- (void) showSbbReqStationsNotAvailableNotice {
    [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqStationsNotAvailableNotice: self.view];
}

- (void) showSbbReqOtherUndefinedErrorNotice {
    [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqOtherUndefinedErrorNotice: self.view];
}

#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([[SBBAPIController sharedSBBAPIController] sbbrssinfoResult]) {
        #ifdef LOGOUTPUTON
        NSLog(@"Rss info, number of rowns: %d", [[SBBAPIController sharedSBBAPIController] getNumberOfSbbRssInfoResults]);
        #endif
        
        return [[SBBAPIController sharedSBBAPIController] getNumberOfSbbRssInfoResults];
    }
    return 0;
}

- (NSString *) shortenTitleIfTooLong:(NSString *)stationName maxLenth:(NSUInteger)maxLength {
    if (!stationName) return  nil; if (maxLength == 0) return  nil;
    NSString *shortenStationName;
    if ([stationName length] > maxLength) {
        shortenStationName = [stationName substringToIndex: maxLength - 3];
        return [NSString stringWithFormat:@"%@...", shortenStationName];
    }
    return stationName;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    RssInfoCell *rssCell = (RssInfoCell *)cell;
    
    RssInfoItem *rssInfoItem = [[SBBAPIController sharedSBBAPIController] getSbbRssInfoResultWithIndex: indexPath.row];
    rssCell.titleLabel.text = [self shortenTitleIfTooLong: rssInfoItem.title maxLenth: 46];
    //[rssCell setRssTitleLabelText: rssInfoItem.title];
    //rssCell.dateLabel.text = rssInfoItem.pubdatestring;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"Dequeue rss cell");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RssInfoCell"];
    
    [self configureCell: cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
#ifdef LOGOUTPUTON
    NSLog(@"Rss feed did select cell: %d", indexPath.row);
#endif
    
    //[tableView deselectRowAtIndexPath: indexPath animated: YES];
    RssInfoItem *rssInfoItem = [[SBBAPIController sharedSBBAPIController] getSbbRssInfoResultWithIndex: indexPath.row];
    
    self.descriptionDetailView.alpha = 0.0;
    
    [self loadDescriptionIntoDetailView: rssInfoItem];

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

//--------------------------------------------------------------------------------

- (void) addHeaderviewToTableView:(RssHeaderView *)headerView
{
    if (!self.delayInfoTableView)
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
        
        [self.delayInfoTableView addSubview:self.headerView];
    }
}

- (void) topPullToRefreshTriggered
{
    
#ifdef LOGOUTPUTON
    NSLog(@"Top pull to load triggered");
#endif
    
    self.isLoadingMoreTop = YES;
    
    [self getSBBRssFeedInfoUpdate];
}

- (void) topPullToLoadNewResultsCompleted
{
    
#ifdef LOGOUTPUTON
    NSLog(@"Top pull to load completed");
#endif
    
    self.isLoadingMoreTop = NO;
    
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.delayInfoTableView.contentInset = UIEdgeInsetsZero;
    }];
    
    [self.headerView changeStateOfControl:MNMBottomPullToRefreshViewStateIdle offset:CGFLOAT_MAX];
    
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.isLoadingMoreTop)
        return;
    
    self.initialContentOffset = scrollView.contentOffset.y;
    
    self.isDragging = YES;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isDragging) {
        //NSLog(@"Scroll view did scoll. Is dragging");
        
        CGPoint currentOffset = scrollView.contentOffset;
        //if (currentOffset.y < self.initialContentOffset) {
        //NSLog(@"Scroll view did scoll. Is dragging up");
        
        if (!self.isLoadingMoreTop && ![self.headerView isHidden]) {
            //NSLog(@"Is dragging header view");
            CGFloat offset = scrollView.contentOffset.y;
            
            if (offset >= 0.0f) {
                //NSLog(@"Is dragging header view. State idle");
                [self.headerView changeStateOfControl:MNMBottomPullToRefreshViewStateIdle offset:offset];
                
            } else if (offset >= 0 - [self.headerView fixedHeight]) {
                //NSLog(@"Is dragging header view. State pull");
                [self.headerView changeStateOfControl:MNMBottomPullToRefreshViewStatePull offset:offset];
                
            } else {
                //NSLog(@"Is dragging header view. State load more.");
                [self.headerView changeStateOfControl:MNMBottomPullToRefreshViewStateRelease offset:offset];
            }
            
        }
        //}
        self.initialContentOffset = currentOffset.y;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isDragging = NO;
    
    CGFloat offset = scrollView.contentOffset.y;
    
    if (scrollView.contentOffset.y <= 0 - [self.headerView fixedHeight]) {
        if (self.isLoadingMoreTop || [self.headerView isHidden])
            return;
        
        #ifdef LOGOUTPUTON
        NSLog(@"Trigger top load more");
        #endif
        
        [self topPullToRefreshTriggered];
        
        [self.headerView changeStateOfControl:MNMBottomPullToRefreshViewStateLoading offset:offset];
        
        [UIView animateWithDuration:0.3 animations:^(void) {
            //NSLog(@"Top load more inset animation");
            self.delayInfoTableView.contentInset = UIEdgeInsetsMake([self.headerView fixedHeight], 0, 0, 0);
        }];
    }
}

- (void) loadDescriptionIntoDetailView:(RssInfoItem *)rssinfoitem {
    //NSLog(@"Item: %@, %@, %@", rssinfoitem.pubdatestring, rssinfoitem.title, rssinfoitem.description);
    
    if (self.rsshtmlsource) {
        NSString *htmlstring = [self.rsshtmlsource copy];
        
        htmlstring = [htmlstring stringByReplacingOccurrencesOfString: @"ITEM_TITLE" withString: rssinfoitem.title];
        
        if (rssinfoitem.pubdatestring) {
            htmlstring = [htmlstring stringByReplacingOccurrencesOfString: @"ITEM_PUBDATE" withString: rssinfoitem.pubdatestring];
        } else {
            htmlstring = [htmlstring stringByReplacingOccurrencesOfString: @"ITEM_PUBDATE" withString: @"-"];
        }
        if (rssinfoitem.description) {
            htmlstring = [htmlstring stringByReplacingOccurrencesOfString: @"ITEM_DESCRIPTION" withString: rssinfoitem.description];
        } else {
            htmlstring = [htmlstring stringByReplacingOccurrencesOfString: @"ITEM_DESCRIPTION" withString: rssinfoitem.title];
        }
        
        [self.descriptionDetailView loadHTMLString: htmlstring baseURL: nil];
    } else {
        [self.descriptionDetailView loadHTMLString: rssinfoitem.description baseURL: nil];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIView animateWithDuration: 0.3 animations: ^{ self.descriptionDetailView.alpha = 1.0;}];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"RssTransportNewsContainerViewControlleriPad: should autororate");
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"RssTransportNewsContainerViewControlleriPad: willAnimateRotateToInterfaceOrientation");
    //[self layoutSubviews: YES toInterfaceOrientation: [[UIDevice currentDevice] orientation]];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	NSLog(@"RssTransportNewsContainerViewControlleriPad: willRotateToInterfaceOrientation");
    //[self layoutSubviews: YES toInterfaceOrientation: [[UIDevice currentDevice] orientation]];
    //[self.bookCollectionViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"RssTransportNewsContainerViewControlleriPad: didRotateToInterfaceOrientation");
    //[self.bookCollectionViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
        
    [self getSBBRssFeedInfo];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    //[self layoutSubviews: NO toInterfaceOrientation: [[UIDevice currentDevice] orientation]];
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

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"RssTransportNewsContainerViewController: did receive memory warning.");
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
    NSLog(@"RSS Container controller selected from tabbar");
    #endif
}

@end
