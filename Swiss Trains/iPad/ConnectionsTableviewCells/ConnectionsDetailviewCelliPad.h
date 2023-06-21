//
//  ConnectionsDetailviewCell.h
//  Swiss Trains
//
//  Created by Alain on 28.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "UIColor+SwissTrains.h"
#import "UIImage+SwissTrains.h"

/*
enum consectionImageType {
    journey = 1,
    walk = 2,
    train = 3,
    tram = 4,
    bus = 5,
    ship = 6
};
*/
/*
// ----------------------------------------------------------

@interface ConnectionImageView : UIView
    @property (assign) BOOL topLine;
    @property (assign) BOOL bottomLine;
    //@property (assign) BOOL walkTypeFlag;
    @property (assign) NSUInteger consectionImageType;
    - (id)initWithFrame:(CGRect)frame topLine:(BOOL)topLine bottonLine:(BOOL)bottomLine type:(NSUInteger)type;
@end

// ----------------------------------------------------------

@interface RoundedRectmageView : UIView
    @property (strong, nonatomic) UIImage *centerImage;
    - (id)initWithFrame:(CGRect)frame centerImage:(UIImage *)centerImage;
@end

// ----------------------------------------------------------
*/
@interface ConnectionsDetailviewCelliPad : UITableViewCell

@property (strong, nonatomic) UILabel *startStationLabel;
@property (strong, nonatomic) UILabel *startTimeLabel;
@property (strong, nonatomic) UILabel *endStationLabel;
@property (strong, nonatomic) UILabel *endTimeLabel;
@property (strong, nonatomic) UILabel *durationLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UILabel *transportInfoLabel;
@property (strong, nonatomic) UILabel *transportCapacity1stLabel;
@property (strong, nonatomic) UILabel *transportCapacity2ndLabel;
@property (strong, nonatomic) UILabel *startStationTrackLabel;
@property (strong, nonatomic) UILabel *endStationTrackLabel;

@property (strong, nonatomic) UILabel *startExpectedTimeLabel;
@property (strong, nonatomic) UILabel *endExpectedTimeLabel;
@property (strong, nonatomic) UILabel *startStationExpectedTrackLabel;
@property (strong, nonatomic) UILabel *endStationExpectedTrackLabel;

@property (strong, nonatomic) UIImageView *transportTypeImageView;
@property (strong, nonatomic) UIImageView *transportNameImageView;
@property (strong, nonatomic) UIImageView *durationTimeImageView;
@property (strong, nonatomic) UIImageView *distanceImageView;
@property (strong, nonatomic) UIImageView *transportCapacity1stImageView;
@property (strong, nonatomic) UIImageView *transportCapacity2ndImageView;

@property (strong, nonatomic) UIImageView *journeyInfoImageView;

@property (strong, nonatomic) UIImageView *transportConnectionImageView;

//@property (strong, nonatomic) ConnectionImageView *connectionImageView;

@property (assign) NSUInteger consectionImageType;

- (void)setSelectableState:(BOOL)canBeSelected;

@property (assign) BOOL detailViewCellHasJourneyInfos;

- (void)setJourneyInfoImageStateVisible:(BOOL)journeyhasinfos;

- (void)setJourneyTrackNumberVisibleState:(BOOL)visible;

@property (assign) BOOL tableViewCellsIsSelectedAndShouldDeselect;


//- (void) setNewConnectionImageLayout:(BOOL)topLine bottomLine:(BOOL)bottomLine type:(NSUInteger)type;

@end
