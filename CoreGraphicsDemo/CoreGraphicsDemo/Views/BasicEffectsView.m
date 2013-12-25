//
//  BasicEffectsView.m
//  CoreGraphicsDemo
//
//  Created by leihui on 13-12-23.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "BasicEffectsView.h"

@implementation BasicEffectsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
#if 0
    // Fill color
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat color[4] = {1.0, 0.5, 0.0, 1.0};
    CGContextSetFillColor(context, color);
    CGContextFillRect(context, rect);
#endif
    
#if 0
    // Draw image
    UIImage *image = [UIImage imageNamed:@"image.png"];
	CGRect centeredImageRect = CGRectMake((CGRectGetWidth(rect)/2.0f)-(image.size.width/2.0f), (CGRectGetHeight(rect)/2.0f)-(image.size.height/2.0f), image.size.width, image.size.height);
	[image drawInRect:centeredImageRect];
#endif
    
#if 0
    // Gradient linear
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat colors[8] = {
        33.0f/255.0f, 102.0f/255.0f, 133.0f/255.0f, 1.0f,   // Dark Blue Color
        138.0f/255.0f, 206.0f/255.0f, 236.0f/255.0f, 1.0f   // Light Blue Color
    };
    
    CGFloat locations[2] = {0.0f, 1.0f};
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 2);
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0f, 0.0f), CGPointMake(0.0f, CGRectGetHeight(rect)),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
#endif
    
#if 0
    // Gradient radial
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *blue = [UIColor colorWithRed:0.14f green:0.57f blue:1.0f alpha:1.0f];
	UIColor *darkBlue = [UIColor colorWithRed:0.084f green:0.342f blue:0.6f alpha:1.0f];
    
	NSArray *gradientColors = [NSArray arrayWithObjects:(id)blue.CGColor, (id)darkBlue.CGColor, nil];
	
	CGFloat gradientLocations[] = {0.0f, 1.0f};
	
	// Note: ARC does not support toll-free-bridging, thus we need to do it manually.
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
	
	CGContextDrawRadialGradient(context, gradient,
								CGPointMake(CGRectGetWidth(rect)/2.0f, CGRectGetHeight(rect)/2.0f),		// Start Center Point
								50.0f,																	// Start Center Radius
								CGPointMake(CGRectGetWidth(rect)/2.0f, CGRectGetHeight(rect)/2.0f),		// End Center Point
								160.0f,																	// End Center Radius
								kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	
    CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);
#endif
    
#if 0
    // Path
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGMutablePathRef triangePath = CGPathCreateMutable();
	
	CGFloat yellowColor[4] = {1.0f, 1.0f, 0.0f, 1.0f};
    
	CGPathMoveToPoint(triangePath, NULL, CGRectGetWidth(rect)/2.0f, CGRectGetHeight(rect)*0.2f);
	CGPathAddLineToPoint(triangePath, NULL, CGRectGetWidth(rect)/4.0f, CGRectGetHeight(rect)*0.7f);
	CGPathAddLineToPoint(triangePath, NULL, CGRectGetWidth(rect)*3.0f/4.0f, CGRectGetHeight(rect)*0.7f);
	
	CGContextAddPath(context, triangePath);
	
	CGContextClosePath(context);
	
	CGContextSetLineWidth(context, 5.0f);
	CGContextSetStrokeColor(context, yellowColor);
	CGContextSetShadow(context, CGSizeMake(3.0f, 3.0f), 4.0f);
	
	CGContextStrokePath(context);
	
	CGPathRelease(triangePath);
#endif
    
#if 0
    // Bezier
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat yellowColor[4] = {1.0f, 1.0f, 0.0f, 1.0f};
	
	UIBezierPath *bezierPath = [UIBezierPath bezierPath];
	
	[bezierPath moveToPoint: CGPointMake(CGRectGetWidth(rect)*0.22f, (CGRectGetHeight(rect)/2.0f)+120.0f)];
	
	[bezierPath addCurveToPoint:CGPointMake((CGRectGetWidth(rect)*0.22f)+171.0f, (CGRectGetHeight(rect)/2.0f)-84.0f) controlPoint1:CGPointMake(CGRectGetWidth(rect)*0.22f, (CGRectGetHeight(rect)/2.0f)+120.0f) controlPoint2:CGPointMake((CGRectGetWidth(rect)*0.22f)+109.0f, (CGRectGetHeight(rect)/2.0f)-92.0f)];
    
	[bezierPath addCurveToPoint:CGPointMake((CGRectGetWidth(rect)*0.22f)+420.0f, (CGRectGetHeight(rect)/2.0f)-90.0f) controlPoint1:CGPointMake((CGRectGetWidth(rect)*0.22f)+233.0f, (CGRectGetHeight(rect)/2.0f)-75.0f) controlPoint2:CGPointMake((CGRectGetWidth(rect)*0.22f)+375.0f, (CGRectGetHeight(rect)/2.0f)+5.0f)];
    
	CGContextAddPath(context, bezierPath.CGPath);
	
	CGContextSetStrokeColor(context, yellowColor);
	CGContextSetLineWidth(context, 5.0f);
	
	CGContextStrokePath(context);
#endif
    
#if 0
    // Clipping
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIImage *image = [UIImage imageNamed:@"image.png"];
	
	CGRect centeredImageRect = CGRectMake((CGRectGetWidth(rect)/2.0f)-(image.size.width/2.0f), (CGRectGetHeight(rect)/2.0f)-(image.size.height/2.0f), image.size.width, image.size.height);
	
	UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:centeredImageRect cornerRadius:20.0f];
	
	CGContextAddPath(context, clipPath.CGPath);
	CGContextClip(context);
	
	[image drawInRect:centeredImageRect];
#endif
    
#if 0
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIImage *image = [UIImage imageNamed:@"image.png"];
	
	CGRect centeredImageRect = CGRectMake((CGRectGetWidth(rect)/2.0f)-(image.size.width/2.0f), (CGRectGetHeight(rect)/2.0f)-(image.size.height/2.0f), image.size.width, image.size.height);
	
	UIBezierPath *outterBoundsClipping = [UIBezierPath bezierPathWithRoundedRect:centeredImageRect cornerRadius:20.0f];
	
	CGRect innerRect = CGRectInset(centeredImageRect, 30.0f, 30.0f);
	
	UIBezierPath *innerBoundsClipping = [UIBezierPath bezierPathWithRoundedRect:innerRect cornerRadius:11.0f];
    
	CGContextSaveGState(context);
	
	CGContextAddPath(context, outterBoundsClipping.CGPath);
	CGContextAddPath(context, innerBoundsClipping.CGPath);
	
	CGContextEOClip(context);
	
	[image drawInRect:centeredImageRect];
	
	CGContextRestoreGState(context);
#endif
}

@end
