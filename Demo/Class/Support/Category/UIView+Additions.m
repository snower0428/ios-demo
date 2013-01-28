//
//  UIView+Additions.m
//  Demo
//
//  Created by lei hui on 13-1-25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView(Additions)

- (id)viewController
{
	id responder = self;
	while (responder && ![responder isKindOfClass:[UIViewController class]]) {
		responder = [responder nextResponder];
	}
	
	if ([responder isKindOfClass:[UIViewController class]]) {
		return responder;
	} else {
		return nil;
	}
}

- (UIImage *)captureScreen
{
    CGSize imageSize = self.frame.size;
    
    //begin
    if (UIGraphicsBeginImageContextWithOptions) {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    } else {
        UIGraphicsBeginImageContext(imageSize);
    }   
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //end
    UIGraphicsEndImageContext();
    
    return retImage;
}

- (void)setPosition:(CGPoint)pt
{
    self.frame = CGRectMake(pt.x, pt.y, self.frame.size.width, self.frame.size.height);
}

- (void)scaleFrameWithSize:(CGSize)size
{
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return;
    }
    if (CGSizeEqualToSize(self.frame.size, CGSizeZero)) {
        return;
    }
    
    CGPoint center = self.center;
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    float sizeWidth = size.width;
    float sizeHeight = size.height;
    float xScale = sizeWidth / width;
    float yScale = sizeHeight / height;
    if (xScale > yScale) {
        height = sizeHeight / sizeWidth * width;
    } else {
        width = sizeWidth / sizeHeight * height;
    }
    
    //ajustSize
    CGRect frame = self.frame;
    frame.size = CGSizeMake(width, height);
    self.frame = frame;
    //ajustPositon
    self.center = center;
}

@end
