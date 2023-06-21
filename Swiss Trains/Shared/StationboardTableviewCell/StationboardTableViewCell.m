//
//  StationboardTableViewCell.m
//  Swiss Trains
//
//  Created by Alain on 18.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "StationboardTableViewCell.h"

@implementation StationboardTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect frame = self.frame;
        frame.size.height = 30;
        frame.size.width = 320;
        self.frame = frame;
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        //self.userInteractionEnabled = NO;
        
        self.clipsToBounds = YES;
        self.contentView.clipsToBounds = YES;
        
        //self.contentView.backgroundColor = [UIColor overviewCellBackgroundColorNormal];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        UIColor *topGradientColor = [UIColor connectionsDetailviewCellTopGradientColorNormal];
        UIColor *bottomGradientColor = [UIColor connectionsDetailviewCellBottomGradientColorNormal];
        CGRect backgroundViewFrame = frame;
        backgroundViewFrame.size.height = 30.0;
        self.backgroundView = [[UIView alloc] initWithFrame:backgroundViewFrame];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = frame;
        gradient.colors = [NSArray arrayWithObjects:(id)topGradientColor.CGColor, (id)bottomGradientColor.CGColor, nil];
        gradient.startPoint = CGPointMake(0.5f, 0.0f);
        gradient.endPoint = CGPointMake(0.5f, 1.0f);
        [self.backgroundView.layer addSublayer:gradient];
        
        self.arrivalTimeLabel = [[UILabel alloc] initWithFrame: CGRectMake(8, 5, 40, 18)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.arrivalTimeLabel.font = [UIFont systemFontOfSize: 12.0];
        self.arrivalTimeLabel.textColor = [UIColor overviewCellTextColorNormal];
        self.arrivalTimeLabel.backgroundColor = [UIColor clearColor];
        self.arrivalTimeLabel.textAlignment = NSTextAlignmentLeft;
        
        self.departureTimeLabel = [[UILabel alloc] initWithFrame: CGRectMake(8, 27, 40, 18)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.departureTimeLabel.font = [UIFont systemFontOfSize: 12.0];
        self.departureTimeLabel.textColor = [UIColor overviewCellTextColorNormal];
        self.departureTimeLabel.backgroundColor = [UIColor clearColor];
        self.departureTimeLabel.textAlignment = NSTextAlignmentLeft;
        
        self.oneTimeLabel = [[UILabel alloc] initWithFrame: CGRectMake(8, 6, 40, 18)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.oneTimeLabel.font = [UIFont systemFontOfSize: 12.0];
        self.oneTimeLabel.textColor = [UIColor overviewCellTextColorNormal];
        self.oneTimeLabel.backgroundColor = [UIColor clearColor];
        self.oneTimeLabel.textAlignment = NSTextAlignmentLeft;
                
        self.transportNameImageView = [[UIImageView alloc] initWithFrame: CGRectMake(48, 5, 80, 20)];
        self.transportNameImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.stationNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(8 + 40 + 80 + 5, 2.5, 320 - 8 - 40 - 80 - 5 - 45, 25)];
        //self.timeLabelMinutesBigTitle.font = [UIFont systemFontOfSize:12.0];
        self.stationNameLabel.font = [UIFont boldSystemFontOfSize: 13.0];
        self.stationNameLabel.textColor = [UIColor overviewCellTextColorNormal];
        self.stationNameLabel.backgroundColor = [UIColor clearColor];
        self.stationNameLabel.textAlignment = NSTextAlignmentLeft;
        
        self.trackLabel= [[UILabel alloc] initWithFrame: CGRectMake(320 - 40, 2.5, 35, 25)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.trackLabel.font = [UIFont systemFontOfSize: 12.0];
        self.trackLabel.textColor = [UIColor overviewCellTextColorNormal];
        self.trackLabel.backgroundColor = [UIColor clearColor];
        self.trackLabel.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview: self.arrivalTimeLabel];
        [self.contentView addSubview: self.departureTimeLabel];
        [self.contentView addSubview: self.oneTimeLabel];
        
        [self.contentView addSubview: self.stationNameLabel];
        [self.contentView addSubview: self.trackLabel];
        
        [self.contentView addSubview: self.transportNameImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) prolongStationNameLabelIfNoTrackInfo {
    self.stationNameLabel.frame = CGRectMake(8 + 40 + 80 + 5, 2.5, 320 - 8 - 40 - 80 - 5, 25);
}

- (void) shortenStationNameLabelIfTrackInfo {
    self.stationNameLabel.frame = CGRectMake(8 + 40 + 80 + 5, 2.5, 320 - 8 - 40 - 80 - 5 - 45, 25);
}

@end
