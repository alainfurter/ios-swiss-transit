//
//  ConnectionsJourneyDetailDirectionsCell.h
//  Swiss Trains
//
//  Created by Alain on 12.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTDManeuver;

@interface ConnectionsJourneyDetailDirectionsCell : UITableViewCell

@property (nonatomic, strong) MTDManeuver *maneuver;

+ (CGFloat)neededHeightForManeuver:(MTDManeuver *)maneuver constrainedToWidth:(CGFloat)width;

@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *instructionsLabel;
@property (nonatomic, strong) UIImageView *turnTypeImageView;

+ (void)setDistanceFont:(UIFont *)distanceFont;
+ (void)setInstructionsFont:(UIFont *)instructionsFont;
//+ (void)setTurnTypeImageHidden:(BOOL)imageHidden;

@end
