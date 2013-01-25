//
//  UIImage+Additions.m
//  CommDemo
//
//  Created by leihui on 12-12-14.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage(Additions)

+ (id)imageFile:(NSString *)file
{
    UIImage *image = nil;
    if (file) {
        if ([file isAbsolutePath]) {
            image = [UIImage imageWithContentsOfFileEx:file];
        } else {
            image = [UIImage imageNamed:file];
        }
    }
    
    return image;
}

- (id)initWithContentsOfFileEx:(NSString *)path
{
	NSString *dstPath = path;
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	
	if (version < 4.1f && path && [[UIScreen mainScreen] isRetina]) {
		NSRange range = [path rangeOfString:@"@2x"];
		if (range.location == NSNotFound) {
			NSString *retinaPath = [NSString stringWithFormat:@"%@@2x.%@",[path stringByDeletingPathExtension], [path pathExtension]];
			if ([[NSFileManager defaultManager] fileExistsAtPath:retinaPath]){//需要加上@2x后缀
				dstPath = retinaPath;
			}
		}
	}
	
	return [self initWithContentsOfFile:dstPath];
}

+ (UIImage *)imageWithContentsOfFileEx:(NSString *)path
{
	NSString *dstPath = path;
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	
	if (version < 4.1f && path && [[UIScreen mainScreen] isRetina]) {
		NSRange range = [path rangeOfString:@"@2x"];
		if (range.location == NSNotFound) {
			NSString *retinaPath = [NSString stringWithFormat:@"%@@2x.%@",[path stringByDeletingPathExtension], [path pathExtension]];
			if ([[NSFileManager defaultManager] fileExistsAtPath:retinaPath]){//需要加上@2x后缀
				dstPath = retinaPath;
			}
		}
	}
	
	return [UIImage imageWithContentsOfFile:dstPath];
}

//缩放图片并且添加相应的边框
- (UIImage *)resizeImage:(CGSize)imageSize color:(UIColor *)borderColor width:(float)borderWidth height:(float)borderHeight
{
	CGRect fullRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
	
	//modify by ztf 2011.11.2
	if (UIGraphicsBeginImageContextWithOptions) {
		UIGraphicsBeginImageContextWithOptions(imageSize, NO, self.scale);
    } else {
        UIGraphicsBeginImageContext(imageSize);
    }
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetBlendMode(context, kCGBlendModeNormal);
	CGContextSetRGBFillColor(context, [borderColor red], [borderColor green], [borderColor blue], [borderColor alpha]);
	CGContextAddRect(context,fullRect);
	CGContextFillPath(context);
	[self drawInRect:CGRectInset(fullRect, borderWidth, borderHeight)];
	UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return retImage;
}

//缩放图片并且添加相应的边框（直接操作view截屏，可能效率低）
- (UIImage *)resizeImageEx:(CGSize)imageSize color:(UIColor *)borderColor width:(float)borderWidth height:(float)borderHeight
{
	CGRect fullRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
	
	UIView *container = [[UIView alloc] initWithFrame:fullRect];
	container.backgroundColor = borderColor;
	UIImageView *imageView = [[UIImageView alloc] initWithImage:self];
	[imageView setFrame:CGRectInset(fullRect, borderWidth, borderHeight)];
	[container addSubview:imageView];
	
	//modify by ztf 2011.11.2
	if (UIGraphicsBeginImageContextWithOptions) {
		UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    } else {
        UIGraphicsBeginImageContext(imageSize);
    }
	[container.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	[container release];
	[imageView release];
	
	return retImage;
}

//缩放图片，并且添加圆角
- (UIImage *)resizeImage:(CGSize)imageSize cornerRadius:(float)cornerRadius
{
	UIImageView *imageView = [[UIImageView alloc] initWithImage:self];
	[imageView setFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
	imageView.layer.masksToBounds = YES;
	imageView.layer.cornerRadius = cornerRadius;
	
	//modify by ztf 2011.11.2
	if (UIGraphicsBeginImageContextWithOptions) {
		UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    } else {
        UIGraphicsBeginImageContext(imageSize);
    }
	[imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	[imageView release];
    
	return retImage;
}

- (UIImage *)clipImageWithRate:(float)rate
{
    float imageRate = self.size.width/self.size.height;
    
    if (imageRate == rate) {
        return self;
    }
    
    float originWidth = self.size.width;
    float originHeight = self.size.height;
    float destWidth = originWidth;
    float destHeight = originHeight;
    if (imageRate > rate) {
        destWidth = originHeight*rate;
    } else {
        destHeight = originWidth*rate;
    }
    float xOffset = (originWidth - destWidth)/2;
    float yOffset = (originHeight - destHeight)/2;
    CGRect rect = CGRectMake(xOffset, yOffset, destWidth, destHeight);
    
    CGImageRef imageRef =  CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *destImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    return destImage;
}

@end
