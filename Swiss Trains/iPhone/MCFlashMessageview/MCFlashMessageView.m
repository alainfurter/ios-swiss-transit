//
//  MCMessageView.m
//  MCMessageView
//

/*
License
=======

This code is distributed under the terms and conditions of the MIT license. 

Copyright (c) 2011 Junior Bontognali

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

#import "MCFlashMessageView.h"

@interface MCFlashMessageView ()

- (void)hideUsingAnimation:(BOOL)animated;
- (void)showUsingAnimation:(BOOL)animated;
- (void)fillRoundedRect:(CGRect)rect inContext:(CGContextRef)context;
- (void)done;
- (void)updateLabelText:(NSString *)newText;
- (void)updateDetailsLabelText:(NSString *)newText;
- (void)setTransformForCurrentOrientation:(BOOL)animated;
- (void)cleanUp;
- (void)deviceOrientationDidChange:(NSNotification*)notification;

@property (assign) float width;
@property (assign) float height;
@property (retain) NSDate *showStarted;

@end

@implementation MCFlashMessageView

#pragma mark -
#pragma mark Accessors

@synthesize animationType;

@synthesize autoHide;

@synthesize opacity;
@synthesize labelFont;
@synthesize detailsLabelFont;

@synthesize icon;

@synthesize width;
@synthesize height;
@synthesize xOffset;
@synthesize yOffset;
@synthesize showtime;

@synthesize removeFromSuperViewOnHide;

@synthesize showStarted;

- (void)setLabelText:(NSString *)newText {
	if ([NSThread isMainThread]) {
		[self updateLabelText:newText];
		[self setNeedsLayout];
		[self setNeedsDisplay];
	} else {
		[self performSelectorOnMainThread:@selector(updateLabelText:) withObject:newText waitUntilDone:NO];
		[self performSelectorOnMainThread:@selector(setNeedsLayout) withObject:nil waitUntilDone:NO];
		[self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
	}
}

- (NSString *)labelText {
	return labelText;
}

- (void)setDetailsLabelText:(NSString *)newText {
	if ([NSThread isMainThread]) {
		[self updateDetailsLabelText:newText];
		[self setNeedsLayout];
		[self setNeedsDisplay];
	} else {
		[self performSelectorOnMainThread:@selector(updateDetailsLabelText:) withObject:newText waitUntilDone:NO];
		[self performSelectorOnMainThread:@selector(setNeedsLayout) withObject:nil waitUntilDone:NO];
		[self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
	}
}

- (NSString *)detailsLabelText {
	return detailsLabelText;
}

#pragma mark -
#pragma mark Accessor helpers

- (void)updateLabelText:(NSString *)newText {
    if (labelText != newText) {
        [labelText release];
        labelText = [newText copy];
    }
}

- (void)updateDetailsLabelText:(NSString *)newText {
    if (detailsLabelText != newText) {
        [detailsLabelText release];
        detailsLabelText = [newText copy];
    }
}

#pragma mark - Constants

#define MARGIN 20.0
#define PADDING 7.0

#define LABELFONTSIZE 16.0
#define LABELDETAILSFONTSIZE 12.0

#define PI 3.14159265358979323846


#pragma mark - Lifecycle methods

- (id)initWithWindow:(UIWindow *)window {
    return [self initWithView:window];
}

- (id)initWithView:(UIView *)view {
	// Let's check if the view is nil (this is a common error when using the windw initializer above)
	if (!view) {
		[NSException raise:@"MCMessageViewIsNillException" 
					format:@"The view used in the MCMessageView initializer is nil."];
	}
	id me = [self initWithFrame:view.bounds];
	// We need to take care of rotation ourselfs if we're adding the message view to a window
	if ([view isKindOfClass:[UIWindow class]]) {
		[self setTransformForCurrentOrientation:NO];
	}
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) 
												 name:UIDeviceOrientationDidChangeNotification object:nil];
	
	return me;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Set default values for properties
        self.animationType = MCMessageViewAnimationZoom;
        self.labelText = nil;
        self.detailsLabelText = nil;
        self.opacity = 0.8;
        self.labelFont = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
        self.detailsLabelFont = [UIFont boldSystemFontOfSize:LABELDETAILSFONTSIZE];
        self.xOffset = 0.0;
        self.yOffset = 0.0;
        self.showtime = 0.5;
		self.removeFromSuperViewOnHide = NO;
        self.icon = [[[UIImageView alloc] init] autorelease];
        self.autoHide = YES;
		
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		
        // Transparent background
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
		
        // Make invisible for now
        self.alpha = 0.0;
		
        // Add label
        label = [[UILabel alloc] initWithFrame:self.bounds];
		
        // Add details label
        detailsLabel = [[UILabel alloc] initWithFrame:self.bounds];
		
		rotationTransform = CGAffineTransformIdentity;
    }
    return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
    [icon release];
    [label release];
    [detailsLabel release];
    [labelText release];
    [detailsLabelText release];
	[showStarted release];
    [super dealloc];
}

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews {
    CGRect frame = self.bounds;
	
    icon.frame = CGRectMake(0, 0, icon.image.size.width, icon.image.size.height);
    
    // Compute Message view dimensions based on icon size (add margin to message view border)
    CGRect indFrame = icon.bounds;
    self.width = indFrame.size.width + 2 * MARGIN;
    self.height = indFrame.size.height + 2 * MARGIN;
	
    // Position the icon
    indFrame.origin.x = floor((frame.size.width - indFrame.size.width) / 2) + self.xOffset;
    indFrame.origin.y = floor((frame.size.height - indFrame.size.height) / 2) + self.yOffset;
    icon.frame = indFrame;
    
    [self addSubview:icon];
	
    // Add label if label text was set
    if (nil != self.labelText) {
        // Get size of label text
        CGSize dims = [self.labelText sizeWithFont:self.labelFont];
		
        // Compute label dimensions based on font metrics if size is larger than max then clip the label width
        float lHeight = dims.height;
        float lWidth;
        if (dims.width <= (frame.size.width - 2 * MARGIN)) {
            lWidth = dims.width;
        }
        else {
            lWidth = frame.size.width - 4 * MARGIN;
        }
		
        // Set label properties
        label.font = self.labelFont;
        label.adjustsFontSizeToFitWidth = NO;
        label.textAlignment = NSTextAlignmentCenter;
        label.opaque = NO;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.text = self.labelText;
		
        // Update message view size
        if (self.width < (lWidth + 2 * MARGIN)) {
            self.width = lWidth + 2 * MARGIN;
        }
        self.height = self.height + lHeight + PADDING;
		
        // Move icon to make room for the label
        indFrame.origin.y -= (floor(lHeight / 2 + PADDING / 2));
        icon.frame = indFrame;
		
        // Set the label position and dimensions
        CGRect lFrame = CGRectMake(floor((frame.size.width - lWidth) / 2) + xOffset,
                                   floor(indFrame.origin.y + indFrame.size.height + PADDING),
                                   lWidth, lHeight);
        label.frame = lFrame;
		
        [self addSubview:label];
		
        // Add details label delatils text was set
        if (nil != self.detailsLabelText) {
            // Get size of label text
            dims = [self.detailsLabelText sizeWithFont:self.detailsLabelFont];
			
            // Compute label dimensions based on font metrics if size is larger than max then clip the label width
            lHeight = dims.height;
            if (dims.width <= (frame.size.width - 2 * MARGIN)) {
                lWidth = dims.width;
            }
            else {
                lWidth = frame.size.width - 4 * MARGIN;
            }
			
            // Set label properties
            detailsLabel.font = self.detailsLabelFont;
            detailsLabel.adjustsFontSizeToFitWidth = NO;
            detailsLabel.textAlignment = NSTextAlignmentCenter;
            detailsLabel.opaque = NO;
            detailsLabel.backgroundColor = [UIColor clearColor];
            detailsLabel.textColor = [UIColor whiteColor];
            detailsLabel.text = self.detailsLabelText;
			
            // Update message view size
            if (self.width < lWidth) {
                self.width = lWidth + 2 * MARGIN;
            }
            self.height = self.height + lHeight + PADDING;
			
            // Move icon to make room for the new label
            indFrame.origin.y -= (floor(lHeight / 2 + PADDING / 2));
            icon.frame = indFrame;
			
            // Move first label to make room for the new label
            lFrame.origin.y -= (floor(lHeight / 2 + PADDING / 2));
            label.frame = lFrame;
			
            // Set label position and dimensions
            CGRect lFrameD = CGRectMake(floor((frame.size.width - lWidth) / 2) + xOffset,
                                        lFrame.origin.y + lFrame.size.height + PADDING, lWidth, lHeight);
            detailsLabel.frame = lFrameD;
			
            [self addSubview:detailsLabel];
        }
    }
}

#pragma mark -
#pragma mark Showing and execution

- (void)show:(BOOL)animated {
	useAnimation = animated;
	
    [self setNeedsDisplay];
    [self showUsingAnimation:useAnimation];
    
    if (autoHide)
        [self performSelector:@selector(hide) withObject:nil afterDelay:(0.3 + self.showtime)];
    
}
     
- (void)hide {
 useAnimation = YES;
 
 // ... otherwise hide the message view immediately
 [self hideUsingAnimation:useAnimation];
}

- (void)hide:(BOOL)animated {
	useAnimation = animated;
	
	// ... otherwise hide the message view immediately
    [self hideUsingAnimation:useAnimation];
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void*)context {
    [self done];
}

- (void)done {
    isFinished = YES;
	
    // If delegate was set make the callback
    self.alpha = 0.0;
	
	if (removeFromSuperViewOnHide) {
		[self removeFromSuperview];
	}
}

- (void)cleanUp {
	self.icon = nil;
	
    [self hide:useAnimation];
}

#pragma mark -
#pragma mark Fade in and Fade out

- (void)showUsingAnimation:(BOOL)animated {
    self.alpha = 0.0;
    if (animated && animationType == MCMessageViewAnimationZoom) {
        self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(1.5, 1.5));
    }
    
	self.showStarted = [NSDate date];
    // Fade in
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.20];
        self.alpha = 1.0;
        if (animationType == MCMessageViewAnimationZoom) {
            self.transform = rotationTransform;
        }
        [UIView commitAnimations];
    }
    else {
        self.alpha = 1.0;
    }
}

- (void)hideUsingAnimation:(BOOL)animated {
    // Fade out
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.20];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationFinished: finished: context:)];
        // 0.02 prevents the message view from passing through touches during the animation the message view will get completely hidden
        // in the done method
        if (animationType == MCMessageViewAnimationZoom) {
            self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(0.5, 0.5));
        }
        self.alpha = 0.02;
        [UIView commitAnimations];
    }
    else {
        self.alpha = 0.0;
        [self done];
    }
}

#pragma mark BG Drawing

- (void)drawRect:(CGRect)rect {
    // Center message view
    CGRect allRect = self.bounds;
    // Draw rounded message view bacgroud rect
    CGRect boxRect = CGRectMake(((allRect.size.width - self.width) / 2) + self.xOffset,
                                ((allRect.size.height - self.height) / 2) + self.yOffset, self.width, self.height);
    CGContextRef ctxt = UIGraphicsGetCurrentContext();
    [self fillRoundedRect:boxRect inContext:ctxt];
}

- (void)fillRoundedRect:(CGRect)rect inContext:(CGContextRef)context {
    float radius = 10.0f;
	
    CGContextBeginPath(context);
    CGContextSetGrayFillColor(context, 0.0, self.opacity);
    CGContextMoveToPoint(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect));
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMinY(rect) + radius, radius, 3 * M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMaxY(rect) - radius, radius, 0, M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMaxY(rect) - radius, radius, M_PI / 2, M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect) + radius, radius, M_PI, 3 * M_PI / 2, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

#pragma mark -
#pragma mark Manual oritentation change

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

- (void)deviceOrientationDidChange:(NSNotification *)notification { 
	if ([self.superview isKindOfClass:[UIWindow class]]) {
		[self setTransformForCurrentOrientation:YES];
	}
	// Stay in sync with the parent view (make sure we cover it fully)
	self.frame = self.superview.bounds;
	[self setNeedsDisplay];
}

- (void)setTransformForCurrentOrientation:(BOOL)animated {
	UIDeviceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	NSInteger degrees = 0;
	
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		if (orientation == UIInterfaceOrientationLandscapeLeft) { degrees = -90; } 
		else { degrees = 90; }
	} else {
		if (orientation == UIInterfaceOrientationPortraitUpsideDown) { degrees = 180; } 
		else { degrees = 0; }
	}
	
	rotationTransform = CGAffineTransformMakeRotation(RADIANS(degrees));
    
	if (animated) {
		[UIView beginAnimations:nil context:nil];
	}
	[self setTransform:rotationTransform];
	if (animated) {
		[UIView commitAnimations];
	}
}

@end

