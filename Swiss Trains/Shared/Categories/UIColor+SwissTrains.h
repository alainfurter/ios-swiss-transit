//
//  UIColor+SwissTrains.h
//  Swiss Trains
//
//  Created by Alain on 28.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SwissTrains)

+(UIColor *) connectionsOverviewCellTopGradientColorSelected;
+(UIColor *) connectionsOverviewCellBottomGradientColorSelected;

+(UIColor *) connectionsOverviewCellTopGradientColorNormal;
+(UIColor *) connectionsOverviewCellBottomGradientColorNormal;


+(UIColor *) connectionsDetailviewCellTopGradientColorSelected;
+(UIColor *) connectionsDetailviewCellBottomGradientColorSelected;

+(UIColor *) connectionsDetailviewCellTopGradientColorNormal;
+(UIColor *) connectionsDetailviewCellBottomGradientColorNormal;

+(UIColor *) rssDetailBackgroundColor;
+(UIColor *) listviewControllersBackgroundColor;
+(UIColor *) selectionControllerBackgroundColor;

// -------------------------------------------------------------------------------------

+(UIColor *) requestSegmentedControlTopGradientColor;
+(UIColor *) requestSegmentedControlBottomGradientColor;
+(UIColor *) requestSegmentedControlItemViewBackgroundColor;
+(UIColor *) requestSegmentedControlItemViewTextColorNormal;
+(UIColor *) requestSegmentedControlItemViewTextColorSelected;
+(UIColor *) requestSegmentedControlItemViewTextColorDisabled;
+(UIColor *) requestSegmentedControlItemViewTextColorNormalShadow;
+(UIColor *) requestSegmentedControlItemViewTextColorSelectedShadow;
+(UIColor *) requestSegmentedControlItemViewTextColorDisabledShadow;
+(UIColor *) requestSegmentedControlItemViewInnerCircleBottomShadowColor;
+(UIColor *) requestSegmentedControlItemImageColor;
+(UIColor *) requestSegmentedControlButtonsImageColorNormal;
+(UIColor *) requestSegmentedControlButtonsImageColorHighlighted;

// -------------------------------------------------------------------------------------

+(UIColor *) toolbarTopGradientColor;
+(UIColor *) toolbarBottomGradientColor;
+(UIColor *) toolbarTextColorNormal;
+(UIColor *) toolbarButtonsImageColorNormal;
+(UIColor *) toolbarButtonsImageColorHighlighted;

// -------------------------------------------------------------------------------------

+(UIColor *) greyBackgroundPatternImageColor;
+(UIColor *) darkBackgroundPatternImageColor;

+(UIColor *) selectStationsViewButtonColorNormal;
+(UIColor *) selectStationsViewButtonColorHighlighted;
+(UIColor *) selectStationsViewFTWButtonColorNormal;
+(UIColor *) selectStationsViewFTWButtonColorHighlighted;

+(UIColor *) overviewTableviewBackgroundColor;
+(UIColor *) overviewCellTextColorNormal;
+(UIColor *) overviewCellTextColorSelected;
+(UIColor *) overviewCellBackgroundColorNormal;
+(UIColor *) overviewCellBackgroundColorSelected;

+(UIColor *) detailTableviewBackgroundColor;
+(UIColor *) detailCellBackgroundColorNormal;
+(UIColor *) detailCellBackgroundColorSelected;
+(UIColor *) detailTableViewCellTextColorNormal;
+(UIColor *) detailTableViewCellTextColorExpectedInfo;
+(UIColor *) detailTableViewCellImageColorExpectedInfo;
+(UIColor *) detailTableViewCellTrainImageColor;
+(UIColor *) detailTableViewCellTramBusImageColor;
+(UIColor *) detailTableViewCellShipImageColor;
+(UIColor *) detailTableViewCellWalkImageColor;

+(UIColor *) detailTableViewCellChangeLineColor;
+(UIColor *) detailTableViewCellJourneyLineColor;

+(UIColor *) detailTableViewCellJourneyInfoImageBackgroundColor;
+(UIColor *) detailTableViewCellJourneyInfoImageColor;

+(UIColor *) connectionsJourneyDetailViewTopInfoViewListBackgroundColor;
+(UIColor *) connectionsJourneyDetailViewTopInfoViewMapBackgroundColor;
+(UIColor *) connectionsJourneyDetailViewTopInfoViewMapBackgroundColoriPad;

+(UIColor *) stationboardBottomSelectionViewBackgroundColor;
+(UIColor *) connectionsJourneyDetailViewBottomInfoViewListBackgroundColor;
+(UIColor *) connectionsJourneyDetailViewBottomInfoViewMapBackgroundColor;
+(UIColor *) connectionsJourneyDetailViewBottomInfoViewMapTextColor;
+(UIColor *) connectionsJourneyDetailViewBottomInfoViewListTextColor;

- (NSString *)stringFromColor;
- (NSString *)hexStringFromColor;

+ (UIColor *)colorWithString:(NSString *)stringToConvert;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

- (BOOL)isEqualToColor:(UIColor *)otherColor;

@end
