//
//  ViewController.h
//  LHTwoDimDemo
//
//  Created by leihui on 13-11-2.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZXingOpenFlag   1       // 启用二维码功能Flag

#if ZXingOpenFlag
#import <ZXingWidgetController.h>
#endif

#if ZXingOpenFlag
@interface ViewController : UIViewController <UITextViewDelegate, ZXingDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, DecoderDelegate>
#else
@interface ViewController : UIViewController <UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, DecoderDelegate>
#endif

@end
