//
//  UIImage+SwissTrains.m
//  Swiss Trains
//
//  Created by Alain on 28.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "UIImage+SwissTrains.h"

@implementation UIImage (SwissTrains)

+ (UIImage *) renderCircleButtonImage:(UIImage *)inputimage backgroundColor:(UIColor *)backgroundColor imageColor:(UIColor *)imageColor {
    
    float scaleFactor = [[UIScreen mainScreen] scale];
    
    CGSize imageSize = CGSizeMake(30, 30);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             imageSize.width * scaleFactor, imageSize.height * scaleFactor,
                                             8, imageSize.width * scaleFactor * 4, colorSpace,
                                             kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    CGContextScaleCTM(ctx, scaleFactor, scaleFactor);
    
    CGSize typeImageSize = CGSizeMake(imageSize.width * scaleFactor, imageSize.height * scaleFactor);
    ;
    UIImage *transportTypeImageResized = [inputimage resizedImage: typeImageSize interpolationQuality: kCGInterpolationDefault];
    UIImage *transportTypeImageColored = [UIImage newImageFromMaskImage: transportTypeImageResized inColor: imageColor];
    
    CGContextSaveGState(ctx);
    
    CGRect circleRect = CGRectMake(0, 0,
                                   imageSize.width,
                                   imageSize.height);
    
    
    
    CGContextSetFillColorWithColor(ctx, backgroundColor.CGColor);
    CGContextFillEllipseInRect(ctx, circleRect);
    
    CGPoint imageStartingPoint = CGPointMake(5, 5);
    
    CGContextDrawImage(ctx, CGRectMake(imageStartingPoint.x, imageStartingPoint.y, imageSize.width - 10, imageSize.height - 10), [transportTypeImageColored CGImage]);
    /*
     UIGraphicsPushContext(ctx);
     CGContextTranslateCTM(ctx, 0.0f, imageSize.height);
     CGContextScaleCTM(ctx, 1.0f, -1.0f);
     [transportTypeImageColored drawAtPoint:imageStartingPoint];
     UIGraphicsPopContext();
     */
    CGImageRef image = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    
    UIImage *retImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
	return retImage;
}

+(UIImage *) newCircleImageWithMaskImage:(UIImage *)mask backgroundColor:(UIColor *)backgroundColor imageColor:(UIColor *)imageColor size:(CGSize)imageSize {
    float imageDistance = 20.0;
    CGRect imageRect = CGRectMake(0, 0, mask.size.width + imageDistance * 2, mask.size.height + imageDistance * 2);
    //CGRect maskRect = CGRectMake(0, 0, mask.size.width, mask.size.height);
    
    float scaleFactor = [[UIScreen mainScreen] scale];
    //scaleFactor = 5.0;
        
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       imageRect.size.width * scaleFactor, imageRect.size.height * scaleFactor,
                                                       8, imageRect.size.width * scaleFactor * 4, colorSpace,
                                                       kCGImageAlphaPremultipliedFirst);
    CGContextScaleCTM(bitmapContext, scaleFactor, scaleFactor);
    
    float radius = imageRect.size.width;
    CGContextSetFillColorWithColor(bitmapContext, backgroundColor.CGColor);
    CGContextFillEllipseInRect(bitmapContext, CGRectMake(0, 0, radius, radius));
    
    CGImageRef maskImage = mask.CGImage;
    CGFloat width = mask.size.width;
    CGFloat height = mask.size.height;
    CGRect bounds = CGRectMake(imageDistance, imageDistance, width,height);
    CGContextClipToMask(bitmapContext, bounds, maskImage);
    
    CGRect boundsFill = CGRectMake(imageDistance, imageDistance, width, height);
    //UIColor *imageColor = [UIColor whiteColor];
    CGContextSetFillColorWithColor(bitmapContext, imageColor.CGColor);
    CGContextFillRect(bitmapContext, boundsFill);
    
    CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    
    UIImage *result = [UIImage imageWithCGImage: mainViewContentBitmapContext scale:scaleFactor orientation: UIImageOrientationUp];
    
    return result;
    
    
    
    /*
    CGImageRef maskImage = mask.CGImage;
    CGFloat width = mask.size.width;
    CGFloat height = mask.size.height;
    CGRect bounds = CGRectMake(0,0,width,height);
    CGContextClipToMask(ctx, bounds, maskImage);
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillRect(ctx, bounds);
    
    
    CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    
    UIImage *result = [UIImage imageWithCGImage: mainViewContentBitmapContext scale: scaleFactor orientation: UIImageOrientationUp];

    return result;
     */
}

+(UIImage *) newImageFromMaskImage:(UIImage *)mask inColor:(UIColor *) color {
    CGImageRef maskImage = mask.CGImage;
    CGFloat width = mask.size.width;
    CGFloat height = mask.size.height;
    CGRect bounds = CGRectMake(0,0,width,height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    float scaleFactor = [[UIScreen mainScreen] scale];
    CGSize size = CGSizeMake(width, height);
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       size.width * scaleFactor, size.height * scaleFactor,
                                                       8, size.width * scaleFactor * 4, colorSpace,
                                                       kCGImageAlphaPremultipliedFirst);
    CGContextScaleCTM(bitmapContext, scaleFactor, scaleFactor);
    //AF- end
    
    CGContextClipToMask(bitmapContext, bounds, maskImage);
    CGContextSetFillColorWithColor(bitmapContext, color.CGColor);
    CGContextFillRect(bitmapContext, bounds);
    
    CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    
    UIImage *result = [UIImage imageWithCGImage: mainViewContentBitmapContext scale: scaleFactor orientation: UIImageOrientationUp];
    
    
    return result;
}

+ (UIImage *)ipMaskedImageNamed:(NSString *)name color:(UIColor *)color
{
    UIImage *image = [UIImage imageNamed:name];
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [image drawInRect:rect];
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
    CGContextFillRect(c, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (UIImage*) maskImage:(UIImage *) image withMask:(UIImage *) mask
{
    CGImageRef imageReference = image.CGImage;
    CGImageRef maskReference = mask.CGImage;
    
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                             CGImageGetHeight(maskReference),
                                             CGImageGetBitsPerComponent(maskReference),
                                             CGImageGetBitsPerPixel(maskReference),
                                             CGImageGetBytesPerRow(maskReference),
                                             CGImageGetDataProvider(maskReference),
                                             NULL, // Decode is null
                                             YES // Should interpolate
                                             );
    
    CGImageRef maskedReference = CGImageCreateWithMask(imageReference, imageMask);
    CGImageRelease(imageMask);
    
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedReference];
    CGImageRelease(maskedReference);
    
    return maskedImage;
}

// --------------------------------------------

+(UIImage *) greyBackGroundImagePattern {
    return [UIImage imageNamed: @"Background.png"];
}

+(UIImage *) timeButtonImage {
    return [UIImage imageNamed: @"Time.png"];
}

+(UIImage *) timenowButtonImage {
    return [UIImage imageNamed: @"TimeNow.png"];
}

+(UIImage *) goButtonImage {
    return [UIImage imageNamed: @"Go.png"];
}

+(UIImage *) pinButtonImage {
    return [UIImage imageNamed: @"Pin.png"];
}

+(UIImage *) switchButtonImage {
    return [UIImage imageNamed: @"Reverse.png"];
}

+(UIImage *) backButtonImage {
    return [UIImage imageNamed: @"Back.png"];
}

+(UIImage *) mapButtonImage {
    return [UIImage imageNamed: @"Map.png"];
}

+(UIImage *) listButtonImage {
    return [UIImage imageNamed: @"List.png"];
}

+(UIImage *) lupeButtonImage {
    return [UIImage imageNamed: @"Lupe.png"];
}

+(UIImage *) chooseStationButtonImage {
    return [UIImage imageNamed: @"Go.png"];
}

+(UIImage *) infoButtonImage {
    return [UIImage imageNamed: @"Info.png"];
}

+(UIImage *) shareButtonImage {
    return [UIImage imageNamed: @"Share.png"];
}

+(UIImage *) conreqButtonImage {
    return [UIImage imageNamed: @"SegConreq.png"];
}

+(UIImage *) stboardButtonImage {
    return [UIImage imageNamed: @"SegStboard.png"];
}

+(UIImage *) delayinfoButtonImage {
    return [UIImage imageNamed: @"SegDelaysinfo.png"];
}

+(UIImage *) updateButtonImage {
    return [UIImage imageNamed: @"Update.png"];
}

+(UIImage *) arrowdownButtonImage {
    return [UIImage imageNamed: @"ArrowDown.png"];
}

+(UIImage *) arrowupButtonImage {
    return [UIImage imageNamed: @"ArrowUp.png"];
}

+(UIImage *) cancelButtonImage {
    return [UIImage imageNamed: @"Cancel.png"];
}

+(UIImage *) gorightButtonImage {
    return [UIImage imageNamed: @"ArrowRight.png"];
}

+(UIImage *) searchButtonImage {
    return [UIImage imageNamed: @"Search.png"];
}

+(UIImage *) alarmButtonImage {
    return [UIImage imageNamed: @"Alarm.png"];
}

+(UIImage *) addtocalendarButtonImage {
    return [UIImage imageNamed: @"AddCalendar.png"];
}

+(UIImage *) addtocalendarandalarmButtonImage {
    return [UIImage imageNamed: @"AlarmCalendar.png"];
}

+(UIImage *) locationheadingButtonImage {
    return [UIImage imageNamed: @"LocationHeading.png"];
}

+(UIImage *) trainlineNormalButtonImage {
    return [UIImage imageNamed: @"TrainlineNormal.png"];
}

+(UIImage *) trainlineDetailedButtonImage {
    return [UIImage imageNamed: @"TrainlineDetailed.png"];
}


// --------------------------------------------

+(UIImage *) trainCapacityImage:(NSNumber *)capacity {
    if (capacity) {
        int capint = [capacity integerValue];
        if (capint >= 0 && capint <= 3) {
            //NSLog(@"Get capacity image: %d", capint);
            return [UIImage imageNamed: [NSString stringWithFormat: @"Capacity%d.png", capint]];
        }
    };
    return nil;
}

+(UIImage *) journeyDurationImage {
    return [UIImage imageNamed: @"Duration.png"];
}

+(UIImage *) journeyChangesImage {
    return [UIImage imageNamed: @"Changes.png"];
}

+(UIImage *) journeyDistanceImage {
    return [UIImage imageNamed: @"Distance.png"];
}

+(UIImage *) journeyToImage {
    return [UIImage imageNamed: @"To.png"];
}

+(UIImage *) journeyFromImage {
    return [UIImage imageNamed: @"From.png"];
}

+(UIImage *) journeyFromToImage {
    return [UIImage imageNamed: @"FromTo.png"];
}

+(UIImage *) journeyArrivalImage {
    return [UIImage imageNamed: @"Arrival.png"];
}

+(UIImage *) journeyDepartureImage {
    return [UIImage imageNamed: @"Departure.png"];
}

+(UIImage *) journeyViaImage {
    return [UIImage imageNamed: @"Via.png"];
}


+(UIImage *) journeyInfoImage {
    return [UIImage imageNamed: @"Delaysinfo.png"];
}

// --------------------------------------------

+(UIImage *) journeyTransportWalkImage {
    return [UIImage imageNamed: @"Walking.png"];
}

+(UIImage *) journeyTransportTrainImage {
    return [UIImage imageNamed: @"Train.png"];
}

+(UIImage *) journeyTransportBusImage {
    return [UIImage imageNamed: @"Bus.png"];
}

+(UIImage *) journeyTransportTramImage {
    return [UIImage imageNamed: @"Tram.png"];
}

+(UIImage *) journeyTransportShipImage {
    return [UIImage imageNamed: @"Ship.png"];
}

+(UIImage *) journeyTransportTrainFastImage {
    return [UIImage imageNamed: @"TrainFast.png"];
}

+(UIImage *) journeyTransportCablecarImage {
    return [UIImage imageNamed: @"Cablecar.png"];
}

+(UIImage *) journeyTransportFuniImage {
    return [UIImage imageNamed: @"Funi.png"];
}


// --------------------------------------------

+(UIImage *) stationBoardFastTrainImage {
    return [UIImage imageNamed: @"StbReqFastTrain.png"];
}

+(UIImage *) stationBoardRegioTrainImage {
    return [UIImage imageNamed: @"StbReqRegioTrain.png"];
}

+(UIImage *) stationBoardBusTramImage {
    return [UIImage imageNamed: @"StbReqTramBus.png"];
}

// --------------------------------------------

+(UIImage *) favoriteSearchImage {
    return [UIImage imageNamed: @"Favorite.png"];
}

// --------------------------------------------

+(UIImage *) tableviewArrowImage {
    return [UIImage imageNamed: @"PullArrow.png"];
}

// --------------------------------------------

+(UIImage *) storeFeaturePrintPDF {
    return [UIImage imageNamed: @"PrintPDF.png"];
}

+(UIImage *) storeFeatureNoAdds {
    return [UIImage imageNamed: @"NoAdds.png"];
}

+(UIImage *) cartButtonImage {
    return [UIImage imageNamed: @"Cart.png"];
}

+(UIImage *) storeBackgroundImageiPhone {
    return [UIImage imageNamed: @"StoreBackgroundiPhone.png"];
}

+(UIImage *) storeBackgroundImageiPad {
    return [UIImage imageNamed: @"StoreBackgroundiPad.png"];
}

+(UIImage *) storeButtonImage {
    return [UIImage imageNamed: @"StoreButton.png"];
}

+(UIImage *) calendarViewButtonImage {
    return [UIImage imageNamed: @"CalendarView.png"];
}

+(UIImage *) calendarViewCurrentTimeImage {
    return [UIImage imageNamed: @"MSCurrentTimeIndicator.png"];
}


// --------------------------------------------

// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    // In iOS 5 the image is already correctly rotated. See Eran Sandler's
    // addition here: http://eran.sandler.co.il/2011/11/07/uiimage-in-ios-5-orientation-and-resize/
    
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0 )
    {
        drawTransposed = NO;
    }
    else
    {
        switch ( self.imageOrientation )
        {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                drawTransposed = YES;
                break;
            default:
                drawTransposed = NO;
        }
        
        transform = [self transformForOrientation:newSize];
    }
    
    //CGSize newImageSize = newSize;
    
    CGFloat scaleFactor = [[UIScreen mainScreen] scale];
    
    CGSize newImageSize = CGSizeMake(newSize.width * scaleFactor, newSize.height * scaleFactor);
    
    UIImage *resizedImage = [self resizedImage:newImageSize transform:transform drawTransposed:drawTransposed interpolationQuality:quality];
    
    NSData *imageData = [[NSData alloc] initWithData: UIImagePNGRepresentation(resizedImage)];
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)imageData);
    CGImageRef imageRef = CGImageCreateWithPNGDataProvider(dataProvider, NULL, NO, kCGRenderingIntentDefault);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
    CGDataProviderRelease(dataProvider);
    CGImageRelease(imageRef);
    
    return image;
    //return [self resizedImage:newSize transform:transform drawTransposed:drawTransposed interpolationQuality:quality];
}

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Fix for a colorspace / transparency issue that affects some types of
    // images. See here: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/comment-page-2/#comment-39951
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap =CGBitmapContextCreate( NULL,
                                               newRect.size.width,
                                               newRect.size.height,
                                               8,
                                               0,
                                               colorSpace,
                                               kCGImageAlphaPremultipliedLast );
    CGColorSpaceRelease(colorSpace);
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    return transform;
}


static CGImageRef CreateMask(CGSize size, NSUInteger thickness)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       size.width,
                                                       size.height,
                                                       8,
                                                       size.width * 32,
                                                       colorSpace,
                                                       kCGBitmapByteOrderDefault | kCGImageAlphaNone);
    if (bitmapContext == NULL)
    {
        NSLog(@"create mask bitmap context failed");
		return nil;
    }
    
    // fill the black color in whole size, anything in black area will be transparent.
    CGContextSetFillColorWithColor(bitmapContext, [UIColor blackColor].CGColor);
    CGContextFillRect(bitmapContext, CGRectMake(0, 0, size.width, size.height));
    
    // fill the white color in whole size, anything in white area will keep.
    CGContextSetFillColorWithColor(bitmapContext, [UIColor whiteColor].CGColor);
    CGContextFillRect(bitmapContext, CGRectMake(thickness, thickness, size.width - thickness * 2, size.height - thickness * 2));
    
    // acquire the mask
    CGImageRef maskImageRef = CGBitmapContextCreateImage(bitmapContext);
    
    // clean up
    CGContextRelease(bitmapContext);
    CGColorSpaceRelease(colorSpace);
    
    return maskImageRef;
}

- (UIImage *)imageWithTransparentBorder:(NSUInteger)thickness
{
    size_t newWidth = self.size.width + 2 * thickness;
    size_t newHeight = self.size.height + 2 * thickness;
    
    size_t bitsPerComponent = 8;
    size_t bitsPerPixel = 32;
    size_t bytesPerRow = bitsPerPixel * newWidth;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if(colorSpace == NULL)
    {
		NSLog(@"create color space failed");
		return nil;
	}
    
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       newWidth,
                                                       newHeight,
                                                       bitsPerComponent,
                                                       bytesPerRow,
                                                       colorSpace,
                                                       kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast);
    if (bitmapContext == NULL)
    {
        NSLog(@"create bitmap context failed");
		return nil;
    }
    
    // acquire image with opaque border
    CGRect imageRect = CGRectMake(thickness, thickness, self.size.width, self.size.height);
    CGContextDrawImage(bitmapContext, imageRect, self.CGImage);
    CGImageRef opaqueBorderImageRef = CGBitmapContextCreateImage(bitmapContext);
    
    // acquire image with transparent border
    CGImageRef maskImageRef = CreateMask(CGSizeMake(newWidth, newHeight), thickness);
    CGImageRef transparentBorderImageRef = CGImageCreateWithMask(opaqueBorderImageRef, maskImageRef);
    UIImage *transparentBorderImage = [UIImage imageWithCGImage:transparentBorderImageRef];
    
    // clean up
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(bitmapContext);
    CGImageRelease(opaqueBorderImageRef);
    CGImageRelease(maskImageRef);
    CGImageRelease(transparentBorderImageRef);
    
    return transparentBorderImage;
}

- (UIImage *)imageWithTransparentLeftRight:(NSUInteger)thickness
{
    size_t newWidth = self.size.width + 2 * thickness;
    size_t newHeight = self.size.height;
    
    size_t bitsPerComponent = 8;
    size_t bitsPerPixel = 32;
    size_t bytesPerRow = bitsPerPixel * newWidth;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if(colorSpace == NULL)
    {
		NSLog(@"create color space failed");
		return nil;
	}
    
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       newWidth,
                                                       newHeight,
                                                       bitsPerComponent,
                                                       bytesPerRow,
                                                       colorSpace,
                                                       kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast);
    if (bitmapContext == NULL)
    {
        NSLog(@"create bitmap context failed");
		return nil;
    }
    
    // acquire image with opaque border
    CGRect imageRect = CGRectMake(thickness, thickness, self.size.width, self.size.height);
    CGContextDrawImage(bitmapContext, imageRect, self.CGImage);
    CGImageRef opaqueBorderImageRef = CGBitmapContextCreateImage(bitmapContext);
    
    // acquire image with transparent border
    CGImageRef maskImageRef = CreateMask(CGSizeMake(newWidth, newHeight), thickness);
    CGImageRef transparentBorderImageRef = CGImageCreateWithMask(opaqueBorderImageRef, maskImageRef);
    UIImage *transparentBorderImage = [UIImage imageWithCGImage:transparentBorderImageRef];
    
    // clean up
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(bitmapContext);
    CGImageRelease(opaqueBorderImageRef);
    CGImageRelease(maskImageRef);
    CGImageRelease(transparentBorderImageRef);
    
    return transparentBorderImage;
}

- (UIImage *)transparentBorderLeftRightImage:(NSUInteger)thickness
{
    float scaleFactor = [[UIScreen mainScreen] scale];
    CGSize size = CGSizeMake(self.size.width, self.size.height);
    
    //NSLog(@"Current image size: %.1f, %.1f", size.width, size.height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       (size.width + thickness * 2) * scaleFactor, size.height * scaleFactor,
                                                       8, (size.width + thickness * 2) * scaleFactor * 4, colorSpace,
                                                       kCGImageAlphaPremultipliedFirst);
    CGContextScaleCTM(bitmapContext, scaleFactor, scaleFactor);
    
    CGContextDrawImage(bitmapContext, CGRectMake(thickness, 0, size.width, size.height), self.CGImage);
    
    CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    
    UIImage *result = [UIImage imageWithCGImage: mainViewContentBitmapContext scale: scaleFactor orientation: UIImageOrientationUp];
    
    //NSLog(@"New image size: %.1f, %.1f", result.size.width, result.size.height);
    
    return result;
    /*
    CGSize size = self.size;
    UIGraphicsBeginImageContext(CGSizeMake(size.width + thickness * 2, size.height));
    [self drawInRect:CGRectMake(thickness, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    */
}

// iPad Tabbar coloring

- (UIImage *)grayTabBarItemFilter {
    
    float scaleFactor = [[UIScreen mainScreen] scale];
    CGSize size = CGSizeMake(self.size.width, self.size.height);

    UIImage *result = self;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) {
        return result;
    }
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                       size.width * scaleFactor, size.height * scaleFactor,
                                                       8, size.width * scaleFactor * 4, colorSpace,
                                                       kCGImageAlphaPremultipliedFirst);
    CGContextScaleCTM(context, scaleFactor, scaleFactor);
    
    
    //CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast);
    //if (context == NULL) {
    //    CGColorSpaceRelease(colorSpace);
    //    return result;
    //}
    
    CGFloat colors[8] = {80/255.0,80/255.0,80/255.0,1, 175/255.0,175/255.0,175/255.0,1};
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0,-(32-size.height)/2.0), CGPointMake(0,size.height+(32-size.height)/2.0), 0);
    CGGradientRelease(gradient);
    CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
    CGContextDrawImage(context, CGRectMake(0,0,size.width,size.height), self.CGImage);
    CGImageRef newImage = CGBitmapContextCreateImage(context);
    if (newImage != NULL) {
        result = [UIImage imageWithCGImage:newImage];
        CGImageRelease(newImage);
    }
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return result;
}

struct RGBA {
    unsigned char red;
    unsigned char green;
    unsigned char blue;
    unsigned char alpha;
};

#define BLUE_ALPHA_THRESHOLD 128
#define BLUE_BRIGHTNESS_ADJUST 30

- (UIImage *)blueTabBarItemFilter {
    float scaleFactor = [[UIScreen mainScreen] scale];
    CGSize size = CGSizeMake(self.size.width, self.size.height);
    
    UIImage *result = self;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) {
        return result;
    }
    
    /*
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast);
    if (context == NULL) {
        CGColorSpaceRelease(colorSpace);
        return result;
    }
    */
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 size.width * scaleFactor, size.height * scaleFactor,
                                                 8, size.width * scaleFactor * 4, colorSpace,
                                                 kCGImageAlphaPremultipliedFirst);
    CGContextScaleCTM(context, scaleFactor, scaleFactor);
    
    
    UIImage *gradient = [UIImage imageNamed:@"selection_gradient.png"];
    CGContextDrawImage(context, CGRectMake(-(gradient.size.width - size.width) / 2.0, -(gradient.size.height - size.height) / 2.0, gradient.size.width, gradient.size.height), gradient.CGImage);
    CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
    CGContextDrawImage(context, CGRectMake(0,0,size.width,size.height), self.CGImage);
    struct RGBA *pixels = CGBitmapContextGetData(context);
    if (pixels != NULL) {
        for (int y = 0; y < size.height; y++) {
            for (int x = 0; x < size.width; x++) {
                int offset = x+y*size.width;
                if (pixels[offset].alpha >= BLUE_ALPHA_THRESHOLD &&
                    ((x == 0 || x == size.width-1 || y == 0 || y == size.height-1) ||
                     (pixels[x+(y-1)*(int)size.width].alpha < BLUE_ALPHA_THRESHOLD) ||
                     (pixels[x+1+y*(int)size.width].alpha < BLUE_ALPHA_THRESHOLD) ||
                     (pixels[x+(y+1)*(int)size.width].alpha < BLUE_ALPHA_THRESHOLD) ||
                     (pixels[x-1+y*(int)size.width].alpha < BLUE_ALPHA_THRESHOLD))) {
                        pixels[offset].red = MIN(pixels[offset].red + BLUE_BRIGHTNESS_ADJUST,255);
                        pixels[offset].green = MIN(pixels[offset].green + BLUE_BRIGHTNESS_ADJUST,255);
                        pixels[offset].blue = MIN(pixels[offset].blue + BLUE_BRIGHTNESS_ADJUST,255);
                    }
            }
        }
        CGImageRef image = CGBitmapContextCreateImage(context);
        if (image != NULL) {
            result = [UIImage imageWithCGImage:image];
            CGImageRelease(image);
        }
    }
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return result;
}

/*
UIImage *grayTabBarItemFilter(UIImage *image) {
    UITabBar* bar = [[UITabBar alloc] init];
    UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"" image:image tag:0];
    [bar setItems:@[item]];
    [[[[UIApplication sharedApplication] windows] lastObject] addSubview:bar];
    UIImage* returnImage;
    for(UIView* view in bar.subviews) {
        for(UIView* small in view.subviews) {
            if([small respondsToSelector:@selector(image)]) {
                returnImage = [(UIImageView*)small image];
            }
        }
    }
    
    [bar removeFromSuperview];
    
    return returnImage ? returnImage : image;
}

UIImage *blueTabBarItemFilter(UIImage *image) {
    UITabBar* bar = [[UITabBar alloc] init];
    UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"" image:image tag:0];
    [bar setItems:@[item]];
    [bar setSelectedItem:item];
    [[[[UIApplication sharedApplication] windows] lastObject] addSubview:bar];
    UIImage* returnImage;
    for(UIView* view in bar.subviews) {
        NSInteger count = 0;
        for(UIView* small in view.subviews) {
            if([small respondsToSelector:@selector(image)]) {
                count++;
                if(count > 1) {
                    returnImage = [(UIImageView*)small image];
                }
            }
        }
    }
    
    [bar removeFromSuperview];
    
    return returnImage ? returnImage : image;
}
*/

@end
