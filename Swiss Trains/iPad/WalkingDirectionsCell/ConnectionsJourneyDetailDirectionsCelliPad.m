//
//  ConnectionsJourneyDetailDirectionsCell.m
//  Swiss Trains
//
//  Created by Alain on 12.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "ConnectionsJourneyDetailDirectionsCelliPad.h"
#import <MTDirectionsKit/MTDirectionsKit.h>


static UIFont *mtd_distanceFont = nil;
static UIFont *mtd_instructionsFont = nil;

@implementation ConnectionsJourneyDetailDirectionsCelliPad

////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle
////////////////////////////////////////////////////////////////////////

+ (void)initialize {
    if (self == [ConnectionsJourneyDetailDirectionsCelliPad class]) {
        mtd_distanceFont = [UIFont boldSystemFontOfSize:14.f];
        mtd_instructionsFont = [UIFont systemFontOfSize:12.f];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        /*
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.font = mtd_distanceFont;
        self.textLabel.lineBreakMode = NSLineBreakByClipping;
        
        self.detailTextLabel.font = mtd_instructionsFont;
        self.detailTextLabel.textColor = [UIColor blackColor];
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        */
        
        //CGRect cellFrame = self.contentView.frame;
        self.contentView.backgroundColor = [UIColor clearColor];
        //NSLog(@"Cell frame height, width: %.1f, %.1f", cellFrame.size.width, cellFrame.size.height);
        /*
         UIImageView *thumbnailImage = [[UIImageView alloc] initWithFrame: CGRectMake(5, 5, 40, 53)];
         thumbnailImage.tag = kCellImageViewTag;
         */
        
        self.distanceLabel = [[UILabel alloc] initWithFrame: CGRectMake(10 + 30, 10, 60, 15)];
        //self.titleLabel.tag = kCellTitleLabelTag;
        self.distanceLabel.font = mtd_distanceFont;;
        self.distanceLabel.backgroundColor = [UIColor clearColor];
        self.distanceLabel.textColor = [UIColor blackColor];
        self.distanceLabel.numberOfLines = 0;
        self.distanceLabel.lineBreakMode = NSLineBreakByClipping;
        
        self.instructionsLabel = [[UILabel alloc] initWithFrame: CGRectMake(75 + 30, 10, 320 - 75 - 10 - 30, 15)];
        //self.titleLabel.tag = kCellTitleLabelTag;
        self.instructionsLabel.font = mtd_instructionsFont;
        self.instructionsLabel.backgroundColor = [UIColor clearColor];
        self.instructionsLabel.textColor = [UIColor blackColor];
        self.instructionsLabel.numberOfLines = 0;
        self.instructionsLabel.textAlignment = NSTextAlignmentLeft;
        //self.instructionsLabel.t
        self.instructionsLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.turnTypeImageView = [[UIImageView alloc] initWithFrame: CGRectMake(10, 10, 25, 25)];
        self.turnTypeImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview: self.distanceLabel];
        [self.contentView addSubview: self.instructionsLabel];
        [self.contentView addSubview: self.turnTypeImageView];

    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Class Methods
////////////////////////////////////////////////////////////////////////

+ (CGFloat)neededHeightForManeuver:(MTDManeuver *)maneuver constrainedToWidth:(CGFloat)width {
    BOOL imageVisible = YES; // maneuver.turnType != MTDTurnTypeUnknown;
    //CGFloat innerWidth = width - 20.f;
    //NSString *headerText = [maneuver.distance description];
    //NSString *detailText = maneuver.instructions;
    
    if (imageVisible) {
        // innerWidth -= CGRectGetWidth(kFKImageViewRect) + kFKPaddingXLeft;
    }
    /*
    CGSize constraint = CGSizeMake(innerWidth, CGFLOAT_MAX);
    
    CGSize sizeHeaderText = [headerText sizeWithFont:mtd_distanceFont
                                   constrainedToSize:constraint
                                       lineBreakMode:NSLineBreakByClipping];
    CGSize sizeDetailText = [detailText sizeWithFont:mtd_instructionsFont
                                   constrainedToSize:constraint
                                       lineBreakMode:NSLineBreakByWordWrapping];
    */
    
    CGFloat innerWidth = 320 - 75 - 10.f;
    CGSize constraint = CGSizeMake(innerWidth, CGFLOAT_MAX);
    
    CGSize sizeDetailText = [maneuver.instructions sizeWithFont:mtd_instructionsFont
                                              constrainedToSize: constraint
                                                  lineBreakMode:NSLineBreakByWordWrapping];
    
    
    
    //CGFloat computedHeight = sizeHeaderText.height + sizeDetailText.height + 16.f;
    CGFloat computedHeight = sizeDetailText.height + 20.f;
    CGFloat neededHeight = imageVisible ? MAX(computedHeight, 50.f) : computedHeight;
    
    return neededHeight;
}

+ (void)setDistanceFont:(UIFont *)distanceFont {
    if (distanceFont != mtd_distanceFont) {
        mtd_distanceFont = distanceFont;
    }
}

+ (void)setInstructionsFont:(UIFont *)instructionsFont {
    if (instructionsFont != mtd_instructionsFont) {
        mtd_instructionsFont = instructionsFont;
    }
}

/*
+ (void)setTurnTypeImageHidden:(BOOL)imageHidden {
    self.turnTypeImageView.hidden = imageHidden;
}
*/
////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewCell
////////////////////////////////////////////////////////////////////////

- (void)setManeuver:(MTDManeuver *)maneuver {
    if (maneuver != _maneuver) {
        _maneuver = maneuver;
        
        //NSLog(@"Manuever cell: %@, %@", maneuver.distance.description, maneuver.instructions);
        
        self.distanceLabel.text = [maneuver.distance description];
        self.instructionsLabel.text = maneuver.instructions;
        
        //NSLog(@"Old detail label height: %.1f", self.instructionsLabel.frame.size.height);
        
        CGFloat innerWidth = 320 - 75 - 10.f;
        CGSize constraint = CGSizeMake(innerWidth, CGFLOAT_MAX);
        
        CGSize sizeDetailText = [maneuver.instructions sizeWithFont:mtd_instructionsFont
                                       constrainedToSize: constraint
                                           lineBreakMode:NSLineBreakByWordWrapping];
        CGRect detailFrame = self.instructionsLabel.frame;
        detailFrame.size.height = sizeDetailText.height;
        self.instructionsLabel.frame = detailFrame;
        
        //NSLog(@"New detail label height: %.1f", self.instructionsLabel.frame.size.height);
        
        UIImage *image =  MTDGetImageForTurnType(maneuver.turnType);
        
        //NSLog(@"Maneuver turn type: %d", maneuver.turnType);
        //NSLog(@"Turn type image size: %.1f, %.1f", image.size.width, image.size.height);
        
        [self.turnTypeImageView setImage: image];
        
        [self setNeedsLayout];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
