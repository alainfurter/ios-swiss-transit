//
//  ControlsBackgroundView.m
//  Swiss Trains
//
//  Created by Alain on 03.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "ControlsBackgroundView.h"

@implementation ControlsBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
    }
    return self;
}

- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGRect insectedRect = CGRectInset(rect, 10, 10);
    
    //// Color Declarations
    //UIColor* color = [UIColor colorWithRed: 0.73 green: 0.73 blue: 0.73 alpha: 1];
    //UIColor* color2 = [UIColor colorWithRed: 0.969 green: 0.969 blue: 0.969 alpha: 1];
    
    //UIColor* color3 = [UIColor colorWithRed: 0.632 green: 0.632 blue: 0.632 alpha: 1];
    //UIColor* color4 = [UIColor colorWithRed: 0.943 green: 0.959 blue: 0.966 alpha: 1];
    
    //// Color Declarations
    //UIColor* color5 = [UIColor colorWithRed: 0.771 green: 0.771 blue: 0.771 alpha: 1];
    //UIColor* color6 = [UIColor colorWithRed: 0.925 green: 0.925 blue: 0.925 alpha: 1];
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color5 = [UIColor colorWithRed: 0.771 green: 0.771 blue: 0.771 alpha: 1];
    UIColor* gradientbottomcolor = [UIColor colorWithRed: 0.95 green: 0.95 blue: 0.95 alpha: 1];
    UIColor* gradienttopcolor = [UIColor colorWithRed: 0.988 green: 0.988 blue: 0.988 alpha: 1];;
    
    //// Gradient Declarations
    NSArray* gradient2Colors = [NSArray arrayWithObjects:
                                (id)gradienttopcolor.CGColor,
                                (id)gradientbottomcolor.CGColor, nil];
    CGFloat gradient2Locations[] = {0, 1};
    CGGradientRef gradient2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradient2Colors, gradient2Locations);
    
    //// Shadow Declarations
    UIColor* shadow = [UIColor whiteColor];
    CGSize shadowOffset = CGSizeMake(0.1, 1.1);
    CGFloat shadowBlurRadius = 5;
    UIColor* shadow2 = [UIColor whiteColor];
    CGSize shadow2Offset = CGSizeMake(0.1, 1.1);
    CGFloat shadow2BlurRadius = 3;
    
    //// Abstracted Attributes
    CGRect roundedRectangleRect = insectedRect;
    CGFloat roundedRectangleStrokeWidth = 1;
    CGFloat roundedRectangleCornerRadius = 8;
    
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: roundedRectangleRect cornerRadius: roundedRectangleCornerRadius];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    CGContextBeginTransparencyLayer(context, NULL);
    [roundedRectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient2, CGPointMake(CGRectGetMidX(insectedRect), 0), CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect)), 0);
    CGContextEndTransparencyLayer(context);
    
    ////// Rounded Rectangle Inner Shadow
    CGRect roundedRectangleBorderRect = CGRectInset([roundedRectanglePath bounds], -shadow2BlurRadius, -shadow2BlurRadius);
    roundedRectangleBorderRect = CGRectOffset(roundedRectangleBorderRect, -shadow2Offset.width, -shadow2Offset.height);
    roundedRectangleBorderRect = CGRectInset(CGRectUnion(roundedRectangleBorderRect, [roundedRectanglePath bounds]), -1, -1);
    
    UIBezierPath* roundedRectangleNegativePath = [UIBezierPath bezierPathWithRect: roundedRectangleBorderRect];
    [roundedRectangleNegativePath appendPath: roundedRectanglePath];
    roundedRectangleNegativePath.usesEvenOddFillRule = YES;
    
    CGContextSaveGState(context);
    {
        CGFloat xOffset = shadow2Offset.width + round(roundedRectangleBorderRect.size.width);
        CGFloat yOffset = shadow2Offset.height;
        CGContextSetShadowWithColor(context,
                                    CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                    shadow2BlurRadius,
                                    shadow2.CGColor);
        
        [roundedRectanglePath addClip];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(roundedRectangleBorderRect.size.width), 0);
        [roundedRectangleNegativePath applyTransform: transform];
        [[UIColor grayColor] setFill];
        [roundedRectangleNegativePath fill];
    }
    CGContextRestoreGState(context);
    
    CGContextRestoreGState(context);
    
    [color5 setStroke];
    roundedRectanglePath.lineWidth = roundedRectangleStrokeWidth;
    [roundedRectanglePath stroke];
    
    
    //// Cleanup
    CGGradientRelease(gradient2);
    CGColorSpaceRelease(colorSpace);
    
}

@end
