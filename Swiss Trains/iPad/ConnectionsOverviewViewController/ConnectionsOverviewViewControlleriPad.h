//
//  ConnectionsOverviewViewController.h
//  Swiss Trains
//
//  Created by Alain on 06.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"

#import "ConnectionsOverviewCelliPad.h"

#import "SBBAPIController.h"

#import "UIApplication+AppDimension.h"

#import "PullTableViewHeaderFooterViews.h"

@class ConnectionsOverviewViewControlleriPad;
//@class HeaderViewiPad, FooterViewiPad;


@protocol ConnectionsOverviewViewControlleriPadDelegate <NSObject>
- (void)didSelectOverviewCellWithIndex:(ConnectionsOverviewViewControlleriPad *)controller index:(NSUInteger)index;
- (void)didTriggerLoadMoreTop;
- (void)didTriggerLoadMoreBottom;
- (void)didTriggerOverviewCellWithIndexLongPress:(ConnectionsOverviewViewControlleriPad *)controller index:(NSUInteger)index;
@end

@interface ConnectionsOverviewViewControlleriPad : UIViewController  <UITableViewDataSource, UITableViewDelegate> {

//@protected
//    BOOL isDragging;
//    BOOL isRefreshing;
//    BOOL isLoadingMore;
    
    // had to store this because the headerView's frame seems to be changed somewhere during scrolling
    // and I couldn't figure out why >.<
//    CGRect headerViewFrame;
}

@property (strong, nonatomic) UITableView *overViewTableView;

@property (assign) NSInteger selectedIndex;

@property (weak) id <ConnectionsOverviewViewControlleriPadDelegate> delegate;

- (id)initWithFrame:(CGRect)viewFrame;
- (void) selectOverviewCellWithIndex:(NSUInteger)index;

- (void) adjustTableViewHeightWithRect:(CGRect)rect reload:(BOOL)reload;

- (void) moveTableviewToToRow;

//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------

- (void) resetTopLoadMoreViewWithNewRowsCount:(NSUInteger)rowsCount;
- (void) resetBottomLoadMoreViewWithNewRowsCount:(NSUInteger)rowsCount;

// The view used for "pull to refresh"
@property (nonatomic, strong) HeaderView *headerView;

// The view used for "load more"
@property (nonatomic, strong) FooterView *footerView;

//@property (nonatomic, strong) UITableView *tableView;
@property (assign) BOOL isDragging;
@property (assign) BOOL isLoadingMoreBottom;
@property (assign) BOOL isLoadingMoreTop;
//@property (assign) BOOL canLoadMore;

//@property (assign) BOOL pullToRefreshEnabled;

// Defaults to YES
//@property (assign) BOOL clearsSelectionOnViewWillAppear;

@property (assign) CGRect headerViewFrame;
@property (assign) CGRect footerViewFrame;

@property (assign) CGFloat initialContentOffset;
//@property (assign) CGFloat previousContentDelta;

// Just a common initialize method
//- (void) initialize;

#pragma mark - Pull to Refresh

// The minimum height that the user should drag down in order to trigger a "refresh" when
// dragging ends.
//- (CGFloat) headerRefreshHeight;

// Will be called if the user drags down which will show the header view. Override this to
// update the header view (e.g. change the label to "Pull down to refresh").
//- (void) willShowHeaderView:(UIScrollView *)scrollView;

// If the user is dragging, will be called on every scroll event that the headerView is shown.
// The value of willRefreshOnRelease will be YES if the user scrolled down enough to trigger a
// "refresh" when the user releases the drag.
//- (void) headerViewDidScroll:(BOOL)willRefreshOnRelease scrollView:(UIScrollView *)scrollView;
//- (void) footerViewDidScroll:(BOOL)willRefreshOnRelease scrollView:(UIScrollView *)scrollView;

// By default, will permanently show the headerView by setting the tableView's contentInset.
//- (void) pinHeaderView;

// Reverse of pinHeaderView.
//- (void) unpinHeaderView;

// Called when the user stops dragging and, if the conditions are met, will trigger a refresh.
//- (void) willBeginRefresh;

// Override to perform fetching of data. The parent method [super refresh] should be called first.
// If the value is NO, -refresh should be aborted.
//- (void) refresh;

// Call to signal that refresh has completed. This will then hide the headerView.
//- (void) refreshCompleted;

#pragma mark - Load More

// The value of the height starting from the bottom that the user needs to scroll down to in order
// to trigger -loadMore. By default, this will be the height of -footerView.
//- (CGFloat) footerLoadMoreHeight;

// Override to perform fetching of next page of data. It's important to call and get the value of
// of [super loadMore] first. If it's NO, -loadMore should be aborted.
//- (BOOL) loadMore;

// Called when all the conditions are met and -loadMore will begin.
//- (void) willBeginLoadingMore;

// Call to signal that "load more" was completed. This should be called so -isLoadingMore is
// properly set to NO.
//- (void) loadMoreCompleted;

// Helper to show/hide -footerView
//- (void) setFooterViewVisibility:(BOOL)visible;

#pragma mark -

// A helper method that calls refreshCompleted and/or loadMoreCompleted if any are active.
//- (void) allLoadingCompleted;

#pragma mark -

//- (void) releaseViewComponents;

@end

//--------------------------------------------------------------------------------
/*
typedef enum {
    
    MNMBottomPullToRefreshViewStateIdleiPad = 0, //<! The control is invisible right after being created or after a reloading was completed
    MNMBottomPullToRefreshViewStatePulliPad, //<! The control is becoming visible and shows "pull to refresh" message
    MNMBottomPullToRefreshViewStateReleaseiPad, //<! The control is whole visible and shows "release to load" message
    MNMBottomPullToRefreshViewStateLoadingiPad //<! The control is loading and shows activity indicator
    
} MNMBottomPullToRefreshViewStateiPad;

@interface HeaderViewiPad : UIView
@property (nonatomic, strong) UIImageView* headerImageView;
@property (nonatomic, strong) UILabel* headerLabel;
@property (nonatomic, strong) UIActivityIndicatorView  *loadingActivityIndicator;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) CGFloat fixedHeight;
@property (nonatomic, readwrite, assign) MNMBottomPullToRefreshViewStateiPad state;
- (void)changeStateOfControl:(MNMBottomPullToRefreshViewStateiPad)state offset:(CGFloat)offset;

@end

@interface FooterViewiPad : UIView
@property (nonatomic, strong) UIImageView* footerImageView;
@property (nonatomic, strong) UILabel* footerLabel;
@property (nonatomic, strong) UIActivityIndicatorView  *loadingActivityIndicator;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) CGFloat fixedHeight;
@property (nonatomic, readwrite, assign) MNMBottomPullToRefreshViewStateiPad state;
- (void)changeStateOfControl:(MNMBottomPullToRefreshViewStateiPad)state offset:(CGFloat)offset;
@end
*/
