//
//  ConnectionsSelectionViewControlleriPad.m
//  Swiss Trains
//
//  Created by Alain on 02.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "ConnectionsSelectionViewControlleriPad.h"

@interface ConnectionsSelectionViewControlleriPad ()

@end

@implementation ConnectionsSelectionViewControlleriPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight  | UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {        
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight  | UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void) loadView {
    CGSize size = [UIApplication currentScreenSize];
    
    //NSLog(@"ConnectionsSelectionViewController. Screen size: %.1f, %.1f", size.width, size.height);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SPLITVIEWMAINVIEWWIDTH, size.height - TOOLBARHEIGHT - TABBARHEIGHT)];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = view;
    
    //NSLog(@"ConnectionsSelection view init: %.1f, %.1f, %.1f, %.1f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
}

- (void) layoutSubviewsWithAnimated:(BOOL)animated beforeRotation:(BOOL)beforeRotation interfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //NSLog(@"ConnectionsSelectionViewControlleriPad layoutSubviews");
	
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
    
    newSize.width = SPLITVIEWMAINVIEWWIDTH;
    newSize.height = newSize.height - TOOLBARHEIGHT - TABBARHEIGHT;
    
    //NSLog(@"ConnectionsSelectionViewControlleriPad. New size: %.1f, %.1f", newSize.width, newSize.height);
    
    if (animated) {
        [UIView beginAnimations:@"ConnectionsSelectionViewControlleriPad LayoutSubviewWithAnimation" context:NULL];
    }
    
    NSUInteger stationSelectionPadding = 55;
    //NSUInteger timeSelectionPadding = 110;
    self.stationsControlBackgroundView.frame = CGRectMake(0, 4+30 + stationSelectionPadding - 55, newSize.width, TEXTFIELDHEIGHT * 3 + 30);
    self.stationsViaControlBackgroundView.frame = CGRectMake(0, 4+30 + stationSelectionPadding - 55, newSize.width, TEXTFIELDHEIGHT * 4 + 45);    
    //self.timeControlBackgroundView.frame = CGRectMake(0, 4 + TEXTFIELDHEIGHT * 3 + 30 + 30 + timeSelectionPadding - 110, newSize.width, TEXTFIELDHEIGHT * 3 + 60 + 20);
    
    self.timeButton.frame = CGRectMake(15+10, 22, BUTTONHEIGHT, BUTTONHEIGHT);
    self.timeLabel.frame = CGRectMake(5 + BUTTONHEIGHT + 45, BUTTONHEIGHT * 3 + 15, BUTTONHEIGHT * 2, BUTTONHEIGHT);    
    self.dateLabel.frame = CGRectMake(5 + BUTTONHEIGHT*2 + 5 + 70, BUTTONHEIGHT * 3 + 15, BUTTONHEIGHT * 3, BUTTONHEIGHT);
    self.timenowButton = [[FTWButton alloc] initWithFrame:CGRectMake(15 + BUTTONHEIGHT * 2 + 18 - 15, 22, BUTTONHEIGHT, BUTTONHEIGHT)];
    self.timePlus10MButton.frame = CGRectMake(15+10, BUTTONHEIGHT * 2 + 15, BUTTONHEIGHT * 2, BUTTONHEIGHT);
    self.timePlus30MButton.frame = CGRectMake(15+10 + BUTTONHEIGHT*2 + 28, BUTTONHEIGHT * 2 + 15, BUTTONHEIGHT * 2, BUTTONHEIGHT);
    self.timePlus60MButton.frame = CGRectMake(BUTTONHEIGHT*2 + 5*2 + BUTTONHEIGHT * 4 + 5 * 2 + 8 - 20, BUTTONHEIGHT * 2 + 15, BUTTONHEIGHT * 2, BUTTONHEIGHT);
    self.navSC.center = CGPointMake(240, 41);
    
    CGFloat lineWidthTime = self.separatorLineLayerTime.lineWidth;
    UIBezierPath *borderBottomPathTime = [UIBezierPath bezierPathWithRect: CGRectMake(10, BUTTONHEIGHT * 2 + 2 - lineWidthTime, newSize.width - 20, lineWidthTime)];
    self.separatorLineLayerTime.path = borderBottomPathTime.CGPath;
    
    self.viaButton.frame = CGRectMake(15, 22 + stationSelectionPadding - BUTTONHEIGHT + 5, BUTTONHEIGHT, BUTTONHEIGHT);
    self.switchStationsButton.frame = CGRectMake(15, 22 + stationSelectionPadding, BUTTONHEIGHT, BUTTONHEIGHT);
    
    self.pinStartButton.frame = CGRectMake(newSize.width - 15 - TEXTFIELDHEIGHT, 4 + stationSelectionPadding, TEXTFIELDHEIGHT, TEXTFIELDHEIGHT);
    self.pinEndButton.frame = CGRectMake(newSize.width - 15 - TEXTFIELDHEIGHT, TEXTFIELDHEIGHT + 16 + stationSelectionPadding, TEXTFIELDHEIGHT, TEXTFIELDHEIGHT);
    
    self.startStationButton.frame = CGRectMake(15 + BUTTONHEIGHT + 5, 4 + stationSelectionPadding, newSize.width - 10 - BUTTONHEIGHT - 25 - BUTTONHEIGHT, TEXTFIELDHEIGHT);
    self.endStationButton.frame = CGRectMake(15 + BUTTONHEIGHT + 5, TEXTFIELDHEIGHT + 16 + stationSelectionPadding, newSize.width - 10 - BUTTONHEIGHT - 25 - BUTTONHEIGHT, TEXTFIELDHEIGHT);
    self.viaStationButton.frame = CGRectMake(15 + BUTTONHEIGHT + 5, TEXTFIELDHEIGHT* 2 + 16 + 12 + stationSelectionPadding, newSize.width - 10 - BUTTONHEIGHT - 25 - BUTTONHEIGHT, TEXTFIELDHEIGHT);

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
    
    //NSLog(@"ConnectionsSelection viewdidload: %.1f, %.1f, %.1f, %.1f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);

	// Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
    self.view.backgroundColor = [UIColor selectionControllerBackgroundColor];
    /*
    UIColor *topGradientColor = [UIColor connectionsDetailviewCellTopGradientColorNormal];
    UIColor *bottomGradientColor = [UIColor connectionsDetailviewCellBottomGradientColorNormal];
    CGRect backgroundViewFrame = self.view.frame;
    backgroundViewFrame.size.height = self.view.frame.size.height;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)topGradientColor.CGColor, (id)bottomGradientColor.CGColor, nil];
    gradient.startPoint = CGPointMake(0.5f, 0.0f);
    gradient.endPoint = CGPointMake(0.5f, 1.0f);
    [self.view.layer addSublayer:gradient];
    */
    
    NSUInteger stationSelectionPadding = 55;
    NSUInteger timeSelectionPadding = 110;
    
    self.startDate = [NSDate date];
    self.endDate = nil;
    
    self.stationsControlBackgroundView = [[ControlsBackgroundView alloc] initWithFrame: CGRectMake(0, 4+30 + stationSelectionPadding - 55, self.view.frame.size.width, TEXTFIELDHEIGHT * 3 + 30)];
    [self.view addSubview: self.stationsControlBackgroundView];
    
    self.stationsViaControlBackgroundView = [[ControlsBackgroundView alloc] initWithFrame: CGRectMake(0, 4+30 + stationSelectionPadding - 55, self.view.frame.size.width, TEXTFIELDHEIGHT * 4 + 45)];
    [self.view addSubview: self.stationsViaControlBackgroundView];
    self.stationsViaControlBackgroundView.alpha = 0.0;
        
    self.timeControlBackgroundView = [[ControlsBackgroundView alloc] initWithFrame: CGRectMake(0, 4 + TEXTFIELDHEIGHT * 3 + 30 + 30 + timeSelectionPadding - 110, self.view.frame.size.width, TEXTFIELDHEIGHT * 3 + 60 + 20)];
    [self.view addSubview: self.timeControlBackgroundView];
        
    self.timeButton = [[FTWButton alloc] init];
    [self.timeButton addGrayStyleForState:UIControlStateNormal];
    [self.timeButton setColors:[NSArray arrayWithObjects:
                                [UIColor colorWithWhite:98.0f/255 alpha:1.0f],
                                [UIColor colorWithWhite:108.0f/255 alpha:1.0f],
                                nil] forControlState:UIControlStateHighlighted];
    [self.timeButton setInnerShadowColor:[UIColor blackColor] forControlState:UIControlStateHighlighted];
	[self.timeButton setInnerShadowRadius:4.0f forControlState:UIControlStateHighlighted];
	[self.timeButton setInnerShadowOffset:CGSizeMake(0, 2) forControlState:UIControlStateHighlighted];
    UIImage *timeButtonImage = [UIImage newImageFromMaskImage: [UIImage timeButtonImage] inColor: [UIColor selectStationsViewFTWButtonColorNormal]];
    UIImage *timeButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage timeButtonImage] inColor: [UIColor selectStationsViewFTWButtonColorHighlighted]];
    [self.timeButton setIcon: timeButtonImage forControlState: UIControlStateNormal];
    [self.timeButton setIcon: timeButtonImageHighlighted forControlState: UIControlStateHighlighted];
    self.timeButton.contentMode = UIViewContentModeCenter;
    self.timeButton.frame = CGRectMake(15+10, 22, BUTTONHEIGHT, BUTTONHEIGHT);
    self.timeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.timeButton addTarget: self action: @selector(selectTimeAndDate:) forControlEvents:UIControlEventTouchUpInside];
    [self.timeButton layoutSubviews];
    [self.timeControlBackgroundView addSubview: self.timeButton];
    
    self.timeLabel = [[UILabel alloc] initWithFrame: CGRectMake(5 + BUTTONHEIGHT + 45, BUTTONHEIGHT * 3 + 15, BUTTONHEIGHT * 2, BUTTONHEIGHT)];
    self.timeLabel.font = [UIFont boldSystemFontOfSize: 15.0];
    self.timeLabel.textColor = [UIColor selectStationsViewButtonColorNormal];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.timeControlBackgroundView addSubview: self.timeLabel];
    
    self.dateLabel = [[UILabel alloc] initWithFrame: CGRectMake(5 + BUTTONHEIGHT*2 + 5 + 70, BUTTONHEIGHT * 3 + 15, BUTTONHEIGHT * 3, BUTTONHEIGHT)];
    self.dateLabel.font = [UIFont boldSystemFontOfSize: 15.0];
    self.dateLabel.textColor = [UIColor selectStationsViewButtonColorNormal];
    self.dateLabel.backgroundColor = [UIColor clearColor];
    self.dateLabel.textAlignment = NSTextAlignmentLeft;
    [self.timeControlBackgroundView addSubview: self.dateLabel];
        
    self.timenowButton = [[FTWButton alloc] initWithFrame:CGRectMake(15 + BUTTONHEIGHT * 2 + 18 - 15, 22, BUTTONHEIGHT, BUTTONHEIGHT)];
    [self.timenowButton addGrayStyleForState:UIControlStateNormal];
    [self.timenowButton setColors:[NSArray arrayWithObjects:
                                   [UIColor colorWithWhite:98.0f/255 alpha:1.0f],
                                   [UIColor colorWithWhite:108.0f/255 alpha:1.0f],
                                   nil] forControlState:UIControlStateHighlighted];
    [self.timenowButton setInnerShadowColor:[UIColor blackColor] forControlState:UIControlStateHighlighted];
	[self.timenowButton setInnerShadowRadius:4.0f forControlState:UIControlStateHighlighted];
	[self.timenowButton setInnerShadowOffset:CGSizeMake(0, 2) forControlState:UIControlStateHighlighted];
    [self.timenowButton setText:@"" forControlState:UIControlStateNormal];
    UIImage *timenowButtonImage = [UIImage newImageFromMaskImage: [UIImage timenowButtonImage] inColor: [UIColor selectStationsViewFTWButtonColorNormal]];
    UIImage *timenowButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage timenowButtonImage] inColor: [UIColor selectStationsViewFTWButtonColorHighlighted]];
    [self.timenowButton setIcon: timenowButtonImage forControlState: UIControlStateNormal];
    [self.timenowButton setIcon: timenowButtonImageHighlighted forControlState: UIControlStateHighlighted];
    self.timenowButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.timenowButton addTarget: self action: @selector(updateDateWithTimeNow:) forControlEvents:UIControlEventTouchUpInside];
    [self.timeControlBackgroundView addSubview: self.timenowButton];
    
    self.timePlus10MButton = [[FTWButton alloc] init];
    self.timePlus10MButton.frame = CGRectMake(15+10, BUTTONHEIGHT * 2 + 15, BUTTONHEIGHT * 2, BUTTONHEIGHT);
	[self.timePlus10MButton addGrayStyleForState:UIControlStateNormal];
	[self.timePlus10MButton setText:NSLocalizedString(@"+10'", @"Time button +10 minutes") forControlState:UIControlStateNormal];
	[self.timePlus10MButton setColors:[NSArray arrayWithObjects:
                                       [UIColor colorWithWhite:98.0f/255 alpha:1.0f],
                                       [UIColor colorWithWhite:108.0f/255 alpha:1.0f],
                                       nil] forControlState:UIControlStateHighlighted];
	[self.timePlus10MButton setInnerShadowColor:[UIColor blackColor] forControlState:UIControlStateHighlighted];
	[self.timePlus10MButton setInnerShadowRadius:4.0f forControlState:UIControlStateHighlighted];
	[self.timePlus10MButton setInnerShadowOffset:CGSizeMake(0, 2) forControlState:UIControlStateHighlighted];
	[self.timePlus10MButton addTarget:self action:@selector(updateTimeWithNowPlus10M:) forControlEvents:UIControlEventTouchUpInside];
    self.timePlus10MButton.textAlignment = NSTextAlignmentCenter;
    [self.timeControlBackgroundView addSubview:self.timePlus10MButton];
    
    self.timePlus30MButton = [[FTWButton alloc] init];
    self.timePlus30MButton.frame = CGRectMake(15+10 + BUTTONHEIGHT*2 + 28, BUTTONHEIGHT * 2 + 15, BUTTONHEIGHT * 2, BUTTONHEIGHT);
	[self.timePlus30MButton addGrayStyleForState:UIControlStateNormal];
	[self.timePlus30MButton setText:NSLocalizedString(@"+30'", @"Time button +30 minutes") forControlState:UIControlStateNormal];
	[self.timePlus30MButton setColors:[NSArray arrayWithObjects:
                                       [UIColor colorWithWhite:98.0f/255 alpha:1.0f],
                                       [UIColor colorWithWhite:108.0f/255 alpha:1.0f],
                                       nil] forControlState:UIControlStateHighlighted];
	[self.timePlus30MButton setInnerShadowColor:[UIColor blackColor] forControlState:UIControlStateHighlighted];
	[self.timePlus30MButton setInnerShadowRadius:4.0f forControlState:UIControlStateHighlighted];
	[self.timePlus30MButton setInnerShadowOffset:CGSizeMake(0, 2) forControlState:UIControlStateHighlighted];
	[self.timePlus30MButton addTarget:self action:@selector(updateTimeWithNowPlus30M:) forControlEvents:UIControlEventTouchUpInside];
    self.timePlus30MButton.textAlignment = NSTextAlignmentCenter;
    [self.timeControlBackgroundView addSubview:self.timePlus30MButton];
    
    self.timePlus60MButton = [[FTWButton alloc] init];
    self.timePlus60MButton.frame = CGRectMake(BUTTONHEIGHT*2 + 5*2 + BUTTONHEIGHT * 4 + 5 * 2 + 8 - 20, BUTTONHEIGHT * 2 + 15, BUTTONHEIGHT * 2, BUTTONHEIGHT);
	[self.timePlus60MButton addGrayStyleForState:UIControlStateNormal];
	[self.timePlus60MButton setText:NSLocalizedString(@"+60'", @"Time button +60 minutes") forControlState:UIControlStateNormal];
	[self.timePlus60MButton setColors:[NSArray arrayWithObjects:
                                       [UIColor colorWithWhite:98.0f/255 alpha:1.0f],
                                       [UIColor colorWithWhite:108.0f/255 alpha:1.0f],
                                       nil] forControlState:UIControlStateHighlighted];
	[self.timePlus60MButton setInnerShadowColor:[UIColor blackColor] forControlState:UIControlStateHighlighted];
	[self.timePlus60MButton setInnerShadowRadius:4.0f forControlState:UIControlStateHighlighted];
	[self.timePlus60MButton setInnerShadowOffset:CGSizeMake(0, 2) forControlState:UIControlStateHighlighted];
	[self.timePlus60MButton addTarget:self action:@selector(updateTimeWithNowPlus60M:) forControlEvents:UIControlEventTouchUpInside];
    self.timePlus60MButton.textAlignment = NSTextAlignmentCenter;
    [self.timeControlBackgroundView addSubview:self.timePlus60MButton];
    
    self.navSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"", @"", nil]];
    
    CGFloat scaleFactorNavSc = 1.5;
    UIImage *depImage =  [[UIImage journeyDepartureImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactorNavSc, SEGMENTHEIGHT) interpolationQuality: kCGInterpolationDefault];
    UIImage *arrImage = [[UIImage journeyArrivalImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactorNavSc, SEGMENTHEIGHT) interpolationQuality: kCGInterpolationDefault];
    self.navSC.sectionImages = [NSArray arrayWithObjects: depImage, arrImage, nil];
    //navSC.sectionTitles = nil;
    
    __weak ConnectionsSelectionViewControlleriPad *weakSelf = self;
    self.navSC.changeHandler = ^(NSUInteger newIndex) {
        //NSLog(@"segmentedControl did select index %i (via block handler)", newIndex);
        if (newIndex == 0) {
            if (weakSelf.endDate) {
                weakSelf.startDate = weakSelf.endDate;
                weakSelf.endDate = nil;
            }
        } else {
            if (weakSelf.startDate) {
                weakSelf.endDate = weakSelf.startDate;
                weakSelf.startDate = nil;
            }
        }
    };
    self.navSC.center = CGPointMake(240, 41);
    [self.timeControlBackgroundView addSubview: self.navSC];
    [self.navSC setSelectedIndex: 0];
    
    self.separatorLineLayerTime = CAShapeLayer.layer;
    [self.view.layer addSublayer:self.separatorLineLayerTime];
    self.separatorLineLayerTime.strokeColor = [UIColor lightGrayColor].CGColor;
    self.separatorLineLayerTime.lineWidth = .5;
    self.separatorLineLayerTime.fillColor = nil;
    [self.timeControlBackgroundView.layer addSublayer: self.separatorLineLayerTime];
    
    CGRect ownframeTime = self.view.frame;
    CGFloat lineWidthTime = self.separatorLineLayerTime.lineWidth;
    UIBezierPath *borderBottomPathTime = [UIBezierPath bezierPathWithRect: CGRectMake(ownframeTime.origin.x + 10, BUTTONHEIGHT * 2 + 2 - lineWidthTime, ownframeTime.size.width - 20, lineWidthTime)];
    self.separatorLineLayerTime.path = borderBottomPathTime.CGPath;
    
    CGFloat scaleFactorArrowImage = 1.0;
    //self.viaButton = [[UIButton alloc] initWithFrame: CGRectMake(15, 22 + stationSelectionPadding - BUTTONHEIGHT + 5, BUTTONHEIGHT, BUTTONHEIGHT)];
    self.viaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *viaDownButtonImage = [UIImage newImageFromMaskImage: [[UIImage arrowdownButtonImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactorArrowImage, SEGMENTHEIGHT * scaleFactorArrowImage) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor selectStationsViewButtonColorNormal]];
    UIImage *viaUpButtonImage = [UIImage newImageFromMaskImage: [[UIImage arrowupButtonImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactorArrowImage, SEGMENTHEIGHT * scaleFactorArrowImage) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor selectStationsViewButtonColorNormal]];
    [[UIImage listButtonImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactorArrowImage, SEGMENTHEIGHT * scaleFactorArrowImage) interpolationQuality: kCGInterpolationDefault];
    [self.viaButton setImage: viaDownButtonImage forState: UIControlStateNormal];
    [self.viaButton setImage: viaUpButtonImage forState: UIControlStateSelected];
    
    self.viaButton.imageView.contentMode = UIViewContentModeCenter;
    self.viaButton.frame = CGRectMake(self.view.frame.origin.x + 15, 22 + stationSelectionPadding - BUTTONHEIGHT + 5, BUTTONHEIGHT, BUTTONHEIGHT);
    self.viaButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.viaButton.showsTouchWhenHighlighted = YES;
    [self.viaButton addTarget: self action: @selector(toggleViaStation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.viaButton];
    
    self.switchStationsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *switchButtonImage = [UIImage newImageFromMaskImage: [UIImage switchButtonImage] inColor: [UIColor selectStationsViewButtonColorNormal]];
    UIImage *switchButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage switchButtonImage] inColor: [UIColor selectStationsViewButtonColorHighlighted]];
    [self.switchStationsButton setImage: switchButtonImage forState: UIControlStateNormal];
    [self.switchStationsButton setImage: switchButtonImageHighlighted forState: UIControlStateHighlighted];
    self.switchStationsButton.imageView.contentMode = UIViewContentModeCenter;
    //self.switchStationsButton.frame = CGRectMake(5, BUTTONHEIGHT + 15, BUTTONHEIGHT, BUTTONHEIGHT);
    self.switchStationsButton.frame = CGRectMake(15, 22 + stationSelectionPadding, BUTTONHEIGHT, BUTTONHEIGHT);
    self.switchStationsButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.switchStationsButton.showsTouchWhenHighlighted = YES;
    [self.switchStationsButton addTarget: self action: @selector(switchStations:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.switchStationsButton];
    
    self.pinStartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *pinButtonImage = [UIImage newImageFromMaskImage: [UIImage pinButtonImage] inColor: [UIColor selectStationsViewButtonColorNormal]];
    UIImage *pinButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage pinButtonImage] inColor: [UIColor selectStationsViewButtonColorHighlighted]];
    [self.pinStartButton setImage: pinButtonImage forState: UIControlStateNormal];
    [self.pinStartButton setImage: pinButtonImageHighlighted forState: UIControlStateHighlighted];
    self.pinStartButton.imageView.contentMode = UIViewContentModeCenter;
    //self.pinStartButton.frame = CGRectMake(self.view.frame.size.width - 5 - TEXTFIELDHEIGHT, BUTTONHEIGHT + 4, TEXTFIELDHEIGHT, TEXTFIELDHEIGHT);
    self.pinStartButton.frame = CGRectMake(self.view.frame.size.width - 15 - TEXTFIELDHEIGHT, 4 + stationSelectionPadding, TEXTFIELDHEIGHT, TEXTFIELDHEIGHT);
    self.pinStartButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.pinStartButton.showsTouchWhenHighlighted = YES;
    [self.pinStartButton addTarget: self action: @selector(setStartLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.pinStartButton];
    
    self.pinEndButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pinEndButton setImage: pinButtonImage forState: UIControlStateNormal];
    [self.pinEndButton setImage: pinButtonImageHighlighted forState: UIControlStateHighlighted];
    self.pinEndButton.imageView.contentMode = UIViewContentModeCenter;
    self.pinEndButton.frame = CGRectMake(self.view.frame.size.width - 15 - TEXTFIELDHEIGHT, TEXTFIELDHEIGHT + 16 + stationSelectionPadding, TEXTFIELDHEIGHT, TEXTFIELDHEIGHT);
    self.pinEndButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.pinEndButton.showsTouchWhenHighlighted = YES;
    [self.pinEndButton addTarget: self action: @selector(setEndLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.pinEndButton];
    
    CGFloat scaleFactorCancelButtonImage = 1.5;
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *cancelButtonImage = [UIImage newImageFromMaskImage: [[UIImage cancelButtonImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactorCancelButtonImage, SEGMENTHEIGHT * scaleFactorCancelButtonImage) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor selectStationsViewButtonColorNormal]];
    UIImage *cancelButtonImageHighlighted = [UIImage newImageFromMaskImage: [[UIImage cancelButtonImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactorCancelButtonImage, SEGMENTHEIGHT * scaleFactorCancelButtonImage) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor selectStationsViewButtonColorHighlighted]];
    [self.cancelButton setImage: cancelButtonImage forState: UIControlStateNormal];
    [self.cancelButton setImage: cancelButtonImageHighlighted forState: UIControlStateHighlighted];
    self.cancelButton.imageView.contentMode = UIViewContentModeCenter;
    self.cancelButton.frame = CGRectMake(self.view.frame.size.width - 15 - TEXTFIELDHEIGHT, TEXTFIELDHEIGHT * 2 + 16 + 12 + stationSelectionPadding, TEXTFIELDHEIGHT, TEXTFIELDHEIGHT);
    self.cancelButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.cancelButton.showsTouchWhenHighlighted = YES;
    [self.cancelButton addTarget: self action: @selector(cancelViaStation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.cancelButton];
    self.cancelButton.alpha = 0.0;
    
    self.startStationButton = [[FTWButton alloc] init];
    self.startStationButton.frame = CGRectMake(15 + BUTTONHEIGHT + 5, 4 + stationSelectionPadding, self.view.frame.size.width - 10 - BUTTONHEIGHT - 25 - BUTTONHEIGHT, TEXTFIELDHEIGHT);
	[self.startStationButton addGrayStyleForState:UIControlStateNormal];
	[self.startStationButton setText:[NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"From:", @"Select stations from station help text"), NSLocalizedString(@"Current location", @"Station text field default text")] forControlState:UIControlStateNormal];
	[self.startStationButton setColors:[NSArray arrayWithObjects:
                                        [UIColor colorWithWhite:98.0f/255 alpha:1.0f],
                                        [UIColor colorWithWhite:108.0f/255 alpha:1.0f],
                                        nil] forControlState:UIControlStateHighlighted];
	[self.startStationButton setInnerShadowColor:[UIColor blackColor] forControlState:UIControlStateHighlighted];
	[self.startStationButton setInnerShadowRadius:4.0f forControlState:UIControlStateHighlighted];
	[self.startStationButton setInnerShadowOffset:CGSizeMake(0, 2) forControlState:UIControlStateHighlighted];
	[self.startStationButton addTarget:self action:@selector(startStationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.startStationButton.textAlignment = NSTextAlignmentLeft;
	[self.view addSubview:self.startStationButton];
    
    self.endStationButton = [[FTWButton alloc] init];
    self.endStationButton.frame = CGRectMake(15 + BUTTONHEIGHT + 5, TEXTFIELDHEIGHT + 16 + stationSelectionPadding, self.view.frame.size.width - 10 - BUTTONHEIGHT - 25 - BUTTONHEIGHT, TEXTFIELDHEIGHT);
	[self.endStationButton addGrayStyleForState:UIControlStateNormal];
	[self.endStationButton setText:[NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"To:", @"Select stations to station help text"), NSLocalizedString(@"Current location", @"Station text field default text")] forControlState:UIControlStateNormal];
	[self.endStationButton setColors:[NSArray arrayWithObjects:
                                      [UIColor colorWithWhite:98.0f/255 alpha:1.0f],
                                      [UIColor colorWithWhite:108.0f/255 alpha:1.0f],
                                      nil] forControlState:UIControlStateHighlighted];
	[self.endStationButton setInnerShadowColor:[UIColor blackColor] forControlState:UIControlStateHighlighted];
	[self.endStationButton setInnerShadowRadius:4.0f forControlState:UIControlStateHighlighted];
	[self.endStationButton setInnerShadowOffset:CGSizeMake(0, 2) forControlState:UIControlStateHighlighted];
	[self.endStationButton addTarget:self action:@selector(endStationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.endStationButton.textAlignment = NSTextAlignmentLeft;
	[self.view addSubview:self.endStationButton];
    
    self.viaStationButton = [[FTWButton alloc] init];
    self.viaStationButton.frame = CGRectMake(15 + BUTTONHEIGHT + 5, TEXTFIELDHEIGHT* 2 + 16 + 12 + stationSelectionPadding, self.view.frame.size.width - 10 - BUTTONHEIGHT - 25 - BUTTONHEIGHT, TEXTFIELDHEIGHT);
	[self.viaStationButton addGrayStyleForState:UIControlStateNormal];
	[self.viaStationButton setText:[NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"Via:", @"Select stations via station help text"), NSLocalizedString(@"Current location", @"Station text field default text")] forControlState:UIControlStateNormal];
	[self.viaStationButton setColors:[NSArray arrayWithObjects:
                                      [UIColor colorWithWhite:98.0f/255 alpha:1.0f],
                                      [UIColor colorWithWhite:108.0f/255 alpha:1.0f],
                                      nil] forControlState:UIControlStateHighlighted];
	[self.viaStationButton setInnerShadowColor:[UIColor blackColor] forControlState:UIControlStateHighlighted];
	[self.viaStationButton setInnerShadowRadius:4.0f forControlState:UIControlStateHighlighted];
	[self.viaStationButton setInnerShadowOffset:CGSizeMake(0, 2) forControlState:UIControlStateHighlighted];
	[self.viaStationButton addTarget:self action:@selector(viaStationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.viaStationButton.textAlignment = NSTextAlignmentLeft;
	[self.view addSubview:self.viaStationButton];
    self.viaStationButton.alpha = 0.0;
    
    
    self.searchButton = [[FTWButton alloc] initWithFrame:CGRectMake(20, 340, self.view.frame.size.width - 40, BUTTONHEIGHT)];
    [self.searchButton addGrayStyleForState:UIControlStateNormal];
    [self.searchButton setColors:[NSArray arrayWithObjects:
                                   [UIColor colorWithWhite:98.0f/255 alpha:1.0f],
                                   [UIColor colorWithWhite:108.0f/255 alpha:1.0f],
                                   nil] forControlState:UIControlStateHighlighted];
    [self.searchButton setInnerShadowColor:[UIColor blackColor] forControlState:UIControlStateHighlighted];
	[self.searchButton setInnerShadowRadius:4.0f forControlState:UIControlStateHighlighted];
	[self.searchButton setInnerShadowOffset:CGSizeMake(0, 2) forControlState:UIControlStateHighlighted];
    NSString *searchButtonText = NSLocalizedString(@"Search", @"Search button title text");
    [self.searchButton setText:searchButtonText forControlState:UIControlStateNormal];
    [self.searchButton setText:searchButtonText forControlState:UIControlStateHighlighted];
    [self.searchButton setText:searchButtonText forControlState:UIControlStateSelected];
    
    //UIImage *searchButtonImage = [UIImage newImageFromMaskImage: [UIImage searchButtonImage] inColor: [UIColor selectStationsViewFTWButtonColorNormal]];
    //UIImage *searchButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage searchButtonImage] inColor: [UIColor selectStationsViewFTWButtonColorHighlighted]];
    //[self.searchButton setIcon: searchButtonImage forControlState: UIControlStateNormal];
    //[self.searchButton setIcon: searchButtonImage forControlState: UIControlStateSelected];
    //[self.searchButton setIcon: searchButtonImage forControlState: UIControlStateHighlighted];
    
    //[self.searchButton setIcon: searchButtonImageHighlighted forControlState: UIControlStateHighlighted];
    //self.timenowButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.searchButton addTarget: self action: @selector(triggerSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.searchButton];
    
    
    /*
    self.stationPickerNavigationController = [[UINavigationController alloc] init];
    self.stationPickerNavigationController.navigationBarHidden = YES;
    [self.view addSubview: self.stationPickerNavigationController.view];
    self.stationPickerNavigationController.view.alpha = 0.0;
    */
    
    //self.stationPickerNavigationController = [[UINavigationController alloc] initWithRootViewController: self.stationPickerViewController];
    //self.stationPickerNavigationController.navigationBarHidden = YES;
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTimeNow:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self updateTimeNow: nil];
}

- (void) triggerSearch:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector: @selector(didTriggerStartSearch:)]) {
        [self.delegate didTriggerStartSearch: self];
    }
}

- (void) updateTimeWithNowPlus10M:(id) sender {
    
    //NSLog(@"Update time, add 10 min");
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *dateString = [dateFormatter stringFromDate: [[NSDate date] dateByAddingTimeInterval:60*10]];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    //[timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *timeString = [timeFormatter stringFromDate: [[NSDate date] dateByAddingTimeInterval:60*10]];
    
    self.dateLabel.text = dateString;
    self.timeLabel.text = timeString;
    
    if (self.startDate) {
        self.startDate = [[NSDate date] dateByAddingTimeInterval:60*10];
        self.endDate = nil;
    } else {
        self.endDate = [[NSDate date] dateByAddingTimeInterval:60*10];
        self.startDate = nil;
    }
}

- (void) updateTimeWithNowPlus30M:(id) sender {
    
    //NSLog(@"Update time, add 30 min");
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *dateString = [dateFormatter stringFromDate: [[NSDate date] dateByAddingTimeInterval:60*30]];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    //[timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *timeString = [timeFormatter stringFromDate: [[NSDate date] dateByAddingTimeInterval:60*30]];
    
    self.dateLabel.text = dateString;
    self.timeLabel.text = timeString;
    
    if (self.startDate) {
        self.startDate = [[NSDate date] dateByAddingTimeInterval:60*30];
        self.endDate = nil;
    } else {
        self.endDate = [[NSDate date] dateByAddingTimeInterval:60*30];
        self.startDate = nil;
    }
}

- (void) updateTimeWithNowPlus60M:(id) sender {
    
    //NSLog(@"Update time, add 60 min");
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *dateString = [dateFormatter stringFromDate: [[NSDate date] dateByAddingTimeInterval:60*60]];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    //[timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *timeString = [timeFormatter stringFromDate: [[NSDate date] dateByAddingTimeInterval:60*60]];
    
    self.dateLabel.text = dateString;
    self.timeLabel.text = timeString;
    
    if (self.startDate) {
        self.startDate = [[NSDate date] dateByAddingTimeInterval:60*60];
        self.endDate = nil;
    } else {
        self.endDate = [[NSDate date] dateByAddingTimeInterval:60*60];
        self.startDate = nil;
    }
}


- (void) updateTimeNow:(NSNotification *)notification {
    //NSLog(@"Update time now. View did load or app came from background");
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *dateString = [dateFormatter stringFromDate: [NSDate date]];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    //[timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *timeString = [timeFormatter stringFromDate: [NSDate date]];
    
    self.dateLabel.text = dateString;
    self.timeLabel.text = timeString;
    
    if (self.startDate) {
        self.startDate = [NSDate date];
        self.endDate = nil;
    } else {
        self.endDate = [NSDate date];
        self.startDate = nil;
    }
}

-(void) cancelCurrentRunningRequestsIfAny {
    
    [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIOperations];
    
    
    if ([[SBBAPIController sharedSBBAPIController] isRequestInProgress]) {
        [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIOperations];
    }
    
    //[self hideLoadingIndicator];
}

- (void) setStartLocation:(id) sender {
    //self.startTextField.text = @"";
    
    [self cancelCurrentRunningRequestsIfAny];
    
    [self.startStationButton setText: [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"From:", @"Select stations from station help text"), NSLocalizedString(@"Current location", @"Station text field default text")] forControlState: UIControlStateNormal];
    self.startStationName = nil;
    self.startStationID = nil;
    self.startStationLatitude = nil;
    self.startStationLongitude = nil;
}

- (void) setEndLocation:(id) sender {
    //self.endTextField.text = @"";
    
    [self cancelCurrentRunningRequestsIfAny];
    
    [self.endStationButton setText: [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"To:", @"Select stations to station help text"), NSLocalizedString(@"Current location", @"Station text field default text")] forControlState: UIControlStateNormal];
    self.endStationName = nil;
    self.endStationID = nil;
    self.endStationLatitude = nil;
    self.endStationLongitude = nil;
}

- (void) cancelViaStation:(id) sender {
    [self cancelCurrentRunningRequestsIfAny];
    
    [self.viaStationButton setText: [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"Via:", @"Select stations via station help text"), NSLocalizedString(@"Current location", @"Station text field default text")] forControlState: UIControlStateNormal];
    self.viaStationName = nil;
    self.viaStationID = nil;
}

- (void) selectTimeAndDate:(id) sender {
    
    [self cancelCurrentRunningRequestsIfAny];
    
    /*
    self.dateAndTimePickerController = [[DateAndTimePickerController alloc] init];
    self.dateAndTimePickerController.delegate = self;
    self.currentlyPushedViewController = dateAndTimePickerViewController;
    [self presentSemiViewController: self.dateAndTimePickerController];
     */
    
    CGRect timeButtonRect = self.timeButton.frame;
    CGRect tbRectinView = [self.view convertRect: timeButtonRect fromView: self.timeButton];
    
    NSDate *date = (self.startDate)?self.startDate:self.endDate;
    BOOL deparr = (self.startDate)?YES:NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dateAndTimePickerButtonPressedFromRect:withdate:deparr:)])
    {
        [self.delegate dateAndTimePickerButtonPressedFromRect: tbRectinView withdate: date deparr:deparr];
    }
}

-(void) switchStations:(id) sender {
    
    [self cancelCurrentRunningRequestsIfAny];
    
    NSString *tempString;
    NSNumber *tempNumber;

    //NSLog(@"Switch station");
    tempString = self.startStationName;
    self.startStationName = self.endStationName;
    self.endStationName = tempString;
    
    tempString = self.startStationID;
    self.startStationID = self.endStationID;
    self.endStationID = tempString;
    
    tempNumber = self.startStationLatitude;
    self.startStationLatitude = self.endStationLatitude;
    self.endStationLatitude = tempNumber;
    
    tempNumber = self.startStationLongitude;
    self.startStationLongitude = self.endStationLongitude;
    self.endStationLongitude = tempNumber;
    
    if (self.startStationName) {
        [self.startStationButton setText: [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"From:", @"Select stations from station help text"), self.startStationName] forControlState: UIControlStateNormal];
    } else {
        [self.startStationButton setText: [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"From:", @"Select stations from station help text"), NSLocalizedString(@"Current location", @"Station text field default text")] forControlState: UIControlStateNormal];
    }
    if (self.endStationName) {
        [self.endStationButton setText: [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"To:", @"Select stations to station help text"), self.endStationName] forControlState: UIControlStateNormal];
    } else {
        [self.endStationButton setText: [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"To:", @"Select stations to station help text"), NSLocalizedString(@"Current location", @"Station text field default text")] forControlState: UIControlStateNormal];
    }
}

- (void) setStartLocationWithStation:(Station *)station {
    if (station) {
        self.startStationName = station.stationName;
        self.startStationID = station.stationId;
        self.startStationLatitude = station.latitude;
        self.startStationLongitude = station.longitude;
        [self.startStationButton setText: [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"From:", @"Select stations from station help text"), station.stationName] forControlState: UIControlStateNormal];
    }
}
- (void) setEndLocationWithStation:(Station *)station {
    if (station) {
        self.endStationName = station.stationName;
        self.endStationID = station.stationId;
        self.endStationLatitude = station.latitude;
        self.endStationLongitude = station.longitude;
        [self.endStationButton setText: [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"To:", @"Select stations to station help text"), station.stationName] forControlState: UIControlStateNormal];
    }
}
- (void) setViaLocationWithStation:(Station *)station {
    if (station) {
        self.viaStationName = station.stationName;
        self.viaStationID = station.stationId;
        //self.viaStationLatitude = station.latitude;
        //self.viaStationLongitude = station.longitude;
        [self.viaStationButton setText: [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"Via:", @"Select stations via station help text"), station.stationName] forControlState: UIControlStateNormal];
    }
}

- (Station *) getStartLocation {
    Station *station = [[Station alloc] init];
    station.stationName = self.startStationName;
    station.stationId = self.startStationID;
    station.latitude = self.startStationLatitude;
    station.longitude = self.startStationLongitude;
    return station;
}

- (Station *) getEndLocation {
    Station *station = [[Station alloc] init];
    station.stationName = self.endStationName;
    station.stationId = self.endStationID;
    station.latitude = self.endStationLatitude;
    station.longitude = self.endStationLongitude;
    return station;
}

- (Station *) getViaLocation {
    Station *station = [[Station alloc] init];
    station.stationName = self.viaStationName;
    station.stationId = self.viaStationID;
    //station.latitude = self.startStationLatitude;
    //station.longitude = self.startStationLongitude;
    return station;
}

- (NSDate *) getConnectionDate {
    if (self.startDate) {
        return self.startDate;
    }
    if (self.endDate) {
        return self.endDate;
    }
    return nil;
}

- (BOOL) getConnectionDateDepArr {
    if (self.startDate) {
        return YES;
    } else {
        return NO;
    }
}

- (void) setLocationsFromMapAppInitAndPushBackToCurrentVCIfRequired:(Station *)from to:(Station *)to push:(BOOL)push searchinit:(BOOL)searchinit {
    
    #ifdef LOGOUTPUTON
    NSLog(@"ConnectionsSelectionViewControlleriPad: Select stations view controller iPad. Set locations from maps");
    #endif
    
    if (!from) {
        self.startStationName = nil;
        self.startStationID = nil;
        self.startStationLatitude = nil;
        self.startStationLongitude = nil;
        [self.startStationButton setText: [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"From:", @"Select stations from station help text"), NSLocalizedString(@"Current location", @"Station text field default text")] forControlState: UIControlStateNormal];
    } else {
        self.startStationName = from.stationName;
        self.startStationID = nil;
        self.startStationLatitude = from.latitude;
        self.startStationLongitude = from.longitude;
        [self.startStationButton setText: [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"From:", @"Select stations from station help text"), from.stationName] forControlState: UIControlStateNormal];
    }
    
    if (!to) {
        self.endStationName = nil;
        self.endStationID = nil;
        self.endStationLatitude = nil;
        self.endStationLongitude = nil;
        [self.endStationButton setText: [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"To:", @"Select stations to station help text"), NSLocalizedString(@"Current location", @"Station text field default text")] forControlState: UIControlStateNormal];
    } else {
        self.endStationName = to.stationName;
        self.endStationID = nil;
        self.endStationLatitude = to.latitude;
        self.endStationLongitude = to.longitude;
        [self.endStationButton setText: [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"To:", @"Select stations to station help text"), to.stationName] forControlState: UIControlStateNormal];
    }
    
    if (push) {
        #ifdef LOGOUTPUTON
        NSLog(@"Set locations, push flag set");
        #endif
    }
    
    if (searchinit) {
        #ifdef LOGOUTPUTON
        NSLog(@"Set locations, search init flag set");
        #endif
    }
}

- (void) toggleViaStationWithFlag:(BOOL)visible {
    self.viaButton.selected = visible;
    
    CGFloat toggleAnimationDuration = 0.1;
    
    if (self.viaButton.selected) {
        
        [UIView animateWithDuration:toggleAnimationDuration animations:^{
            self.stationsViaControlBackgroundView.alpha = 1.0;
            self.stationsControlBackgroundView.alpha = 1.0;
            self.cancelButton.alpha = 1.0;
            self.viaStationButton.alpha = 1.0;
            self.endStationButton.alpha = 1.0;
            self.pinStartButton.alpha = 1.0;
            self.pinEndButton.alpha = 1.0;
            self.switchStationsButton.alpha = 1.0;
            CGRect timeContainerFrame = self.timeControlBackgroundView.frame;
            timeContainerFrame.origin.y = 4 + TEXTFIELDHEIGHT * 3 + 30 + 30 + 45;
            self.timeControlBackgroundView.frame = timeContainerFrame;
            CGRect searchButtonRect = self.searchButton.frame;
            searchButtonRect.origin.y = 340 + 45;
            self.searchButton.frame = searchButtonRect;
        }];
    } else {
        [UIView animateWithDuration:toggleAnimationDuration animations:^{
            self.stationsViaControlBackgroundView.alpha = 0.0;
            self.stationsControlBackgroundView.alpha = 1.0;
            self.cancelButton.alpha = 0.0;
            self.viaStationButton.alpha = 0.0;
            self.endStationButton.alpha = 1.0;
            self.pinStartButton.alpha = 1.0;
            self.pinEndButton.alpha = 1.0;
            self.switchStationsButton.alpha = 1.0;
            CGRect timeContainerFrame = self.timeControlBackgroundView.frame;
            timeContainerFrame.origin.y = 4 + TEXTFIELDHEIGHT * 3 + 30 + 30;
            self.timeControlBackgroundView.frame = timeContainerFrame;
            CGRect searchButtonRect = self.searchButton.frame;
            searchButtonRect.origin.y = 340;
            self.searchButton.frame = searchButtonRect;
        }];
    }
    
}

-(void) toggleViaStation:(id) sender {
    BOOL visibleState = !self.viaButton.selected;
    [self toggleViaStationWithFlag: visibleState];
    
    if (self.delegate && [self.delegate respondsToSelector: @selector(didTriggerOpenShowViaStationWithVisibleFlag:visible:)]) {
        [self.delegate didTriggerOpenShowViaStationWithVisibleFlag: self visible: visibleState];
    }
}


-(void) startStationButtonTapped:(id) sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectStartStationButtonPressed:fromrect:)])
    {
        [self.delegate selectStartStationButtonPressed:self fromrect:self.startStationButton.frame];
    }
}

-(void) endStationButtonTapped:(id) sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectEndStationButtonPressed:fromrect:)])
    {
        [self.delegate selectEndStationButtonPressed:self fromrect:self.endStationButton.frame];
    }
}

-(void) viaStationButtonTapped:(id) sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectViaStationButtonPressed:fromrect:)])
    {
        [self.delegate selectViaStationButtonPressed:self fromrect:self.viaStationButton.frame];
    }
}

- (void)setConnectionDate:(NSDate *)date depArr:(BOOL)depArr {
    
    //NSLog(@"Set connection date");
    
    //[self dismissSemiModalView];
    
    if (date) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        [dateFormatter setDateFormat:@"dd/MM/YYYY"];
        //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
        NSString *dateString = [dateFormatter stringFromDate: date];
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH:mm"];
        //[timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
        NSString *timeString = [timeFormatter stringFromDate: date];
        
        self.dateLabel.text = dateString;
        self.timeLabel.text = timeString;
        
        if (self.startDate) {
            self.startDate = date;
        } else {
            self.endDate = date;
        }
    }
}

- (void) updateDateWithTimeNow:(id)sender {
    
    [self cancelCurrentRunningRequestsIfAny];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *dateString = [dateFormatter stringFromDate: [NSDate date]];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    //[timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:1]];
    NSString *timeString = [timeFormatter stringFromDate: [NSDate date]];
    
    self.dateLabel.text = dateString;
    self.timeLabel.text = timeString;
    
    if (self.startDate) {
        self.startDate = [NSDate date];
        self.endDate = nil;
    } else {
        self.startDate = nil;
        self.endDate = [NSDate date];
    }
}

- (void) startGettingUserLocation {
    NSLog(@"Start getting the users location");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"ConnectionsSelectionViewControlleriPad: should autororate");
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	NSLog(@"ConnectionsSelectionViewControlleriPad: willRotateToInterfaceOrientation");
    //[self layoutSubviews:YES toInterfaceOrientation:toInterfaceOrientation];
    //[self.connectionsMapViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"ConnectionsSelectionViewControlleriPad: didRotateToInterfaceOrientation");
    //[self.connectionsMapViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"ConnectionsSelectionViewControlleriPad: willAnimateRotateToInterfaceOrientation");
    //[self layoutSubviews:YES toInterfaceOrientation:toInterfaceOrientation];
	//[self.connectionsMapViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration: duration];
}

- (void) viewWillAppear:(BOOL)animated {
    //NSLog(@"ConnectionsSelectionViewControlleriPad: viewwillappear");
	[super viewWillAppear:animated];
	//[self.connectionsMapViewController viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
    //NSLog(@"ConnectionsSelectionViewControlleriPad: viewdidappear");
	[super viewDidAppear:animated];
    //[self layoutSubviews: NO toInterfaceOrientation: [[UIDevice currentDevice] orientation]];
	//[self.connectionsMapViewController viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    //NSLog(@"ConnectionsSelectionViewControlleriPad: viewwilldisappear");
	[super viewWillDisappear:animated];
	//[self.connectionsMapViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    //NSLog(@"ConnectionsSelectionViewControlleriPad: viewdiddisappear");
	[super viewDidDisappear:animated];
	//[self.connectionsMapViewController viewDidDisappear:animated];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
