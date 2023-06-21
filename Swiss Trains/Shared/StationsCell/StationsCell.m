//
//  StationsCell.m
//  Swiss Trains
//
//  Created by Alain on 20.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "StationsCell.h"

@implementation StationsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGRect cellFrame = self.contentView.frame;
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        //NSLog(@"Cell frame height, width: %.1f, %.1f", cellFrame.size.width, cellFrame.size.height);
        /*
         UIImageView *thumbnailImage = [[UIImageView alloc] initWithFrame: CGRectMake(5, 5, 40, 53)];
         thumbnailImage.tag = kCellImageViewTag;
         */
        
        self.titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(5, 5, cellFrame.size.width - 5, 15)];
        //self.titleLabel.tag = kCellTitleLabelTag;
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview: self.titleLabel];
        
        self.favoriteImageView = [[UIImageView alloc] initWithFrame: CGRectMake(5, 5, 15, 15)];
        self.self.favoriteImageView.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *favoriteImage =  [UIImage newImageFromMaskImage:[[UIImage favoriteSearchImage] resizedImage: CGSizeMake(15, 15) interpolationQuality: kCGInterpolationDefault]
                                                          inColor: [UIColor detailTableViewCellJourneyInfoImageBackgroundColor]];
        [self.self.favoriteImageView setImage: favoriteImage];
        [self.contentView addSubview: self.favoriteImageView];
        self.favoriteImageView.alpha = 0.0;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setFavoriteCell:(BOOL)isFavriteCell {
    CGRect cellFrame = self.contentView.frame;
    if (isFavriteCell) {
        self.favoriteImageView.alpha = 1.0;
        self.titleLabel.frame = CGRectMake(5+15+5, 5, cellFrame.size.width - 5 - 15 - 5, 15);
    } else {
        self.favoriteImageView.alpha = 0.0;
        self.titleLabel.frame = CGRectMake(5, 5, cellFrame.size.width - 5, 15);
    }
}

@end
