//
//  StationsAnnotationView.m
//  Swiss Trains
//
//  Created by Alain on 14.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "StationsAnnotationView.h"

@implementation StationsAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        //UIImage *blipImage = [UIImage imageNamed:@"blip.png"];
        CGRect frame = [self frame];
        //frame.size = [blipImage size];
        [self setFrame:frame];
        [self setCenterOffset:CGPointMake(0.0, 0.0)];
        //[self setImage:blipImage];
    }
    return self;
}

- (UIImage *) renderAnnotationImageForAnnotationType:(NSUInteger)annotationType {
    
    float scaleFactor = [[UIScreen mainScreen] scale];
    
    CGSize imageSizeFromStart = CGSizeMake(20, 20);
    CGSize imageSizeMiddle = CGSizeMake(10, 10);
    CGSize imageSize;
    
    if (annotationType == middleStation) {
        imageSize = imageSizeMiddle;
    } else {
        imageSize = imageSizeFromStart;
    }
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             imageSize.width * scaleFactor, imageSize.height * scaleFactor,
                                             8, imageSize.width * scaleFactor * 4, colorSpace,
                                             kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    CGContextScaleCTM(ctx, scaleFactor, scaleFactor);
    
    //CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIColor *circleColor;
    if (annotationType == startStation) {
        circleColor = [UIColor redColor];
    } else if (annotationType == middleStation) {
        circleColor = [UIColor darkGrayColor];
    } else if (annotationType == endStation) {
        circleColor = [UIColor greenColor];
    }

    CGContextSaveGState(ctx);
    UIGraphicsPushContext(ctx);
    
    CGRect outerTopCircle = {0, 0, imageSize.width, imageSize.height};
    CGRect outerTopMaskCircle  = CGRectInset(outerTopCircle, 2, 2);
    CGRect innerTopCircle = CGRectInset(outerTopCircle, 3, 3);
    
    UIBezierPath *outerTopCirclePath = [UIBezierPath bezierPathWithOvalInRect: outerTopCircle];
    
    [outerTopCirclePath appendPath:[UIBezierPath bezierPathWithOvalInRect: outerTopMaskCircle]];
    outerTopCirclePath.usesEvenOddFillRule = YES;
    
    [circleColor set];
    [outerTopCirclePath fill];
    
    UIBezierPath *innerTopCirclePath = [UIBezierPath bezierPathWithOvalInRect: innerTopCircle];
    [[UIColor blackColor] set];
    [innerTopCirclePath fill];
    
    UIGraphicsPopContext();
    
    CGContextRestoreGState(ctx);
    
    //UIGraphicsEndImageContext();
    
    CGImageRef image = CGBitmapContextCreateImage(ctx);
    
    CGContextRelease(ctx);
    
    UIImage *retImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
	return retImage;
}

- (void) setAnnotationImageForType:(NSUInteger)annotationType {
    UIImage *annotationImage = [self renderAnnotationImageForAnnotationType: annotationType];
    //CGRect frame = [self frame];
    //CGSize viewSize = CGSizeMake(annotationImage.size.width / 2, annotationImage.size.height / 2);
    //frame.size = viewSize;
    
    NSData *imageData = [[NSData alloc] initWithData: UIImagePNGRepresentation(annotationImage)];
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)imageData);
    CGImageRef imageRef = CGImageCreateWithPNGDataProvider(dataProvider, NULL, NO, kCGRenderingIntentDefault);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
    CGDataProviderRelease(dataProvider);
    CGImageRelease(imageRef);
    
    //[self setFrame:frame];
    //[self setCenterOffset:CGPointMake(0.0, -7.0)];
    [self setImage:image];
    [self setNeedsDisplay];
}

- (UIImage *) renderAnnotationImageForAnnotationType:(NSUInteger)annotationType withscale:(double)scale {
    
    float scaleFactor = [[UIScreen mainScreen] scale];
    
    CGSize imageSizeFromStart = CGSizeMake(20 * scale, 20 * scale);
    CGSize imageSizeMiddle = CGSizeMake(10 * scale, 10 * scale);
    CGSize imageSize;
    
    if (annotationType == middleStation) {
        imageSize = imageSizeMiddle;
    } else {
        imageSize = imageSizeFromStart;
    }
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             imageSize.width * scaleFactor, imageSize.height * scaleFactor,
                                             8, imageSize.width * scaleFactor * 4, colorSpace,
                                             kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    CGContextScaleCTM(ctx, scaleFactor, scaleFactor);
    
    //CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIColor *circleColor;
    if (annotationType == startStation) {
        circleColor = [UIColor redColor];
    } else if (annotationType == middleStation) {
        circleColor = [UIColor darkGrayColor];
    } else if (annotationType == endStation) {
        circleColor = [UIColor greenColor];
    }
    
    CGContextSaveGState(ctx);
    UIGraphicsPushContext(ctx);
    
    CGRect outerTopCircle = {0, 0, imageSize.width, imageSize.height};
    CGRect outerTopMaskCircle  = CGRectInset(outerTopCircle, 2, 2);
    CGRect innerTopCircle = CGRectInset(outerTopCircle, 3, 3);
    
    UIBezierPath *outerTopCirclePath = [UIBezierPath bezierPathWithOvalInRect: outerTopCircle];
    
    [outerTopCirclePath appendPath:[UIBezierPath bezierPathWithOvalInRect: outerTopMaskCircle]];
    outerTopCirclePath.usesEvenOddFillRule = YES;
    
    [circleColor set];
    [outerTopCirclePath fill];
    
    UIBezierPath *innerTopCirclePath = [UIBezierPath bezierPathWithOvalInRect: innerTopCircle];
    [[UIColor blackColor] set];
    [innerTopCirclePath fill];
    
    UIGraphicsPopContext();
    
    CGContextRestoreGState(ctx);
    
    //UIGraphicsEndImageContext();
    
    CGImageRef image = CGBitmapContextCreateImage(ctx);
    
    CGContextRelease(ctx);
    
    UIImage *retImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
	return retImage;
}

- (void) setAnnotationImageForType:(NSUInteger)annotationType withscale:(double)scale {
    UIImage *annotationImage = [self renderAnnotationImageForAnnotationType: annotationType];
    //CGRect frame = [self frame];
    //CGSize viewSize = CGSizeMake(annotationImage.size.width / 2, annotationImage.size.height / 2);
    //frame.size = viewSize;
    
    NSData *imageData = [[NSData alloc] initWithData: UIImagePNGRepresentation(annotationImage)];
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)imageData);
    CGImageRef imageRef = CGImageCreateWithPNGDataProvider(dataProvider, NULL, NO, kCGRenderingIntentDefault);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
    CGDataProviderRelease(dataProvider);
    CGImageRelease(imageRef);
    
    //[self setFrame:frame];
    //[self setCenterOffset:CGPointMake(0.0, -7.0)];
    [self setImage:image];
    [self setNeedsDisplay];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
