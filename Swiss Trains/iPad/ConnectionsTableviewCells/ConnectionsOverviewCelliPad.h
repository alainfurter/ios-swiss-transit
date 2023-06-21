//
//  ConnectionsOverviewCell.h
//  Swiss Trains
//
//  Created by Alain on 28.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"

@interface CircleImageViewiPad : UIView

@property (strong, nonatomic) UIImage *centerImage;

- (id)initWithFrame:(CGRect)frame centerImage:(UIImage *)centerImage;

@end

@interface ConnectionsOverviewCelliPad : UITableViewCell

@property (strong, nonatomic) UILabel *timeLabelMinutesBig;
@property (strong, nonatomic) UILabel *timeLabelMinutesBigTitle;

@property (strong, nonatomic) UILabel *timeLabelMinutesSmall;
@property (strong, nonatomic) UILabel *timeLabelMinutesSmallTitle;
@property (strong, nonatomic) UILabel *timeLabelHoursSmall;
@property (strong, nonatomic) UILabel *timeLabelHoursSmallTitle;

@property (strong, nonatomic) UILabel *departureTimeLabel;
@property (strong, nonatomic) UILabel *arrivalTimeLabel;
@property (strong, nonatomic) UIImageView *departureImageView;
@property (strong, nonatomic) UIImageView *arrivalImageView;

@property (strong, nonatomic) CircleImageViewiPad *changesImageView;
@property (strong, nonatomic) UILabel *changesLabel;

@property (strong, nonatomic) UIImageView *connectionInfoImageView;

@property (assign) BOOL overviewCellHasJourneyInfos;

- (void)setConnectionInfoImageStateVisible:(BOOL)connectionhasinfos;

@end
