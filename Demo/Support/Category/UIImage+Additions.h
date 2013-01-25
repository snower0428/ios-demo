//
//  UIImage+Additions.h
//  CommDemo
//
//  Created by leihui on 12-12-14.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage(Additions)

+ (id)imageFile:(NSString*)file;

//加载图片类似initWithContentsOfFile（为了解决4.0固件不能自动识别@2x图片）
- (id)initWithContentsOfFileEx:(NSString *)path;

//加载图片类似imageWithContentsOfFile（为了解决4.0固件不能自动识别@2x图片）
+ (UIImage*)imageWithContentsOfFileEx:(NSString *)path;

//缩放图片并且添加相应的边框
- (UIImage*)resizeImage:(CGSize)imageSize color:(UIColor*)borderColor width:(float)borderWidth height:(float)borderHeight;

//缩放图片并且添加相应的边框（直接操作view截屏，可能效率低）
- (UIImage*)resizeImageEx:(CGSize)imageSize color:(UIColor*)borderColor width:(float)borderWidth height:(float)borderHeight;

//缩放图片，并且添加圆角
- (UIImage*)resizeImage:(CGSize)imageSize cornerRadius:(float)cornerRadius;

//按照宽/高比例切割图片
- (UIImage*)clipImageWithRate:(float)rate;//可以用UIViewContentMode代替

@end
