//
//  ConnectionsJourneyDetailPasslistCell.h
//  Swiss Trains
//
//  Created by Alain on 12.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"

@interface ConnectionsJourneyDetailPasslistCell : UITableViewCell

@property (nonatomic, strong) UILabel *departureTimeLabel;
@property (nonatomic, strong) UILabel *arrivalTimeLabel;
@property (nonatomic, strong) UILabel *oneTimeLabel;
@property (nonatomic, strong) UILabel *stationNameLabel;
@property (nonatomic, strong) UILabel *trackLabel;

@property (nonatomic, strong) UIImageView *passlistImage;

- (void) prolongStationNameLabelIfNoTrackInfo;
- (void) shortenStationNameLabelIfTrackInfo;

@end
