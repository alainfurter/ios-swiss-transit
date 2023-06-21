//
//  SelectStationsViewController.m
//  Swiss Trains
//
//  Created by Alain on 20.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "SelectStationsViewController.h"

//#define TOOLBARHEIGHT 44.0
#define BUTTONHEIGHT 36.0
#define TEXTFIELDHEIGHT 30.0
#define SEGMENTHEIGHT 18.0

#define STATIONLEGAL          @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890' "
//#define STATIONILLEGAL        @"-/:;()$&@\".,?!'[]{}#%^*+=_\\|~<>€£¥•"
#define STATIONILLEGAL        @"-/:;()$&@\".,?![]{}#%^*+=_\\|~<>€£¥•"
#define NUMBERLEGAL           @"1234567890"

#define kSemiModalAnimationDuration   0.3

#import "IASKSpecifier.h"
#import "IASKSettingsReader.h"

@interface SelectStationsViewController ()

@end

@implementation SelectStationsViewController

@synthesize fetchedResultsController, managedObjectContext;

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

    //self.view.backgroundColor = [UIColor lightGrayColor];
    self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
    
    NSUInteger stationSelectionPadding = 55;
    NSUInteger timeSelectionPadding = 110;
    
    self.showIntroFlag = NO;
    self.skipIntroFlag = NO;
    
    //NSLog(@"Init skip intro flag");
    
    self.startDate = [NSDate date];
    self.endDate = nil;
    self.selectedRequestType = conreqRequestType;
    
    self.currentlyPushedViewController = noViewController;
        
    self.conReqContrainerView = [[UIView alloc] initWithFrame: CGRectMake(0, BUTTONHEIGHT, self.view.frame.size.width, self.view.frame.size.height - BUTTONHEIGHT)];
    self.stbContrainerView = [[UIView alloc] initWithFrame: CGRectMake(0, BUTTONHEIGHT, self.view.frame.size.width, self.view.frame.size.height - BUTTONHEIGHT)];
    self.delayinfoContrainerView = [[UIView alloc] initWithFrame: CGRectMake(0, BUTTONHEIGHT, self.view.frame.size.width, self.view.frame.size.height - BUTTONHEIGHT)];
    
    // Start image
    [self.view addSubview: self.conReqContrainerView];
    [self.view addSubview: self.stbContrainerView];
    self.stbContrainerView.alpha = 0.0;
    [self.view addSubview: self.delayinfoContrainerView];
    self.delayinfoContrainerView.alpha = 0.0;
    
    CGFloat scaleFactor = 3.5;
    //CGFloat scaleFactorConReq = 3.0;
    UIImage *conreqImage =  [UIImage newImageFromMaskImage: [[UIImage conreqButtonImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactor, SEGMENTHEIGHT * scaleFactor) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlItemImageColor]];
    UIImage *stbImage = [UIImage newImageFromMaskImage: [[UIImage stboardButtonImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactor, SEGMENTHEIGHT * scaleFactor) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlItemImageColor]];
    UIImage *infoImage = [UIImage newImageFromMaskImage: [[UIImage delayinfoButtonImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactor, SEGMENTHEIGHT * scaleFactor) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlItemImageColor]];
    self.requestTypeSegmentControl = [[SDSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: @"", nil]];
    //self.requestTypeSegmentControl = [[SDSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, BUTTONHEIGHT)];
    //self.requestTypeSegmentControl = [[SDSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: conreqImage, stbImage, infoImage, nil]];
    CGRect segmentcontrolFrame = CGRectMake(0, 0, self.view.frame.size.width, REQSEGCONTROLHEIGHT);
    self.requestTypeSegmentControl.frame = segmentcontrolFrame;
    
    //start image
    //[self.requestTypeSegmentControl insertSegmentWithTitle: @"" atIndex:0 animated:NO];
    
    [self.requestTypeSegmentControl insertSegmentWithImage: conreqImage atIndex: 1 animated: NO];
    [self.requestTypeSegmentControl insertSegmentWithImage: stbImage atIndex: 2 animated: NO];
    [self.requestTypeSegmentControl insertSegmentWithImage: infoImage atIndex: 3 animated: NO];
    
    [self.requestTypeSegmentControl setImage: conreqImage forSegmentAtIndex: 0];
    [self.requestTypeSegmentControl setBackgroundImage: conreqImage forState: UIControlStateNormal barMetrics: UIBarMetricsDefault];
    [self.requestTypeSegmentControl setImage: stbImage forSegmentAtIndex: 1];
    [self.requestTypeSegmentControl setImage: infoImage forSegmentAtIndex: 2];
    [self.requestTypeSegmentControl addTarget:self action: @selector(segmentDidChange:) forControlEvents: UIControlEventValueChanged];
    [self.requestTypeSegmentControl removeSegmentAtIndex: 3 animated: NO];
    
    //start image
    [self.view addSubview: self.requestTypeSegmentControl];
    
    self.conreqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.conreqButton.frame = CGRectMake(58, 0, BUTTONHEIGHT*2.3 - 14, BUTTONHEIGHT);
    //self.conreqButton.backgroundColor = [UIColor colorWithWhite:0.5 alpha: 0.6];
    [self.conreqButton addTarget: self action: @selector(selectConReqType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.conreqButton];
    
    self.stbreqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.stbreqButton.frame = CGRectMake(55 + BUTTONHEIGHT*2.3 - 11, 0, BUTTONHEIGHT*2.3 - 15, BUTTONHEIGHT);
    //self.stbreqButton.backgroundColor = [UIColor colorWithWhite:0.5 alpha: 0.6];
    [self.stbreqButton addTarget: self action: @selector(selectStbReqType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.stbreqButton];
    
    self.inforeqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.inforeqButton.frame = CGRectMake(55 + BUTTONHEIGHT*2.3 - 11 + BUTTONHEIGHT*2.3 - 15, 0, BUTTONHEIGHT*2.3 - 14, BUTTONHEIGHT);
    //self.inforeqButton.backgroundColor = [UIColor colorWithWhite:0.5 alpha: 0.6];
    [self.inforeqButton addTarget: self action: @selector(selectInfoReqType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.inforeqButton];
    
    
    self.stationsControlBackgroundView = [[ControlsBackgroundView alloc] initWithFrame: CGRectMake(0, 4+30 + stationSelectionPadding - 55, self.view.frame.size.width, TEXTFIELDHEIGHT * 3 + 30)];
    [self.conReqContrainerView addSubview: self.stationsControlBackgroundView];
    
    self.stationsViaControlBackgroundView = [[ControlsBackgroundView alloc] initWithFrame: CGRectMake(0, 4+30 + stationSelectionPadding - 55, self.view.frame.size.width, TEXTFIELDHEIGHT * 4 + 45)];
    [self.conReqContrainerView addSubview: self.stationsViaControlBackgroundView];
    self.stationsViaControlBackgroundView.alpha = 0.0;
    
    self.stationsStbControlBackgroundView = [[ControlsBackgroundView alloc] initWithFrame: CGRectMake(0, 4+30 + stationSelectionPadding - 55, self.view.frame.size.width, TEXTFIELDHEIGHT + 45)];
    [self.conReqContrainerView addSubview: self.stationsStbControlBackgroundView];
    self.stationsStbControlBackgroundView.alpha = 0.0;
    
    self.timeControlBackgroundView = [[ControlsBackgroundView alloc] initWithFrame: CGRectMake(0, 4 + TEXTFIELDHEIGHT * 3 + 30 + 30 + timeSelectionPadding - 110, self.view.frame.size.width, TEXTFIELDHEIGHT * 3 + 60 + 20)];
    [self.conReqContrainerView addSubview: self.timeControlBackgroundView];
    
    
    self.connectionsContainerViewController = [[ConnectionsContainerViewController alloc] init];
    self.connectionsContainerViewController.view.frame = CGRectMake(320, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.connectionsContainerViewController.delegate = self;
    
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
    //self.timeButton.showsTouchWhenHighlighted = YES;
    [self.timeButton addTarget: self action: @selector(selectTimeAndDate:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview: self.timeButton];
    [self.timeButton layoutSubviews];
    [self.timeControlBackgroundView addSubview: self.timeButton];
    
    self.timeLabel = [[UILabel alloc] initWithFrame: CGRectMake(5 + BUTTONHEIGHT + 45, BUTTONHEIGHT * 3 + 15, BUTTONHEIGHT * 2, BUTTONHEIGHT)];
    //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
    self.timeLabel.font = [UIFont boldSystemFontOfSize: 15.0];
    self.timeLabel.textColor = [UIColor selectStationsViewButtonColorNormal];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    //[self.view addSubview: self.timeLabel];
    [self.timeControlBackgroundView addSubview: self.timeLabel];
    
    self.dateLabel = [[UILabel alloc] initWithFrame: CGRectMake(5 + BUTTONHEIGHT*2 + 5 + 70, BUTTONHEIGHT * 3 + 15, BUTTONHEIGHT * 3, BUTTONHEIGHT)];
    //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
    self.dateLabel.font = [UIFont boldSystemFontOfSize: 15.0];
    self.dateLabel.textColor = [UIColor selectStationsViewButtonColorNormal];
    self.dateLabel.backgroundColor = [UIColor clearColor];
    self.dateLabel.textAlignment = NSTextAlignmentLeft;
    //[self.view addSubview: self.dateLabel];
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
    //[self.timenowButton setIcon: timenowButtonImageHighlighted forControlState: UIControlStateSelected];
    [self.timenowButton setIcon: timenowButtonImageHighlighted forControlState: UIControlStateHighlighted];
    self.timenowButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    //self.timeButton.showsTouchWhenHighlighted = YES;
    [self.timenowButton addTarget: self action: @selector(updateDateWithTimeNow:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview: self.timeButton];
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
	//[self.view addSubview:self.startStationButton];
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
	//[self.view addSubview:self.startStationButton];
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
	//[self.view addSubview:self.startStationButton];
    [self.timeControlBackgroundView addSubview:self.timePlus60MButton];
    
    self.navSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"", @"", nil]];    
    CGFloat scaleFactorNavSc = 1.5;
    UIImage *depImage =  [[UIImage journeyDepartureImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactorNavSc, SEGMENTHEIGHT) interpolationQuality: kCGInterpolationDefault];
    UIImage *arrImage = [[UIImage journeyArrivalImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactorNavSc, SEGMENTHEIGHT) interpolationQuality: kCGInterpolationDefault];
    self.navSC.sectionImages = [NSArray arrayWithObjects: depImage, arrImage, nil];
    //navSC.sectionTitles = nil;
    
    __weak SelectStationsViewController *weakself = self;
    self.navSC.changeHandler = ^(NSUInteger newIndex) {
        //NSLog(@"segmentedControl did select index %i (via block handler)", newIndex);
        if (newIndex == 0) {
            if (weakself.endDate) {
                weakself.startDate = weakself.endDate;
                weakself.endDate = nil;
            }
        } else {
            if (weakself.startDate) {
                weakself.endDate = weakself.startDate;
                weakself.startDate = nil;
            }
        }
    };
    //self.navSC.center = CGPointMake(240, TEXTFIELDHEIGHT * 2 + 10 + 20 + timeSelectionPadding);
    self.navSC.center = CGPointMake(240, 41);
    [self.timeControlBackgroundView addSubview: self.navSC];
    [self.navSC setSelectedIndex: 0];
    
    self.separatorLineLayerTime = CAShapeLayer.layer;
    [self.view.layer addSublayer:self.separatorLineLayerTime];
    self.separatorLineLayerTime.strokeColor = [UIColor lightGrayColor].CGColor;
    self.separatorLineLayerTime.lineWidth = .5;
    self.separatorLineLayerTime.fillColor = nil;
    //[self.view.layer addSublayer: self.separatorLineLayer];
    [self.timeControlBackgroundView.layer addSublayer: self.separatorLineLayerTime];
    
    CGRect ownframeTime = self.view.frame;
    CGFloat lineWidthTime = self.separatorLineLayerTime.lineWidth;
    UIBezierPath *borderBottomPathTime = [UIBezierPath bezierPathWithRect: CGRectMake(ownframeTime.origin.x + 10, BUTTONHEIGHT * 2 + 2 - lineWidthTime, ownframeTime.size.width - 20, lineWidthTime)];
    //const CGFloat lineY = bottom - self.borderBottomLayer.lineWidth;
    //[self addArrowAtPoint:CGPointMake(position, lineY) toPath:borderBottomPath withLineWidth:_borderBottomLayer.lineWidth];
    self.separatorLineLayerTime.path = borderBottomPathTime.CGPath;
    
    //CGFloat scaleFactorReqSegControlInfo = 0.6;
    self.infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *infoButtonImage =  [UIImage newImageFromMaskImage: [[UIImage infoButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLINFO, BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLINFO) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
    UIImage *infoButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage infoButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLINFO, BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLINFO) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
    [self.infoButton setImage: infoButtonImage forState: UIControlStateNormal];
    [self.infoButton setImage: infoButtonImageHighlighted forState: UIControlStateHighlighted];
    self.infoButton.imageView.contentMode = UIViewContentModeCenter;
    self.infoButton.frame = CGRectMake(5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.infoButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.infoButton.showsTouchWhenHighlighted = YES;
    [self.infoButton addTarget: self action: @selector(showInfoViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    //Start image
    [self.view addSubview: self.infoButton];
    
    //CGFloat SCALEFACTORREQSEQCONTROLGO = 1.0;
    self.goButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *goButtonImage =  [UIImage newImageFromMaskImage: [[UIImage searchButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLGO, BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLGO) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorNormal]];
    UIImage *goButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage searchButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLGO, BUTTONHEIGHT * SCALEFACTORREQSEQCONTROLGO) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlButtonsImageColorHighlighted]];
    
    [self.goButton setImage: goButtonImage forState: UIControlStateNormal];
    [self.goButton setImage: goButtonImageHighlighted forState: UIControlStateHighlighted];
    self.goButton.imageView.contentMode = UIViewContentModeCenter;
    self.goButton.frame = CGRectMake(self.view.frame.size.width - 5 - BUTTONHEIGHT, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    self.goButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.goButton.showsTouchWhenHighlighted = YES;
    [self.goButton addTarget: self action: @selector(executeSBBAPIRequest:) forControlEvents:UIControlEventTouchUpInside];
    
    // start image
    [self.view addSubview: self.goButton];
    
        
    CGFloat scaleFactorArrowImage = 1.0;
    self.viaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *viaDownButtonImage = [UIImage newImageFromMaskImage: [[UIImage arrowdownButtonImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactorArrowImage, SEGMENTHEIGHT * scaleFactorArrowImage) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor selectStationsViewButtonColorNormal]];
    UIImage *viaUpButtonImage = [UIImage newImageFromMaskImage: [[UIImage arrowupButtonImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactorArrowImage, SEGMENTHEIGHT * scaleFactorArrowImage) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor selectStationsViewButtonColorNormal]];
    [[UIImage listButtonImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactor, SEGMENTHEIGHT * scaleFactor) interpolationQuality: kCGInterpolationDefault];
    [self.viaButton setImage: viaDownButtonImage forState: UIControlStateNormal];
    //[self.viaButton setImage: viaDownButtonImageHighlighted forState: UIControlStateHighlighted];
    [self.viaButton setImage: viaUpButtonImage forState: UIControlStateSelected];
    //[self.viaButton setImage: viaUpButtonImageHighlighted forState: UIControlStateHighlighted];
    
    self.viaButton.imageView.contentMode = UIViewContentModeCenter;
    //self.switchStationsButton.frame = CGRectMake(5, BUTTONHEIGHT + 15, BUTTONHEIGHT, BUTTONHEIGHT);
    self.viaButton.frame = CGRectMake(15, 22 + stationSelectionPadding - BUTTONHEIGHT + 5, BUTTONHEIGHT, BUTTONHEIGHT);
    self.viaButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.viaButton.showsTouchWhenHighlighted = YES;
    [self.viaButton addTarget: self action: @selector(toggleViaStation:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview: self.switchStationsButton];
    [self.conReqContrainerView addSubview: self.viaButton];
    
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
    //[self.view addSubview: self.switchStationsButton];
    [self.conReqContrainerView addSubview: self.switchStationsButton];
    
    self.pinStartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *pinButtonImage = [UIImage newImageFromMaskImage: [UIImage pinButtonImage] inColor: [UIColor selectStationsViewButtonColorNormal]];
    UIImage *pinButtonImageHighlighted = [UIImage newImageFromMaskImage: [UIImage pinButtonImage] inColor: [UIColor selectStationsViewButtonColorHighlighted]];
    [self.pinStartButton setImage: pinButtonImage forState: UIControlStateNormal];
    [self.pinStartButton setImage: pinButtonImageHighlighted forState: UIControlStateHighlighted];
    self.pinStartButton.imageView.contentMode = UIViewContentModeCenter;
    self.pinStartButton.frame = CGRectMake(self.view.frame.size.width - 15 - TEXTFIELDHEIGHT, 4 + stationSelectionPadding, TEXTFIELDHEIGHT, TEXTFIELDHEIGHT);
    self.pinStartButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.pinStartButton.showsTouchWhenHighlighted = YES;
    [self.pinStartButton addTarget: self action: @selector(setStartLocation:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview: self.pinStartButton];
    [self.conReqContrainerView addSubview: self.pinStartButton];
    
    self.pinEndButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pinEndButton setImage: pinButtonImage forState: UIControlStateNormal];
    [self.pinEndButton setImage: pinButtonImageHighlighted forState: UIControlStateHighlighted];
    self.pinEndButton.imageView.contentMode = UIViewContentModeCenter;
    self.pinEndButton.frame = CGRectMake(self.view.frame.size.width - 15 - TEXTFIELDHEIGHT, TEXTFIELDHEIGHT + 16 + stationSelectionPadding, TEXTFIELDHEIGHT, TEXTFIELDHEIGHT);
    self.pinEndButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.pinEndButton.showsTouchWhenHighlighted = YES;
    [self.pinEndButton addTarget: self action: @selector(setEndLocation:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview: self.pinEndButton];
    [self.conReqContrainerView addSubview: self.pinEndButton];
    
    CGFloat scaleFactorCancelButtonImage = 1.5;
    UIImage *cancelButtonImage = [UIImage newImageFromMaskImage: [[UIImage cancelButtonImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactorCancelButtonImage, SEGMENTHEIGHT * scaleFactorCancelButtonImage) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor selectStationsViewButtonColorNormal]];
    UIImage *cancelButtonImageHighlighted = [UIImage newImageFromMaskImage: [[UIImage cancelButtonImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactorCancelButtonImage, SEGMENTHEIGHT * scaleFactorCancelButtonImage) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor selectStationsViewButtonColorHighlighted]];
    self.cancelStbDirButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelStbDirButton setImage: cancelButtonImage forState: UIControlStateNormal];
    [self.cancelStbDirButton setImage: cancelButtonImageHighlighted forState: UIControlStateHighlighted];
    self.cancelStbDirButton.imageView.contentMode = UIViewContentModeCenter;
    self.cancelStbDirButton.frame = CGRectMake(self.view.frame.size.width - 15 - TEXTFIELDHEIGHT, TEXTFIELDHEIGHT + 16 + stationSelectionPadding, TEXTFIELDHEIGHT, TEXTFIELDHEIGHT);
    self.cancelStbDirButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.cancelStbDirButton.showsTouchWhenHighlighted = YES;
    [self.cancelStbDirButton addTarget: self action: @selector(cancelStbDirStation:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview: self.pinEndButton];
    [self.conReqContrainerView addSubview: self.cancelStbDirButton];
    self.cancelStbDirButton.alpha = 0.0;

    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setImage: cancelButtonImage forState: UIControlStateNormal];
    [self.cancelButton setImage: cancelButtonImageHighlighted forState: UIControlStateHighlighted];
    self.cancelButton.imageView.contentMode = UIViewContentModeCenter;
    self.cancelButton.frame = CGRectMake(self.view.frame.size.width - 15 - TEXTFIELDHEIGHT, TEXTFIELDHEIGHT * 2 + 16 + 12 + stationSelectionPadding, TEXTFIELDHEIGHT, TEXTFIELDHEIGHT);
    self.cancelButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.cancelButton.showsTouchWhenHighlighted = YES;
    [self.cancelButton addTarget: self action: @selector(cancelViaStation:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview: self.pinEndButton];
    [self.conReqContrainerView addSubview: self.cancelButton];
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
	//[self.view addSubview:self.startStationButton];
    [self.conReqContrainerView addSubview:self.startStationButton];
    
    
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
	//[self.view addSubview:self.endStationButton];
    [self.conReqContrainerView addSubview:self.endStationButton];
    
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
	//[self.view addSubview:self.endStationButton];
    [self.conReqContrainerView addSubview:self.viaStationButton];
    self.viaStationButton.alpha = 0.0;
        
    self.stationPickerViewController = [[StationPickerViewController alloc] init];
    self.stationPickerViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.stationPickerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    self.stationPickerViewController.managedObjectContext = self.managedObjectContext;
    self.stationPickerViewController.stationTypeIndex = startStationType;
    self.stationPickerViewController.stationpickerType = connectionsStationpickerType;
    self.stationPickerViewController.delegate = self;
    
    self.stbCurrentStationIsPrechecked = NO;
    self.stbIsPreCheckingStation = NO;
    self.stbPushStationboardViewControllerAfterPreCheck = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTimeNow:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appisenteringbackgroundaction:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    /*
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(appdidbecomeactiveaction:)
     name:UIApplicationDidBecomeActiveNotification object:nil];
     */
    
    [self updateTimeNow: nil];
    
    self.delayInfoTableView = [[UITableView alloc] initWithFrame: self.delayinfoContrainerView.bounds style:UITableViewStylePlain];
    self.delayInfoTableView.rowHeight = 30;
    //self.overViewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.delayInfoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.delayInfoTableView.separatorColor = [UIColor lightGrayColor];
    //self.delayInfoTableView.backgroundColor = [UIColor overviewTableviewBackgroundColor];
    self.delayInfoTableView.backgroundColor = [UIColor listviewControllersBackgroundColor];
    //self.overViewTableView.backgroundColor = [UIColor blackColor];
    [self.delayInfoTableView registerClass:[RssInfoCell class] forCellReuseIdentifier: @"RssInfoCell"];
    [self.delayinfoContrainerView addSubview: self.delayInfoTableView];
    self.delayInfoTableView.dataSource = self;
    self.delayInfoTableView.delegate = self;
    self.delayInfoTableView.alpha = 0.0;
    
    
    self.searchButton = [[FTWButton alloc] initWithFrame:CGRectMake(20, 330, self.view.frame.size.width - 40, BUTTONHEIGHT)];
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
    [self.searchButton addTarget: self action: @selector(triggerSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self.conReqContrainerView addSubview: self.searchButton];
    
    //-----------------
    self.headerView = [[RssHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    [self addHeaderviewToTableView: self.headerView];
    //-----------------
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *introPath = [documentsDirectory stringByAppendingPathComponent: INTROSHOWNFLAGFILE];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
#ifdef FORCESHOWINTRO
    [fileManager removeItemAtPath: introPath error:NULL];
#endif
    
    //NSLog(@"Check intro flag");
    
    if (![fileManager fileExistsAtPath:introPath]) {
        [@"Introrun" writeToFile: introPath atomically: YES encoding: NSUTF8StringEncoding error: NULL];
        self.showIntroFlag = YES;
    }
    
    [self.view addSubview: self.connectionsContainerViewController.view];
    
}

- (void)movieDidFinish:(IntroMoviePlayerController *)controller {
    [self startGettingUserLocation];
}

- (void)showMoviePlayerController {
    IntroMoviePlayerController *introMoviePlayerController = [[IntroMoviePlayerController alloc] init];
    introMoviePlayerController.view.frame = self.view.bounds;
    introMoviePlayerController.modalPresentationStyle = UIModalPresentationFullScreen;
    introMoviePlayerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    introMoviePlayerController.wantsFullScreenLayout = YES;
    
    [self presentViewController: introMoviePlayerController animated: YES completion: nil];
    
    //introMoviePlayerController.view.superview.bounds = CGRectMake(0, 0, IPADMOVIEWIDTH * IPADMOVIESCALEFACTOR, IPADMOVIEHEIGHT * IPADMOVIESCALEFACTOR);
}

- (void) viewDidAppear:(BOOL)animated {
    
	[super viewDidAppear:animated];
    
    //NSLog(@"Check intro flag and init movie player");
    
    if (self.showIntroFlag) {
        self.showIntroFlag = NO;
        [self showMoviePlayerController];
    } else {
        [self startGettingUserLocation];
    }
}

/*
- (void) adstest {
    [[DTBannerManager sharedManager] removeAds];
}

- (void) adsontest {
    [[DTBannerManager sharedManager] addAdsToViewController: self.navigationController];
}
*/
 
- (void) updateTimeWithNowPlus10M:(id) sender {
    
    //NSLog(@"Update time, add 10 min");
    
    //[self performSelector:@selector(adstest) withObject:nil afterDelay: 5.0];
    
    [self cancelCurrentRunningRequestsIfAny];
    
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
    
    //[self performSelector:@selector(adsontest) withObject:nil afterDelay: 5.0];
    
    //NSLog(@"Update time, add 30 min");
    
    [self cancelCurrentRunningRequestsIfAny];
    
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
    
    [self cancelCurrentRunningRequestsIfAny];
    
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
        self.endDate = [NSDate date];
        self.startDate = nil;
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.currentlyPushedViewController = noViewController;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

// Present semi view date and time picker functions

-(UIView*)parentTarget {
    // To make it work with UINav & UITabbar as well
    UIViewController * target = self;
    while (target.parentViewController != nil) {
        target = target.parentViewController;
    }
    return target.view;
}

-(CAAnimationGroup*)animationGroupForward:(BOOL)_forward {
    // Create animation keys, forwards and backwards
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    t1 = CATransform3DRotate(t1, 15.0f*M_PI/180.0f, 1, 0, 0);
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = t1.m34;
    t2 = CATransform3DTranslate(t2, 0, [self parentTarget].frame.size.height*-0.08, 0);
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:t1];
    animation.duration = kSemiModalAnimationDuration/2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation2.toValue = [NSValue valueWithCATransform3D:(_forward?t2:CATransform3DIdentity)];
    animation2.beginTime = animation.duration;
    animation2.duration = animation.duration;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setDuration:animation.duration*2];
    [group setAnimations:[NSArray arrayWithObjects:animation,animation2, nil]];
    return group;
}

-(void)presentSemiViewController:(UIViewController*)vc {
    [self presentSemiView:vc.view];
}

-(void)presentSemiView:(UIView*)vc {
    // Determine target
    UIView * target = [self parentTarget];
    
    if (![target.subviews containsObject:vc]) {
        // Calulate all frames
        CGRect sf = vc.frame;
        CGRect vf = target.frame;
        CGRect f  = CGRectMake(0, vf.size.height-sf.size.height, vf.size.width, sf.size.height);
        CGRect of = CGRectMake(0, 0, vf.size.width, vf.size.height-sf.size.height);
        
        // Add semi overlay
        UIView * overlay = [[UIView alloc] initWithFrame:target.bounds];
        overlay.backgroundColor = [UIColor blackColor];
        
        // Take screenshot and scale
        UIGraphicsBeginImageContext(target.bounds.size);
        [target.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIImageView * ss = [[UIImageView alloc] initWithImage:image];
        [overlay addSubview:ss];
        [target addSubview:overlay];
        
        // Dismiss button
        // Don't use UITapGestureRecognizer to avoid complex handling
        UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [dismissButton addTarget:self action:@selector(dismissSemiModalView) forControlEvents:UIControlEventTouchUpInside];
        dismissButton.backgroundColor = [UIColor clearColor];
        dismissButton.frame = of;
        [overlay addSubview:dismissButton];
        
        // Begin overlay animation
        [ss.layer addAnimation:[self animationGroupForward:YES] forKey:@"pushedBackAnimation"];
        [UIView animateWithDuration:kSemiModalAnimationDuration animations:^{
            ss.alpha = 0.5;
        }];
        
        // Present view animated
        vc.frame = CGRectMake(0, vf.size.height, vf.size.width, sf.size.height);
        [target addSubview:vc];
        vc.layer.shadowColor = [[UIColor blackColor] CGColor];
        vc.layer.shadowOffset = CGSizeMake(0, -2);
        vc.layer.shadowRadius = 5.0;
        vc.layer.shadowOpacity = 0.8;
        [UIView animateWithDuration:kSemiModalAnimationDuration animations:^{
            vc.frame = f;
        }];
    }
}

-(void)dismissSemiModalView {
    UIView * target = [self parentTarget];
    UIView * modal = [target.subviews objectAtIndex:target.subviews.count-1];
    UIView * overlay = [target.subviews objectAtIndex:target.subviews.count-2];
    //__weak DateAndTimePickerController *weakDateAndTimePickerController = self.dateAndTimePickerController;
    [UIView animateWithDuration:kSemiModalAnimationDuration animations:^{
        modal.frame = CGRectMake(0, target.frame.size.height, modal.frame.size.width, modal.frame.size.height);
    } completion:^(BOOL finished) {
        [overlay removeFromSuperview];
        [modal removeFromSuperview];
        self.dateAndTimePickerController = nil;
    }];
    
    // Begin overlay animation
    UIImageView * ss = (UIImageView*)[overlay.subviews objectAtIndex:0];
    [ss.layer addAnimation:[self animationGroupForward:NO] forKey:@"bringForwardAnimation"];
    [UIView animateWithDuration:kSemiModalAnimationDuration animations:^{
        ss.alpha = 1;
    }];
}


// Functions

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
    
    //NSLog(@"Cancel requests");
    
    [self hideLoadingIndicator];
    
    if ([[SBBAPIController sharedSBBAPIController] isRequestInProgress]) {
        [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIOperations];
    }
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

- (void)  cancelStbDirStation:(id) sender {
    [self cancelCurrentRunningRequestsIfAny];
    
    [self.endStationButton setText: NSLocalizedString(@"Direction", @"Selectstationscontroller direction station replacment for nil station name") forControlState: UIControlStateNormal];
    self.dirStationName = nil;
    self.dirStationID = nil;
}

- (void) selectTimeAndDate:(id) sender {
    
    [self cancelCurrentRunningRequestsIfAny];
    
    self.dateAndTimePickerController = [[DateAndTimePickerController alloc] init];
    self.dateAndTimePickerController.delegate = self;
    self.currentlyPushedViewController = dateAndTimePickerViewController;
    [self presentSemiViewController: self.dateAndTimePickerController];
}

- (void) triggerSearch:(id)sender {
    [self executeSBBAPIRequest: nil];
}

-(void) executeSBBAPIRequest:(id) sender {
    
    if (self.selectedRequestType == conreqRequestType) {
        [self cancelCurrentRunningRequestsIfAny];
        [self getConnections: sender];
    } else if (self.selectedRequestType == stbRequestType) {
        [self getStationBoard:sender];
    }
}

- (void) preCheckStationboardProductTypesForStationAndPushStationboardViewControllerIfFlagSet {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable)
    {
        return;
    }
    
    Station *stbStation = [[Station alloc] init];
    [stbStation setStationName: self.stbStationName];
    [stbStation setStationId: self.stbStationID];
    
    Station *dirStation = [[Station alloc] init];
    [dirStation setStationName: self.dirStationName];
    [dirStation setStationId: self.dirStationID];
    
    if ((!self.stbStationName && !self.dirStationName) || [self.stbStationName isEqualToString: self.dirStationName])  return;
    
    NSDate *connectionTime; BOOL isDepartureTime = YES;
    
    if (self.startDate) {
        connectionTime = self.startDate;
        isDepartureTime = YES;
    } else if (self.endDate) {
        connectionTime = self.endDate;
        isDepartureTime = NO;
    } else {
        connectionTime = [NSDate date];
        isDepartureTime = YES;
    }
    
    if ([[SBBAPIController sharedSBBAPIController] isRequestInProgress]) {
        [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIOperations];
    }
    
    self.stbIsPreCheckingStation = YES;
    self.stbCurrentStationIsPrechecked = NO;
    
    if (self.stationboardConnectionsViewController) {
        self.stationboardConnectionsViewController = nil;
    }
    
    [[SBBAPIController sharedSBBAPIController] getProductTypesWithQuickCheckStbReqXMLStationboardRequestWithProductCode: stbStation
                                                                                                            destination: dirStation
                                                                                                                stbDate: connectionTime
                                                                                                          departureTime:isDepartureTime
                                                                                                   gotProductTypesBlock:^(NSUInteger productTypes){
#ifdef LOGOUTPUTON
                                                                                                       NSLog(@"Prechecked product types after selecting station");
#endif
                                                                                                       if (productTypes != stbNone) {
                                                                                                           self.stbIsPreCheckingStation = NO;
                                                                                                           self.stbStationboardCurrentPrecheckedProductType = productTypes;
                                                                                                           self.stbCurrentStationIsPrechecked = YES;
                                                                                                           
                                                                                                           if (self.stbPushStationboardViewControllerAfterPreCheck) {
#ifdef LOGOUTPUTON
                                                                                                               NSLog(@"Prechecked product types. Push flag set. Push view controller");
#endif
                                                                                                               self.stbPushStationboardViewControllerAfterPreCheck = NO;
                                                                                                               
                                                                                                               [self hideLoadingIndicator];
                                                                                                               
                                                                                                               self.stationboardConnectionsViewController = [[StationboardConnectionsViewController alloc] init];
                                                                                                               
                                                                                                               self.stationboardConnectionsViewController.stbStation = stbStation;
                                                                                                               self.stationboardConnectionsViewController.dirStation = dirStation;
                                                                                                               self.stationboardConnectionsViewController.connectionTime = connectionTime;
                                                                                                               self.stationboardConnectionsViewController.isDepartureTime = isDepartureTime;
                                                                                                               
                                                                                                               [self.stationboardConnectionsViewController updateControllerWithStationBoardProductCodesType: productTypes];
                                                                                                               self.currentlyPushedViewController = stationboardViewController;
                                                                                                               [self.navigationController pushViewController: self.stationboardConnectionsViewController animated: YES];
                                                                                                               
                                                                                                           }
                                                                                                       } else {
                                                                                                           // No products for station and ev. direction
                                                                                                       }
                                                                                                   }
                                                                                           failedToGetProductTypesBlock:^(NSUInteger errorcode){
                                                                                               //NSLog(@"Prechecked product types after selecting station failed.");
                                                                                               
                                                                                               //NSUInteger kStbReqRequestFailureCancelled = 7599;
                                                                                               
                                                                                               self.stbIsPreCheckingStation = NO;
                                                                                               self.stbCurrentStationIsPrechecked = NO;
                                                                                               
                                                                                               [self hideLoadingIndicator];
                                                                                               
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
    
    Station *stbStation = [[Station alloc] init];
    [stbStation setStationName: self.stbStationName];
    [stbStation setStationId: self.stbStationID];
    
    Station *dirStation = [[Station alloc] init];
    [dirStation setStationName: self.dirStationName];
    [dirStation setStationId: self.dirStationID];
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable)
    {
        
        [self hideLoadingIndicator];
        
        UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        [[NoticeviewMessages sharedNoticeMessagesController] showNoNetworkErrorMessage: currentWindow];
        
        return;
    }
    
    if (!self.stbStationName || !self.stbStationID)
	{
		[self hideLoadingIndicator];
        
        UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        [[NoticeviewMessages sharedNoticeMessagesController] showNoStationSelected: currentWindow];
        
		return;
	}
    
    
    if ((!self.stbStationName && !self.dirStationName) || [self.stbStationName isEqualToString: self.dirStationName])
	{
		[self hideLoadingIndicator];
        
        UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        [[NoticeviewMessages sharedNoticeMessagesController] showStbStationsIdenticalMessage: currentWindow];
        
		return;
	}
    
    /*
     if (self.startDate) {
     NSLog(@"Search with startdate");
     } else  if (self.endDate) {
     NSLog(@"Search with enddate");
     }
     */
    
    NSDate *connectionTime; BOOL isDepartureTime = YES;
    
    if (self.startDate) {
        connectionTime = self.startDate;
        isDepartureTime = YES;
    } else if (self.endDate) {
        connectionTime = self.endDate;
        isDepartureTime = NO;
    } else {
        connectionTime = [NSDate date];
        isDepartureTime = YES;
    }
    
    if ([[SBBAPIController sharedSBBAPIController] isRequestInProgress]) {
        [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIOperations];
    }
    
    if (self.stbCurrentStationIsPrechecked) {
        
        if (self.stationboardConnectionsViewController) {
            self.stationboardConnectionsViewController = nil;
        }
        
        self.stationboardConnectionsViewController = [[StationboardConnectionsViewController alloc] init];
        
        self.stationboardConnectionsViewController.stbStation = stbStation;
        self.stationboardConnectionsViewController.dirStation = dirStation;
        self.stationboardConnectionsViewController.connectionTime = connectionTime;
        self.stationboardConnectionsViewController.isDepartureTime = isDepartureTime;
        
        [self.stationboardConnectionsViewController updateControllerWithStationBoardProductCodesType: self.stbStationboardCurrentPrecheckedProductType];
        self.currentlyPushedViewController = stationboardViewController;
        [self.navigationController pushViewController: self.stationboardConnectionsViewController animated: YES];
        return;
    }
    
    [self showLoadingIndicator];
    
    if (self.stationboardConnectionsViewController) {
        self.stationboardConnectionsViewController = nil;
    }
    
    [[SBBAPIController sharedSBBAPIController] getProductTypesWithQuickCheckStbReqXMLStationboardRequestWithProductCode: stbStation
                                                                                                            destination: dirStation
                                                                                                                stbDate: connectionTime
                                                                                                          departureTime:isDepartureTime
                                                                                                   gotProductTypesBlock:^(NSUInteger productTypes){
                                                                                                       [self hideLoadingIndicator];
                                                                                                       
                                                                                                       if (productTypes != stbNone) {
                                                                                                           self.stationboardConnectionsViewController = [[StationboardConnectionsViewController alloc] init];
                                                                                                           
                                                                                                           self.stationboardConnectionsViewController.stbStation = stbStation;
                                                                                                           self.stationboardConnectionsViewController.dirStation = dirStation;
                                                                                                           self.stationboardConnectionsViewController.connectionTime = connectionTime;
                                                                                                           self.stationboardConnectionsViewController.isDepartureTime = isDepartureTime;
                                                                                                           
                                                                                                           [self.stationboardConnectionsViewController updateControllerWithStationBoardProductCodesType: productTypes];
                                                                                                           self.currentlyPushedViewController = stationboardViewController;
                                                                                                           [self.navigationController pushViewController: self.stationboardConnectionsViewController animated: YES];
                                                                                                       } else {
                                                                                                           [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqNoProductsForStbStation:self.view];
                                                                                                       }
                                                                                                   }
                                                                                           failedToGetProductTypesBlock:^(NSUInteger errorcode){
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

- (BOOL) checkIfInCH: (CLLocationCoordinate2D) coordinate {
    if (coordinate.latitude > 47.818688) return NO;
    if (coordinate.latitude < 45.79817) return NO;
    if (coordinate.longitude > 10.508423) return NO;
    if (coordinate.longitude < 5.921631) return NO;
    return YES;
}

-(void) getConnections:(id) sender {
    
    [self showLoadingIndicator];
    
    Station *startStation = [[Station alloc] init];
    [startStation setStationName: self.startStationName];
    [startStation setStationId: self.startStationID];
    [startStation setLatitude: self.startStationLatitude];
    [startStation setLongitude: self.startStationLongitude];
    
    Station *endStation = [[Station alloc] init];
    [endStation setStationName: self.endStationName];
    [endStation setStationId: self.endStationID];
    [endStation setLatitude: self.endStationLatitude];
    [endStation setLongitude: self.endStationLongitude];
    
    Station *viaStation = nil;
    if (self.viaStationName && self.viaStationID) {
        viaStation = [[Station alloc] init];
        [viaStation setStationName: self.viaStationName];
        [viaStation setStationId: self.viaStationID];
    }
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable)
    {
        
        [self hideLoadingIndicator];
        
        UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        [[NoticeviewMessages sharedNoticeMessagesController] showNoNetworkErrorMessage: currentWindow];
        
        return;
    }
    
    if ((!self.startStationName && !self.endStationName) || [self.startStationName isEqualToString: self.endStationName])
	{
		[self hideLoadingIndicator];
        
        UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        [[NoticeviewMessages sharedNoticeMessagesController] showConStationsIdenticalMessage: currentWindow];
        
		return;
	}
    /*
     if (!self.startStationName || !self.endStationName)
     {
     [self.activityIndicatorView stopAnimating];
     self.activityIndicatorView.alpha = 0.0;
     
     WBInfoNoticeView *notice = [WBInfoNoticeView infoNoticeInWindow:NSLocalizedString(@"Current location used", @"Selectstationsviewcontroller current location used title") message: NSLocalizedString(@"One of the stations is the current location. This is not yet supported.", @"Selectstationsviewcontroller current location used message")];
     [notice show];
     
     return;
     }
     */
    
    /*
     if (self.startDate) {
     NSLog(@"Search with startdate");
     } else  if (self.endDate) {
     NSLog(@"Search with enddate");
     }
     */
    
    NSDate *connectionTime; BOOL isDepartureTime = YES;
    
    if (self.startDate) {
        connectionTime = self.startDate;
        isDepartureTime = YES;
    } else if (self.endDate) {
        connectionTime = self.endDate;
        isDepartureTime = NO;
    } else {
        connectionTime = [NSDate date];
        isDepartureTime = YES;
    }
    
    if (!self.startStationName || !self.endStationName) {
        
        BKLocationManager *manager = [BKLocationManager sharedManager];
        
        [manager setDidUpdateLocationBlock:^(CLLocationManager *manager, CLLocation *newLocation, CLLocation *oldLocation) {
            
            #ifdef LOGOUTPUTON
            NSLog(@"didUpdateLocation: lat: %.6f, %.6f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
            #endif
            
            self.userLocation = newLocation;
            self.userLocationDate = [NSDate date];
            
            if (![self checkIfInCH: newLocation.coordinate]) {
                
                UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
                [[NoticeviewMessages sharedNoticeMessagesController] showLocationOutsideSwitzerland: currentWindow];
            }
            
            if (!self.startStationName) {
                //startStation = [[Station alloc] init];
                startStation.latitude = [NSNumber numberWithFloat: newLocation.coordinate.latitude];
                startStation.longitude = [NSNumber numberWithFloat: newLocation.coordinate.longitude];
                startStation.stationName = nil;
                startStation.stationId = nil;
                
                //NSLog(@"Set start station: lat: %@, %@", [startStation latitude], [startStation longitude]);
                
            } else {
                //endStation = [[Station alloc] init];
                endStation.latitude = [NSNumber numberWithFloat: newLocation.coordinate.latitude];
                endStation.longitude = [NSNumber numberWithFloat: newLocation.coordinate.longitude];
                endStation.stationName = nil;
                endStation.stationId = nil;
                
                //NSLog(@"Set start station: lat: %@, %@", [endStation latitude], [endStation longitude]);
            }
            
            [manager stopUpdatingLocation];
            manager = nil;
            
            if ([[SBBAPIController sharedSBBAPIController] isRequestInProgress]) {
                [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIOperations];
            }
            
            //if (self.connectionsContainerViewController) {
            //    self.connectionsContainerViewController = nil;
            //}
            
            [[SBBAPIController sharedSBBAPIController] sendConReqXMLConnectionRequest: startStation
                                                                           endStation: endStation
                                                                           viaStation: viaStation
                                                                              conDate: connectionTime
                                                                        departureTime: isDepartureTime
                                                                         successBlock: ^(NSUInteger numberofresults){
                                                                             [self hideLoadingIndicator];
                                                                             
                                                                             if (numberofresults > 0) {
                                                                                 self.currentlyPushedViewController = connectionsViewController;
                                                                                 [self moveConnectionsResultContainerViewOnScreen];
                                                                                 [self.connectionsContainerViewController updateConnectionsController];
                                                                             } else {
                                                                                 [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqDidNotReturnAnyResultNotice: self.view];
                                                                             }
                                                                         }
                                                                         failureBlock: ^(NSUInteger errorcode){
                                                                             [self hideLoadingIndicator];
                                                                             
                                                                             if (errorcode == kConReqRequestFailureConnectionFailed) {
                                                                                 [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqFailedNotice:self.view];
                                                                             } else if (errorcode == kSbbReqStationsNotDefined) {
                                                                                 [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqStationsNotAvailableNotice:self.view];
                                                                             } else if (errorcode == kConReqRequestFailureCancelled) {
                                                                                 // Nothing to do
                                                                             } else if (errorcode == kConRegRequestFailureNoNewResults) {
                                                                                 [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqDidNotReturnAnyResultNotice: self.view];
                                                                             } else {
                                                                                 [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqOtherUndefinedErrorNotice:self.view];
                                                                             }
                                                                             
                                                                         }];
            
        }];
        
        [manager setDidFailBlock:^(CLLocationManager *manager, NSError *error) {
            NSLog(@"didFailUpdateLocation");
            
            [self hideLoadingIndicator];
            
            NSString * errorMessage;
            NSUInteger errorCode = 0;
            
            switch ([error code]) {
                    
                case kCLErrorLocationUnknown:
                    errorMessage =
                    NSLocalizedString(@"We could not determine your location. Please try again later.", nil);
                    errorCode = 1;
                    break;
                    
                case kCLErrorDenied:
                    errorMessage =
                    NSLocalizedString(@"We could not access your current location.", nil);
                    errorCode = 2;
                    break;
                    
                default:
                    errorMessage =
                    NSLocalizedString(@"An unexpected error occured when trying to determine your location.", nil);
                    errorCode = 1;
                    break;
                    
            };
            
            NSLog(@"Error: %@", errorMessage);
            
            if (errorCode == 2) {
                UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
                [[NoticeviewMessages sharedNoticeMessagesController] showLocationManagerDenied: currentWindow];
            } else {
                UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
                [[NoticeviewMessages sharedNoticeMessagesController] showLocationManagerError:currentWindow];
            }
        }];
        
        [manager stopUpdatingLocationAndRestManager];
        [manager startUpdatingLocationWithAccuracy:kCLLocationAccuracyHundredMeters];
        return;
    }
    
    if ([[SBBAPIController sharedSBBAPIController] isRequestInProgress]) {
        [[SBBAPIController sharedSBBAPIController] cancelAllSBBAPIOperations];
    }
    
    //if (self.connectionsContainerViewController) {
    //    self.connectionsContainerViewController = nil;
    //}
    
    [[SBBAPIController sharedSBBAPIController] sendConReqXMLConnectionRequest: startStation
                                                                   endStation: endStation
                                                                   viaStation: viaStation
                                                                      conDate: connectionTime
                                                                departureTime: isDepartureTime
                                                                 successBlock: ^(NSUInteger numberofresults){
                                                                     [self hideLoadingIndicator];
                                                                     
                                                                     if (numberofresults > 0) {
                                                                         self.currentlyPushedViewController = connectionsViewController;
                                                                         [self moveConnectionsResultContainerViewOnScreen];
                                                                         [self.connectionsContainerViewController updateConnectionsController];
                                                                     } else {
                                                                         [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqDidNotReturnAnyResultNotice: self.view];
                                                                     }
                                                                 }
                                                                 failureBlock: ^(NSUInteger errorcode){
                                                                     [self hideLoadingIndicator];
                                                                     
                                                                     if (errorcode == kConReqRequestFailureConnectionFailed) {
                                                                         [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqFailedNotice:self.view];
                                                                     } else if (errorcode == kSbbReqStationsNotDefined) {
                                                                         [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqStationsNotAvailableNotice:self.view];
                                                                     } else if (errorcode == kConReqRequestFailureCancelled) {
                                                                         // Nothing to do
                                                                     } else if (errorcode == kConRegRequestFailureNoNewResults) {
                                                                         [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqDidNotReturnAnyResultNotice: self.view];
                                                                     } else {
                                                                         [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqOtherUndefinedErrorNotice:self.view];
                                                                     }
                                                                 }];
    
}

- (void) moveConnectionsResultContainerViewOffScreen {
#ifdef LOGOUTPUTON
    NSLog(@"moveConnectionsContainerViewOffScreen");
#endif
    
    [self.connectionsContainerViewController dispatchViewDisappearsAdjustments];
    
    CGRect currentFrame = self.connectionsContainerViewController.view.frame;
    //NSLog(@"Origin: %.1f", currentFrame.origin.x);
    currentFrame.origin.x = 320;
    [UIView animateWithDuration: 0.3 animations: ^{
        self.connectionsContainerViewController.view.frame = currentFrame;
        //NSLog(@"Origin: %.1f", self.connectionsContainerViewController.view.frame.origin.x);
    } completion:^(BOOL finished){
        //NSLog(@"Moved controller off screen");
        self.currentlyPushedViewController = noViewController;
    }];
}

- (void) moveConnectionsResultContainerViewOnScreen {
#ifdef LOGOUTPUTON
    NSLog(@"moveConnectionsContainerViewOnScreen");
#endif
    
    CGRect currentFrame = self.connectionsContainerViewController.view.frame;
    //NSLog(@"Origin: %.1f", currentFrame.origin.x);
    currentFrame.origin.x = 0;
    
    [self.view bringSubviewToFront: self.connectionsContainerViewController.view];
    
    if (self.connectionsContainerViewController) {
        [self.connectionsContainerViewController dispatchViewAppearsAdjustments];
        [self.connectionsContainerViewController moveConnectionsResultOverviewtableviewToTopRow];
    }
    
    [UIView animateWithDuration: 0.3 animations: ^{
        self.connectionsContainerViewController.view.frame = currentFrame;
        //NSLog(@"Origin: %.1f", self.connectionsContainerViewController.view.frame.origin.x);
    } completion:^(BOOL finished){
        //NSLog(@"Moved controller on screen");
        self.currentlyPushedViewController = connectionsViewController;
    }];
}

- (void)didTriggerPushback:(ConnectionsContainerViewController *)controller {
    [self moveConnectionsResultContainerViewOffScreen];
    self.currentlyPushedViewController = noViewController;
}

-(void) switchStations:(id) sender {
    
    [self cancelCurrentRunningRequestsIfAny];
    
    NSString *tempString;
    NSNumber *tempNumber;
    /*
     tempString = self.startTextField.text;
     self.startTextField.text = self.endTextField.text;
     self.endTextField.text = tempString;
     */
    
    if (self.selectedRequestType == conreqRequestType) {
#ifdef LOGOUTPUTON
        NSLog(@"Switch station: conreq type");
#endif
        
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
    } else {
#ifdef LOGOUTPUTON
        NSLog(@"Switch station: stbreq type");
#endif
        
        self.stbCurrentStationIsPrechecked = NO;
        
        tempString = self.stbStationName;
        self.stbStationName = self.dirStationName;
        self.dirStationName = tempString;
        
        tempString = self.stbStationID;
        self.stbStationID = self.dirStationID;
        self.dirStationID = tempString;
        
        if (self.stbStationName) {
            [self.startStationButton setText: [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"From:", @"Select stations from station help text"), self.stbStationName] forControlState: UIControlStateNormal];
        } else {
            [self.startStationButton setText: [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"From:", @"Select stations from station help text"), NSLocalizedString(@"Station", @"Selectstationscontroller stb station replacment for nil station name")] forControlState: UIControlStateNormal];
        }
        if (self.dirStationName) {
            [self.endStationButton setText: self.dirStationName forControlState: UIControlStateNormal];
        } else {
            [self.endStationButton setText: NSLocalizedString(@"Direction", @"Selectstationscontroller direction station replacment for nil station name") forControlState: UIControlStateNormal];
        }
        
    }
}

- (void) setLocationsFromMapAppInitAndPushBackToCurrentVCIfRequired:(Station *)from to:(Station *)to push:(BOOL)push searchinit:(BOOL)searchinit {
    
#ifdef LOGOUTPUTON
    NSLog(@"Select stations view controller. Set locations from maps");
#endif
    
    //NSLog(@"Init stations from map");
    self.showIntroFlag = NO;
    
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
        [self.startStationButton setText: [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"From:", @"Select stations from station help text"), from.stationName]  forControlState: UIControlStateNormal];
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
        
        if (self.currentlyPushedViewController != 0) {
            #ifdef LOGOUTPUTON
            NSLog(@"Another view controller is on screen. Force push back.");
            #endif
            
            if (self.currentlyPushedViewController == connectionsViewController) {
                #ifdef LOGOUTPUTON
                NSLog(@"Connections view controller is on screen. Force push back.");
                #endif
                if (self.connectionsContainerViewController) {
                    [self.connectionsContainerViewController forcePushBackToPreviousViewController];
                    //self.connectionsContainerViewController = nil;
                }
            } else if (self.currentlyPushedViewController == stationboardViewController) {
                #ifdef LOGOUTPUTON
                NSLog(@"Stationboard view controller is on screen. Force push back.");
                #endif
                if (self.stationboardConnectionsViewController) {
                    [self.stationboardConnectionsViewController forcePushBackToPreviousViewController];
                    //self.stationboardConnectionsViewController = nil;
                }
            } else if (self.currentlyPushedViewController == settingsViewController) {
                #ifdef LOGOUTPUTON
                NSLog(@"Settings view controller is on screen. Force push back.");
                #endif
                if (self.appSettingsViewController) {
                    [self.appSettingsViewController dismissViewControllerAnimated: NO completion: nil];
                }
            } else if (self.currentlyPushedViewController == rssdetailViewController) {
                #ifdef LOGOUTPUTON
                NSLog(@"Rss detail view controller is on screen. Force push back.");
                #endif
                if (self.rssDetailInfoViewController) {
                    [self.rssDetailInfoViewController forcePushBackToPreviousViewController];
                }
                
            } else if (self.currentlyPushedViewController == stationsPickerViewController) {
                #ifdef LOGOUTPUTON
                NSLog(@"Stations picker view controller is on screen. Force push back.");
                #endif
                if (self.stationPickerViewController) {
                    [self.stationPickerViewController forcePushBackToPreviousViewController];
                }
            } else if (self.currentlyPushedViewController == dateAndTimePickerViewController) {
                #ifdef LOGOUTPUTON
                NSLog(@"Date and time view controller is on screen. Force push back.");
                #endif
                if (self.dateAndTimePickerController) {
                    [self dismissSemiModalView];
                }
            }
        }
        if (self.selectedRequestType != conreqRequestType) {
            #ifdef LOGOUTPUTON
            NSLog(@"Switch to con req request type");
            #endif
            [self selectConReqType: nil];
        }
    }
    
    if (searchinit) {
        #ifdef LOGOUTPUTON
        NSLog(@"Set locations, search init flag set");
        #endif
    }
}

- (void) toggleViaStationWithFlag:(BOOL)visible {
    
    [self cancelCurrentRunningRequestsIfAny];
    
    self.viaButton.selected = visible;
    
    CGFloat toggleAnimationDuration = 0.1;
    
    if (self.viaButton.selected) {
        
        [UIView animateWithDuration:toggleAnimationDuration animations:^{
            self.stationsViaControlBackgroundView.alpha = 1.0;
            self.stationsControlBackgroundView.alpha = 1.0;
            self.stationsStbControlBackgroundView.alpha = 0.0;
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
            searchButtonRect.origin.y = 330 + 45;
            self.searchButton.frame = searchButtonRect;
        }];
    } else {
        [UIView animateWithDuration:toggleAnimationDuration animations:^{
            self.stationsViaControlBackgroundView.alpha = 0.0;
            self.stationsStbControlBackgroundView.alpha = 0.0;
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
            searchButtonRect.origin.y = 330;
            self.searchButton.frame = searchButtonRect;
        }];
    }
    
}

- (void) toggleStbDirStationWithFlag:(BOOL)visible {
    
    [self cancelCurrentRunningRequestsIfAny];
    
    self.viaButton.selected = visible;
    
    CGFloat toggleAnimationDuration = 0.1;
    
    if (self.viaButton.selected) {
        
        [UIView animateWithDuration:toggleAnimationDuration animations:^{
            self.stationsControlBackgroundView.alpha = 1.0;
            self.stationsStbControlBackgroundView.alpha = 0.0;
            self.stationsViaControlBackgroundView.alpha = 0.0;
            self.cancelStbDirButton.alpha = 1.0;
            self.endStationButton.alpha = 1.0;
            self.viaStationButton.alpha = 0.0;
            self.pinStartButton.alpha = 0.0;
            self.pinEndButton.alpha = 0.0;
            self.switchStationsButton.alpha = 0.0;
            CGRect timeContainerFrame = self.timeControlBackgroundView.frame;
            timeContainerFrame.origin.y = 4 + TEXTFIELDHEIGHT + 30 + 30 + 40 + 20;
            self.timeControlBackgroundView.frame = timeContainerFrame;
            CGRect searchButtonRect = self.searchButton.frame;
            searchButtonRect.origin.y = 330 + 45 - 45;
            self.searchButton.frame = searchButtonRect;
        }];
    } else {
        [UIView animateWithDuration:toggleAnimationDuration animations:^{
            self.stationsControlBackgroundView.alpha = 0.0;
            self.stationsStbControlBackgroundView.alpha = 1.0;
            self.stationsViaControlBackgroundView.alpha = 0.0;
            self.cancelStbDirButton.alpha = 0.0;
            self.endStationButton.alpha = 0.0;
            self.viaStationButton.alpha = 0.0;
            self.pinStartButton.alpha = 0.0;
            self.pinEndButton.alpha = 0.0;
            self.switchStationsButton.alpha = 0.0;
            CGRect timeContainerFrame = self.timeControlBackgroundView.frame;
            timeContainerFrame.origin.y = 4 + TEXTFIELDHEIGHT + 30 + 30 + 15;
            self.timeControlBackgroundView.frame = timeContainerFrame;
            CGRect searchButtonRect = self.searchButton.frame;
            searchButtonRect.origin.y = 330 - 45;
            self.searchButton.frame = searchButtonRect;
        }];
    }
    
}

-(void) toggleViaStation:(id) sender {
    
    [self cancelCurrentRunningRequestsIfAny];
    
    BOOL visibleState = !self.viaButton.selected;
    
    if (self.selectedRequestType == conreqRequestType) {
        [self toggleViaStationWithFlag: visibleState];
    } else if (self.selectedRequestType == stbRequestType) {
        [self toggleStbDirStationWithFlag: visibleState];
    }
}

-(void) startStationButtonTapped:(id) sender {
    
    [self cancelCurrentRunningRequestsIfAny];
    
    if (!self.stationPickerViewController) {
        self.stationPickerViewController = [[StationPickerViewController alloc] init];
        self.stationPickerViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.stationPickerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        self.stationPickerViewController.managedObjectContext = self.managedObjectContext;
        self.stationPickerViewController.delegate = self;
    }
    self.stationPickerViewController.stationTypeIndex = startStationType;
    [self.stationPickerViewController clearStationSetting];
    self.currentlyPushedViewController = stationsPickerViewController;
    
    if (self.selectedRequestType == conreqRequestType) {
        self.stationPickerViewController.stationpickerType = connectionsStationpickerType;
    }
    if (self.selectedRequestType == stbRequestType) {
        self.stationPickerViewController.stationpickerType = stationboardStationpickerType;
    }
    
    [self.navigationController presentViewController: self.stationPickerViewController animated: YES completion: nil];
}

-(void) endStationButtonTapped:(id) sender {
    
    [self cancelCurrentRunningRequestsIfAny];
    
    if (!self.stationPickerViewController) {
        self.stationPickerViewController = [[StationPickerViewController alloc] init];
        self.stationPickerViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.stationPickerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        self.stationPickerViewController.managedObjectContext = self.managedObjectContext;
        self.stationPickerViewController.delegate = self;
    }
    self.stationPickerViewController.stationTypeIndex = endStationType;
    [self.stationPickerViewController clearStationSetting];
    self.currentlyPushedViewController = stationsPickerViewController;
    
    if (self.selectedRequestType == conreqRequestType) {
        self.stationPickerViewController.stationpickerType = connectionsStationpickerType;
    }
    if (self.selectedRequestType == stbRequestType) {
        self.stationPickerViewController.stationpickerType = stationboardStationpickerType;
    }
    
    [self.navigationController presentViewController: self.stationPickerViewController animated: YES completion: nil];
    
}

-(void) viaStationButtonTapped:(id) sender {
    
    [self cancelCurrentRunningRequestsIfAny];
    
    if (!self.stationPickerViewController) {
        self.stationPickerViewController = [[StationPickerViewController alloc] init];
        self.stationPickerViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.stationPickerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        self.stationPickerViewController.managedObjectContext = self.managedObjectContext;
        self.stationPickerViewController.delegate = self;
    }
    self.stationPickerViewController.stationTypeIndex = viaStationType;
    [self.stationPickerViewController clearStationSetting];
    self.currentlyPushedViewController = stationsPickerViewController;
    [self.navigationController presentViewController: self.stationPickerViewController animated: YES completion: nil];
    
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
        UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        [[NoticeviewMessages sharedNoticeMessagesController] showNoNetworkErrorMessage: currentWindow];
        
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
       
                                                              [self topPullToLoadNewResultsCompleted];
                                                              
                                                              if (numberofresults > 0) {
                                                                  [self.delayInfoTableView reloadData];
                                                              } else {
                                                                  [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqDidNotReturnAnyResultNotice: self.view];
                                                              }
                                                          }
                                                          failureBlock:^(NSUInteger errorcode){
    
                                                              [self topPullToLoadNewResultsCompleted];
                                                              
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
    
    [self.activityIndicatorView startAnimating];
    self.activityIndicatorView.alpha = 1.0;
    self.delayInfoTableView.alpha = 0.0;
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable)
    {
        UIWindow *currentWindow = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        [[NoticeviewMessages sharedNoticeMessagesController] showNoNetworkErrorMessage: currentWindow];
        
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
                                                              [self.activityIndicatorView stopAnimating];
                                                              self.activityIndicatorView.alpha = 0.0;
                                                              self.delayInfoTableView.alpha = 1.0;
                                                              //[self topPullToLoadNewResultsCompleted];
                                                              
                                                              if (numberofresults > 0) {
                                                                  [self.delayInfoTableView reloadData];
                                                              } else {
                                                                  [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqDidNotReturnAnyResultNotice: self.view];
                                                              }
                                                          }
                                                          failureBlock:^(NSUInteger errorcode){
                                                              [self.activityIndicatorView stopAnimating];
                                                              self.activityIndicatorView.alpha = 0.0;
                                                              
                                                              if (errorcode == kRssReqRequestFailureConnectionFailed) {
                                                                  [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqFailedNotice:self.view];
                                                              } else if (kRssReqRequestFailureCancelled) {
                                                                  // Nothing to do
                                                              } else {
                                                                  [[NoticeviewMessages sharedNoticeMessagesController] showSbbReqOtherUndefinedErrorNotice:self.view];
                                                              }
                                                          }];
}

- (void) updatesbbrssinfoResult:(id)sender {
    
    [self getSBBRssFeedInfo];
}

#pragma mark -
#pragma mark DateTimePicker delegate

- (void)dateTimePickerOK:(DateAndTimePickerController *)controller didPickDate:(NSDate *)date depArr:(BOOL)depArr {
    
#ifdef LOGOUTPUTON
    NSLog(@"Date picker dismiss delegate received");
#endif
    
    [self dismissSemiModalView];
    
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
        
        /*
         if (depArr) {
         self.startDate = date;
         self.endDate = nil;
         } else {
         self.startDate = nil;
         self.endDate = date;
         }
         */
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

#pragma mark -
#pragma mark Stationpickercontroller delegate

- (void)didSelectStationWithStationTypeIndex:(StationPickerViewController *)controller stationTypeIndex:(NSUInteger)index station:(Station *)station {
    if (station) {
        if (self.selectedRequestType == conreqRequestType) {
            if ((station.stationName && station.stationId) || (station.stationName && !station.stationId && station.latitude && station.longitude)) {
                //NSLog(@"Name only: %@, Id: %@, %.6f, %.6f", station.stationName, station.stationId, [station.latitude doubleValue], [station.longitude doubleValue]);
                
                if (index == startStationType) {
                    self.startStationName = station.stationName;
                    self.startStationID = station.stationId;
                    self.startStationLatitude = station.latitude;
                    self.startStationLongitude = station.longitude;
                    [self.startStationButton setText: [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"From:", @"Select stations from station help text"), station.stationName] forControlState: UIControlStateNormal];
                } else if (index == endStationType) {
                    self.endStationName = station.stationName;
                    self.endStationID = station.stationId;
                    self.endStationLatitude = station.latitude;
                    self.endStationLongitude = station.longitude;
                    [self.endStationButton setText: [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"To:", @"Select stations to station help text"), station.stationName] forControlState: UIControlStateNormal];
                } else if (index == viaStationType) {
                    self.viaStationName = station.stationName;
                    self.viaStationID = station.stationId;
                    [self.viaStationButton setText: [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"Via:", @"Select stations via station help text"), station.stationName] forControlState: UIControlStateNormal];
                }
            }
        } else {
            if (station.stationName && station.stationId) {
                if (index == startStationType) {
                    self.stbStationName = station.stationName;
                    self.stbStationID = station.stationId;
                    [self.startStationButton setText: [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"From:", @"Select stations from station help text"), station.stationName] forControlState: UIControlStateNormal];
                    
                    //[self preCheckStationboardProductTypesForStationAndPushStationboardViewControllerIfFlagSet];
                    
                } else if (index == endStationType) {
                    self.dirStationName = station.stationName;
                    self.dirStationID = station.stationId;
                    [self.endStationButton setText: station.stationName forControlState: UIControlStateNormal];
                }
                [self preCheckStationboardProductTypesForStationAndPushStationboardViewControllerIfFlagSet];
            }
        }
    }
}

- (void)dateTimePickerCancel:(DateAndTimePickerController *)controller {
    
}

#pragma mark -
#pragma mark Requestsegmentcontrol did change

- (IBAction)selectConReqType:(id)sender {
    self.conReqContrainerView.alpha = 0.0;
    self.stbContrainerView.alpha = 0.0;
    self.delayinfoContrainerView.alpha = 0.0;
    //self.updateButton.alpha = 0.0;

    self.goButton.alpha = 1.0;

#ifdef LOGOUTPUTON
    NSLog(@"Con req button");
#endif
    
    [self cancelCurrentRunningRequestsIfAny];
    
    CGFloat scaleFactor = 2;
    UIImage *conreqImage =  [UIImage newImageFromMaskImage: [[UIImage conreqButtonImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactor, SEGMENTHEIGHT * scaleFactor) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlItemImageColor]];

    MCFlashMessageView *messageView = [[MCFlashMessageView alloc] initWithView:self.view];
    messageView.icon.image = conreqImage;
    messageView.labelText = NSLocalizedString(@"Connections", "Select stations conreq flash message title");
    [self.view addSubview:messageView];
    [messageView show:YES];
    //[messageView release];
    
    [self.requestTypeSegmentControl setSelectedSegmentIndex: 0];
    
    self.selectedRequestType = conreqRequestType;
    NSString *startStationNameRep = (self.startStationName)?[NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"From:", @"Select stations from station help text"), self.startStationName]:[NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"From:", @"Select stations from station help text"), NSLocalizedString(@"Current location", @"Station text field default text")];
    NSString *endStationNameRep = (self.endStationName)?[NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"To:", @"Select stations to station help text"), self.endStationName]:[NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"To:", @"Select stations to station help text"), NSLocalizedString(@"Current location", @"Station text field default text")];
    NSString *viaStationNameRep = (self.viaStationName)?[NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"Via:", @"Select stations via station help text"), self.viaStationName]:[NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"Via:", @"Select stations via station help text"), NSLocalizedString(@"Current location", @"Station text field default text")];
    
    [self.startStationButton setText: startStationNameRep forControlState: UIControlStateNormal];
    [self.endStationButton setText: endStationNameRep forControlState: UIControlStateNormal];
    [self.viaStationButton setText: viaStationNameRep forControlState: UIControlStateNormal];
    
    self.pinStartButton.alpha = 0.0;
    self.pinEndButton.alpha = 0.0;
    self.viaButton.alpha = 0.0;
    self.switchStationsButton.alpha = 0.0;
    self.cancelStbDirButton.alpha = 0.0;
    
    [self toggleStbDirStationWithFlag: NO];
    
    if (self.viaStationName) {
        [self toggleViaStationWithFlag:YES];
    } else {
        [self toggleViaStationWithFlag:NO];
    }
    
    //[self cancelViaStation: nil];
    
    [UIView animateWithDuration: 0.3 animations: ^{
        self.conReqContrainerView.alpha = 1.0;
        self.pinStartButton.alpha = 1.0;
        self.pinEndButton.alpha = 1.0;
        self.viaButton.alpha = 1.0;
        self.switchStationsButton.alpha = 1.0;
    }];
}

- (IBAction)selectStbReqType:(id)sender {
    self.conReqContrainerView.alpha = 0.0;
    self.stbContrainerView.alpha = 0.0;
    self.delayinfoContrainerView.alpha = 0.0;
    //self.updateButton.alpha = 0.0;

    self.goButton.alpha = 1.0;

#ifdef LOGOUTPUTON
    NSLog(@"Stb req button");
#endif
    
    [self cancelCurrentRunningRequestsIfAny];
    
    CGFloat scaleFactor = 2;
    UIImage *stbImage = [UIImage newImageFromMaskImage: [[UIImage stboardButtonImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactor, SEGMENTHEIGHT * scaleFactor) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlItemImageColor]];
    MCFlashMessageView *messageView = [[MCFlashMessageView alloc] initWithView:self.view];
    messageView.icon.image = stbImage;
    messageView.labelText = NSLocalizedString(@"Timetable", "Select stations stbreq flash message title");
    [self.view addSubview:messageView];
    [messageView show:YES];
    //[messageView release];
    
    [self.requestTypeSegmentControl setSelectedSegmentIndex: 1];
    
    self.selectedRequestType = stbRequestType;
    NSString *stbStationNameRep = (self.stbStationName)?[NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"From:", @"Select stations from station help text"), self.stbStationName]:[NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"From:", @"Select stations from station help text"), NSLocalizedString(@"Station", @"Selectstationscontroller stb station replacment for nil station name")];
    NSString *dirStationNameRep = (self.dirStationName)?self.dirStationName:NSLocalizedString(@"Direction", @"Selectstationscontroller direction station replacment for nil station name");
    [self.startStationButton setText: stbStationNameRep forControlState: UIControlStateNormal];
    [self.endStationButton setText: dirStationNameRep forControlState: UIControlStateNormal];
    
    self.pinStartButton.alpha = 0.0;
    self.pinEndButton.alpha = 0.0;
    self.viaButton.alpha = 0.0;
    self.switchStationsButton.alpha = 0.0;
    self.cancelStbDirButton.alpha = 0.0;
    
    [self toggleViaStationWithFlag:NO];
    
    if (self.dirStationName) {
        [self toggleStbDirStationWithFlag: YES];
    } else {
        [self toggleStbDirStationWithFlag: NO];
    }
    
    [UIView animateWithDuration: 0.3 animations: ^{
        self.conReqContrainerView.alpha = 1.0;
        self.viaButton.alpha = 1.0;
    }];
}

- (IBAction)selectInfoReqType:(id)sender {
    self.conReqContrainerView.alpha = 0.0;
    self.stbContrainerView.alpha = 0.0;
    self.delayinfoContrainerView.alpha = 0.0;
    self.delayInfoTableView.alpha = 0.0;
    //self.updateButton.alpha = 1.0;

    self.goButton.alpha = 0.0;

#ifdef LOGOUTPUTON
    NSLog(@"Info req button");
#endif
    
    [self cancelCurrentRunningRequestsIfAny];
    
    CGFloat scaleFactor = 2;
    UIImage *infoImage = [UIImage newImageFromMaskImage: [[UIImage delayinfoButtonImage] resizedImage: CGSizeMake(SEGMENTHEIGHT * scaleFactor, SEGMENTHEIGHT * scaleFactor) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor requestSegmentedControlItemImageColor]];
    MCFlashMessageView *messageView = [[MCFlashMessageView alloc] initWithView:self.view];
    messageView.icon.image = infoImage;
    messageView.labelText = NSLocalizedString(@"Infos", "Select stations rssreq flash message title");
    [self.view addSubview:messageView];
    [messageView show:YES];
    //[messageView release];
    
    [self.requestTypeSegmentControl setSelectedSegmentIndex: 2];
    
    self.selectedRequestType = delayinfoRequestType;
    [UIView animateWithDuration: 0.3 animations: ^{
        self.delayinfoContrainerView.alpha = 1.0;
    }];
    [self getSBBRssFeedInfo];
}

- (IBAction)segmentDidChange:(id)sender
{
    [self cancelCurrentRunningRequestsIfAny];
    
    //UISegmentedControl *segControl = (UISegmentedControl *)sender;
    self.conReqContrainerView.alpha = 0.0;
    self.stbContrainerView.alpha = 0.0;
    self.delayinfoContrainerView.alpha = 0.0;
    self.delayInfoTableView.alpha = 0.0;
    //self.updateButton.alpha = 0.0;

    self.goButton.alpha = 0.0;

    //NSLog(@"Segment did change: %d", [sender selectedSegmentIndex]);
    if ([sender selectedSegmentIndex] == 0) {
        
        self.selectedRequestType = conreqRequestType;
        NSString *startStationNameRep = (self.startStationName)?[NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"From:", @"Select stations from station help text"), self.startStationName]:[NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"From:", @"Select stations from station help text"), NSLocalizedString(@"Current location", @"Station text field default text")];
        NSString *endStationNameRep = (self.endStationName)?[NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"To:", @"Select stations to station help text"), self.endStationName]:[NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"To:", @"Select stations to station help text"), NSLocalizedString(@"Current location", @"Station text field default text")];
        NSString *viaStationNameRep = (self.viaStationName)?[NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"Via:", @"Select stations via station help text"), self.viaStationName]:[NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"Via:", @"Select stations via station help text"), NSLocalizedString(@"Current location", @"Station text field default text")];
        
        [self.startStationButton setText: startStationNameRep forControlState: UIControlStateNormal];
        [self.endStationButton setText: endStationNameRep forControlState: UIControlStateNormal];
        [self.viaStationButton setText: viaStationNameRep forControlState: UIControlStateNormal];
            
        [self toggleStbDirStationWithFlag: NO];
        
        if (self.viaStationName) {
            [self toggleViaStationWithFlag:YES];
        } else {
            [self toggleViaStationWithFlag:NO];
        }
        
        [UIView animateWithDuration: 0.3 animations: ^{
            self.conReqContrainerView.alpha = 1.0;
 
            self.goButton.alpha = 1.0;
        }];
        
    } else if ([sender selectedSegmentIndex] == 1) {
        
        self.selectedRequestType = stbRequestType;
        NSString *stbStationNameRep = (self.stbStationName)?[NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"From:", @"Select stations from station help text"), self.stbStationName]:[NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"From:", @"Select stations from station help text"), NSLocalizedString(@"Station", @"Selectstationscontroller stb station replacment for nil station name")];
        NSString *dirStationNameRep = (self.dirStationName)?self.dirStationName:NSLocalizedString(@"Direction", @"Selectstationscontroller direction station replacment for nil station name");
        [self.startStationButton setText: stbStationNameRep forControlState: UIControlStateNormal];
        [self.endStationButton setText: dirStationNameRep forControlState: UIControlStateNormal];
                
        [self toggleViaStationWithFlag:NO];
        
        if (self.dirStationName) {
            [self toggleStbDirStationWithFlag: YES];
        } else {
            [self toggleStbDirStationWithFlag: NO];
        }
        
        [UIView animateWithDuration: 0.3 animations: ^{
            self.conReqContrainerView.alpha = 1.0;

            self.goButton.alpha = 1.0;
        }];
        
    } else if ([sender selectedSegmentIndex] == 2) {
        self.selectedRequestType = delayinfoRequestType;
        [UIView animateWithDuration: 0.3 animations: ^{
            self.delayinfoContrainerView.alpha = 1.0;
        }];
        [self getSBBRssFeedInfo];
        
    }
}

- (void) showInfoViewController:(id) sender {
    //NSLog(@"Show info view controller");
    
    [self cancelCurrentRunningRequestsIfAny];
    
    [self showSettingsPush: sender];
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
        //NSLog(@"Rss info, number of rowns: %d", [[SBBAPIController sharedSBBAPIController] getNumberOfSbbRssInfoResults]);
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
    
    //NSLog(@"Rss feed did select cell: %d", indexPath.row);
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    RssInfoItem *rssInfoItem = [[SBBAPIController sharedSBBAPIController] getSbbRssInfoResultWithIndex: indexPath.row];
    
    if (self.rssDetailInfoViewController) {
        self.rssDetailInfoViewController = nil;
    }
    
    self.rssDetailInfoViewController = [[RssDetailInfoViewController alloc] init];
    [self.rssDetailInfoViewController loadDescriptionIntoDetailView: rssInfoItem];
    self.currentlyPushedViewController = rssdetailViewController;
    [self.navigationController pushViewController: self.rssDetailInfoViewController animated: YES];
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
        
        //NSLog(@"Trigger top load more");
        
        [self topPullToRefreshTriggered];
        
        [self.headerView changeStateOfControl:MNMBottomPullToRefreshViewStateLoading offset:offset];
        
        [UIView animateWithDuration:0.3 animations:^(void) {
            //NSLog(@"Top load more inset animation");
            self.delayInfoTableView.contentInset = UIEdgeInsetsMake([self.headerView fixedHeight], 0, 0, 0);
        }];
    }
}

//--------------------------------------------------------------------------------

#pragma mark -
#pragma mark App Settings methods


- (IBAction)showSettingsPush:(id)sender {
    
    if (!self.appSettingsViewController) {
		self.appSettingsViewController = [[IASKAppSettingsViewController alloc] initWithNibName:@"IASKAppSettingsView" bundle:nil];
		self.appSettingsViewController.delegate = self;
	}
    
	[self.appSettingsViewController setShowCreditsFooter:NO];   // Uncomment to not display InAppSettingsKit credits for creators.
	// But we encourage you no to uncomment. Thank you!
	//self.appSettingsViewController.showDoneButton = NO;
    
    UINavigationController *aNavController = [[UINavigationController alloc] initWithRootViewController:self.appSettingsViewController];
    
    aNavController.navigationBar.barStyle=UIBarStyleBlack;
        
    aNavController.modalPresentationStyle = UIModalPresentationFullScreen;
    self.appSettingsViewController.showDoneButton = YES;
    self.currentlyPushedViewController = settingsViewController;
    [self presentViewController: aNavController animated: YES completion: nil];
    
	//[self.navigationController pushViewController:self.appSettingsViewController animated:YES];
}

#pragma mark -
#pragma mark IASKAppSettingsViewControllerDelegate protocol
- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
    //NSLog(@"Dismiss settings view");
        
    [sender dismissViewControllerAnimated: YES completion: nil];
    
	// your code here to reconfigure the app for changed settings
}

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
        [self performSelector: @selector(showMoviePlayerController) withObject:self afterDelay: 1];
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

        NSString *UTApName  = kUTControllerAppNameiPhone;

		NSString *messageText = [NSString stringWithFormat: @"%@\n\n\n\n\n\n\n\n\n\n\nMessage id: %@\niPhone: %@\niOS Version: %@\nApp version: %@\nLanguage: %@",NSLocalizedString(@"Dear Support, ", @"Swiss Transit settings support email draft text"), messageId, [self iPhoneDevice], [self systemVersion], UTApName, [[NSLocale currentLocale] localeIdentifier]];
        return messageText;
    } else if ([key isEqualToString:@"TELLAFRIENDEMAILKEY"]) {
        
        NSString *description =  NSLocalizedString(@"Check out this app!", @"Recommend Swiss Transit Share Item Description");
        //NSString *shortdescription = NSLocalizedString(@"Check out this app!", @"Recommend Swiss Transit Share Item Description");
        
        NSString *appStoreIDString = [NSString stringWithFormat: @"%d", AppStoreIDIPHONE];
        NSString *appStoreURL =  [NSString stringWithFormat: @"http://itunes.apple.com/ch/app/%@/id%@?mt=8&uo=4", AppStoreURLAPIPHONE,appStoreIDString];;

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
                               kAppNameiPhone,
                               kAppSeller,
                               kAppCategory,
                               appStoreURL];
        return emailBody;
        
    } else if ([key isEqualToString:@"STREPORTERREMAILKEY"]) {
        NSString *messageId;
        messageId = [[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        NSString *description =  NSLocalizedString(@"There is an error with the following station:", @"Report station error message description");

        NSString *UTApName  = kUTControllerAppNameiPhone;
        
		NSString *messageText = [NSString stringWithFormat: @"%@\n\n%@\n\n\n\n\n\n\n\n\nMessage id: %@\niPhone: %@\niOS Version: %@\nApp version: %@\nLanguage: %@",NSLocalizedString(@"Dear Support, ", @"Swiss Transit settings support email draft text"), description, messageId, [self iPhoneDevice], [self systemVersion], UTApName, [[NSLocale currentLocale] localeIdentifier]];
        return messageText;
        
    } else if ([key isEqualToString:@"APREPORTERREMAILKEY"]) {
        NSString *messageId;
        messageId = [[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
		NSString *description =  NSLocalizedString(@"There is an error in the app:", @"Report app error message description");
        
        NSString *UTApName  = kUTControllerAppNameiPhone;

		NSString *messageText = [NSString stringWithFormat: @"%@\n\n%@\n\n\n\n\n\n\n\n\nMessage id: %@\niPhone: %@\niOS Version: %@\nApp version: %@\nLanguage: %@",NSLocalizedString(@"Dear Support, ", @"Swiss Transit settings support email draft text"), description, messageId, [self iPhoneDevice], [self systemVersion], UTApName, [[NSLocale currentLocale] localeIdentifier]];
        return messageText;
        
    }
    return @"";
}

//--------------------------------------------------------------------------------

- (void) startGettingUserLocation {
#ifdef LOGOUTPUTON
    NSLog(@"Start getting the users location");
#endif
    
    BKLocationManager *manager = [BKLocationManager sharedManager];
    
    [manager setDidUpdateLocationBlock:^(CLLocationManager *manager, CLLocation *newLocation, CLLocation *oldLocation) {
        
#ifdef LOGOUTPUTON
        NSLog(@"didUpdateLocation: lat: %.6f, %.6f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
#endif
        
        self.userLocation = newLocation;
        self.userLocationDate = [NSDate date];
        
        [manager stopUpdatingLocation];
        manager = nil;
    }];
    
    [manager setDidFailBlock:^(CLLocationManager *manager, NSError *error) {
        NSLog(@"didFailUpdateLocation");
        
        [manager stopUpdatingLocation];
        manager = nil;
    }];
    
    [manager stopUpdatingLocationAndRestManager];
    [manager startUpdatingLocationWithAccuracy:kCLLocationAccuracyHundredMeters];
}

- (void) appdidbecomeactiveaction:(id)sender {
#if LOGOUTPUTON
    NSLog(@"App did become active notificatoin received");
#endif
    
    [self startGettingUserLocation];
}

- (void) appisenteringbackgroundaction:(id)sender {
#if LOGOUTPUTON
    NSLog(@"App is entering background notificatoin received");
#endif
    
    [self cancelCurrentRunningRequestsIfAny];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

