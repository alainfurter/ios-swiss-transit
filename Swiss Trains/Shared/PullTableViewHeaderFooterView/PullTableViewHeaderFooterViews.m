//
//  PullTableViewHeaderFooterViews.m
//  Swiss Trains
//
//  Created by Alain on 03.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "PullTableViewHeaderFooterViews.h"

@implementation HeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //NSLog(@"Headerview: %.1f, %.1f, %.1f, %.1f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width,self.frame.size.height);
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        UIImage *headerImage = [UIImage tableviewArrowImage];
        self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width / 2 - headerImage.size.width / 2, 4, headerImage.size.width, headerImage.size.height)];
        [self.headerImageView setImage: headerImage];
        self.headerLabel = [[UILabel alloc] initWithFrame: CGRectMake(46 + 5, 13, frame.size.width - headerImage.size.width - 46 - 5 + 10, 21)];
        self.headerLabel.backgroundColor = [UIColor clearColor];
        
        //NSLog(@"Headerview: %.1f, %.1f, %.1f, %.1f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width,self.frame.size.height);
        [self addSubview: self.headerImageView];
        [self addSubview: self.headerLabel];
        
        self.loadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.loadingActivityIndicator setCenter:[self center]];
        [self.loadingActivityIndicator setHidesWhenStopped:YES];
        [self.loadingActivityIndicator setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        [self addSubview: self.loadingActivityIndicator];
        
        
        self.fixedHeight = self.frame.size.height;
    }
    return self;
}

- (CGFloat) DegreesToRadians:(CGFloat)degrees {
    return degrees * M_PI / 180;
}
- (CGFloat) RadiansToDegrees:(CGFloat)radians {
    return radians * 180/M_PI;
}

- (void) rotateImageView:(UIImageView*)imageView angle:(CGFloat)angle
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    imageView.transform = CGAffineTransformMakeRotation([self DegreesToRadians:angle]);
    [UIView commitAnimations];
}

- (void)changeStateOfControl:(MNMBottomPullToRefreshViewState)state offset:(CGFloat)offset {
    
    
    self.state = state;
    
    CGFloat height = self.fixedHeight;
    
    switch (state) {
            
        case MNMBottomPullToRefreshViewStateIdle: {
            
            //[iconImageView_ setTransform:CGAffineTransformIdentity];
            //[iconImageView_ setHidden:NO];
            
            [self.loadingActivityIndicator stopAnimating];
            self.headerImageView.alpha = 1.0;
            [self rotateImageView:self.headerImageView angle:180];
            
            //[messageLabel_ setText:MNM_BOTTOM_PTR_PULL_TEXT_KEY];
            
            break;
            
        } case MNMBottomPullToRefreshViewStatePull: {
            
            /*
             if (rotateIconWhileBecomingVisible_) {
             
             CGFloat angle = (-offset * M_PI) / CGRectGetHeight([self frame]);
             
             [iconImageView_ setTransform:CGAffineTransformRotate(CGAffineTransformIdentity, angle)];
             
             } else {
             
             [iconImageView_ setTransform:CGAffineTransformIdentity];
             }
             
             [messageLabel_ setText:MNM_BOTTOM_PTR_PULL_TEXT_KEY];
             */
            self.headerImageView.alpha = 1.0;
            [self rotateImageView:self.headerImageView angle:180];
            
            break;
            
        } case MNMBottomPullToRefreshViewStateRelease: {
            
            //[iconImageView_ setTransform:CGAffineTransformMakeRotation(M_PI)];
            
            //[messageLabel_ setText:MNM_BOTTOM_PTR_RELEASE_TEXT_KEY];
            
            //height = fixedHeight_ + fabs(offset);
            self.headerImageView.alpha = 1.0;
            [self rotateImageView:self.headerImageView angle:0];
            
            break;
            
        } case MNMBottomPullToRefreshViewStateLoading: {
            
            //[iconImageView_ setHidden:YES];
            self.headerImageView.alpha = 0.0;
            [self.loadingActivityIndicator startAnimating];
            
            //[messageLabel_ setText:MNM_BOTTOM_PTR_LOADING_TEXT_KEY];
            
            //height = fixedHeight_ + fabs(offset);
            
            break;
            
        } default:
            break;
    }
    
    CGRect frame = [self frame];
    frame.size.height = height;
    //[self setFrame:frame];
    
    [self setNeedsLayout];
}


@end

@implementation FooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //NSLog(@"Footerview: %.1f, %.1f, %.1f, %.1f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width,self.frame.size.height);
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        UIImage *footerImage = [UIImage tableviewArrowImage];
        self.footerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width / 2 - footerImage.size.width / 2, 4, footerImage.size.width, footerImage.size.height)];
        [self.footerImageView setImage: footerImage];
        self.footerLabel = [[UILabel alloc] initWithFrame: CGRectMake(46 + 5, 13, frame.size.width - footerImage.size.width - 46 - 5 + 10, 21)];
        self.footerLabel.backgroundColor = [UIColor clearColor];
        
        //NSLog(@"Footerview: %.1f, %.1f, %.1f, %.1f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width,self.frame.size.height);
        
        [self addSubview: self.footerImageView];
        [self addSubview: self.footerLabel];
        
        self.loadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.loadingActivityIndicator setCenter:[self center]];
        [self.loadingActivityIndicator setHidesWhenStopped:YES];
        [self.loadingActivityIndicator setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        [self addSubview: self.loadingActivityIndicator];
        
        self.fixedHeight = self.frame.size.height;
    }
    return self;
}

- (CGFloat) DegreesToRadians:(CGFloat)degrees {
    return degrees * M_PI / 180;
}
- (CGFloat) RadiansToDegrees:(CGFloat)radians {
    return radians * 180/M_PI;
}

- (void) rotateImageView:(UIImageView*)imageView angle:(CGFloat)angle
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    imageView.transform = CGAffineTransformMakeRotation([self DegreesToRadians:angle]);
    [UIView commitAnimations];
}

- (void)changeStateOfControl:(MNMBottomPullToRefreshViewState)state offset:(CGFloat)offset {
    
    self.state = state;
    
    CGFloat height = self.fixedHeight;
    
    switch (state) {
            
        case MNMBottomPullToRefreshViewStateIdle: {
            
            //[iconImageView_ setTransform:CGAffineTransformIdentity];
            //[iconImageView_ setHidden:NO];
            
            [self.loadingActivityIndicator stopAnimating];
            self.footerImageView.alpha = 1.0;
            [self rotateImageView:self.footerImageView angle:0];
            
            //[messageLabel_ setText:MNM_BOTTOM_PTR_PULL_TEXT_KEY];
            
            break;
            
        } case MNMBottomPullToRefreshViewStatePull: {
            
            /*
             if (rotateIconWhileBecomingVisible_) {
             
             CGFloat angle = (-offset * M_PI) / CGRectGetHeight([self frame]);
             
             [iconImageView_ setTransform:CGAffineTransformRotate(CGAffineTransformIdentity, angle)];
             
             } else {
             
             [iconImageView_ setTransform:CGAffineTransformIdentity];
             }
             
             [messageLabel_ setText:MNM_BOTTOM_PTR_PULL_TEXT_KEY];
             */
            self.footerImageView.alpha = 1.0;
            [self rotateImageView:self.footerImageView angle:0];
            
            break;
            
        } case MNMBottomPullToRefreshViewStateRelease: {
            
            //[iconImageView_ setTransform:CGAffineTransformMakeRotation(M_PI)];
            
            //[messageLabel_ setText:MNM_BOTTOM_PTR_RELEASE_TEXT_KEY];
            
            //height = fixedHeight_ + fabs(offset);
            
            self.footerImageView.alpha = 1.0;
            [self rotateImageView:self.footerImageView angle:180];
            
            break;
            
        } case MNMBottomPullToRefreshViewStateLoading: {
            
            //[iconImageView_ setHidden:YES];
            
            self.footerImageView.alpha = 0.0;
            [self.loadingActivityIndicator startAnimating];
            
            //[messageLabel_ setText:MNM_BOTTOM_PTR_LOADING_TEXT_KEY];
            
            //height = fixedHeight_ + fabs(offset);
            
            break;
            
        } default:
            break;
    }
    
    CGRect frame = [self frame];
    frame.size.height = height;
    //[self setFrame:frame];
    
    [self setNeedsLayout];
    
}


@end

//--------------------------------------------------------------------------------

@implementation StbHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //NSLog(@"Headerview: %.1f, %.1f, %.1f, %.1f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width,self.frame.size.height);
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        UIImage *headerImage = [UIImage tableviewArrowImage];
        self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 4, headerImage.size.width, headerImage.size.height)];
        [self.headerImageView setImage: headerImage];
        self.headerLabel = [[UILabel alloc] initWithFrame: CGRectMake(46 + 5 + 5, 13, frame.size.width - headerImage.size.width - 46 - 5 - 5 + 10, 21)];
        self.headerLabel.backgroundColor = [UIColor clearColor];
        
        //NSLog(@"Headerview: %.1f, %.1f, %.1f, %.1f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width,self.frame.size.height);
        [self addSubview: self.headerImageView];
        [self addSubview: self.headerLabel];
        
        self.loadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.loadingActivityIndicator setCenter:[[self headerImageView] center]];
        [self.loadingActivityIndicator setHidesWhenStopped:YES];
        [self.loadingActivityIndicator setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        [self addSubview: self.loadingActivityIndicator];
        
        
        self.fixedHeight = self.frame.size.height;
    }
    return self;
}

- (CGFloat) DegreesToRadians:(CGFloat)degrees {
    return degrees * M_PI / 180;
}
- (CGFloat) RadiansToDegrees:(CGFloat)radians {
    return radians * 180/M_PI;
}

- (void) rotateImageView:(UIImageView*)imageView angle:(CGFloat)angle
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    imageView.transform = CGAffineTransformMakeRotation([self DegreesToRadians:angle]);
    [UIView commitAnimations];
}

- (void)changeStateOfControl:(StbPullToRefreshViewState)state offset:(CGFloat)offset {
    
    
    self.state = state;
    
    CGFloat height = self.fixedHeight;
    
    switch (state) {
            
        case StbPullToRefreshViewStateIdle: {
            
            //[iconImageView_ setTransform:CGAffineTransformIdentity];
            //[iconImageView_ setHidden:NO];
            
            [self.loadingActivityIndicator stopAnimating];
            self.headerImageView.alpha = 1.0;
            [self rotateImageView:self.headerImageView angle:180];
            self.headerLabel.text = NSLocalizedString(@"Pull to load", @"Pull to load stb info header cell");
            
            //[messageLabel_ setText:MNM_BOTTOM_PTR_PULL_TEXT_KEY];
            
            break;
            
        } case StbPullToRefreshViewStatePull: {
            
            /*
             if (rotateIconWhileBecomingVisible_) {
             
             CGFloat angle = (-offset * M_PI) / CGRectGetHeight([self frame]);
             
             [iconImageView_ setTransform:CGAffineTransformRotate(CGAffineTransformIdentity, angle)];
             
             } else {
             
             [iconImageView_ setTransform:CGAffineTransformIdentity];
             }
             
             [messageLabel_ setText:MNM_BOTTOM_PTR_PULL_TEXT_KEY];
             */
            self.headerImageView.alpha = 1.0;
            [self rotateImageView:self.headerImageView angle:180];
            self.headerLabel.text = NSLocalizedString(@"Pull to load", @"Pull to load stb info header cell");
            
            break;
            
        } case StbPullToRefreshViewStateRelease: {
            
            //[iconImageView_ setTransform:CGAffineTransformMakeRotation(M_PI)];
            
            //[messageLabel_ setText:MNM_BOTTOM_PTR_RELEASE_TEXT_KEY];
            
            //height = fixedHeight_ + fabs(offset);
            self.headerImageView.alpha = 1.0;
            [self rotateImageView:self.headerImageView angle:0];
            self.headerLabel.text = NSLocalizedString(@"Release to load", @"Release to load stb info header cell");
            
            break;
            
        } case StbPullToRefreshViewStateLoading: {
            
            //[iconImageView_ setHidden:YES];
            self.headerImageView.alpha = 0.0;
            [self.loadingActivityIndicator startAnimating];
            self.headerLabel.text = NSLocalizedString(@"Loading...", @"Loading... stb info header cell");
            
            //[messageLabel_ setText:MNM_BOTTOM_PTR_LOADING_TEXT_KEY];
            
            //height = fixedHeight_ + fabs(offset);
            
            break;
            
        } default:
            break;
    }
    
    CGRect frame = [self frame];
    frame.size.height = height;
    //[self setFrame:frame];
    
    [self setNeedsLayout];
}


@end

@implementation StbFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //NSLog(@"Footerview: %.1f, %.1f, %.1f, %.1f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width,self.frame.size.height);
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        UIImage *footerImage = [UIImage tableviewArrowImage];
        self.footerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 4, footerImage.size.width, footerImage.size.height)];
        [self.footerImageView setImage: footerImage];
        self.footerLabel = [[UILabel alloc] initWithFrame: CGRectMake(46 + 5 + 5, 13, frame.size.width - footerImage.size.width - 46 - 5 - 5 + 10, 21)];
        self.footerLabel.backgroundColor = [UIColor clearColor];
        
        //NSLog(@"Footerview: %.1f, %.1f, %.1f, %.1f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width,self.frame.size.height);
        
        [self addSubview: self.footerImageView];
        [self addSubview: self.footerLabel];
        
        self.loadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.loadingActivityIndicator setCenter:[[self footerImageView] center]];
        [self.loadingActivityIndicator setHidesWhenStopped:YES];
        [self.loadingActivityIndicator setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        [self addSubview: self.loadingActivityIndicator];
        
        self.fixedHeight = self.frame.size.height;
    }
    return self;
}

- (CGFloat) DegreesToRadians:(CGFloat)degrees {
    return degrees * M_PI / 180;
}
- (CGFloat) RadiansToDegrees:(CGFloat)radians {
    return radians * 180/M_PI;
}

- (void) rotateImageView:(UIImageView*)imageView angle:(CGFloat)angle
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    imageView.transform = CGAffineTransformMakeRotation([self DegreesToRadians:angle]);
    [UIView commitAnimations];
}

- (void)changeStateOfControl:(StbPullToRefreshViewState)state offset:(CGFloat)offset {
    
    self.state = state;
    
    CGFloat height = self.fixedHeight;
    
    switch (state) {
            
        case StbPullToRefreshViewStateIdle: {
            
            //[iconImageView_ setTransform:CGAffineTransformIdentity];
            //[iconImageView_ setHidden:NO];
            
            [self.loadingActivityIndicator stopAnimating];
            self.footerImageView.alpha = 1.0;
            [self rotateImageView:self.footerImageView angle:0];
            self.footerLabel.text = NSLocalizedString(@"Pull to load", @"Pull to load stb info header cell");
            
            //[messageLabel_ setText:MNM_BOTTOM_PTR_PULL_TEXT_KEY];
            
            break;
            
        } case StbPullToRefreshViewStatePull: {
            
            /*
             if (rotateIconWhileBecomingVisible_) {
             
             CGFloat angle = (-offset * M_PI) / CGRectGetHeight([self frame]);
             
             [iconImageView_ setTransform:CGAffineTransformRotate(CGAffineTransformIdentity, angle)];
             
             } else {
             
             [iconImageView_ setTransform:CGAffineTransformIdentity];
             }
             
             [messageLabel_ setText:MNM_BOTTOM_PTR_PULL_TEXT_KEY];
             */
            self.footerImageView.alpha = 1.0;
            [self rotateImageView:self.footerImageView angle:0];
            self.footerLabel.text = NSLocalizedString(@"Pull to load", @"Pull to load stb info header cell");
            
            break;
            
        } case StbPullToRefreshViewStateRelease: {
            
            //[iconImageView_ setTransform:CGAffineTransformMakeRotation(M_PI)];
            
            //[messageLabel_ setText:MNM_BOTTOM_PTR_RELEASE_TEXT_KEY];
            
            //height = fixedHeight_ + fabs(offset);
            
            self.footerImageView.alpha = 1.0;
            [self rotateImageView:self.footerImageView angle:180];
            self.footerLabel.text = NSLocalizedString(@"Release to load", @"Release to load stb info header cell");
            
            break;
            
        } case StbPullToRefreshViewStateLoading: {
            
            //[iconImageView_ setHidden:YES];
            
            self.footerImageView.alpha = 0.0;
            [self.loadingActivityIndicator startAnimating];
            self.footerLabel.text = NSLocalizedString(@"Loading...", @"Loading... stb info header cell");
            
            //[messageLabel_ setText:MNM_BOTTOM_PTR_LOADING_TEXT_KEY];
            
            //height = fixedHeight_ + fabs(offset);
            
            break;
            
        } default:
            break;
    }
    
    CGRect frame = [self frame];
    frame.size.height = height;
    //[self setFrame:frame];
    
    [self setNeedsLayout];
}

@end

//--------------------------------------------------------------------------------



@implementation RssHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //NSLog(@"Headerview: %.1f, %.1f, %.1f, %.1f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width,self.frame.size.height);
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        UIImage *headerImage = [UIImage tableviewArrowImage];
        self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 4, headerImage.size.width, headerImage.size.height)];
        [self.headerImageView setImage: headerImage];
        self.headerLabel = [[UILabel alloc] initWithFrame: CGRectMake(46 + 5 + 5, 13, frame.size.width - headerImage.size.width - 46 - 5 - 5 + 10, 21)];
        self.headerLabel.backgroundColor = [UIColor clearColor];
        
        //NSLog(@"Headerview: %.1f, %.1f, %.1f, %.1f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width,self.frame.size.height);
        [self addSubview: self.headerImageView];
        [self addSubview: self.headerLabel];
        
        self.loadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.loadingActivityIndicator setCenter:[[self headerImageView] center]];
        [self.loadingActivityIndicator setHidesWhenStopped:YES];
        [self.loadingActivityIndicator setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        [self addSubview: self.loadingActivityIndicator];
        
        
        self.fixedHeight = self.frame.size.height;
    }
    return self;
}

- (CGFloat) DegreesToRadians:(CGFloat)degrees {
    return degrees * M_PI / 180;
}
- (CGFloat) RadiansToDegrees:(CGFloat)radians {
    return radians * 180/M_PI;
}

- (void) rotateImageView:(UIImageView*)imageView angle:(CGFloat)angle
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    imageView.transform = CGAffineTransformMakeRotation([self DegreesToRadians:angle]);
    [UIView commitAnimations];
}

- (void)changeStateOfControl:(RssPullToRefreshViewState)state offset:(CGFloat)offset {
    
    
    self.state = state;
    
    CGFloat height = self.fixedHeight;
    
    switch (state) {
            
        case RssPullToRefreshViewStateIdle: {
            
            //[iconImageView_ setTransform:CGAffineTransformIdentity];
            //[iconImageView_ setHidden:NO];
            
            [self.loadingActivityIndicator stopAnimating];
            self.headerImageView.alpha = 1.0;
            [self rotateImageView:self.headerImageView angle:180];
            self.headerLabel.text = NSLocalizedString(@"Pull to refresh", @"Pull to refresh rss info header cell");
            
            //[messageLabel_ setText:MNM_BOTTOM_PTR_PULL_TEXT_KEY];
            
            break;
            
        } case RssPullToRefreshViewStatePull: {
            
            /*
             if (rotateIconWhileBecomingVisible_) {
             
             CGFloat angle = (-offset * M_PI) / CGRectGetHeight([self frame]);
             
             [iconImageView_ setTransform:CGAffineTransformRotate(CGAffineTransformIdentity, angle)];
             
             } else {
             
             [iconImageView_ setTransform:CGAffineTransformIdentity];
             }
             
             [messageLabel_ setText:MNM_BOTTOM_PTR_PULL_TEXT_KEY];
             */
            self.headerImageView.alpha = 1.0;
            [self rotateImageView:self.headerImageView angle:180];
            self.headerLabel.text = NSLocalizedString(@"Pull to refresh", @"Pull to refresh rss info header cell");
            
            break;
            
        } case RssPullToRefreshViewStateRelease: {
            
            //[iconImageView_ setTransform:CGAffineTransformMakeRotation(M_PI)];
            
            //[messageLabel_ setText:MNM_BOTTOM_PTR_RELEASE_TEXT_KEY];
            
            //height = fixedHeight_ + fabs(offset);
            self.headerImageView.alpha = 1.0;
            [self rotateImageView:self.headerImageView angle:0];
            self.headerLabel.text = NSLocalizedString(@"Release to refresh", @"Release to refresh rss info header cell");
            
            break;
            
        } case RssPullToRefreshViewStateLoading: {
            
            //[iconImageView_ setHidden:YES];
            self.headerImageView.alpha = 0.0;
            [self.loadingActivityIndicator startAnimating];
            self.headerLabel.text = NSLocalizedString(@"Refreshing...", @"Refreshing... rss info header cell");
            
            //[messageLabel_ setText:MNM_BOTTOM_PTR_LOADING_TEXT_KEY];
            
            //height = fixedHeight_ + fabs(offset);
            
            break;
            
        } default:
            break;
    }
    
    CGRect frame = [self frame];
    frame.size.height = height;
    //[self setFrame:frame];
    
    [self setNeedsLayout];
}


@end

