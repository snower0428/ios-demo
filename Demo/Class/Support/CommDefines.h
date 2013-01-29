//
//  CommDefines.h
//  CommDemo
//
//  Created by leihui on 12-10-17.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#ifndef CommDemo_CommDefines_h
#define CommDemo_CommDefines_h


#ifdef DEBUG
#define  CCLOG(...)  NSLog(__VA_ARGS__)//调试debug
#else
#define  CCLOG(...)  do{}while(0)//release
#endif


//按钮执行的block
typedef void(^ButtonBlock)(void);

//本地化字符串
#define  _(string)   NSLocalizedString(string, nil)

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

#define SYSTEM_VERSION  [[UIDevice currentDevice].systemVersion floatValue]

//判断是否是iPhone5设备
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
                    CGSizeEqualToSize(CGSizeMake(640,1136), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 *
 *  屏幕元素定义
 *
 */
#define SCREEN_WIDTH            320
#define SCREEN_HEIGHT           (iPhone5?[[UIScreen mainScreen] currentMode].size.height/2:480)
#define APP_HEIGHT              (SCREEN_HEIGHT-20)      //相当于之前的460，应用程序的大小高度
#define APP_VIEW_HEIGH          (APP_HEIGHT-44)   //相当于之前的460-44，应用程序的大小高度(除去頂部攔)
#define	DOCK_HEIGHT				93
#define	STATUSBAR_HEIGHT		20
#define	NAVIGATIONBAR_HEIGHT	44
#define	TABBAR_HEIGHT			50

//
//语言类型
//
typedef enum
{
	LanguageTypeEnglish,
	LanguageTypezh_CN,
	LanguageTypezh_FT,
}LanguageType;

//
//视图控件类型
//
typedef enum
{
	LayerTypeStaticImage	= 0, //静态图
	LayerTypeClickImage		= 1, //可点击的静态图
	LayerTypeMoveableImage	= 2, //可移动的图
	LayerTypeAnimationImage	= 3, //动画
	LayerTypeButton			= 4, //按钮
	LayerTypeBook			= 5, //书本图标
	LayerTypeSegment		= 6, //分页控件
	LayerTypeAudio			= 7, //音频控件
	LayerTypeCheckButton	= 8, //勾选框
	LayerTypeDialog			= 9, //对话框
	LayerTypeRotationView	= 10, //旋转图
	LayerTypeSlider			= 11, //滑动条
	LayerTypePageIndicator	= 12, //页面指示器
	LayerTypeMultiSwitch	= 13, //切换器
	LayerTypeTextWord		= 14, //文本框（单）
	LayerTypeScrollImage	= 15, //可滑动的静态图
	LayerTypeDragableImage	= 16, //可拖动的静态图
	LayerTypePopoverView	= 17, //弹出选择面板
	LayerTypeScrollView		= 18, //scrollview
	LayerTypeBooksCoverFlow	= 19, //BooksCoverFlow
}LayerType;

//
//页面切换动画类型
//
typedef enum
{
	TransitionTypeNone		= -1,
	TransitionTypePageCurl	= 0,  //翻页
	TransitionTypePush		= 1,  //旧页面被新页面退走
	TransitionTypeFade		= 2,  //淡入淡出
	TransitionTypeMoveIn	= 3,  //新页面移入
    TransitionTypeReveal	= 4,  //旧页面被抽走
}TransitionType;

//
//页面切换动画方向---消息类型
//
typedef enum
{
	TransitionDirectionFromLeft		= 0,
	TransitionDirectionFromRight	= 1,
	TransitionDirectionFromTop		= 2,
	TransitionDirectionFromBottom	= 3,
}TransitionDirection;


/************************************************************
 *
 *  Header
 *
 */

//#import "GTMBase64Ex.h"             //Base64
//#import "RegexKitLite.h"            //Regex
#import "JSON.h"                    //JSON
#import "MBProgressHUD.h"           //MBProgressHUD
#import "LogInAlertView.h"          //LogInAlertView
//#import "iToast.h"                  //iToast
#import "AppstoreManager.h"
#import "BlockButtonItem.h"
#import "Utility.h"
//#import "PlistPathManager.h"
#import "NSDateExtention.h"
#import "BBTransition.h"
//#import "BabyBookService.h"
#import "TimerManager.h"
#import "Logger.h"
//#import "Category.h"
#import "PlistParser.h"
#import "LayerParser.h"
#import "RandomExtention.h"
#import "BBAudioPlayer.h"
#import "BBAudioRecorder.h"
#import "BBVideoPlayer.h"
#import "SoundEffect.h"
//#import "AnimationEffects.h"

//#import "AFOpenFlowView.h"  //Openflow

//CustomView
#import "NumberView.h"
#import "AnimationView.h"
#import "AudioView.h"
#import "BookImageView.h"
#import "ClickImageView.h"
#import "CustomUIPageControl.h"
#import "DialogView.h"
#import "MoveableImageView.h"
#import "RotationImageView.h"
#import "SegmentView.h"
#import "UICheckButton.h"
#import "MultiSwitchView.h"
#import "ProgressView.h"
//#import "WordContentView.h"
#import "CustomButton.h"
#import "DragableImageView.h"
#import "BBPopoverView.h"
//#import "BBViewController.h"
#import "BBScrollView.h"
//#import "BooksCoverFlow.h"
//#import "FlakeMoveView.h"
#import "JumpText.h"
//#import "CustomScrollView.h"
//#import "ClickEffectView.h"

#import "Addtions.h"

#endif
