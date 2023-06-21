//
//  ClosestStationsCell.m
//  Swiss Trains
//
//  Created by Alain on 15.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "ClosestStationsCell.h"

@implementation ClosestStationsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect cellFrame = self.contentView.frame;
        self.contentView.backgroundColor = [UIColor clearColor];
        //NSLog(@"Cell frame height, width: %.1f, %.1f", cellFrame.size.width, cellFrame.size.height);
        /*
         UIImageView *thumbnailImage = [[UIImageView alloc] initWithFrame: CGRectMake(5, 5, 40, 53)];
         thumbnailImage.tag = kCellImageViewTag;
         */
        
        self.titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(5, 5, cellFrame.size.width - 5 - 5 - 40 - 5, 15)];
        //self.titleLabel.tag = kCellTitleLabelTag;
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview: self.titleLabel];
        
        self.distanceLabel = [[UILabel alloc] initWithFrame: CGRectMake(cellFrame.size.width - 5 - 40, 5, 40, 15)];
        
        //NSLog(@"Closest station cell width: %.1f", cellFrame.size.width);
        //self.titleLabel.tag = kCellTitleLabelTag;
        self.distanceLabel.font = [UIFont systemFontOfSize:14.0];
        self.distanceLabel.backgroundColor = [UIColor clearColor];
        self.distanceLabel.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview: self.distanceLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) updateCellLabelWithRectWidth:(CGRect)newrect {
    //CGRect cellFrame = self.contentView.frame;
    self.titleLabel.frame = CGRectMake(5, 5, newrect.size.width - 5 - 5 - 40 - 5, 15);
    self.distanceLabel.frame = CGRectMake(newrect.size.width - 5 - 40, 5, 40, 15);
    [self setNeedsDisplay];
}

@end
