//
//  LHCommDefines.h
//  Demo
//
//  Created by lei hui on 13-7-23.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#ifndef Demo_LHCommDefines_h
#define Demo_LHCommDefines_h

//按钮执行的block
typedef void(^ButtonBlock)(void);

//res目录
//#define RES_DIRECTORY  [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"res"]
#define RES_DIRECTORY  [[NSBundle mainBundle] bundlePath]
#define DOCUMENTS_DIRECTORY  NSHomeDirectory()

#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGB(r,g,b)  RGBA(r,g,b,1)
#define RandomRGB    RGB(arc4random()%255, arc4random()%255, arc4random()%255)

#define ARIAL_FONT(s)           [UIFont fontWithName:@"ArialMT" size:s]
#define ARIAL_BOLDFONT(s)       [UIFont fontWithName:@"Arial-BoldMT" size:s]
#define MS_FONT(s)              [UIFont fontWithName:@"微软雅黑" size:s]
#define FZY4JW_FONT(s)          [UIFont fontWithName:@"FZY4JW--GB1-0" size:s]

//时间格式
#define TIME_FORMAT_SEP_GENERAL         @"%d.%d.%d"
#define TIME_FORMAT_SEP_POINT           @"%d.%d.%d"
#define TIME_FORMAT_SEP_SEP             @"%d-%02d-%02d"

//日期格式
#define DATE_FORMAT_YYYY_MM_DD          @"yyyy-MM-dd"
#define DATE_FORMAT_YYYY_MM             @"yyyy-MM"
#define DATE_STR_FORMAT_YYYY_MM_DD      @"%04d-%02d-%02d"
#define DATE_STR_FORMAT_YYYY_MM         @"%04d-%02d"
#define DATE_FORMAT_YYYY_MM_DD_HH_mm_ss @"yyyy-MM-dd hh:mm:ss"

//动画控件默认参数
#define  ANIMATION_REPEATCOUNT_DEFAULT     1
#define  ANIMATION_DURATION_DEFAULT        1.0
#define  ANIMATION_INTERVAL_DEFAULT        0
#define  ANIMATION_PERODIC_DEFAULT         1

//自动翻页延迟间隔
#define  AUTOFLIP_DELAY_DEFAULT  2.0f

//录音时间间隔（超过则会自动停止）
#define DERUATION_FOR_RECORD  120.0f


#ifndef SAFE_DELETE
#define SAFE_DELETE(x) if(x){[x release]; x=nil;}
#endif

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radian) (180.0 / M_PI * radian)

#define SECOND_OF_YEAR              (365*24*60*60)

//加密key（32位之内）
#define AES_KEY [NSString stringWithFormat:@"%s%s%@","78H&aW36","s-@2Kf",@"abcdefgh123456789"]

/*-------------------- 横屏标志宏定义 --------------------*/
//#define Landscape


/*-------------------- 全屏区域宏定义 --------------------*/
#ifdef Landscape
#ifdef TARGET_IPAD
#define FULLSCREEN_RECT				CGRectMake(0, 0, 1024, 768)
#else
#define FULLSCREEN_RECT				CGRectMake(0, 0, 480, 320)
#endif
#else
#ifdef TARGET_IPAD
#define FULLSCREEN_RECT				CGRectMake(0, 0, 768, 1024)
#else
#define FULLSCREEN_RECT				CGRectMake(0, 0, 320, 480)
#endif
#endif

/**
 * 产生随机数: 0.0 ~ 1.0
 */
#define foo4random()            (1.0 * (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX)

//本地化字符串
#define  _(string)              NSLocalizedString(string, nil)

#endif
