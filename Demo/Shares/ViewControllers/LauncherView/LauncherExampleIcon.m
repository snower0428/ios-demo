//
//  LauncherExampleIcon.m
//  HMLauncherViewExample
//
//  Created by Heiko Maaß on 29.02.12.
//  Copyright (c) 2012 Heiko Maass. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LauncherExampleIcon.h"
#import "HMLauncherItem.h"

#define DELETE_BUTTON_TAG   123

@interface LauncherExampleIcon(private)
- (void) setIconImageFromIconPath:(NSString *)iconPath;
- (UIImage*) mergeBackgroundImage:(UIImage*) bottomImage withTopImage:(UIImage*) image;
@end

@implementation LauncherExampleIcon
@synthesize iconImage;
@synthesize closeImage;
@synthesize closeRect;

- (BOOL) hitCloseButton:(CGPoint)point {
    return (CGRectContainsPoint(self.closeRect, point));
}

- (void) drawRect:(CGRect)rect
{
#if 0
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat availableWidth = self.iconImage.size.width;
    
    // Icon
    CGFloat x = floor((self.bounds.size.width - availableWidth) / 2);
    CGFloat y = 10;
    CGRect buttonRect = CGRectMake(x, y, self.iconImage.size.width, self.iconImage.size.height);
    
    // Highlighted
    if (self.highlighted && (self.canBeTapped || self.canBeDragged)) {
        [[UIColor darkGrayColor] setFill];
        UIBezierPath *outerPath = [UIBezierPath bezierPathWithRoundedRect:buttonRect cornerRadius:11.0];
        CGContextSaveGState(context);
        [outerPath addClip];
        CGContextFillRect(context, buttonRect);
        CGContextRestoreGState(context);
    }
    CGFloat alpha = 1.0;
    if (self.canBeDragged == NO) {
        alpha = 0.3;
    }
    [self.iconImage drawInRect:buttonRect blendMode:kCGBlendModeOverlay alpha:alpha];
    
    // Close Button
    if (!self.hideDeleteImage) {
        [self.closeImage drawInRect:self.closeRect];
    } 
    // Text
    y += buttonRect.size.height + 3;
    UIFont *font = [UIFont systemFontOfSize:14.0];
    [[UIColor whiteColor] setFill];
    
    NSString *text = self.launcherItem.titleText;
    CGSize maxTextSize = CGSizeMake(availableWidth, self.bounds.size.height - y);
    CGSize textSize = [text sizeWithFont:font 
                       constrainedToSize:maxTextSize 
                           lineBreakMode:UILineBreakModeWordWrap];
    
    x = floor((self.bounds.size.width - textSize.width) / 2);
    CGRect textRect = CGRectMake(x, y, textSize.width, textSize.height);
    CGContextSetAlpha(context, alpha);
    [text drawInRect:textRect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
#endif
    if (!self.hideDeleteImage) {
        UIButton *deleteButton = (UIButton *)[self viewWithTag:DELETE_BUTTON_TAG];
        if (deleteButton) {
            deleteButton.hidden = NO;
        }
    }
}


- (void) setIconImageFromIconPath:(NSString *)iconPath {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *imagePath = [bundle pathForResource:self.launcherItem.iconPath ofType:nil]; 
    UIImage *aIconImage = [UIImage imageWithContentsOfFile:imagePath];
    
    // I've used the static imageNamed function before, but imageNamed doesn't work in unittests.
    //
    // UIImage *aIconImage = [UIImage imageNamed:self.launcherItem.iconPath];
    // UIImage *aBackgroundImage = [UIImage imageNamed:self.launcherItem.iconBackgroundPath];
    NSString *aBackgroundImagePath = [bundle pathForResource:self.launcherItem.iconBackgroundPath ofType:nil];
    UIImage *aBackgroundImage = [UIImage imageWithContentsOfFile:aBackgroundImagePath];
    
    NSParameterAssert(aIconImage != nil);
    self.iconImage = [self mergeBackgroundImage:aBackgroundImage  withTopImage:aIconImage];
}

- (UIImage*) mergeBackgroundImage:(UIImage*) bottomImage withTopImage:(UIImage*) image {
    CGSize newSize = bottomImage.size;   
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		if ([[UIScreen mainScreen] scale] == 2.0) {
			UIGraphicsBeginImageContextWithOptions(newSize, NO, 2.0);
		} else {
			UIGraphicsBeginImageContext(newSize);
		}
	} else {
		UIGraphicsBeginImageContext(newSize);
	}

    
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    int x = (int)((bottomImage.size.width - image.size.width) / 2);
    int y = (int)((bottomImage.size.height- image.size.height) / 2);
    
    [image drawInRect:CGRectMake(x, y, image.size.width, image.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (id) initWithLauncherItem:(HMLauncherItem *)launcherItem {
    if (self = [super initWithLauncherItem:launcherItem]) {
        closeRect = CGRectMake(2, 5, 20, 20);
        [self setCloseImage: [UIImage imageNamed:@"close.png"]];
//        [self setIconImageFromIconPath:self.launcherItem.iconPath];
//        NSParameterAssert(self.iconImage != nil);
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        image.backgroundColor = [UIColor purpleColor];
        image.layer.cornerRadius = 8;
        [self addSubview:image];
        
        UILabel *label = [[UILabel alloc] initWithFrame:image.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.text = launcherItem.titleText;
        label.textAlignment = UITextAlignmentCenter;
        [image addSubview:label];
        [label release];
        
        [image release];
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, 70, 15)];
        labelTitle.backgroundColor = [UIColor clearColor];
        labelTitle.text = [NSString stringWithFormat:@"第%@个", launcherItem.titleText];
        labelTitle.textAlignment = UITextAlignmentCenter;
        [self addSubview:labelTitle];
        [labelTitle release];
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame = closeRect;
        deleteButton.tag = DELETE_BUTTON_TAG;
        [deleteButton setImage:self.closeImage forState:UIControlStateNormal];
        [self addSubview:deleteButton];
        deleteButton.hidden = YES;
    }
    return self;
}

- (void) dealloc {
    [iconImage release], iconImage = nil;
    [closeImage release], closeImage = nil;
    [super dealloc];
}

@end
