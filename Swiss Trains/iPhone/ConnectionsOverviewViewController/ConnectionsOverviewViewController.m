//
//  ConnectionsOverviewViewController.m
//  Swiss Trains
//
//  Created by Alain on 06.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "ConnectionsOverviewViewController.h"

#define DEFAULT_HEIGHT_OFFSET 52.0f

@interface ConnectionsOverviewViewController ()

@end

@implementation ConnectionsOverviewViewController

//--------------------------------------------------------------------------------

/*
@synthesize headerView;
@synthesize footerView;

@synthesize isDragging;
@synthesize isRefreshing;
@synthesize isLoadingMore;

@synthesize canLoadMore;

@synthesize pullToRefreshEnabled;

@synthesize clearsSelectionOnViewWillAppear;
*/

//--------------------------------------------------------------------------------

- (id)initWithFrame:(CGRect)viewFrame
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.view.frame = viewFrame;
        self.selectedIndex = -1;
        
        //self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        self.view.backgroundColor = [UIColor listviewControllersBackgroundColor];
        
        self.overViewTableView = [[UITableView alloc] initWithFrame: self.view.bounds style:UITableViewStylePlain];
        self.overViewTableView.rowHeight = 142;
        //self.overViewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.overViewTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.overViewTableView.separatorColor = [UIColor lightGrayColor];
        //self.overViewTableView.backgroundColor = [UIColor overviewTableviewBackgroundColor];
        self.overViewTableView.backgroundColor = [UIColor clearColor];
        //self.overViewTableView.backgroundColor = [UIColor blackColor];
        [self.overViewTableView registerClass:[ConnectionsOverviewCell class] forCellReuseIdentifier: @"ConnectionsOverviewCell"];
        [self.view addSubview: self.overViewTableView];
        self.overViewTableView.dataSource = self;
        self.overViewTableView.delegate = self;
    }
    return self;
}

- (void) loadView {
    CGSize size = [UIApplication currentScreenSize];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, size.height - TOOLBARHEIGHT)];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = view;
}

- (void) adjustTableViewHeightWithRect:(CGRect)rect reload:(BOOL)reload {
    CGRect tableFrame = self.overViewTableView.frame;
    tableFrame.size.height = rect.size.height;
    self.overViewTableView.frame = tableFrame;
    if (reload) {
        [self.overViewTableView reloadData];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.selectedIndex = -1;
        
        //self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        self.view.backgroundColor = [UIColor listviewControllersBackgroundColor];
        
        self.overViewTableView = [[UITableView alloc] initWithFrame: self.view.bounds style:UITableViewStylePlain];
        self.overViewTableView.rowHeight = 142;
        //self.overViewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.overViewTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.overViewTableView.separatorColor = [UIColor lightGrayColor];
        //self.overViewTableView.backgroundColor = [UIColor overviewTableviewBackgroundColor];
        self.overViewTableView.backgroundColor = [UIColor clearColor];
        //self.overViewTableView.backgroundColor = [UIColor blackColor];
        [self.overViewTableView registerClass:[ConnectionsOverviewCell class] forCellReuseIdentifier: @"ConnectionsOverviewCell"];
        [self.view addSubview: self.overViewTableView];
        self.overViewTableView.dataSource = self;
        self.overViewTableView.delegate = self;
        
        //-----------------
        self.headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
        self.footerView = [[FooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
        [self addHeaderviewToTableView: self.headerView];
        [self addFooterviewToTableView: self.footerView];
        [self relocateFooterView];
        //-----------------
    }
    return self;
}

- (void) moveTableviewToToRow {
    if ([self.overViewTableView numberOfRowsInSection: 0] > 0) {
        [self.overViewTableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection: 0] atScrollPosition: UITableViewScrollPositionTop animated: NO];
    }
}

#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if ([[SBBAPIController sharedSBBAPIController] getConnectionResults]) {
        //NSLog(@"Overview, number of rowns: %d", [[SBBAPIController sharedSBBAPIController] getNumberOfConnectionResults]);
        return [[SBBAPIController sharedSBBAPIController] getNumberOfConnectionResults];
    }
    return 0;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    ConOverview *overView = [[SBBAPIController sharedSBBAPIController] getOverviewForConnectionResultWithIndex: indexPath.row];
    ConSection *conSection = [[SBBAPIController sharedSBBAPIController] getConsectionForConnectionResultWithIndexAndConsectionIndex: indexPath.row consectionIndex: 0];
    ConSection *lastConSection = [[SBBAPIController sharedSBBAPIController] getLastConsectionForConnectionResultWithIndex: indexPath.row];
        
    ConnectionsOverviewCell *overViewCell = (ConnectionsOverviewCell *)cell;
    //if (NO) {
    if ([overView getHoursFromDuration] > 0) {
        NSString *durationHours = [overView getHoursStringFromDuration];
        //NSString *durationHours = @"02";
        NSString *durationMinutes = [overView getMinutesStringFromDuration];
        //overViewCell.timeLabelHoursSmall.text = [NSString stringWithFormat: @"%@H", durationHours];
        //overViewCell.timeLabelMinutesSmall.text = [NSString stringWithFormat: @"%@M", durationMinutes];
        overViewCell.timeLabelHoursSmall.text = [NSString stringWithFormat: @"%@", durationHours];
        overViewCell.timeLabelMinutesSmall.text = [NSString stringWithFormat: @"%@", durationMinutes];
        overViewCell.timeLabelHoursSmallTitle.text = [NSLocalizedString(@"Hrs", @"Overviewcell minutes title") uppercaseString];
        overViewCell.timeLabelMinutesSmallTitle.text = [NSLocalizedString(@"Min", @"Overviewcell minutes title") uppercaseString];
        overViewCell.timeLabelMinutesBig.text = @"";
        overViewCell.timeLabelMinutesBigTitle.text = @"";
    } else {
        NSString *duration = [overView getMinutesStringFromDuration];
        overViewCell.timeLabelHoursSmall.text = @"";
        overViewCell.timeLabelMinutesSmall.text = @"";
        overViewCell.timeLabelHoursSmallTitle.text = @"";
        overViewCell.timeLabelMinutesSmallTitle.text = @"";
        overViewCell.timeLabelMinutesBig.text = duration;
        overViewCell.timeLabelMinutesBigTitle.text = [NSLocalizedString(@"Minutes", @"Overviewcell minutes title") uppercaseString];
    }
    overViewCell.changesLabel.text = [overView transfers];

    BOOL ConnectionHasInfo = [[SBBAPIController sharedSBBAPIController] ConnectionResultWithIndexHasInfos: indexPath.row];
    [overViewCell setConnectionInfoImageStateVisible: ConnectionHasInfo];
    
    //overViewCell.departureTimeLabel.text = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForOverview: overView];
    overViewCell.departureTimeLabel.text = [[SBBAPIController sharedSBBAPIController] getDepartureTimeForConsection: conSection];
    overViewCell.arrivalTimeLabel.text = [[SBBAPIController sharedSBBAPIController] getArrivalTimeForConsection: lastConSection];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 142;
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
	// only when gesture was recognized, not when ended
	if (gesture.state == UIGestureRecognizerStateBegan)
	{
		// get affected cell
		UITableViewCell *cell = (UITableViewCell *)[gesture view];
        
		// get indexPath of cell
		NSIndexPath *indexPath = [self.overViewTableView indexPathForCell:cell];
        
		// do something with this action
        
        #ifdef LOGOUTPUTON
		NSLog(@"Overview: Long-pressed cell at row %@", indexPath);
        #endif
                
        if (self.delegate && [self.delegate respondsToSelector:@selector(didTriggerOverviewCellWithIndexLongPress:index:)])
        {
            [self.delegate didTriggerOverviewCellWithIndexLongPress:self index: indexPath.row];
        }
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"Dequeue overview cell");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConnectionsOverviewCell"];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPressGesture.minimumPressDuration = 1.0;
    [cell addGestureRecognizer:longPressGesture];

    [self configureCell: cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    #ifdef LOGOUTPUTON
    NSLog(@"OverviewTableview did select cell: %d", indexPath.row);
    #endif
    
    self.selectedIndex = indexPath.row;
    //[self.detailViewTableView reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectOverviewCellWithIndex:index:)])
	{
        [self.delegate didSelectOverviewCellWithIndex:self index: indexPath.row];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([[[[SBBAPIController sharedSBBAPIController] connectionsResult] conResults] count] > 0) {
        [self.overViewTableView reloadData];
        [self performSelector:@selector(relocateFooterView) withObject:nil afterDelay:2.0f];
        if (self.selectedIndex < 0) {
            self.selectedIndex = 0;
            [self.overViewTableView selectRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection:0] animated: YES scrollPosition:UITableViewScrollPositionNone];
            //[self.detailViewTableView reloadData];
        } else {
            [self.overViewTableView selectRowAtIndexPath: [NSIndexPath indexPathForRow: self.selectedIndex inSection:0] animated: YES scrollPosition:UITableViewScrollPositionNone];
            //[self.detailViewTableView reloadData];
        }
        
    }
}

- (void) selectOverviewCellWithIndex:(NSUInteger)index {
    
}

- (void) adjustForViewWillAppear {

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self.overViewTableView reloadData];
}

- (void) adjustForViewWillDisappear {

}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//--------------------------------------------------------------------------------

- (void) addHeaderviewToTableView:(HeaderView *)headerView
{
    if (!self.overViewTableView)
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
        
        [self.overViewTableView addSubview:self.headerView];
    }
}

- (void) addFooterviewToTableView:(FooterView *)footerView
{
    if (!self.overViewTableView)
        return;
    
    /*
    self.overViewTableView.tableFooterView = nil;
    self.footerView = nil;
    */
    
    if (footerView) {
        //self.footerView = (FooterView *)footerView;
        
        CGRect f = self.footerView.frame;
        self.footerView.frame = CGRectMake(f.origin.x, self.overViewTableView.contentSize.height, f.size.width, f.size.height);
        self.footerViewFrame = self.footerView.frame;
        
        [self.overViewTableView addSubview:self.footerView];
    }
}

-(int) heightForCellAtIndexPath: (NSIndexPath *) indexPath {
    
    UITableViewCell *cell =  [self.overViewTableView cellForRowAtIndexPath:indexPath];
    int cellHeight   =  cell.frame.size.height;
    return cellHeight;
}

-(void) updateTableWithNewRowCountAtTop : (int) rowCount
{
    #ifdef LOGOUTPUTON
    NSLog(@"update tableview at top");
    #endif
    
    NSUInteger apinumberofresults = [[SBBAPIController sharedSBBAPIController] getNumberOfConnectionResults];
    NSUInteger tablenumberofresults = [self.overViewTableView numberOfRowsInSection: 0];
    if (apinumberofresults != (tablenumberofresults + rowCount)) {
        #ifdef LOGOUTPUTON
        NSLog(@"Update tableview at top. Api and tableview rows don't match. Just reload. %d, %d, %d", apinumberofresults, tablenumberofresults, rowCount);
        #endif
        
        self.overViewTableView.contentInset = UIEdgeInsetsZero;
        [self.overViewTableView reloadData];
        [self relocateHeaderView];
        
        return;
    }
    
    //[self.headerView removeFromSuperview];
    
    //Save the tableview content offset
    CGPoint tableViewOffset = [self.overViewTableView contentOffset];
    
    //Turn of animations for the update block
    //to get the effect of adding rows on top of TableView
    [UIView setAnimationsEnabled:NO];
    
    [self.overViewTableView beginUpdates];
    
    NSMutableArray *rowsInsertIndexPath = [[NSMutableArray alloc] init];
    
    int heightForNewRows = 0;
    
    for (NSInteger i = 0; i < rowCount; i++) {
        
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection: 0];
        [rowsInsertIndexPath addObject:tempIndexPath];
        
        heightForNewRows = heightForNewRows + [self heightForCellAtIndexPath: [NSIndexPath indexPathForRow:0 inSection: 0]];
    }
    
    [self.overViewTableView insertRowsAtIndexPaths:rowsInsertIndexPath withRowAnimation:UITableViewRowAnimationNone];
    
    tableViewOffset.y += heightForNewRows;
    
    [self.overViewTableView endUpdates];
    
    self.overViewTableView.contentInset = UIEdgeInsetsZero;
    
    [UIView setAnimationsEnabled:YES];
    
    [self.overViewTableView setContentOffset:tableViewOffset animated:NO];
    
    [self relocateFooterView];
    
    /*
    CGPoint savedOffset = [self.overViewTableView contentOffset];
    [self.overViewTableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection: 0] atScrollPosition: UITableViewScrollPositionTop animated: YES];
    [self.overViewTableView setContentOffset: savedOffset animated: YES];
    */
}

-(void) updateTableWithNewRowCountAtBottom : (int) rowCount
{
    #ifdef LOGOUTPUTON
    NSLog(@"update tableview at bottom");
    #endif
    
    NSUInteger apinumberofresults = [[SBBAPIController sharedSBBAPIController] getNumberOfConnectionResults];
    NSUInteger tablenumberofresults = [self.overViewTableView numberOfRowsInSection: 0];
    if (apinumberofresults != (tablenumberofresults + rowCount)) {
        #ifdef LOGOUTPUTON
        NSLog(@"Update tableview at bottom. Api and tableview rows don't match. Just reload. %d, %d, %d", apinumberofresults, tablenumberofresults, rowCount);
        #endif
        
        self.overViewTableView.contentInset = UIEdgeInsetsZero;
        [self.overViewTableView reloadData];
        [self relocateFooterView];
        
        return;
    }
    
    //Save the tableview content offset
    CGPoint tableViewOffset = [self.overViewTableView contentOffset];
    CGSize tableViewSize = [self.overViewTableView contentSize];
    
    //Turn of animations for the update block
    //to get the effect of adding rows on top of TableView
    [UIView setAnimationsEnabled:NO];
    
    [self.overViewTableView beginUpdates];
    
    NSMutableArray *rowsInsertIndexPath = [[NSMutableArray alloc] init];
    
    int heightForNewRows = 0;
    
    NSUInteger numberofRowsNow = [self.overViewTableView numberOfRowsInSection: 0];
    
    for (NSInteger i = numberofRowsNow; i < numberofRowsNow + rowCount; i++) {
        
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection: 0];
        [rowsInsertIndexPath addObject:tempIndexPath];
        
        heightForNewRows = heightForNewRows + [self heightForCellAtIndexPath:tempIndexPath];
    }
    
    [self.overViewTableView insertRowsAtIndexPaths:rowsInsertIndexPath withRowAnimation:UITableViewRowAnimationNone];
    
    tableViewSize.height += heightForNewRows;
    
    [self.overViewTableView endUpdates];
    
    
    CGFloat yOrigin = 0.0f;
    
    if (tableViewSize.height >= CGRectGetHeight([self.overViewTableView frame])) {
        
        //NSLog(@"Add rows at botttom. Relocate footer view. Contentsize is higher than height");
        yOrigin = tableViewSize.height;
        
    } else {
        //NSLog(@"Add rows at botttom. Relocate footer view. Contentsize is smaller than height");
        yOrigin = CGRectGetHeight([self.overViewTableView frame]);
    }
    
    yOrigin += [self.footerView fixedHeight];
    
    CGRect frame = [self.footerView frame];
    frame.origin.y = yOrigin;
    [self.footerView setFrame:frame];
    
    [self.footerView removeFromSuperview];
    [self.overViewTableView addSubview:self.footerView];
    
    self.overViewTableView.contentInset = UIEdgeInsetsZero;
    
    [UIView setAnimationsEnabled:YES];
    
    [self.overViewTableView setContentOffset:tableViewOffset animated:NO];
}

- (void) topPullToLoadNewResultsTriggered
{
    #ifdef LOGOUTPUTON
    NSLog(@"Top pull to load triggered");
    #endif
    
    self.isLoadingMoreTop = YES;
        
    //[self performSelector:@selector(topPullToLoadNewResultsCompleted) withObject:nil afterDelay:2.0f];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTriggerLoadMoreTop)])
	{
        [self.delegate didTriggerLoadMoreTop];
	}
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
    
    [self.headerView changeStateOfControl:MNMBottomPullToRefreshViewStateIdle offset:CGFLOAT_MAX];
    
}

- (void)bottomPullToLoadNewResultsTriggered {
    
    #ifdef LOGOUTPUTON
    NSLog(@"Bottom pull to load triggered");
    #endif
    
    self.isLoadingMoreBottom = YES;
    
    //[self performSelector:@selector(bottomPullToLoadNewResultsCompleted) withObject:nil afterDelay:2.0f];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTriggerLoadMoreBottom)])
	{
        [self.delegate didTriggerLoadMoreBottom];
	}
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
    
    [self.footerView changeStateOfControl:MNMBottomPullToRefreshViewStateIdle offset:CGFLOAT_MAX];
}

- (void) resetTopLoadMoreViewWithNewRowsCount:(NSUInteger)rowsCount {
    [self topPullToLoadNewResultsCompleted];
    //[self.overViewTableView setNeedsDisplay];
    //[self.overViewTableView reloadData];
    if (rowsCount > 0) {
        [self updateTableWithNewRowCountAtTop: rowsCount];
    } else {
        [UIView animateWithDuration:0.3 animations:^(void) {
            self.overViewTableView.contentInset = UIEdgeInsetsZero;
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
            self.overViewTableView.contentInset = UIEdgeInsetsZero;
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
    self.footerView.alpha = 1.0;
    self.headerView.alpha = 1.0;
    
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
                    [self.headerView changeStateOfControl:MNMBottomPullToRefreshViewStateIdle offset:offset];
                    
                } else if (offset >= 0 - [self.headerView fixedHeight]) {
                    //NSLog(@"Is dragging header view. State pull");
                    [self.headerView changeStateOfControl:MNMBottomPullToRefreshViewStatePull offset:offset];
                    
                } else {
                    //NSLog(@"Is dragging header view. State load more.");
                    [self.headerView changeStateOfControl:MNMBottomPullToRefreshViewStateRelease offset:offset];
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
                    [self.footerView changeStateOfControl:MNMBottomPullToRefreshViewStateIdle offset:offset];
                    //[self footerViewDidScroll:NO scrollView:scrollView];
                    
                } else if (offset <= 0.0f && offset >= -[self.footerView fixedHeight]) {
                    //NSLog(@"Is dragging footer view. State pull");
                    [self.footerView changeStateOfControl:MNMBottomPullToRefreshViewStatePull offset:offset];
                    //[self footerViewDidScroll:NO scrollView:scrollView];
                    
                } else {
                    //NSLog(@"Is dragging footer view. State load more.");
                    [self.footerView changeStateOfControl:MNMBottomPullToRefreshViewStateRelease offset:offset];
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
        
        [self.headerView changeStateOfControl:MNMBottomPullToRefreshViewStateLoading offset:offset];
        
        [UIView animateWithDuration:0.3 animations:^(void) {
            //NSLog(@"Top load more inset animation");
            self.overViewTableView.contentInset = UIEdgeInsetsMake([self.headerView fixedHeight], 0, 0, 0);
        }];

    } else if (offset <= 0.0f && offset < height) {
        
        if (self.isLoadingMoreBottom || [self.footerView isHidden])
            return;

        //NSLog(@"Trigger bottom load more");
        [self bottomPullToLoadNewResultsTriggered];
        
        [self.footerView changeStateOfControl:MNMBottomPullToRefreshViewStateLoading offset:offset];
        
        [UIView animateWithDuration:0.3f animations:^{
            
            //NSLog(@"Bottom load more inset animation");
            
            if ([self.overViewTableView contentSize].height >= CGRectGetHeight([self.overViewTableView frame])) {
                
                [self.overViewTableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, -height, 0.0f)];
                
            } else {
                
                [self.overViewTableView setContentInset:UIEdgeInsetsMake(height, 0.0f, 0.0f, 0.0f)];
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
    
    if ([self.overViewTableView contentSize].height < CGRectGetHeight([self.overViewTableView frame])) {
        
        offset = -[self.overViewTableView contentOffset].y;
        
    } else {
        
        offset = ([self.overViewTableView contentSize].height - [self.overViewTableView contentOffset].y) - CGRectGetHeight([self.overViewTableView frame]);
    }
    
    return offset;
}

- (void)relocateHeaderView {
        
    CGFloat height = [self.headerView fixedHeight];
    CGRect frame = [self.headerView frame];
    frame.origin.y = 0 - height;
    [self.headerView setFrame:frame];
    /*
    [UIView animateWithDuration: 0.1 animations: ^{
        
    } completion:^(BOOL finished){}];
    */
    //[self.headerView removeFromSuperview];
    //[self.overViewTableView addSubview:self.headerView];
}

/*
 * Relocate pull-to-refresh view
 */
- (void)relocateFooterView {
    
    CGFloat yOrigin = 0.0f;
    
    //NSLog(@"Relocate footer view. Content height: %.1f, height: %.1f", [self.overViewTableView contentSize].height, CGRectGetHeight([self.overViewTableView frame]));
    
    if ([self.overViewTableView contentSize].height >= CGRectGetHeight([self.overViewTableView frame])) {
        
        //NSLog(@"Relocate footer view. Contentsize is higher than height");
        yOrigin = [self.overViewTableView contentSize].height;
        
    } else {
        //NSLog(@"Relocate footer view. Contentsize is smaller than height");
        yOrigin = CGRectGetHeight([self.overViewTableView frame]);
    }
    
    CGRect frame = [self.footerView frame];
    frame.origin.y = yOrigin;
    [self.footerView setFrame:frame];
    
    
    [self.footerView removeFromSuperview];
    [self.overViewTableView addSubview:self.footerView];
}

/*
 * Sets the pull-to-refresh view visible or not. Visible by default
 */

//#pragma mark -
//#pragma mark Table view scroll management

/*
 * Checks state of control depending on tableView scroll offset
 */
/*
- (void)tableViewScrolled {
    
    if (![self.footerView isHidden] && ![self.footerView isLoading]) {
        
        CGFloat offset = [self tableScrollOffset];
        
        if (offset >= 0.0f) {
            
            [self.footerView changeStateOfControl:MNMBottomPullToRefreshViewStateIdle offset:offset];
            
        } else if (offset <= 0.0f && offset >= -[self.footerView fixedHeight]) {
            
            [self.footerView changeStateOfControl:MNMBottomPullToRefreshViewStatePull offset:offset];
            
        } else {
            
            [self.footerView changeStateOfControl:MNMBottomPullToRefreshViewStateRelease offset:offset];
        }
    }
}
*/
@end






