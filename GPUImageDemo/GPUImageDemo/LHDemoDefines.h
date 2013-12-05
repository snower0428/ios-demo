//
//  EmojiDefines.h
//  LHDemo
//
//  Created by leihui on 13-9-10.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#ifndef LHDemo_EmojiDefines_h
#define LHDemo_EmojiDefines_h

#define _(x)            NSLocalizedString(x, @"")

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
#define TOOLBAR_HEIGHT          44

#endif
