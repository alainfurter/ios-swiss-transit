//
//  ClosestStationsCell.h
//  Swiss Trains
//
//  Created by Alain on 15.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClosestStationsCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) NSString *stationId;

- (void) updateCellLabelWithRectWidth:(CGRect)newrect;

@end
