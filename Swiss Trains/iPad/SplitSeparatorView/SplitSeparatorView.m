//
//  SplitSeparatorView.m
//  Swiss Trains
//
//  Created by Alain on 02.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "SplitSeparatorView.h"

@implementation SplitSeparatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)drawRect:(CGRect)rect {
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* strokeColor = [UIColor colorWithRed: 0.333 green: 0.333 blue: 0.333 alpha: 1];
    UIColor* color = [UIColor colorWithRed: 0.667 green: 0.667 blue: 0.667 alpha: 1];
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)strokeColor.CGColor,
                               (id)color.CGColor, nil];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    //// Abstracted Attributes
    CGRect rectangleRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: rectangleRect];
    CGContextSaveGState(context);
    [rectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(rect.origin.x, rect.size.height / 2), CGPointMake(rect.origin.x + rect.size.width, rect.size.height / 2), 0);
    CGContextRestoreGState(context);
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    /*
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    static CGFloat const kArcThickness = 2.0f;
    //static CGFloat const kArcThickness = 20.0f;
    CGRect arcBounds = CGRectInset(self.bounds, 10.0f, 10.0f);
    CGPoint arcCenter = CGPointMake(CGRectGetMidX(arcBounds), CGRectGetMidY(arcBounds));
    CGFloat arcRadius = 0.5f * (MIN(arcBounds.size.width, arcBounds.size.height) - kArcThickness);
    
    //UIBezierPath *arc = [UIBezierPath bezierPathWithRect: rect];
    UIBezierPath *arc = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:arcRadius startAngle:-M_PI / 3.0 endAngle:-2.0 * M_PI / 3.0 clockwise:NO];
    
    CGPathRef shape = CGPathCreateCopyByStrokingPath(arc.CGPath, NULL, kArcThickness, kCGLineCapSquare, kCGLineJoinBevel, 10.0f);
    //CGPathRef shape = CGPathCreateCopyByStrokingPath(arc.CGPath, NULL, kArcThickness, kCGLineCapRound, kCGLineJoinRound, 10.0f);
    //CGMutablePathRef shapeInverse = shape;
    CGMutablePathRef shapeInverse = CGPathCreateMutableCopy(shape);
    CGPathAddRect(shapeInverse, NULL, CGRectInfinite);
    
    CGContextBeginPath(gc);
    CGContextAddPath(gc, shape);
    CGContextSetFillColorWithColor(gc, [UIColor colorWithWhite:.9 alpha:1].CGColor);
    CGContextFillPath(gc);
    
    CGContextSaveGState(gc); {
        CGContextBeginPath(gc);
        CGContextAddPath(gc, shape);
        CGContextClip(gc);
        CGContextSetShadowWithColor(gc, CGSizeZero, 7, [UIColor colorWithWhite:0 alpha:.25].CGColor);
        CGContextBeginPath(gc);
        CGContextAddPath(gc, shapeInverse);
        CGContextFillPath(gc);
    } CGContextRestoreGState(gc);
    
    CGContextSetStrokeColorWithColor(gc, [UIColor colorWithWhite:.75 alpha:1].CGColor);
    CGContextSetLineWidth(gc, 1);
    CGContextSetLineJoin(gc, kCGLineCapRound);
    CGContextBeginPath(gc);
    CGContextAddPath(gc, shape);
    CGContextStrokePath(gc);
    
    CGPathRelease(shape);
    CGPathRelease(shapeInverse);
     */
}

@end
