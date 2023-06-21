//
//  ConnectionsOverviewCell.m
//  Swiss Trains
//
//  Created by Alain on 28.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "ConnectionsOverviewCell.h"
#import <math.h>

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation CircleImageView

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
    
    //UIBezierPath *innerTopCirclePath = [UIBezierPath bezierPathWithOvalInRect: innerTopCircle];
    //[[UIColor blackColor] set];
    //[innerTopCirclePath fill];
    /*
    CGRect outerBottomCircle = {5, self.frame.size.height - 25 - 15, 25, 25};
    CGRect outerBottomMaskCircle  = CGRectInset(outerBottomCircle, 4, 4);
    CGRect innerBottomCircle = CGRectInset(outerBottomCircle, 6, 6);
    
    UIBezierPath *outerBottomCirclePath = [UIBezierPath bezierPathWithOvalInRect: outerBottomCircle];
    
    [outerBottomCirclePath appendPath:[UIBezierPath bezierPathWithOvalInRect: outerBottomMaskCircle]];
    outerBottomCirclePath.usesEvenOddFillRule = YES;
    
    [[UIColor detailTableViewCellJourneyLineColor] set];
    [outerBottomCirclePath fill];
    
    UIBezierPath *innerBottomCirclePath = [UIBezierPath bezierPathWithOvalInRect: innerBottomCircle];
    [[UIColor blackColor] set];
    [innerBottomCirclePath fill];
    */
}

@end


@implementation ConnectionsOverviewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect frame = self.frame;
        frame.size.height = 142;
        frame.size.width = 80;
        self.frame = frame;
        
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.overviewCellHasJourneyInfos = NO;
        
        //self.contentView.backgroundColor = [UIColor clearColor];

        //self.contentView.backgroundColor = [UIColor overviewCellBackgroundColorNormal];
        
        CGRect backgroundViewFrame = self.contentView.frame;
        backgroundViewFrame.size.height = 142;
        self.backgroundView = [[UIView alloc] initWithFrame:backgroundViewFrame];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[UIColor connectionsOverviewCellTopGradientColorNormal].CGColor, (id)[UIColor connectionsOverviewCellBottomGradientColorNormal].CGColor, nil];
        gradient.startPoint = CGPointMake(0.5f, 0.0f);
        gradient.endPoint = CGPointMake(0.5f, 1.0f);
        [self.backgroundView.layer addSublayer:gradient];
        
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:backgroundViewFrame];
        CAGradientLayer *gradientselected = [CAGradientLayer layer];
        gradientselected.frame = self.bounds;
        gradientselected.colors = [NSArray arrayWithObjects:(id)[UIColor connectionsOverviewCellTopGradientColorSelected].CGColor, (id)[UIColor connectionsOverviewCellBottomGradientColorSelected].CGColor, nil];
        gradientselected.startPoint = CGPointMake(0.5f, 0.0f);
        gradientselected.endPoint = CGPointMake(0.5f, 1.0f);
        [self.selectedBackgroundView.layer addSublayer:gradientselected];
        
        self.timeLabelMinutesBig = [[UILabel alloc] initWithFrame: CGRectMake(8, 20 - 5 - 5, 70, 40)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.timeLabelMinutesBig.font = [UIFont boldSystemFontOfSize: 54.0];
        self.timeLabelMinutesBig.textColor = [UIColor overviewCellTextColorNormal];
        self.timeLabelMinutesBig.backgroundColor = [UIColor clearColor];
        self.timeLabelMinutesBig.textAlignment = NSTextAlignmentLeft;
        
        self.timeLabelMinutesBigTitle = [[UILabel alloc] initWithFrame: CGRectMake(11, 70 - 5 - 5, 60, 10)];
        //self.timeLabelMinutesBigTitle.font = [UIFont systemFontOfSize:12.0];
        self.timeLabelMinutesBigTitle.font = [UIFont boldSystemFontOfSize: 12.0];
        self.timeLabelMinutesBigTitle.textColor = [UIColor overviewCellTextColorNormal];
        self.timeLabelMinutesBigTitle.backgroundColor = [UIColor clearColor];
        self.timeLabelMinutesBig.textAlignment = NSTextAlignmentLeft;
        
        /*
        self.timeLabelHoursSmall = [[UILabel alloc] initWithFrame: CGRectMake(8, 20, 70, 30)];
        //self.timeLabelHoursSmall.font = [UIFont systemFontOfSize:20.0];
        self.timeLabelHoursSmall.font = [UIFont boldSystemFontOfSize: 32.0];
        self.timeLabelHoursSmall.backgroundColor = [UIColor clearColor];
        self.timeLabelHoursSmall.textAlignment = NSTextAlignmentLeft;
    
        self.timeLabelMinutesSmall = [[UILabel alloc] initWithFrame: CGRectMake(8, 50, 70, 30)];
        //self.timeLabelMinutesSmall.font = [UIFont systemFontOfSize:20.0];
        self.timeLabelMinutesSmall.font = [UIFont boldSystemFontOfSize: 32.0];
        self.timeLabelMinutesSmall.backgroundColor = [UIColor clearColor];
        self.timeLabelMinutesSmall.textAlignment = NSTextAlignmentLeft;
        */
        
        self.timeLabelHoursSmall = [[UILabel alloc] initWithFrame: CGRectMake(15, 20 - 5 - 5, 70, 30)];
        //self.timeLabelHoursSmall.font = [UIFont systemFontOfSize:20.0];
        self.timeLabelHoursSmall.font = [UIFont boldSystemFontOfSize: 35.0];
        self.timeLabelHoursSmall.textColor = [UIColor overviewCellTextColorNormal];
        self.timeLabelHoursSmall.backgroundColor = [UIColor clearColor];
        self.timeLabelHoursSmall.textAlignment = NSTextAlignmentLeft;
        
        self.timeLabelHoursSmallTitle = [[UILabel alloc] initWithFrame: CGRectMake(45, 22 - 5 - 5, 32, 30)];
        //self.timeLabelHoursSmall.font = [UIFont systemFontOfSize:20.0];
        self.timeLabelHoursSmallTitle.font = [UIFont boldSystemFontOfSize: 13.0];
        self.timeLabelHoursSmallTitle.textColor = [UIColor overviewCellTextColorNormal];
        self.timeLabelHoursSmallTitle.backgroundColor = [UIColor clearColor];
        self.timeLabelHoursSmallTitle.textAlignment = NSTextAlignmentRight;
        //self.timeLabelHoursSmallTitle.transform = CGAffineTransformMakeRotation(-92/57.2957795);
        self.timeLabelHoursSmallTitle.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-90));
        
        self.timeLabelMinutesSmall = [[UILabel alloc] initWithFrame: CGRectMake(15, 50 - 5 - 5, 70, 30)];
        //self.timeLabelMinutesSmall.font = [UIFont systemFontOfSize:20.0];
        self.timeLabelMinutesSmall.font = [UIFont boldSystemFontOfSize: 35.0];
        self.timeLabelMinutesSmall.textColor = [UIColor overviewCellTextColorNormal];
        self.timeLabelMinutesSmall.backgroundColor = [UIColor clearColor];
        self.timeLabelMinutesSmall.textAlignment = NSTextAlignmentLeft;
        
        self.timeLabelMinutesSmallTitle = [[UILabel alloc] initWithFrame: CGRectMake(45, 53 - 5 - 5, 32, 30)];
        //self.timeLabelMinutesSmall.font = [UIFont systemFontOfSize:20.0];
        self.timeLabelMinutesSmallTitle.font = [UIFont boldSystemFontOfSize: 13.0];
        self.timeLabelMinutesSmallTitle.textColor = [UIColor overviewCellTextColorNormal];
        self.timeLabelMinutesSmallTitle.backgroundColor = [UIColor clearColor];
        self.timeLabelMinutesSmallTitle.textAlignment = NSTextAlignmentRight;
        //self.timeLabelMinutesSmallTitle.transform = CGAffineTransformMakeRotation(-92/57.2957795);
        self.timeLabelMinutesSmallTitle.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-90));
        
        /*
        UIImage *changesImage = [UIImage newCircleImageWithMaskImage: [UIImage journeyChangesImage] backgroundColor: [UIColor detailTableViewCellJourneyInfoImageBackgroundColor] imageColor: [UIColor detailTableViewCellJourneyInfoImageColor] size:CGSizeMake(20, 20)];
        
        self.changesImageView = [[UIImageView alloc] initWithFrame: CGRectMake(18, 85, 20, 20)];
        self.changesImageView.image = changesImage;
        */
        
        self.changesImageView = [[CircleImageView alloc] initWithFrame: CGRectMake(18, 85 - 5 - 5, 20, 20) centerImage: [UIImage journeyChangesImage]];
         
        self.changesLabel = [[UILabel alloc] initWithFrame: CGRectMake(43, 85 - 5 - 5, 20, 20)];
        //self.timeLabelMinutesSmall.font = [UIFont systemFontOfSize:20.0];
        self.changesLabel.font = [UIFont boldSystemFontOfSize: 20.0];
        self.changesLabel.textColor = [UIColor overviewCellTextColorNormal];
        self.changesLabel.backgroundColor = [UIColor clearColor];
        self.changesLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.contentView addSubview: self.timeLabelMinutesBig];
        [self.contentView addSubview: self.timeLabelMinutesBigTitle];
        
        [self.contentView addSubview: self.timeLabelHoursSmall];
        [self.contentView addSubview: self.timeLabelMinutesSmall];
        
        [self.contentView addSubview: self.timeLabelHoursSmallTitle];
        [self.contentView addSubview: self.timeLabelMinutesSmallTitle];
        
        [self.contentView addSubview: self.changesImageView];
        [self.contentView addSubview: self.changesLabel];
        
        self.departureImageView = [[UIImageView alloc] initWithFrame: CGRectMake(8, 110 - 4, 20, 10)];
        self.departureImageView.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *departureImage =  [UIImage newImageFromMaskImage:[[UIImage journeyDepartureImage] resizedImage: CGSizeMake(20, 10) interpolationQuality: kCGInterpolationDefault]
                                                          inColor: [UIColor detailTableViewCellJourneyInfoImageBackgroundColor]];
        [self.departureImageView setImage: departureImage];
        
        self.arrivalImageView = [[UIImageView alloc] initWithFrame: CGRectMake(8, 125 - 4 + 3, 20, 10)];
        self.arrivalImageView.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *arrivalImage = [UIImage newImageFromMaskImage:[[UIImage journeyArrivalImage] resizedImage: CGSizeMake(20, 10) interpolationQuality: kCGInterpolationDefault]
                                                       inColor: [UIColor detailTableViewCellJourneyInfoImageBackgroundColor]];
        [self.arrivalImageView setImage: arrivalImage];
        
        self.departureTimeLabel = [[UILabel alloc] initWithFrame: CGRectMake(35, 110 - 4, 50, 12)];
        //self.timeLabelMinutesBigTitle.font = [UIFont systemFontOfSize:12.0];
        self.departureTimeLabel .font = [UIFont boldSystemFontOfSize: 15.0];
        self.departureTimeLabel .textColor = [UIColor overviewCellTextColorNormal];
        self.departureTimeLabel .backgroundColor = [UIColor clearColor];
        self.departureTimeLabel .textAlignment = NSTextAlignmentLeft;
        
        self.arrivalTimeLabel = [[UILabel alloc] initWithFrame: CGRectMake(35, 125 - 4 + 2, 50, 12)];
        //self.timeLabelMinutesBigTitle.font = [UIFont systemFontOfSize:12.0];
        self.arrivalTimeLabel.font = [UIFont boldSystemFontOfSize: 15.0];
        self.self.arrivalTimeLabel.textColor = [UIColor overviewCellTextColorNormal];
        self.self.arrivalTimeLabel.backgroundColor = [UIColor clearColor];
        self.arrivalTimeLabel.textAlignment = NSTextAlignmentLeft;
                
        self.connectionInfoImageView = [[UIImageView alloc] initWithFrame: CGRectMake(55, 85 - 5 - 5, 20, 20)];
        self.connectionInfoImageView.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *connectionInfoImage =  [UIImage newImageFromMaskImage: [[UIImage journeyInfoImage] resizedImage: CGSizeMake(20, 20) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor detailTableViewCellImageColorExpectedInfo]];
        [self.connectionInfoImageView setImage: connectionInfoImage];
        self.connectionInfoImageView.alpha = 0.0;

        
        [self.contentView addSubview: self.departureImageView];
        [self.contentView addSubview: self.departureTimeLabel];
        [self.contentView addSubview: self.arrivalImageView];
        [self.contentView addSubview: self.arrivalTimeLabel];
        
        [self.contentView addSubview: self.connectionInfoImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        //self.contentView.backgroundColor = [UIColor overviewCellBackgroundColorSelected];
        self.timeLabelMinutesBig.textColor = [UIColor overviewCellTextColorSelected];
        self.timeLabelMinutesBigTitle.textColor = [UIColor overviewCellTextColorSelected];
        self.timeLabelMinutesSmall.textColor = [UIColor overviewCellTextColorSelected];
        self.timeLabelMinutesSmallTitle.textColor = [UIColor overviewCellTextColorSelected];
        self.timeLabelHoursSmall.textColor = [UIColor overviewCellTextColorSelected];
        self.timeLabelHoursSmallTitle.textColor = [UIColor overviewCellTextColorSelected];
        self.changesLabel.textColor = [UIColor overviewCellTextColorSelected];
        self.departureTimeLabel.textColor = [UIColor overviewCellTextColorSelected];
        self.arrivalTimeLabel.textColor = [UIColor overviewCellTextColorSelected];
    } else {
        //self.contentView.backgroundColor = [UIColor overviewCellBackgroundColorNormal];
        self.timeLabelMinutesBig.textColor = [UIColor overviewCellTextColorNormal];
        self.timeLabelMinutesBigTitle.textColor = [UIColor overviewCellTextColorNormal];
        self.timeLabelMinutesSmall.textColor = [UIColor overviewCellTextColorNormal];
        self.timeLabelMinutesSmallTitle.textColor = [UIColor overviewCellTextColorNormal];
        self.timeLabelHoursSmall.textColor = [UIColor overviewCellTextColorNormal];
        self.timeLabelHoursSmallTitle.textColor = [UIColor overviewCellTextColorNormal];
        self.changesLabel.textColor = [UIColor overviewCellTextColorNormal];
        self.departureTimeLabel.textColor = [UIColor overviewCellTextColorNormal];
        self.arrivalTimeLabel.textColor = [UIColor overviewCellTextColorNormal];
    }

    // Configure the view for the selected state
}

- (void)setConnectionInfoImageStateVisible:(BOOL)connectionhasinfos {
    if (connectionhasinfos) {
        self.connectionInfoImageView.alpha = 1.0;
        self.overviewCellHasJourneyInfos = YES;
    } else {
        self.connectionInfoImageView.alpha = 0.0;
        self.overviewCellHasJourneyInfos = NO;
    }
}

@end
