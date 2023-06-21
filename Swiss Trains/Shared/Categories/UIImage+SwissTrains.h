//
//  UIImage+SwissTrains.h
//  Swiss Trains
//
//  Created by Alain on 28.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SwissTrains)

+ (UIImage *) renderCircleButtonImage:(UIImage *)inputimage backgroundColor:(UIColor *)backgroundColor imageColor:(UIColor *)imageColor;

+(UIImage *) newCircleImageWithMaskImage:(UIImage *)mask backgroundColor:(UIColor *)backgroundColor imageColor:(UIColor *)imageColor size:(CGSize)imageSize;

+(UIImage *) newImageFromMaskImage:(UIImage *)mask inColor:(UIColor *) color;

+(UIImage *) greyBackGroundImagePattern;
+(UIImage *) timeButtonImage;
+(UIImage *) timenowButtonImage;
+(UIImage *) goButtonImage;
+(UIImage *) pinButtonImage;
+(UIImage *) switchButtonImage;
+(UIImage *) backButtonImage;
+(UIImage *) mapButtonImage;
+(UIImage *) listButtonImage;
+(UIImage *) lupeButtonImage;
+(UIImage *) chooseStationButtonImage;
+(UIImage *) infoButtonImage;
+(UIImage *) shareButtonImage;
+(UIImage *) conreqButtonImage;
+(UIImage *) stboardButtonImage;
+(UIImage *) delayinfoButtonImage;
+(UIImage *) updateButtonImage;
+(UIImage *) arrowdownButtonImage;
+(UIImage *) arrowupButtonImage;
+(UIImage *) cancelButtonImage;
+(UIImage *) gorightButtonImage;
+(UIImage *) searchButtonImage;
+(UIImage *) alarmButtonImage;
+(UIImage *) addtocalendarButtonImage;
+(UIImage *) addtocalendarandalarmButtonImage;
+(UIImage *) locationheadingButtonImage;
+(UIImage *) trainlineNormalButtonImage;
+(UIImage *) trainlineDetailedButtonImage;

+(UIImage *) trainCapacityImage:(NSNumber *)capacity;
+(UIImage *) journeyDurationImage;
+(UIImage *) journeyChangesImage;
+(UIImage *) journeyDistanceImage;
+(UIImage *) journeyToImage;
+(UIImage *) journeyFromImage;
+(UIImage *) journeyFromToImage;
+(UIImage *) journeyArrivalImage;
+(UIImage *) journeyDepartureImage;
+(UIImage *) journeyViaImage;
+(UIImage *) journeyInfoImage;

+(UIImage *) journeyTransportWalkImage;
+(UIImage *) journeyTransportTrainImage;
+(UIImage *) journeyTransportBusImage;
+(UIImage *) journeyTransportTramImage;
+(UIImage *) journeyTransportShipImage;
+(UIImage *) journeyTransportTrainFastImage;
+(UIImage *) journeyTransportCablecarImage;
+(UIImage *) journeyTransportFuniImage;

+(UIImage *) stationBoardFastTrainImage;
+(UIImage *) stationBoardRegioTrainImage;
+(UIImage *) stationBoardBusTramImage;

+(UIImage *) favoriteSearchImage;

+(UIImage *) tableviewArrowImage;

+(UIImage *) storeFeaturePrintPDF;
+(UIImage *) storeFeatureNoAdds;
+(UIImage *) cartButtonImage;
+(UIImage *) storeBackgroundImageiPhone;
+(UIImage *) storeBackgroundImageiPad;
+(UIImage *) storeButtonImage;

+(UIImage *) calendarViewButtonImage;
+(UIImage *) calendarViewCurrentTimeImage;

- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)imageWithTransparentBorder:(NSUInteger)thickness;
- (UIImage *)imageWithTransparentLeftRight:(NSUInteger)thickness;
- (UIImage *)transparentBorderLeftRightImage:(NSUInteger)thickness;

- (UIImage *)blueTabBarItemFilter;
- (UIImage *)grayTabBarItemFilter;

@end
