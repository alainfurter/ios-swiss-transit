//
//  RssInfoCell.h
//  Swiss Trains
//
//  Created by Alain on 21.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "UIColor+SwissTrains.h"



@interface RssInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *dateLabel;

- (void) setRssTitleLabelText:(NSString *)titletext;

@end

@interface SelectedBackgroundView : UIView
@end
