//
//  PullTableViewHeaderFooterViews.h
//  Swiss Trains
//
//  Created by Alain on 03.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"

typedef enum {
    
    StbPullToRefreshViewStateIdle = 0, //<! The control is invisible right after being created or after a reloading was completed
    StbPullToRefreshViewStatePull, //<! The control is becoming visible and shows "pull to refresh" message
    StbPullToRefreshViewStateRelease, //<! The control is whole visible and shows "release to load" message
    StbPullToRefreshViewStateLoading //<! The control is loading and shows activity indicator
    
} StbPullToRefreshViewState;

typedef enum {
    
    MNMBottomPullToRefreshViewStateIdle = 0, //<! The control is invisible right after being created or after a reloading was completed
    MNMBottomPullToRefreshViewStatePull, //<! The control is becoming visible and shows "pull to refresh" message
    MNMBottomPullToRefreshViewStateRelease, //<! The control is whole visible and shows "release to load" message
    MNMBottomPullToRefreshViewStateLoading //<! The control is loading and shows activity indicator
    
} MNMBottomPullToRefreshViewState;

typedef enum {
    
    RssPullToRefreshViewStateIdle = 0, //<! The control is invisible right after being created or after a reloading was completed
    RssPullToRefreshViewStatePull, //<! The control is becoming visible and shows "pull to refresh" message
    RssPullToRefreshViewStateRelease, //<! The control is whole visible and shows "release to load" message
    RssPullToRefreshViewStateLoading //<! The control is loading and shows activity indicator
    
} RssPullToRefreshViewState;

@interface HeaderView : UIView
@property (nonatomic, strong) UIImageView* headerImageView;
@property (nonatomic, strong) UILabel* headerLabel;
@property (nonatomic, strong) UIActivityIndicatorView  *loadingActivityIndicator;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) CGFloat fixedHeight;
@property (nonatomic, readwrite, assign) MNMBottomPullToRefreshViewState state;
- (void)changeStateOfControl:(MNMBottomPullToRefreshViewState)state offset:(CGFloat)offset;

@end

@interface FooterView : UIView
@property (nonatomic, strong) UIImageView* footerImageView;
@property (nonatomic, strong) UILabel* footerLabel;
@property (nonatomic, strong) UIActivityIndicatorView  *loadingActivityIndicator;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) CGFloat fixedHeight;
@property (nonatomic, readwrite, assign) MNMBottomPullToRefreshViewState state;
- (void)changeStateOfControl:(MNMBottomPullToRefreshViewState)state offset:(CGFloat)offset;
@end

@interface StbHeaderView : UIView
@property (nonatomic, strong) UIImageView* headerImageView;
@property (nonatomic, strong) UILabel* headerLabel;
@property (nonatomic, strong) UIActivityIndicatorView  *loadingActivityIndicator;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) CGFloat fixedHeight;
@property (nonatomic, readwrite, assign) StbPullToRefreshViewState state;
- (void)changeStateOfControl:(StbPullToRefreshViewState)state offset:(CGFloat)offset;
@end

@interface StbFooterView : UIView
@property (nonatomic, strong) UIImageView* footerImageView;
@property (nonatomic, strong) UILabel* footerLabel;
@property (nonatomic, strong) UIActivityIndicatorView  *loadingActivityIndicator;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) CGFloat fixedHeight;
@property (nonatomic, readwrite, assign) StbPullToRefreshViewState state;
- (void)changeStateOfControl:(StbPullToRefreshViewState)state offset:(CGFloat)offset;
@end

@interface RssHeaderView : UIView
@property (nonatomic, strong) UIImageView* headerImageView;
@property (nonatomic, strong) UILabel* headerLabel;
@property (nonatomic, strong) UIActivityIndicatorView  *loadingActivityIndicator;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) CGFloat fixedHeight;
@property (nonatomic, readwrite, assign) RssPullToRefreshViewState state;
- (void)changeStateOfControl:(RssPullToRefreshViewState)state offset:(CGFloat)offset;
@end
