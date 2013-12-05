//
//  BaseViewCtrl.h
//  GPUImageDemo
//
//  Created by leihui on 13-11-25.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewCtrl : UIViewController
{
    GPUImagePicture     *_picture;
}

- (GPUImageOutput<GPUImageInput> *)filterWithImage:(UIImage *)image;
- (UISlider *)sliderWithValue:(CGFloat)value minimumValue:(CGFloat)minimumValue maximumValue:(CGFloat)maximumValue;

@end
