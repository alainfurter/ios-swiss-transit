//
//  RssInfoCell.m
//  Swiss Trains
//
//  Created by Alain on 21.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "RssInfoCell.h"

@implementation RssInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        CGRect cellFrame = self.contentView.frame;
        cellFrame.size.height = 30;
        self.frame = cellFrame;
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIColor *topGradientColor = [UIColor connectionsDetailviewCellTopGradientColorNormal];
        UIColor *bottomGradientColor = [UIColor connectionsDetailviewCellBottomGradientColorNormal];
        CGRect backgroundViewFrame = cellFrame;
        backgroundViewFrame.size.height = 30.0;
        self.backgroundView = [[UIView alloc] initWithFrame:backgroundViewFrame];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = cellFrame;
        gradient.colors = [NSArray arrayWithObjects:(id)topGradientColor.CGColor, (id)bottomGradientColor.CGColor, nil];
        gradient.startPoint = CGPointMake(0.5f, 0.0f);
        gradient.endPoint = CGPointMake(0.5f, 1.0f);
        [self.backgroundView.layer addSublayer:gradient];
        
        //NSLog(@"Cell frame height, width: %.1f, %.1f", cellFrame.size.width, cellFrame.size.height);
        /*
         UIImageView *thumbnailImage = [[UIImageView alloc] initWithFrame: CGRectMake(5, 5, 40, 53)];
         thumbnailImage.tag = kCellImageViewTag;
         */
        /*
        self.dateLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, 5, cellFrame.size.width - 20, 15)];
        self.dateLabel.font = [UIFont systemFontOfSize:12.0];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        [self.contentView addSubview: self.dateLabel];
        */
        self.titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(5, 8, cellFrame.size.width - 5, 15)];
        //self.titleLabel.tag = kCellTitleLabelTag;
        
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.textColor = [UIColor colorWithWhite: 0.2 alpha:1.0];
        //UIFont *EuropaGroSH = [UIFont fontWithName:@"EuropaGroSH-Med" size:14.0f];
        //self.titleLabel.font = EuropaGroSH;
        
        self.titleLabel.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview: self.titleLabel];
        
        
        //self.backgroundColor = [UIColor clearColor];
        //self.backgroundView.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        
        //SelectedBackgroundView *selectedBackgroundView = [[SelectedBackgroundView alloc] init];
        //self.selectedBackgroundView = selectedBackgroundView;
    }
    return self;
}

- (CGFloat) neededHeightForRowWithText:(NSString *)title {
    CGSize maximumLabelSize = CGSizeMake(320, 75);
    
    CGSize expectedLabelSize = [title sizeWithFont:self.titleLabel.font constrainedToSize:maximumLabelSize lineBreakMode:self.titleLabel.lineBreakMode];
    return expectedLabelSize.height;
}

- (void) setRssTitleLabelText:(NSString *)titletext {
    CGFloat height = [self neededHeightForRowWithText:titletext];
    CGRect labelframe = self.titleLabel.frame;
    labelframe.size.height = height;
    self.titleLabel.frame = labelframe;
    self.titleLabel.text = titletext;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation SelectedBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void) viewdidLoads {
    
}

- (UIColor *) colorWithHex:(int)hex {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];

    CGRect adjustedRect = CGRectInset(rect, 10, 10);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:adjustedRect cornerRadius:10];
    
    [[UIColor darkBackgroundPatternImageColor] set];
    [path fill];
    
    [[self colorWithHex:0xcdcbca] set];
    [path setLineWidth: 2.0f];
    float lineDash[2];
    lineDash[0] = 2.0; lineDash[1] = 2.0;
    [path setLineDash: lineDash count:2 phase:0.0f];
    [path stroke];
}


@end
