//
//  LayerParser.h
//  BabyBooks
//
//  Created by zhangtianfu on 11-5-15.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//
//	============  解析类（只是解析创建控件，如果要设置时间对象或者代理，需要在调用处额外设置.所有解析的view都是autorelease）	================

#import <Foundation/Foundation.h>


@interface LayerParser : NSObject {

}

//	解析多个控件
+ (NSMutableArray*)parseLayers:(NSArray*)layersInfo resDirectory:(NSString*)resDirectory;
//	解析单个控件
+ (id)parseLayerItem:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory;
//	删除控件
+ (void)removeLayers:(NSMutableArray*)layers;


+ (id)loadStaticImage:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory;	//	静态图
+ (id)loadClickImage:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory;		//	可点击图片
+ (id)loadMoveableImage:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory;	//	可移动图片
+ (id)loadAnimationImage:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory;	//	动画
+ (id)loadButton:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory;			//	按钮
+ (id)loadCheckButton:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory;	//	勾选框
+ (id)loadSegment:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory;		//	分段控件
+ (id)loadAudioView:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory;		//	可点击音频
//+ (id)loadBookIcon:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory;		//	书本图标
+ (id)loadRotationView:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory;	//	旋转图片
+ (id)loadSlider:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory;			//	滑动条
+ (id)loadPageIndicator:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory;	//	页面指示器
+ (id)loadMultiSwitch:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory;	//	切换器
//+ (id)loadTextWord:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory;		//  文本框（单）
+ (id)loadScrollImage:(NSDictionary *)layerItem resDirectory:(NSString *)resDirectory;  //  可滚动的图片
+ (id)loadDragableImage:(NSDictionary *)layerItem resDirectory:(NSString *)resDirectory;//	可拖动的图片
//+ (id)loadClickableImageView:(NSDictionary *)layerItem resDirectory:(NSString *)resDirectory;	// 可点击图片(可产生多种效果)
+ (id)loadPopoverView:(NSDictionary *)layerItem resDirectory:(NSString *)resDirectory;	//弹出选择面板
+ (id)loadScrollView:(NSDictionary *)layerItem resDirectory:(NSString *)resDirectory;	//scrollview
//+ (id)loadBooksCoverFlow:(NSDictionary *)layerItem resDirectory:(NSString *)resDirectory;	//BooksCoverFlow



@end
