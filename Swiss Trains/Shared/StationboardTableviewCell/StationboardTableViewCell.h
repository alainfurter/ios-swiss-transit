//
//  StationboardTableViewCell.h
//  Swiss Trains
//
//  Created by Alain on 18.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"

@interface StationboardTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *departureTimeLabel;
@property (nonatomic, strong) UILabel *arrivalTimeLabel;
@property (nonatomic, strong) UILabel *oneTimeLabel;
@property (nonatomic, strong) UILabel *stationNameLabel;
@property (nonatomic, strong) UILabel *trackLabel;

@property (strong, nonatomic) UIImageView *transportNameImageView;

- (void) prolongStationNameLabelIfNoTrackInfo;
- (void) shortenStationNameLabelIfTrackInfo;

@property (assign) BOOL tableViewCellsIsSelectedAndShouldDeselect;

@end
