//
//  Support.h
//  CommDemo
//
//  Created by leihui on 12-10-17.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#ifndef CommDemo_Support_h
#define CommDemo_Support_h

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
#import "LHCommDefines.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import "LogInAlertView.h"
#import "AppstoreManager.h"
#import "BlockButtonItem.h"
#import "Utility.h"
#import "NSDateExtention.h"
#import "BBTransition.h"
#import "TimerManager.h"
#import "Logger.h"
#import "PlistParser.h"
#import "LayerParser.h"
#import "RandomExtention.h"
#import "BBAudioPlayer.h"
#import "BBAudioRecorder.h"
#import "BBVideoPlayer.h"
#import "SoundEffect.h"

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
#import "CustomButton.h"
#import "DragableImageView.h"
#import "BBPopoverView.h"
#import "BBScrollView.h"
#import "JumpText.h"
#import "Addtions.h"

#endif
