//
//  ConnectionsJourneyDetailPasslistCell.m
//  Swiss Trains
//
//  Created by Alain on 12.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "ConnectionsJourneyDetailPasslistCell.h"

@implementation ConnectionsJourneyDetailPasslistCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect frame = self.frame;
        frame.size.height = 50;
        frame.size.width = 320 - 80;
        self.frame = frame;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.userInteractionEnabled = NO;
        
        self.clipsToBounds = YES;
        self.contentView.clipsToBounds = YES;
        
        //self.contentView.backgroundColor = [UIColor overviewCellBackgroundColorNormal];
        self.contentView.backgroundColor = [UIColor clearColor];
        
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
        
        self.oneTimeLabel = [[UILabel alloc] initWithFrame: CGRectMake(8, 14, 40, 18)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.oneTimeLabel.font = [UIFont systemFontOfSize: 12.0];
        self.oneTimeLabel.textColor = [UIColor overviewCellTextColorNormal];
        self.oneTimeLabel.backgroundColor = [UIColor clearColor];
        self.oneTimeLabel.textAlignment = NSTextAlignmentLeft;
        
        self.passlistImage = [[UIImageView alloc] initWithFrame: CGRectMake(48, 0, 30, 50)];
        self.passlistImage.contentMode = UIViewContentModeScaleAspectFill;
        
        //self.stationNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(8 + 40 + 10 + 50 - 18, 10, 320 - 80 - 8 - 40 - 5 - 50 - 25 - 5 + 13 + 30, 30)];
        self.stationNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(8 + 40 + 10 + 50 - 18, 10, 320 - 8 - 40 - 10 - 50 + 18 - 40, 30)];
        //self.timeLabelMinutesBigTitle.font = [UIFont systemFontOfSize:12.0];
        self.stationNameLabel.font = [UIFont boldSystemFontOfSize: 13.0];
        self.stationNameLabel.textColor = [UIColor overviewCellTextColorNormal];
        self.stationNameLabel.backgroundColor = [UIColor clearColor];
        self.stationNameLabel.textAlignment = NSTextAlignmentLeft;
        
        self.trackLabel= [[UILabel alloc] initWithFrame: CGRectMake(320 - 40, 10, 35, 30)];
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
    
        [self.contentView addSubview: self.passlistImage];

    }
    return self;
}

- (void) prolongStationNameLabelIfNoTrackInfo {
    self.stationNameLabel.frame = CGRectMake(8 + 40 + 10 + 50 - 18, 10, 320 - 8 - 40 - 10 - 50 + 18, 30);
}

- (void) shortenStationNameLabelIfTrackInfo {
    self.stationNameLabel.frame = CGRectMake(8 + 40 + 10 + 50 - 18, 10, 320 - 8 - 40 - 10 - 50 + 18 - 40, 30);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
