//
//  ConnectionInfoCell.h
//  Swiss Trains
//
//  Created by Alain on 28.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIColor+SwissTrains.h"

@interface ConnectionInfoTableviewCell : UITableViewCell

@property (strong, nonatomic) UILabel *connectionInfoTextLabel;

+ (CGFloat)neededHeightForInfo:(NSString *)infotext constrainedToWidth:(CGFloat)width;
+ (void)setInfoFont:(UIFont *)infoFont;

- (void)setConnectionInfoText:(NSString *)infotext;

@end
