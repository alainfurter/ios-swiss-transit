//
//  StatusToolbariPad.m
//  Swiss Trains
//
//  Created by Alain on 02.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "StatusToolbariPad.h"

@implementation StatusToolbariPad

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect frame = self.frame;
        frame.size.height = 36;
        self.frame = frame;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.layer.backgroundColor = UIColor.clearColor.CGColor;
        self.backgroundColor = [UIColor colorWithPatternImage: [self greyGradientPatternImage]];
        
        self.clipsToBounds = NO;
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.layer.shadowOpacity = 1.0f;
        self.layer.shadowRadius = 2.5f;
        
        CGRect shadowRect = CGRectMake(0, 0, 1024, self.frame.size.height);
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowRect].CGPath;
    }
    return self;
}

- (UIImage *)greyGradientPatternImage {
    
    //CGSize segmentedControlSize = self.frame.size;
    CGSize segmentedControlSize = CGSizeMake(1024, 36);
    
    CGGradientRef glossGradient;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //size_t num_locations = 2;
    //CGFloat locations[2] = { 0.0, 1.0 };
    //CGFloat components[8] = { 1.0, 1.0, 1.0, 0.35,  // Start color
    //    1.0, 1.0, 1.0, 0.06 }; // End color
    //CGFloat components[8] = { 82/255, 83/255, 84/255, 0.45,  // Start color
    //    34/255, 35/255, 37/255, 1.0 }; // End color
    //glossGradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, num_locations);
    
    UIColor *startColor = [UIColor requestSegmentedControlTopGradientColor];
    UIColor *endColor = [UIColor requestSegmentedControlBottomGradientColor];
    
    CGFloat locations[2] = { 0.0, 1.0 };
    NSArray *colors = [NSArray arrayWithObjects:(id)startColor.CGColor, (id)endColor.CGColor, nil];
    glossGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    
    CGRect currentBounds = self.frame;
    //CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    //CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
    
    CGPoint topCenter = CGPointMake(0, CGRectGetMaxY(currentBounds));
    CGPoint midCenter = CGPointMake(0, CGRectGetMidY(currentBounds));
    
    
    //CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, midCenter, 0);
    
    float scaleFactor = [[UIScreen mainScreen] scale];
    
    //CGContextRef bitmapContext = CGBitmapContextCreate(NULL, 320, 480, 8, 4 * 320, colorSpace, kCGImageAlphaNoneSkipFirst);
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, segmentedControlSize.width * scaleFactor, segmentedControlSize.height * scaleFactor, 8, segmentedControlSize.width * scaleFactor * 4, colorSpace, kCGImageAlphaNoneSkipFirst);
    CGContextScaleCTM(bitmapContext, scaleFactor, scaleFactor);
    
    //CGContextDrawLinearGradient(bitmapContext, glossGradient, CGPointMake(0.0f, 0.0f), CGPointMake(320.0f, 480.0f), 0);
    CGContextDrawLinearGradient(bitmapContext, glossGradient, topCenter, midCenter, 0);
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGContextRelease(bitmapContext);
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(glossGradient);
    return uiImage;
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
