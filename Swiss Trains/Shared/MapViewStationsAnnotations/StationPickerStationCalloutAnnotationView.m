//
//  StationPickerStationAnnotationView.m
//  Swiss Trains
//
//  Created by Alain on 15.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "StationPickerStationCalloutAnnotationView.h"

@implementation StationPickerCalloutStationAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGSize)contentSize {
    return CGSizeMake(320, 80.0);
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame = [self frame];
        [self setFrame:frame];
        
        [self setCenterOffset:CGPointMake(0.0, -7.0)];
        UIImage *annotationImage = [self renderAnnotationImageForAnnotation];
        NSData *imageData = [[NSData alloc] initWithData: UIImagePNGRepresentation(annotationImage)];
        CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)imageData);
        CGImageRef imageRef = CGImageCreateWithPNGDataProvider(dataProvider, NULL, NO, kCGRenderingIntentDefault);
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
        CGDataProviderRelease(dataProvider);
        CGImageRelease(imageRef);
        [self setImage:image];
        //[self setNeedsDisplay];
    }
    return self;
}

- (UIImage *) renderAnnotationImageForAnnotation {
    
    float scaleFactor = [[UIScreen mainScreen] scale];
    
    CGSize imageSize = CGSizeMake(20, 20);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             imageSize.width * scaleFactor, imageSize.height * scaleFactor,
                                             8, imageSize.width * scaleFactor * 4, colorSpace,
                                             kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    CGContextScaleCTM(ctx, scaleFactor, scaleFactor);
    
    //CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIColor *circleColor = [UIColor darkGrayColor];
    
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
