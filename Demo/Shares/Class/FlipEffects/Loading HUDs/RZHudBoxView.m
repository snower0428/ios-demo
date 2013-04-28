//
//  RZHudBoxView.m
//  Rue La La
//
//  Created by Nick Donaldson on 6/12/12.
//  Copyright (c) 2012 Raizlabs Corporation. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "RZHudBoxView.h"

#define kDefaultWidth       140
#define kDefaultHeight      110

#define kMinDimensionIpad   22

#define kOuterPadding       15
#define kElementPadding     10

#define kLayoutAnimationTime 0.2

@interface RZHudBoxView ()

@property (nonatomic, strong) UIActivityIndicatorView *activitySpinner;
@property (nonatomic, strong) UILabel *messageLabel;

- (UIBezierPath*)boxMaskPathForRect:(CGRect)rect;
- (void)updateLayoutAnimated:(BOOL)animated;
- (void)animateBoxShadowToRect:(CGRect)rect duration:(NSTimeInterval)duration;

@end

@implementation RZHudBoxView

@synthesize customView = _customView;
@synthesize style = _style;
@synthesize color = _color;
@synthesize cornerRadius = _cornerRadius;
@synthesize shadowAlpha = _shadowAlpha;
@synthesize borderColor = _borderColor;
@synthesize borderWidth = _borderWidth;

@synthesize labelText = _labelText;

@synthesize activitySpinner = _activitySpinner;
@synthesize messageLabel = _messageLabel;

- (id)initWithStyle:(RZHudBoxStyle)style color:(UIColor*)color cornerRadius:(CGFloat)cornerRadius;
{
    if (self = [super initWithFrame:CGRectMake(0, 0, kDefaultWidth, kDefaultHeight)])
    {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        self.opaque = NO;
        
        self.style = style;
        self.color = color;
        self.cornerRadius = cornerRadius;
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.messageLabel.adjustsFontSizeToFitWidth = NO;
        self.messageLabel.lineBreakMode = UILineBreakModeTailTruncation;
        self.messageLabel.textAlignment = style == RZHudBoxStyleInfo ? UITextAlignmentLeft : UITextAlignmentCenter;
        self.messageLabel.font = [UIFont systemFontOfSize:18];
        self.messageLabel.shadowColor = [UIColor clearColor];
        
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 3.0;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowOpacity = 0.2;
    }
    return self;
}

- (void)layoutSubviews
{
    [self updateLayoutAnimated:NO];
    // update shadow path
}

- (void)updateLayoutAnimated:(BOOL)animated
{
    CGSize labelSize = CGSizeZero;
    if (self.labelText.length){
        CGFloat maxWidth = self.superview ? self.superview.bounds.size.width - 4*kOuterPadding : CGFLOAT_MAX;
        labelSize = [self.labelText sizeWithFont:self.labelFont constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX)];
    }
    
    CGFloat newWidth = MAX(labelSize.width + 2*kOuterPadding, kMinDimensionIpad);
    if (self.customView){
        newWidth += self.customView.bounds.size.width + kElementPadding;
    }
    
    CGFloat newHeight = MAX(self.customView.bounds.size.height, labelSize.height + self.activitySpinner.bounds.size.height + kElementPadding);
    newHeight = MAX(newHeight + 2*kOuterPadding, kMinDimensionIpad);
    
    CGRect oldFrame = self.frame;
    CGRect newFrame = self.frame;
    newFrame.size.width = newWidth;
    newFrame.size.height = newHeight;
    newFrame.origin.x += (oldFrame.size.width - newWidth)/2.0;
    newFrame.origin.y += (oldFrame.size.height - newHeight)/2.0;
    
    CGRect customViewFrame = CGRectZero;
    if (self.customView){
        CGFloat originY = (newFrame.size.height - self.customView.bounds.size.height)/2;
        customViewFrame = CGRectMake(kOuterPadding, originY, self.customView.bounds.size.width, self.customView.bounds.size.height);
    }
    
    CGRect newMessageFrame = (CGRect){CGPointZero, labelSize};
    newMessageFrame.origin.x = self.customView ? CGRectGetMaxX(self.customView.frame) + kElementPadding : kOuterPadding;
    newMessageFrame.origin.y = self.activitySpinner ? newFrame.size.height - kOuterPadding - labelSize.height : (newFrame.size.height - newMessageFrame.size.height)/2;
    
    CGPoint activityCenter = CGPointZero;
    if (self.activitySpinner){
        if (self.labelText.length){
            activityCenter = CGPointMake(newMessageFrame.origin.x + newMessageFrame.size.width/2, newMessageFrame.origin.y - kElementPadding - self.activitySpinner.bounds.size.height/2);
        }
        else{
            activityCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2);
        }
    }
    
    if (animated){
        [UIView animateWithDuration:kLayoutAnimationTime
                         animations:^{
                             self.frame = newFrame;
                             self.customView.frame = customViewFrame;
                             self.messageLabel.frame = newMessageFrame;
                             self.activitySpinner.center = activityCenter;
                         }];
        
        [UIView transitionWithView:self.messageLabel
                          duration:kLayoutAnimationTime
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.messageLabel.text = self.labelText;
                        } 
                        completion:NULL
         ];
        
        [self animateBoxShadowToRect:(CGRect){CGPointZero, newFrame.size} duration:kLayoutAnimationTime];
    }
    else{
        self.frame = newFrame;
        self.customView.frame = customViewFrame;
        self.messageLabel.frame = newMessageFrame;
        self.activitySpinner.center = activityCenter;
        
        self.messageLabel.text = self.labelText;
        self.layer.shadowPath = [self boxMaskPathForRect:(CGRect){CGPointZero, newFrame.size}].CGPath;
    }
    
    if (self.labelText.length != 0 && !self.messageLabel.superview){
        [self addSubview:self.messageLabel];
    }
    
    if (self.labelText.length == 0 && self.messageLabel.superview){
        [self.messageLabel removeFromSuperview];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // outline path
    UIBezierPath *outlinePath = [self boxMaskPathForRect:self.bounds];
    
    CGContextSetFillColorWithColor(ctx, self.color.CGColor);
    CGContextSetStrokeColorWithColor(ctx, self.borderColor ? self.borderColor.CGColor : [UIColor clearColor].CGColor);
    CGContextSetLineWidth(ctx, self.borderWidth);
    CGContextAddPath(ctx, outlinePath.CGPath);
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

- (void)animateBoxShadowToRect:(CGRect)rect duration:(NSTimeInterval)duration
{
    UIBezierPath *shadowPath = [self boxMaskPathForRect:rect];
    
    CABasicAnimation *shadowAnim = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
    shadowAnim.fromValue = (__bridge id)self.layer.shadowPath;
    shadowAnim.toValue = (__bridge id)[shadowPath CGPath];
    shadowAnim.duration = duration;
    shadowAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    shadowAnim.fillMode = kCAFillModeBoth;
    
    self.layer.shadowPath = shadowPath.CGPath;
    [self.layer addAnimation:shadowAnim forKey:@"moveDatPath"];
}


- (UIBezierPath*)boxMaskPathForRect:(CGRect)rect
{
    // outline path
    CGRect insetBounds = CGRectInset(rect, self.borderWidth/2, self.borderWidth/2);
    if (self.cornerRadius > 0.0)
        return [UIBezierPath bezierPathWithRoundedRect:insetBounds cornerRadius:self.cornerRadius];
    else
        return [UIBezierPath bezierPathWithRect:insetBounds];
}

#pragma mark - Properties

- (void)setCustomView:(UIView *)customView
{
    if (customView && self.style != RZHudBoxStyleInfo){
        NSLog(@"Warning: Custom HUD view only valid for style RZHudStyleInfo");
        return;
    }
    
    if (customView && self.superview){
        NSLog(@"Warning: Cannot change HUD custom image while presented!");
        return;
    }
    
    if (_customView){
        [_customView removeFromSuperview];
        self.customView = nil;
    }
    _customView = customView;
    if (customView){
        customView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_customView];
    }
    [self updateLayoutAnimated:NO];
}

- (void)setStyle:(RZHudBoxStyle)style
{
    if (self.superview){
        NSLog(@"Warning: Cannot change HUD style while presented!");
        return;
    }
    _style = style;
    if (style == RZHudBoxStyleLoading){
        self.activitySpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activitySpinner.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        self.activitySpinner.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        self.activitySpinner.hidesWhenStopped = NO;
        [self addSubview:self.activitySpinner];
        [self.activitySpinner startAnimating];
    }
    else{
        [self.activitySpinner removeFromSuperview];
        self.activitySpinner = nil;
    }
    [self setNeedsLayout];
}


- (void)setLabelText:(NSString *)labelText
{    
    _labelText = [labelText copy];
    
    [self updateLayoutAnimated:(self.superview != nil)];
}

- (UIColor*)labelColor
{    
    return self.messageLabel.textColor;
}

- (void)setLabelColor:(UIColor *)labelColor
{
    self.messageLabel.textColor = labelColor;
}

- (UIFont*)labelFont
{
    return self.messageLabel.font;
}

- (void)setLabelFont:(UIFont *)labelFont
{
    self.messageLabel.font = labelFont;
    [self updateLayoutAnimated:(self.superview && self.messageLabel.superview)];
}

- (UIColor*)spinnerColor
{
    return self.activitySpinner.color;
}

- (void)setSpinnerColor:(UIColor *)spinnerColor
{
    self.activitySpinner.color = spinnerColor;
}

- (void)setShadowAlpha:(CGFloat)shadowAlpha
{
    _shadowAlpha = shadowAlpha;
    self.layer.shadowOpacity = shadowAlpha;
}

@end
