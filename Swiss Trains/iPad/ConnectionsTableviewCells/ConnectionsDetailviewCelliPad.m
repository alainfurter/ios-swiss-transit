//
//  ConnectionsDetailviewCell.m
//  Swiss Trains
//
//  Created by Alain on 28.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "ConnectionsDetailviewCelliPad.h"

#define DTCELLVIEWHEIGHT 154.0

/*
@implementation ConnectionImageView

- (id)initWithFrame:(CGRect)frame topLine:(BOOL)topLine bottonLine:(BOOL)bottomLine type:(NSUInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.topLine = topLine;
        self.bottomLine = bottomLine;
        //self.walkTypeFlag = NO;
        self.clipsToBounds = YES;
        self.consectionImageType = type;
        //NSLog(@"Init image frame: %d", type);
    }
    return self;
}

- (UIColor *) colorWithHex:(int)hex {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

//- (void) drawLineAtPosition:(LinePosition)position rect:(CGRect)rect color:(UIColor *)color {
- (void) drawLineAtPosition:(CGPoint)startPoint endPoint:(CGPoint)endPoint color:(UIColor *)color dashed:(BOOL)dashed {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGContextMoveToPoint(ctx, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(ctx, endPoint.x, endPoint.y);
    
    //UIColor *colorBlue = [UIColor blueColor];
    //[color set];
    
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextSetLineWidth(ctx, 4.0f);
    
    //NSLog(@"Dashed: %@", dashed?@"Y":@"N");
    
    if (dashed) {
        CGFloat dotRadius = 2;
        CGFloat lengths[2];
        lengths[0] = 0;
        lengths[1] = dotRadius*4;
        CGContextSetLineCap(ctx, kCGLineCapSquare);
        //CGContextSetLineWidth(ctx, 4);
        CGContextSetLineDash(ctx, 0.0f, lengths, 2);
    }
    
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}

- (void)drawRect:(CGRect)rect
{

    [super drawRect:rect];
    
    if (self.topLine) {
        [self drawLineAtPosition: CGPointMake(17.5, 0 + 2) endPoint: CGPointMake(17.5, 15) color: [UIColor lightGrayColor] dashed: YES];
    }
    if (self.bottomLine) {
        [self drawLineAtPosition: CGPointMake(17.5, self.frame.size.height - 15 + 2) endPoint: CGPointMake(17.5, self.frame.size.height) color: [UIColor lightGrayColor] dashed: YES];
    }
    
    //NSLog(@"Check type: %d", self.consectionImageType);
    
    UIColor *circleColor;
    UIColor *lineColor;
    if (self.consectionImageType == walk) {
        circleColor = [UIColor detailTableViewCellChangeLineColor];
        lineColor = [UIColor detailTableViewCellChangeLineColor];
    } else {
        circleColor = [UIColor detailTableViewCellJourneyLineColor];
        lineColor = [UIColor detailTableViewCellJourneyLineColor];
    }
    [self drawLineAtPosition: CGPointMake(17.5, 15 + 25) endPoint: CGPointMake(17.5, self.frame.size.height - 15 - 25) color: lineColor dashed: NO];
        
    CGRect outerTopCircle = {5, 15, 25, 25};
    CGRect outerTopMaskCircle  = CGRectInset(outerTopCircle, 4, 4);
    CGRect innerTopCircle = CGRectInset(outerTopCircle, 6, 6);
    
    UIBezierPath *outerTopCirclePath = [UIBezierPath bezierPathWithOvalInRect: outerTopCircle];
    
    [outerTopCirclePath appendPath:[UIBezierPath bezierPathWithOvalInRect: outerTopMaskCircle]];
    outerTopCirclePath.usesEvenOddFillRule = YES;
    
    [circleColor set];
    [outerTopCirclePath fill];
    
    UIBezierPath *innerTopCirclePath = [UIBezierPath bezierPathWithOvalInRect: innerTopCircle];
    [[UIColor blackColor] set];
    [innerTopCirclePath fill];
    
    CGRect outerBottomCircle = {5, self.frame.size.height - 25 - 15, 25, 25};
    CGRect outerBottomMaskCircle  = CGRectInset(outerBottomCircle, 4, 4);
    CGRect innerBottomCircle = CGRectInset(outerBottomCircle, 6, 6);
    
    UIBezierPath *outerBottomCirclePath = [UIBezierPath bezierPathWithOvalInRect: outerBottomCircle];
    
    [outerBottomCirclePath appendPath:[UIBezierPath bezierPathWithOvalInRect: outerBottomMaskCircle]];
    outerBottomCirclePath.usesEvenOddFillRule = YES;
    
    [circleColor set];
    [outerBottomCirclePath fill];
    
    UIBezierPath *innerBottomCirclePath = [UIBezierPath bezierPathWithOvalInRect: innerBottomCircle];
    [[UIColor blackColor] set];
    [innerBottomCirclePath fill];
}

@end

// ----------------------------------------------------------

@implementation RoundedRectmageView

- (id)initWithFrame:(CGRect)frame centerImage:(UIImage *)centerImage {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.centerImage = [UIImage newImageFromMaskImage: centerImage inColor: [UIColor detailTableViewCellJourneyInfoImageColor]];
    }
    return self;
}

- (UIColor *) colorWithHex:(int)hex {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //CGRect outerTopCircle = {0, 0, 25, 25};
    //CGRect outerTopMaskCircle  = CGRectInset(outerTopCircle, 4, 4);
    //CGRect innerTopCircle = CGRectInset(outerTopCircle, 6, 6);
    
    UIBezierPath *outerTopCirclePath = [UIBezierPath bezierPathWithOvalInRect: rect];
    
    //[outerTopCirclePath appendPath:[UIBezierPath bezierPathWithOvalInRect: outerTopMaskCircle]];
    //outerTopCirclePath.usesEvenOddFillRule = YES;
    
    [[UIColor detailTableViewCellJourneyInfoImageBackgroundColor] set];
    [outerTopCirclePath fill];
    
    
    float insectLength = self.frame.size.width * 0.20;
    CGRect imageRect = CGRectInset(rect, insectLength, insectLength);
    [self.centerImage drawInRect: imageRect];
}

@end

// ----------------------------------------------------------
*/
 
@implementation ConnectionsDetailviewCelliPad

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect frame = self.frame;
        frame.size.height = DTCELLVIEWHEIGHT;
        frame.size.width = 240;
        self.frame = frame;
        
        //self.consectionImageType = journey;
        
        self.clipsToBounds = YES;
        self.contentView.clipsToBounds = YES;
        
        self.detailViewCellHasJourneyInfos = NO;
        
        //self.contentView.backgroundColor = [UIColor detailCellBackgroundColorNormal];
        
        UIColor *topGradientColor = [UIColor connectionsDetailviewCellTopGradientColorNormal];
        UIColor *bottomGradientColor = [UIColor connectionsDetailviewCellBottomGradientColorNormal];
        CGRect backgroundViewFrame = self.contentView.frame;
        backgroundViewFrame.size.height = DTCELLVIEWHEIGHT;
        self.backgroundView = [[UIView alloc] initWithFrame:backgroundViewFrame];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)topGradientColor.CGColor, (id)bottomGradientColor.CGColor, nil];
        gradient.startPoint = CGPointMake(0.5f, 0.0f);
        gradient.endPoint = CGPointMake(0.5f, 1.0f);
        [self.backgroundView.layer addSublayer:gradient];
        
         self.selectedBackgroundView = [[UIView alloc] initWithFrame:backgroundViewFrame];
         CAGradientLayer *gradientselected = [CAGradientLayer layer];
         gradientselected.frame = self.bounds;
         gradientselected.colors = [NSArray arrayWithObjects:(id)[UIColor connectionsDetailviewCellTopGradientColorSelected].CGColor, (id)[UIColor connectionsDetailviewCellBottomGradientColorSelected].CGColor, nil];
         gradientselected.startPoint = CGPointMake(0.5f, 0.0f);
         gradientselected.endPoint = CGPointMake(0.5f, 1.0f);
         [self.selectedBackgroundView.layer addSublayer:gradientselected];
         
        /*
        self.contentView.backgroundColor = [UIColor clearColor];
        UIColor *topGradientColor = [UIColor colorWithRed:247.0/255.0f green:247.0/255.0f blue:247.0/255.0f alpha:1.0];
        UIColor *bottomGradientColor = [UIColor colorWithRed:227.0/255.0f green:230.0/255.0f blue:235.0/255.0f alpha:1.0];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[topGradientColor CGColor], (id)[bottomGradientColor CGColor], nil];
        [self.backgroundView.layer addSublayer:gradient];
        */
        
        self.startStationLabel = [[UILabel alloc] initWithFrame: CGRectMake(8, 5, 224, 30)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.startStationLabel.font = [UIFont boldSystemFontOfSize: 15.0];
        self.startStationLabel.textColor = [UIColor detailTableViewCellTextColorNormal];
        self.startStationLabel.backgroundColor = [UIColor clearColor];
        self.startStationLabel.textAlignment = NSTextAlignmentLeft;
        
        self.startTimeLabel = [[UILabel alloc] initWithFrame: CGRectMake(8, 35, 40, 10)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.startTimeLabel.font = [UIFont systemFontOfSize: 12.0];
        self.startTimeLabel.textColor = [UIColor detailTableViewCellTextColorNormal];
        self.startTimeLabel.backgroundColor = [UIColor clearColor];
        self.startTimeLabel.textAlignment = NSTextAlignmentLeft;
        
        self.startExpectedTimeLabel = [[UILabel alloc] initWithFrame: CGRectMake(48, 35, 40, 10)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.startExpectedTimeLabel.font = [UIFont systemFontOfSize: 12.0];
        self.startExpectedTimeLabel.textColor = [UIColor detailTableViewCellTextColorExpectedInfo];
        self.startExpectedTimeLabel.backgroundColor = [UIColor clearColor];
        self.startExpectedTimeLabel.textAlignment = NSTextAlignmentLeft;
        
        self.startStationTrackLabel = [[UILabel alloc] initWithFrame: CGRectMake(self.frame.size.width - 40 - 5 - 40, 22, 40, 10)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.startStationTrackLabel.font = [UIFont systemFontOfSize: 12.0];
        self.startStationTrackLabel.textColor = [UIColor detailTableViewCellTextColorNormal];
        self.startStationTrackLabel.backgroundColor = [UIColor clearColor];
        self.startStationTrackLabel.textAlignment = NSTextAlignmentRight;
        
        self.startStationExpectedTrackLabel = [[UILabel alloc] initWithFrame: CGRectMake(self.frame.size.width - 40 - 5 - 40, 34, 40, 10)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.startStationExpectedTrackLabel.font = [UIFont systemFontOfSize: 12.0];
        self.startStationExpectedTrackLabel.textColor = [UIColor detailTableViewCellTextColorExpectedInfo];
        self.startStationExpectedTrackLabel.backgroundColor = [UIColor clearColor];
        self.startStationExpectedTrackLabel.textAlignment = NSTextAlignmentRight;
        
        self.endStationLabel = [[UILabel alloc] initWithFrame: CGRectMake(8, self.bounds.size.height - 30 - 5 - 10, 224, 30)];
        //self.timeLabelMinutesBigTitle.font = [UIFont systemFontOfSize:12.0];
        self.endStationLabel.font = [UIFont boldSystemFontOfSize: 15.0];
        self.endStationLabel.textColor = [UIColor detailTableViewCellTextColorNormal];
        self.endStationLabel.backgroundColor = [UIColor clearColor];
        self.endStationLabel.textAlignment = NSTextAlignmentLeft;
        
        self.endTimeLabel = [[UILabel alloc] initWithFrame: CGRectMake(8, self.bounds.size.height - 10 - 5, 40, 10)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.endTimeLabel.font = [UIFont systemFontOfSize: 12.0];
        self.endTimeLabel.textColor = [UIColor detailTableViewCellTextColorNormal];
        self.endTimeLabel.backgroundColor = [UIColor clearColor];
        self.endTimeLabel.textAlignment = NSTextAlignmentLeft;
        
        self.endExpectedTimeLabel = [[UILabel alloc] initWithFrame: CGRectMake(48, self.bounds.size.height - 10 - 5, 40, 10)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.endExpectedTimeLabel.font = [UIFont systemFontOfSize: 12.0];
        self.endExpectedTimeLabel.textColor = [UIColor detailTableViewCellTextColorExpectedInfo];
        self.endExpectedTimeLabel.backgroundColor = [UIColor clearColor];
        self.endExpectedTimeLabel.textAlignment = NSTextAlignmentLeft;
        
        self.endStationTrackLabel = [[UILabel alloc] initWithFrame: CGRectMake(self.frame.size.width - 40 - 5 - 40, self.bounds.size.height - 33, 40, 10)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.endStationTrackLabel.font = [UIFont systemFontOfSize: 12.0];
        self.endStationTrackLabel.textColor = [UIColor detailTableViewCellTextColorNormal];
        self.endStationTrackLabel.backgroundColor = [UIColor clearColor];
        self.endStationTrackLabel.textAlignment = NSTextAlignmentRight;
        
        self.endStationExpectedTrackLabel = [[UILabel alloc] initWithFrame: CGRectMake(self.frame.size.width - 40 - 5 - 40, self.bounds.size.height - 21, 40, 10)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.endStationExpectedTrackLabel.font = [UIFont systemFontOfSize: 12.0];
        self.endStationExpectedTrackLabel.textColor = [UIColor detailTableViewCellTextColorExpectedInfo];
        self.endStationExpectedTrackLabel.backgroundColor = [UIColor clearColor];
        self.endStationExpectedTrackLabel.textAlignment = NSTextAlignmentRight;
        
        self.durationTimeImageView = [[UIImageView alloc] initWithFrame: CGRectMake(140, 65, 15, 15)];
        self.durationTimeImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.durationTimeImageView setImage: [UIImage newImageFromMaskImage: [UIImage journeyDurationImage] inColor: [UIColor detailTableViewCellJourneyInfoImageColor]]];
        
        self.durationLabel = [[UILabel alloc] initWithFrame: CGRectMake(160, 65, 10, 10)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.durationLabel.font = [UIFont systemFontOfSize: 12.0];
        self.durationLabel.textColor = [UIColor detailTableViewCellTextColorNormal];
        self.durationLabel.backgroundColor = [UIColor clearColor];
        self.durationLabel.textAlignment = NSTextAlignmentLeft;
        
        self.distanceImageView = [[UIImageView alloc] initWithFrame: CGRectMake(140, 90, 15, 15)];
        self.distanceImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.distanceImageView setImage: [UIImage newImageFromMaskImage: [UIImage journeyDistanceImage] inColor: [UIColor detailTableViewCellJourneyInfoImageColor]]];
        
        self.distanceLabel = [[UILabel alloc] initWithFrame: CGRectMake(160, 90, 10, 10)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.distanceLabel.font = [UIFont systemFontOfSize: 12.0];
        self.distanceLabel.textColor = [UIColor detailTableViewCellTextColorNormal];
        self.distanceLabel.backgroundColor = [UIColor clearColor];
        self.distanceLabel.textAlignment = NSTextAlignmentLeft;
        
        self.transportInfoLabel = [[UILabel alloc] initWithFrame: CGRectMake(50, 85, 80, 10)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.transportInfoLabel.font = [UIFont systemFontOfSize: 9.0];
        self.transportInfoLabel.textColor = [UIColor detailTableViewCellTextColorNormal];
        self.transportInfoLabel.backgroundColor = [UIColor clearColor];
        self.transportInfoLabel.textAlignment = NSTextAlignmentLeft;
        
        self.transportCapacity1stLabel = [[UILabel alloc] initWithFrame: CGRectMake(50, 85, 20, 10)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.transportCapacity1stLabel.font = [UIFont systemFontOfSize: 9.0];
        self.transportCapacity1stLabel.textColor = [UIColor detailTableViewCellTextColorNormal];
        self.transportCapacity1stLabel.backgroundColor = [UIColor clearColor];
        self.transportCapacity1stLabel.textAlignment = NSTextAlignmentLeft;
        
        self.transportCapacity1stImageView = [[UIImageView alloc] initWithFrame: CGRectMake(50 + 10, 86, 10, 8)];
        self.transportCapacity1stImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.transportCapacity2ndLabel = [[UILabel alloc] initWithFrame: CGRectMake(50 + 10 + 14 + 5, 85, 20, 10)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.transportCapacity2ndLabel.font = [UIFont systemFontOfSize: 9.0];
        self.transportCapacity2ndLabel.textColor = [UIColor detailTableViewCellTextColorNormal];
        self.transportCapacity2ndLabel.backgroundColor = [UIColor clearColor];
        self.transportCapacity2ndLabel.textAlignment = NSTextAlignmentLeft;
        
        self.transportCapacity2ndImageView = [[UIImageView alloc] initWithFrame: CGRectMake(50 + 10 + 14 + 5 + 10, 86, 10, 8)];
        self.transportCapacity2ndImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.transportTypeImageView = [[UIImageView alloc] initWithFrame: CGRectMake(8, 58, 30, 30)];
        self.transportTypeImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.transportNameImageView = [[UIImageView alloc] initWithFrame: CGRectMake(50, 63, 80, 20)];
        self.transportNameImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.journeyInfoImageView = [[UIImageView alloc] initWithFrame: CGRectMake(135, 61, 25, 25)];
        self.journeyInfoImageView.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *journeyInfoImage =  [UIImage newImageFromMaskImage: [[UIImage journeyInfoImage] resizedImage: CGSizeMake(25, 25) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor detailTableViewCellImageColorExpectedInfo]];
        [self.journeyInfoImageView setImage: journeyInfoImage];
        self.journeyInfoImageView.alpha = 0.0;
        
        self.transportConnectionImageView = [[UIImageView alloc] initWithFrame: CGRectMake(self.frame.size.width - 40 - 5, 0, 40, self.frame.size.height)];
        self.transportConnectionImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview: self.startStationLabel];
        [self.contentView addSubview: self.endStationLabel];
        
        [self.contentView addSubview: self.startTimeLabel];
        [self.contentView addSubview: self.endTimeLabel];
        
        [self.contentView addSubview: self.startStationTrackLabel];
        [self.contentView addSubview: self.endStationTrackLabel];
        
        //[self.contentView addSubview: self.durationTimeImageView];
        //[self.contentView addSubview: self.durationLabel];
        
        //[self.contentView addSubview: self.distanceImageView];
        //[self.contentView addSubview: self.distanceLabel];
        
        [self.contentView addSubview: self.transportInfoLabel];
        
        [self.contentView addSubview: self.transportTypeImageView];
        [self.contentView addSubview: self.transportNameImageView];
        [self.contentView addSubview: self.transportConnectionImageView];
        
        [self.contentView addSubview: self.transportCapacity1stLabel];
        [self.contentView addSubview: self.transportCapacity1stImageView];
        [self.contentView addSubview: self.transportCapacity2ndLabel];
        [self.contentView addSubview: self.transportCapacity2ndImageView];
        
        [self.contentView addSubview: self.journeyInfoImageView];
        [self.contentView addSubview: self.startExpectedTimeLabel];
        [self.contentView addSubview: self.endExpectedTimeLabel];
        [self.contentView addSubview: self.startStationExpectedTrackLabel];
        [self.contentView addSubview: self.endStationExpectedTrackLabel];
        
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
        //self.userInteractionEnabled = NO;
        
        //self.connectionImageView = [[ConnectionImageView alloc] initWithFrame: CGRectMake(self.bounds.size.width - 40 - 5, 0, 40, 185) topLine: NO bottonLine: NO type: self.consectionImageType];
        //[self.contentView addSubview: self.connectionImageView];
    }
    return self;
}

/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
*/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        //self.contentView.backgroundColor = [UIColor detailCellBackgroundColorSelected];
    } else {
        //self.contentView.backgroundColor = [UIColor detailCellBackgroundColorNormal];
    }
    
    // Configure the view for the selected state
}

- (void)setSelectableState:(BOOL)canBeSelected
{
    if (canBeSelected) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.userInteractionEnabled = YES;
    } else {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.userInteractionEnabled = YES;
        //self.userInteractionEnabled = NO;
    }
}

- (void)setJourneyInfoImageStateVisible:(BOOL)journeyhasinfos
{
    if (journeyhasinfos) {
        self.journeyInfoImageView.alpha = 1.0;
        self.detailViewCellHasJourneyInfos = YES;
    } else {
        self.journeyInfoImageView.alpha = 0.0;
        self.detailViewCellHasJourneyInfos = NO;
    }
}

- (void)setJourneyTrackNumberVisibleState:(BOOL)visible {
    if (visible) {
        self.startStationTrackLabel.alpha = 1.0;
        self.startStationExpectedTrackLabel.alpha = 1.0;
        self.endStationTrackLabel.alpha = 1.0;
        self.endStationExpectedTrackLabel.alpha = 1.0;
    } else {
        self.startStationTrackLabel.alpha = 0.0;
        self.startStationExpectedTrackLabel.alpha = 0.0;
        self.endStationTrackLabel.alpha = 0.0;
        self.endStationExpectedTrackLabel.alpha = 0.0;
    }
}

/*
- (void) setNewConnectionImageLayout:(BOOL)topLine bottomLine:(BOOL)bottomLine type:(NSUInteger)type {
    if (self.connectionImageView) {
        [self.connectionImageView removeFromSuperview];
        self.connectionImageView = nil;
    }

    NSLog(@"ConnectionType: %d", type);
    self.consectionImageType = type;
    self.connectionImageView = self.connectionImageView = [[ConnectionImageView alloc] initWithFrame: CGRectMake(self.frame.size.width - 40 - 5, 0, 40, self.frame.size.height) topLine: topLine bottonLine: bottomLine type:type];
    [self.contentView addSubview: self.connectionImageView];
}
*/

@end





