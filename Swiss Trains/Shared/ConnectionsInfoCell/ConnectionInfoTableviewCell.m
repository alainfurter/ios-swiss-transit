//
//  ConnectionInfoCell.m
//  Swiss Trains
//
//  Created by Alain on 28.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "ConnectionInfoTableviewCell.h"

#define CELLWIDTH 240
#define CELLHEIGHT 50

static UIFont *mtd_infoFont = nil;

@implementation ConnectionInfoTableviewCell

+ (void)initialize {
    if (self == [ConnectionInfoTableviewCell class]) {
        mtd_infoFont = [UIFont systemFontOfSize:12.f];
    }
}

+ (void)setInfoFont:(UIFont *)infoFont {
    if (infoFont != mtd_infoFont) {
        mtd_infoFont = infoFont;
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    
        //self.contentView.backgroundColor = [UIColor overviewCellBackgroundColorNormal];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.connectionInfoTextLabel = [[UILabel alloc] initWithFrame: CGRectMake(5, 5, CELLWIDTH - 5, CELLHEIGHT)];
        //self.timeLabelMinutesBig.font = [UIFont systemFontOfSize:55.0];
        self.connectionInfoTextLabel.font = [UIFont boldSystemFontOfSize: 12.0];
        self.connectionInfoTextLabel.textColor = [UIColor overviewCellTextColorNormal];
        self.connectionInfoTextLabel.backgroundColor = [UIColor clearColor];
        self.connectionInfoTextLabel.textAlignment = NSTextAlignmentLeft;
        self.connectionInfoTextLabel.numberOfLines = 0;
        self.connectionInfoTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.userInteractionEnabled = NO;
                
        [self.contentView addSubview: self.connectionInfoTextLabel];
    }
    return self;
}

+ (CGFloat)neededHeightForInfo:(NSString *)infotext constrainedToWidth:(CGFloat)width {
        
    CGFloat innerWidth = CELLWIDTH - 5;
    CGSize constraint = CGSizeMake(innerWidth, CGFLOAT_MAX);
    
    CGSize sizeDetailText = [infotext sizeWithFont:mtd_infoFont
                                              constrainedToSize: constraint
                                                  lineBreakMode:NSLineBreakByWordWrapping];
    
    
    
    //CGFloat computedHeight = sizeHeaderText.height + sizeDetailText.height + 16.f;
    CGFloat computedHeight = sizeDetailText.height + 10.f;
    CGFloat neededHeight = computedHeight;
    
    //NSLog(@"Needed height: %.1f", neededHeight);
    
    return neededHeight;
}

- (void)setConnectionInfoText:(NSString *)infotext {
                
    CGFloat innerWidth = CELLWIDTH - 5;
    CGSize constraint = CGSizeMake(innerWidth, CGFLOAT_MAX);
    
    CGSize sizeDetailText = [infotext sizeWithFont:mtd_infoFont
                                 constrainedToSize: constraint
                                     lineBreakMode:NSLineBreakByWordWrapping];
    
    
    CGRect infoFrame = self.connectionInfoTextLabel.frame;
    infoFrame.size.height = sizeDetailText.height;
    self.connectionInfoTextLabel.frame = infoFrame;
    
    self.connectionInfoTextLabel.text = infotext;
                
    [self setNeedsLayout];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
