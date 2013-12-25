//
//  LHDefines.h
//  Demo
//
//  Created by lei hui on 13-7-26.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#ifndef Demo_LHDefines_h
#define Demo_LHDefines_h

//系统版本
#define SYSTEM_VERSION      [[UIDevice currentDevice].systemVersion floatValue]
//程序版本
#define BUNDLE_VERSION      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

//Documents目录
#define DOCUMENTS_DIRECTORY     [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

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
#define TOOLBAR_HEIGHT          44

//状态栏透明页面偏移量
#define kTopShift   (SYSTEM_VERSION<7.0 ? (-STATUSBAR_HEIGHT) : 0)

#define kTopOrigin  (SYSTEM_VERSION<7.0 ? 0 : (STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT))

#define RGB(r, g, b)            [UIColor colorWithRed:(float)(r)/255.f green:(float)(g)/255.f blue:(float)(b)/255.f alpha:1.0f]
#define RGBA(r, g, b, a)        [UIColor colorWithRed:(float)(r)/255.f green:(float)(g)/255.f blue:(float)(b)/255.f alpha:a]

#define kTableViewBackgroundColor   [UIColor colorWithRed:238.f/255.f green:241.f/255.f blue:246.f/255.f alpha:1]

#define _(s)    NSLocalizedString((s),@"")

#ifdef __IPHONE_6_0
#define UITextAlignmentLeft 			NSTextAlignmentLeft
#define UITextAlignmentCenter           NSTextAlignmentCenter
#define UITextAlignmentRight            NSTextAlignmentRight
#define UILineBreakModeCharacterWrap 	NSLineBreakByCharWrapping
#define UILineBreakModeWordWrap         NSLineBreakByWordWrapping
#define UILineBreakModeClip             NSLineBreakByClipping
#define UILineBreakModeTruncatingHead   NSLineBreakByTruncatingHead
#define UILineBreakModeTruncatingMiddle NSLineBreakByTruncatingMiddle
#define UILineBreakModeTailTruncation   NSLineBreakByTruncatingTail
#endif

#endif
