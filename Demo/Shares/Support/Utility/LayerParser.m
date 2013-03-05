//
//  LayerParser.m
//  BabyBooks
//
//  Created by zhangtianfu on 11-5-15.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import "LayerParser.h"
//#import "BookManager.h"
#import "AnimationView.h"
#import "SegmentView.h"
#import "AudioView.h"
#import "UICheckButton.h"
#import "BookImageView.h"
#import "ClickImageView.h"
#import "RotationImageView.h"
#import "MoveableImageView.h"
#import "CustomUIPageControl.h"
#import "MultiSwitchView.h"
//#import "WordContentView.h"
#import "CustomButton.h"
#import "DragableImageView.h"
//#import "ClickableImageView.h"
#import "BBScrollView.h"
//#import "BooksCoverFlow.h"


@implementation LayerParser


+ (NSMutableArray*)parseLayers:(NSArray*)layersInfo resDirectory:(NSString*)resDirectory{
	if (![[NSFileManager defaultManager] fileExistsAtPath:resDirectory]) {
		return nil;
	}
	
	if ([layersInfo count] == 0) {
		return nil;
	}
	
	NSMutableArray *layers = [[[NSMutableArray alloc] init] autorelease];
	for (NSDictionary *item in layersInfo) {
		NSNumber *type = [item objectForKey:@"type"];
		if (nil == type){
			continue;
		}
		
		id layerItem = [LayerParser parseLayerItem:item resDirectory:resDirectory];
		if (layerItem == nil || layerItem == (id)[NSNull null]) {
			continue;
		}
		
		[layers addObject:layerItem];
	}
	
	if ([layers count] == 0) {
		return nil;
	}else {
		return layers;
	}
}

+ (id)parseLayerItem:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory{
	id returnItem = nil;
	
	LayerType type = (LayerType)[[layerItem objectForKey:@"type"] intValue];
	switch (type){
		case LayerTypeStaticImage: {
			returnItem = [LayerParser loadStaticImage:layerItem resDirectory:resDirectory];
		}break;
			
		case LayerTypeClickImage:{
			returnItem = [LayerParser loadClickImage:layerItem resDirectory:resDirectory];
		}break;
			
		case LayerTypeMoveableImage:{
			returnItem = [LayerParser loadMoveableImage:layerItem resDirectory:resDirectory];
		}break;
            
		case LayerTypeAnimationImage:{
			returnItem = [LayerParser loadAnimationImage:layerItem resDirectory:resDirectory];
		}break;
			
		case LayerTypeButton:{
			returnItem = [LayerParser loadButton:layerItem resDirectory:resDirectory];
		}break;
			
		case LayerTypeCheckButton:{
			returnItem = [LayerParser loadCheckButton:layerItem resDirectory:resDirectory];
		}break;
			
		case LayerTypeSegment:{
			returnItem = [LayerParser loadSegment:layerItem resDirectory:resDirectory];
		}break;
			
		case LayerTypeAudio:{
			returnItem = [LayerParser loadAudioView:layerItem resDirectory:resDirectory];
		}break;
			
//		case LayerTypeBook:{
//			returnItem = [LayerParser loadBookIcon:layerItem resDirectory:resDirectory];
//		}break;
			
		case LayerTypeRotationView:{
			returnItem = [LayerParser loadRotationView:layerItem resDirectory:resDirectory];
		}break;

		case LayerTypeSlider:{
			returnItem = [LayerParser loadSlider:layerItem resDirectory:resDirectory];
		}break;
			
		case LayerTypePageIndicator:{//页面指示器
			returnItem = [LayerParser loadPageIndicator:layerItem resDirectory:resDirectory];
		}break;
			
		case LayerTypeMultiSwitch:{//切换器
			returnItem = [LayerParser loadMultiSwitch:layerItem resDirectory:resDirectory];
		}break;
			
//		case LayerTypeTextWord:{
//			returnItem =[LayerParser loadTextWord:layerItem resDirectory:resDirectory];
//		}break;
			
		case LayerTypeScrollImage:{
			returnItem =[LayerParser loadScrollImage:layerItem resDirectory:resDirectory];
		}break;
		case LayerTypeDragableImage:{
			returnItem =[LayerParser loadDragableImage:layerItem resDirectory:resDirectory];
		}break;
			
		case LayerTypePopoverView:{
			returnItem =[LayerParser loadPopoverView:layerItem resDirectory:resDirectory];
		}break;
			
		case LayerTypeScrollView:{
			returnItem = [LayerParser loadScrollView:layerItem resDirectory:resDirectory];
		}break;
            
//        case LayerTypeBooksCoverFlow:{
//            returnItem =  [LayerParser loadBooksCoverFlow:layerItem resDirectory:resDirectory];
//        }break;

		default:
			WriteLog(@"----------未识别type-------:\n%@",layerItem);
			break;
	}
	
	if (returnItem && returnItem != (id)[NSNull null]) {
		return returnItem;
	}
	
	return nil;
}

+ (void)removeLayers:(NSMutableArray*)layers{
	for (id item in layers){
		if (item == (id)[NSNull null]){
			continue;
		}
		
		if ([item isKindOfClass:[AnimationView class]]){
			[item stopAnimating];
		}else if ([item isKindOfClass:[AudioView class]]) {
			[item stop];
		}else if ([item isKindOfClass:[MoveableImageView class]]) {
			[item stopMovement];
		}
		
		[item removeFromSuperview];
	}
	
	[layers removeAllObjects];
}

//	==================静态图=======================
+ (id)loadStaticImage:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory{
	UIImageView *imageView = nil;
	
	//image
	UIImage *image = [layerItem getImageForKey:@"image" resDirectory:resDirectory];
	
	//frame
	CGRect rc = [layerItem getRectForKey:@"frame" fromImage:image];
	
	if (image && CGRectGetWidth(rc)>0 && CGRectGetHeight(rc)>0){
		imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
		imageView.frame = rc;
		imageView.tag = [[layerItem objectForKey:@"tag"] intValue];
	}else{
		WriteLog(@"loadStaticImage ----------解析失败-------:\n%@",layerItem);
	}
	
	return imageView;
}



//	==================可点击图片=======================
+ (id)loadClickImage:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory{
	ClickImageView *clickView = nil;
	
	//image
	UIImage *image = [layerItem getImageForKey:@"image" resDirectory:resDirectory];
	
	//frame
	CGRect rc = [layerItem getRectForKey:@"frame" fromImage:image];

	if (image && CGRectGetWidth(rc)>0 && CGRectGetHeight(rc)>0){
		BOOL highlight = [[layerItem objectForKey:@"highlight"] boolValue];
		
		clickView = [[[ClickImageView alloc] initWithImage:image] autorelease];
		clickView.frame = rc;
		clickView.showsTouchWhenHighlighted = highlight;
	}else{
		WriteLog(@"loadClickImage ----------解析失败-------:\n%@",layerItem);
	}
	
	return clickView;
}

//	==================可移动图片 =======================
+ (id)loadMoveableImage:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory{
	MoveableImageView *moveView = nil;
	
	//image
	UIImage *image = [layerItem getImageForKey:@"image" resDirectory:resDirectory];
	
	//frame
	CGRect rc = [layerItem getRectForKey:@"frame" fromImage:image];

	if (image && CGRectGetWidth(rc)>0 && CGRectGetHeight(rc)>0){
		int repeatCount = [[layerItem objectForKey:@"repeatCount"] intValue];
		double duration = [[layerItem objectForKey:@"duration"] floatValue];
		BOOL  autoReverses = [[layerItem objectForKey:@"autoReverses"] boolValue];
		int  timingFunction = [[layerItem objectForKey:@"timingFunction"] intValue];
		
		NSString *moveViewAudioName = [layerItem objectForKey:@"audio"];
		NSString *moveViewAudioPath = [resDirectory stringByAppendingPathComponent:moveViewAudioName];

		moveView = [[[MoveableImageView alloc] initWithImage:image] autorelease];
		moveView.frame = rc;
		moveView.repeatCountValue = repeatCount;
		moveView.durationValue = duration;
		moveView.autoReversesValue = autoReverses;
		moveView.timingFunctionValue = timingFunction;
		moveView.movableImageViewAudioPath = moveViewAudioPath;

		//fromValue
		CGPoint fromValue = CGPointZero;
		NSString *fromValueString = [layerItem objectForKey:@"fromValue"];
		if (fromValueString) {
			fromValue = CGPointFromString(fromValueString);
		}else {
			fromValue = rc.origin;
		}
		fromValue.x += CGRectGetWidth(rc)/2;
		fromValue.y += CGRectGetHeight(rc)/2;
		moveView.fromValue = fromValue;
		
		//toValue
		CGPoint toValue = CGPointZero;
		NSString *toValueString = [layerItem objectForKey:@"toValue"];
		if (toValueString) {
			toValue = CGPointFromString(toValueString);
		}else {
			toValue = rc.origin;
		}
		toValue.x += CGRectGetWidth(rc)/2;
		toValue.y += CGRectGetHeight(rc)/2;
		moveView.toValue = toValue;
		
	}else{
		WriteLog(@"loadMoveableImage ----------解析失败-------:\n%@",layerItem);
	}
	
	return moveView;
}
	
//	================== 动画=======================
+ (id)loadAnimationImage:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory{
	AnimationView *animationView = nil;
	
	//frame
	CGRect rc = [layerItem getRectForKey:@"frame"];
	
	//images
	NSArray *animationImages = [layerItem getImagesForKey:@"images" resDirectory:resDirectory];
	if ([animationImages count]>0){
		UIImage *firstImage = [animationImages objectAtIndex:0];
		
		if (rc.size.width == -1){
			rc.size.width = firstImage.size.width;
		}
		if (rc.size.height == -1){
			rc.size.height = firstImage.size.height;
		}
		
		
		if (CGRectGetWidth(rc)>0 && CGRectGetHeight(rc)>0){
			NSNumber *repeatCountValue = [layerItem objectForKey:@"repeatCount"];
			int repeatCount = (repeatCountValue?[repeatCountValue intValue] : ANIMATION_REPEATCOUNT_DEFAULT);
			if (repeatCount <= 0){
				repeatCount = 1;
			}
			
			NSNumber *durationValue = [layerItem objectForKey:@"duration"];
			float duration = (durationValue?[durationValue floatValue] : ANIMATION_DURATION_DEFAULT);
			
			NSNumber *intervalValue = [layerItem objectForKey:@"interval"];
			float interval = (intervalValue?[intervalValue floatValue] : ANIMATION_INTERVAL_DEFAULT);
			
			NSNumber *perodicValue = [layerItem objectForKey:@"perodic"];
			int perodic = (perodicValue?[perodicValue intValue] : ANIMATION_PERODIC_DEFAULT);
			if (perodic <= 0) {
				perodic = 0;
			}
			
			BOOL autoStart = NO;
			NSNumber *autoStartValue = [layerItem objectForKey:@"autoStart"];
			if (autoStartValue) {
				autoStart = [autoStartValue boolValue];
			}else {
				NSNumber *startAtOnceValue = [layerItem objectForKey:@"startAtOnce"];//兼容旧版本配置
				if (startAtOnceValue) {
					autoStart = [startAtOnceValue boolValue];
				}
			}
			
			float autoStartDelayTime = [[layerItem objectForKey:@"autoStartDelayTime"] floatValue];
			
			BOOL stopAtLastFrame = [[layerItem objectForKey:@"stopAtLastFrame"] boolValue];
			int  performCount = [[layerItem objectForKey:@"performCount"] intValue];
			if (performCount < 1) {
				performCount = -1;
			}
			
			
			//audios
			NSArray	*audios = [layerItem objectForKey:@"audios"];
			NSMutableArray *animationAudioPathArray = [NSMutableArray array];
			if (audios) {
				for (NSString *audioName in audios) {
					NSString *audioPath = [resDirectory stringByAppendingPathComponent:audioName];
					[animationAudioPathArray addObject:audioPath];
				}
			}else {//audio
				NSString	*audioName = [layerItem objectForKey:@"audio"];
				if (audioName) {
					NSString	*audioPath = [resDirectory stringByAppendingPathComponent:audioName];
					[animationAudioPathArray addObject:audioPath];
				}
			}
			
			NSString *clickRectString = [layerItem objectForKey:@"clickRect"];
			CGRect	clickRect = CGRectFromString(clickRectString);
			
			int tag = [[layerItem objectForKey:@"tag"] intValue];
			
			animationView = [[[AnimationView alloc] initWithFrame:rc] autorelease];
			animationView.animationImages = animationImages;
			animationView.animationCycleAnimatingCount = repeatCount;
			animationView.animationCycleAnimatingDuration = duration;
			animationView.animationCycleSleepDuration = interval;
			animationView.animationCycleCount = perodic;
			animationView.autoStart = autoStart;
			animationView.setLastFrameAfterAnimating = stopAtLastFrame;
			animationView.clickRect = clickRect;
			
			if ([animationAudioPathArray count]>0) {
				animationView.soundEffectSouces = animationAudioPathArray;
			}
			
			animationView.performCount = performCount;
			
			if (autoStartDelayTime>0) {
				animationView.autoStartDelayTime = autoStartDelayTime;
			}
			
			//默认图
			NSString *imageName = [layerItem objectForKey:@"image"];
			UIImage *image = nil;
			if (imageName) {
				NSString *imagePath = [resDirectory stringByAppendingPathComponent:imageName];
				image = [[UIImage alloc] initWithContentsOfFileEx:imagePath];
				if (image) {
					animationView.animationOriginImage = image;
					[image release];
				}
			}else {//兼容旧版本配置
				BOOL visible = [[layerItem objectForKey:@"visible"] boolValue];
				if (visible) {
					animationView.animationOriginImage = firstImage;
				}
			}
			
			if (tag>0) {
				[animationView setTag:tag];
			}
		}else{
			WriteLog(@"loadAnimationImage ----------解析失败-------:\n%@",layerItem);
		}
	}else{
		WriteLog(@"loadAnimationImage ----------解析失败-------:\n%@",layerItem);
	}
	
	return animationView;
}

//	================== 按钮 =======================
+ (id)loadButton:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory{
	CustomButton *btn = nil;
	
	//image
	UIImage *normalImage = [layerItem getImageForKey:@"normalImage" resDirectory:resDirectory];
	UIImage *downlImage = [layerItem getImageForKey:@"downImage" resDirectory:resDirectory];
	UIImage *disableImage = [layerItem getImageForKey:@"disableImage" resDirectory:resDirectory];
    
	//frame
	CGRect rc = [layerItem getRectForKey:@"frame" fromImage:normalImage];

	if (CGRectGetWidth(rc)>0 && CGRectGetHeight(rc)>0){
		//highlight
		BOOL highlight = [[layerItem objectForKey:@"highlight"] boolValue];
		btn = [CustomButton buttonWithType:UIButtonTypeCustom];
		btn.frame = rc;
		//action
		btn.tag = [[layerItem objectForKey:@"action"] intValue];
		//disable
		//btn.enabled = ![[layerItem objectForKey:@"disable"] boolValue];
		
		[btn setImage:normalImage forState:UIControlStateNormal];
		[btn setImage:downlImage forState:UIControlStateHighlighted];
		[btn setImage:disableImage forState:UIControlStateDisabled];
		
		//fontSize
		NSNumber *fontSizeValue = [layerItem objectForKey:@"fontSize"];
		if (fontSizeValue) {
			btn.titleLabel.font = [UIFont boldSystemFontOfSize:[fontSizeValue intValue]];
		}
		
		//title
		NSString *title = [layerItem objectForKey:@"title"];
		if (title) {
			[btn setTitle:title forState:UIControlStateNormal]; 
		}
		
		//openPagePlist
		NSString *openPagePlist = [layerItem objectForKey:@"openPagePlist"];
		if (openPagePlist) {
			[btn setOpenPagePlist:openPagePlist];
		}
		
		//closePageTag
		NSNumber *closePageTagValue = [layerItem objectForKey:@"closePageTag"];
		if (closePageTagValue && [closePageTagValue intValue]>0) {
			[btn setClosePageTag:[closePageTagValue intValue]];
		}
		
		//exclusive
		NSNumber *exclusiveValue = [layerItem objectForKey:@"exclusive"];
		if (exclusiveValue) {
			[btn setIsExclusive:[exclusiveValue boolValue]];
		}
		
		//highlight
		if (highlight){
			btn.showsTouchWhenHighlighted = YES;
		}
		
		//isEnabled
		NSNumber *isEnabledValue = [layerItem objectForKey:@"isEnabled"];
		if (isEnabledValue) {
			[btn setEnabled:[isEnabledValue boolValue]];
		}
		
		//autoClick
		NSNumber *autoClickValue = [layerItem objectForKey:@"autoClick"];
		if (autoClickValue) {
			[btn setAutoClick:[autoClickValue boolValue]];
		}
		
		// Link to the page by index
		NSNumber *pageIndex = [layerItem objectForKey:@"pageIndex"];
		if (pageIndex)
		{
			[btn setPageIndex:[pageIndex intValue]];
		}
		
		btn.exclusiveTouch = YES;
	}else{
		WriteLog(@"loadButton ----------解析失败-------:\n%@",layerItem);
	}
	
	return btn;
}
	
//	================== 勾选框 =======================
+ (id)loadCheckButton:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory{
	UICheckButton *checkBtn = nil;
	
	//image
	UIImage *uncheckImage = [layerItem getImageForKey:@"uncheckImage" resDirectory:resDirectory];
	UIImage *checkImage = [layerItem getImageForKey:@"checkImage" resDirectory:resDirectory];

	//frame
	CGRect rc = [layerItem getRectForKey:@"frame" fromImage:uncheckImage];

	if (CGRectGetWidth(rc)>0 && CGRectGetHeight(rc)>0 && uncheckImage && checkImage){
		checkBtn = [[[UICheckButton alloc] initWithCheckImage:checkImage UncheckImage:uncheckImage] autorelease];
		checkBtn.frame = rc;
		checkBtn.tag = [[layerItem objectForKey:@"action"] intValue];
	}else{
		WriteLog(@"loadCheckButton ----------解析失败-------:\n%@",layerItem);
	}
	
	return checkBtn;
}

//	================== 分段控件 =======================
+ (id)loadSegment:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory{
	SegmentView *segmentView = nil;
	
	//images
	NSArray *images = [layerItem getImagesForKey:@"images" resDirectory:resDirectory];
	int imagesCount = [images count];
	//actions
	NSMutableArray	*actions =  [layerItem objectForKey:@"actions"];
	if (imagesCount>1 && nil == actions) {
		actions = [NSMutableArray array];
		for (int i=0; i<imagesCount; i++) {
			[actions addObject:[NSNumber numberWithInt:i]];
		}
	}
	int actionsCount = [actions count];
	if (imagesCount == actionsCount && actionsCount>1){
		UIImage *firstImage = [images objectAtIndex:0];

		//frame
		CGRect rc = [layerItem getRectForKey:@"frame" fromImage:firstImage];

		if (CGRectGetWidth(rc)>0 && CGRectGetHeight(rc)>0){
			int tag = [[layerItem objectForKey:@"tag"] intValue];
			int style = [[layerItem objectForKey:@"style"] intValue];
			int action = -1;
			if ([layerItem objectForKey:@"action"]) {
				action = [[layerItem objectForKey:@"action"] intValue];
			}
            BOOL repeatClick = [[layerItem objectForKey:@"repeatClick"] boolValue];
			
			segmentView = [[[SegmentView alloc] initWithFrame:rc Style:(SegmentViewStyle)style] autorelease];
			segmentView.images = images;
			segmentView.actions = actions;
			segmentView.action = action;
			segmentView.tag = tag;
            segmentView.enableRepeatClick = repeatClick;
			[segmentView initializeData];

		}else{
			WriteLog(@"loadSegment ----------解析失败-------:\n%@",layerItem);
		}
	}else{
		WriteLog(@"loadSegment ----------解析失败-------:\n%@",layerItem);
	}
	
	return segmentView;
}

//	================== 可点击音频 =======================
+ (id)loadAudioView:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory{
	AudioView *audioView = nil;
	
	//clickRect
	CGRect rc = [layerItem getRectForKey:@"clickRect"];
	
	//tag
	int tag = [[layerItem objectForKey:@"tag"] intValue];

	NSString *audioName = [layerItem objectForKey:@"audio"];
	NSString *audioPath = [resDirectory   stringByAppendingPathComponent:audioName];
	BOOL isDirectory = YES;

	if ([[NSFileManager defaultManager] fileExistsAtPath:audioPath isDirectory:&isDirectory] && !isDirectory && CGRectGetWidth(rc)>0 && CGRectGetHeight(rc)>0){
		audioView = [[[AudioView alloc] initWithFrame:rc audioPath:audioPath] autorelease];
		
		if (tag>0) {
			[audioView setTag:tag];
		}
	}else{
		WriteLog(@"loadAudioView ----------解析失败-------:\n%@",layerItem);
	}
	
	return audioView;
}

//	================== 书本图标 =======================
//+ (id)loadBookIcon:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory{
//	BookImageView *imageView = nil;
//	
//	//free
//	BOOL free = [[layerItem objectForKey:@"free"] boolValue];
//	
//	//BookIcon
//	NSString *imageName = nil;
//	NSDictionary *bookIconInfo = [layerItem objectForKey:@"BookIcon"];
//
//	NSString *path1 = [RES_DIRECTORY stringByStandardizingPath];
//	NSString *path2 = [resDirectory stringByStandardizingPath];
//	if (NSOrderedSame == [path1 caseInsensitiveCompare:path2]) {//书架资源，语言按照设备语言
//		imageName = [bookIconInfo getValueWithLanguageType:[BookManager getAppLanguage]];
//	}else {//非书架资源
//		imageName = [bookIconInfo getValueWithLanguageType:[BookManager sharedInstance].languageType];
//	}
//	NSString *imagePath = [resDirectory stringByAppendingPathComponent:imageName];
//	UIImage *image = [[UIImage alloc] initWithContentsOfFileEx:imagePath];
//	
//	//frame
//	CGRect rc = [layerItem getRectForKey:@"frame" fromImage:image];
//
//	if (CGRectGetWidth(rc)>0 && CGRectGetHeight(rc)>0 && image){
//		imageView = [[[BookImageView alloc] initWithImage:image] autorelease];
//		imageView.frame = rc;
//		imageView.bookInfo = layerItem;
//
//		if (!free){
//			//lock
//			NSDictionary *lockInfo = [layerItem objectForKey:@"Lock"];
//			UIImage *lockImage = [lockInfo getImageForKey:@"image" resDirectory:resDirectory];
//			if (lockImage) {
//				UIImageView *lockView = [[UIImageView alloc] initWithImage:lockImage];
//				[imageView addSubview:lockView];
//				[lockView release];
//		
//				//frame
//				CGRect lockRect = [lockInfo getRectForKey:@"frame" fromImage:lockImage];
//				[lockView setFrame:lockRect];
//			}
//		}
//	}else{
//		WriteLog(@"loadBookIcon ----------解析失败-------:\n%@",layerItem);
//	}
//	
//	[image release];
//	
//	return imageView;
//}

//	================== 旋转图片 =======================
+ (id)loadRotationView:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory{
	RotationImageView *rotationView = nil;
	
	//image
	UIImage *image = [layerItem getImageForKey:@"image" resDirectory:resDirectory];
	
	//frame
	CGRect rc = [layerItem getRectForKey:@"frame" fromImage:image];

	if (image && CGRectGetWidth(rc)>0 && CGRectGetHeight(rc)>0){
		NSDictionary *xInfo = [layerItem objectForKey:@"X"];
		NSDictionary *yInfo = [layerItem objectForKey:@"Y"];
		NSDictionary *zInfo = [layerItem objectForKey:@"Z"];
		
		int repeatCount = [[layerItem objectForKey:@"repeatCount"] intValue];
		double duration = [[layerItem objectForKey:@"duration"] floatValue];
		BOOL autoReverses = [[layerItem objectForKey:@"autoReverses"] boolValue];
		int timingFunction = [[layerItem objectForKey:@"timingFunction"] intValue];
		int fillMode = [[layerItem objectForKey:@"fillMode"] intValue];
		
		BOOL removedOnCompletionValue = YES;
		id removedOnCompletion = [layerItem objectForKey:@"removedOnCompletion"];
		if (removedOnCompletion)
		{
			removedOnCompletionValue = [removedOnCompletion boolValue];
		}
		
		rotationView = [[[RotationImageView alloc] initWithImage:image] autorelease];
		rotationView.repeatCountValue = repeatCount;
		rotationView.durationValue = duration;
		rotationView.autoReversesValue = autoReverses;
		rotationView.timingFunctionValue = timingFunction;
		rotationView.fillModeValue = fillMode;
		rotationView.removedOnCompletionValue = removedOnCompletionValue;
		rotationView.xAxis = xInfo;
		rotationView.yAxis = yInfo;
		rotationView.zAxis = zInfo;
		rotationView.frame = rc;
	}else{
		WriteLog(@"loadRotationView ----------解析失败-------:\n%@",layerItem);
	}
	
	return rotationView;
}

//	================== 滑动条 =======================
+ (id)loadSlider:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory{
	UISlider *slider = nil;
	
	//frame
	CGRect rc = [layerItem getRectForKey:@"frame"];
	
	if (CGRectGetWidth(rc)>0 && CGRectGetHeight(rc)>0){
		//left
		UIImage *leftImage = [layerItem getImageForKey:@"leftImage" resDirectory:resDirectory];
		//right
		UIImage *rightImage = [layerItem getImageForKey:@"rightImage" resDirectory:resDirectory];
		//center
		UIImage *centerImageNormal = [layerItem getImageForKey:@"centerImageNormal" resDirectory:resDirectory];
		UIImage *centerImageDown = [layerItem getImageForKey:@"centerImageDown" resDirectory:resDirectory];
		
		slider = [[[UISlider alloc] initWithFrame:rc] autorelease];

		//action
		slider.tag = [[layerItem objectForKey:@"action"] intValue];
		
		if (leftImage) {
			[slider setMinimumTrackImage:leftImage forState:UIControlStateNormal];
		}
		
		if (rightImage) {
			[slider setMaximumTrackImage:rightImage forState:UIControlStateNormal];
		}
		
		if (centerImageNormal) {
			[slider setThumbImage: centerImageNormal forState:UIControlStateNormal];
		}
		
		if (centerImageDown) {
			[slider setThumbImage: centerImageDown forState:UIControlStateHighlighted];
		}
		
		slider.minimumValue = 0.0;
		slider.maximumValue = 1.0;
		slider.continuous = YES;//微调 czg
	}else{
		WriteLog(@"loadSlider ----------解析失败-------:\n%@",layerItem);
	}
	
	return slider;
}

//	================== 页面指示器 =======================
+ (id)loadPageIndicator:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory{
	CustomUIPageControl *pageControl = nil;
	
	//frame
	CGRect rc = [layerItem getRectForKey:@"frame"];
	if (CGRectGetWidth(rc)>0 && CGRectGetHeight(rc)>0){
		//normalImage
		UIImage *normalImage = [layerItem getImageForKey:@"normalImage" resDirectory:resDirectory];
		
		//highlightImage
		UIImage *highlightImage = [layerItem getImageForKey:@"highlightImage" resDirectory:resDirectory];
		
		//numberOfPages
		int numberOfPages = [[layerItem objectForKey:@"numberOfPages"] intValue];
		
		
		pageControl = [[[CustomUIPageControl alloc] initWithFrame:rc] autorelease];
		
		if (normalImage){
			[pageControl setImagePageStateNormal:normalImage];
		}
		
		if (highlightImage) {
			[pageControl setImagePageStateHighlighted:highlightImage];
		}
		
		if (numberOfPages>0) {
			[pageControl setNumberOfPages:numberOfPages];
		}
	}else{
		WriteLog(@"loadPageIndicator ----------解析失败-------:\n%@",layerItem);
	}
	
	return pageControl;
}

//	================== 切换器 =======================
+ (id)loadMultiSwitch:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory{
	MultiSwitchView *multiSwitch = nil;
	
	//images
	NSArray *images = [layerItem getImagesForKey:@"images" resDirectory:resDirectory];
	int imagesCount = [images count];
	
	//actions
	NSMutableArray	*actions =  [layerItem objectForKey:@"actions"];
	if (imagesCount>0 && nil == actions) {
		actions = [NSMutableArray array];
		for (int i=0; i<imagesCount; i++) {
			[actions addObject:[NSNumber numberWithInt:i]];
		}
	}
	int actionsCount = [actions count];
	
	if (imagesCount == actionsCount && actionsCount>0){
		UIImage *firstImage = [images objectAtIndex:0];
		
		//frame
		CGRect rc = [layerItem getRectForKey:@"frame" fromImage:firstImage];
		
		if (CGRectGetWidth(rc)>0 && CGRectGetHeight(rc)>0){
			UIImage *image = [layerItem getImageForKey:@"image" resDirectory:resDirectory];
			int tag = [[layerItem objectForKey:@"tag"] intValue];
			int action = -1;
			if ([layerItem objectForKey:@"action"]) {
				action = [[layerItem objectForKey:@"action"] intValue];
			}

			multiSwitch = [[[MultiSwitchView alloc] initWithFrame:rc] autorelease];
			multiSwitch.image = image;
			multiSwitch.images = images;
			multiSwitch.actions = actions;
			multiSwitch.action = action;
			multiSwitch.tag = tag;
			
		}else{
			WriteLog(@"loadMultiSwitch ----------解析失败-------:\n%@",layerItem);
		}
	}else{
		WriteLog(@"loadMultiSwitch ----------解析失败-------:\n%@",layerItem);
	}

	return multiSwitch;
}

//	================== 文本框（单） =======================
//+ (id)loadTextWord:(NSDictionary*)layerItem resDirectory:(NSString*)resDirectory{
//	WordContentView *label = nil;
//
//	CGRect rt = CGRectFromString([layerItem objectForKey:@"frame"]);
//	label = [[[WordContentView alloc] initWithFrame:rt wordInfo:layerItem resDirectory:resDirectory] autorelease];
//	
//	return label;
//}

//	==================可滚动的静态图=======================
+ (id)loadScrollImage:(NSDictionary *)layerItem resDirectory:(NSString *)resDirectory
{
	UIScrollView *scrollView=nil;
	
	UIImageView *imageView = [LayerParser loadStaticImage:layerItem resDirectory:resDirectory];
	if (!imageView) {
		WriteLog(@"loadScrollImage ----------解析失败-------:\n%@",layerItem);
		return nil;
	}
	CGSize szImage=imageView.frame.size;
	CGRect rc = [layerItem getRectForKey:@"scrollFrame" fromImage:imageView.image];
	
	if (CGRectGetWidth(rc)>0 && CGRectGetHeight(rc)>0){
		
		scrollView = [[[UIScrollView alloc] initWithFrame:rc] autorelease];
		scrollView.contentSize = CGSizeMake(szImage.width, szImage.height);
		scrollView.pagingEnabled = YES;

		scrollView.backgroundColor = [UIColor clearColor];
		scrollView.userInteractionEnabled=YES;
		[scrollView addSubview:imageView];
		
		CGRect frameImage=imageView.frame;
		frameImage.origin.x-=rc.origin.x;
		frameImage.origin.y-=rc.origin.y;
		imageView.frame=frameImage;
	}else{
		WriteLog(@"loadScrollImage ----------解析失败-------:\n%@",layerItem);
	}
	
	return scrollView;
}

//	==================可拖动图片=======================
+ (id)loadDragableImage:(NSDictionary *)layerItem resDirectory:(NSString *)resDirectory
{
	DragableImageView *imageView =nil;
	
	UIImage *image = [layerItem getImageForKey:@"image" resDirectory:resDirectory];
	
	CGRect rt = [layerItem getRectForKey:@"frame" fromImage:image];
	imageView.frame =rt;
	imageView = [[[DragableImageView alloc] initWithFrame:rt] autorelease];
	[imageView setOriginalFrame:rt];
	imageView.image = image;
	
	imageView.destRect = CGRectFromString([layerItem objectForKey:@"destRect"]);
	imageView.destRectExt = CGRectFromString([layerItem objectForKey:@"destRectExt"]);
	
	// 声音
	NSString *audioName = [layerItem objectForKey:@"audio"];
	NSString *audioPath = [resDirectory stringByAppendingPathComponent:audioName];
	imageView.dragViewAudioPath = audioPath;
	
	// 拖动正确发出的声音
	NSString *rightAudioName = [layerItem objectForKey:@"rightAudio"];
	NSString *rightAudioPath = [resDirectory stringByAppendingPathComponent:rightAudioName];
	imageView.rightAudioPath = rightAudioPath;
	
	// 拖动错误发出的声音
	NSString *wrongAudioName = [layerItem objectForKey:@"wrongAudio"];
	NSString *wrongAudioPath = [resDirectory stringByAppendingPathComponent:wrongAudioName];
	imageView.wrongAudioPath = wrongAudioPath;
	
	// 加入动画支持
	NSArray *animationImages = [layerItem getImagesForKey:@"images" resDirectory:resDirectory];
	if ([animationImages count] > 0)
	{
		CGFloat duration = [[layerItem objectForKey:@"duration"] floatValue];
		imageView.animationImages = animationImages;
		imageView.image = [animationImages objectAtIndex:0];
		imageView.animationDuration = duration;
		imageView.animationRepeatCount = 0;
		imageView.hasAnimation = YES;
	}
	
	//destImage
	UIImage *destImage = [layerItem getImageForKey:@"destImage" resDirectory:resDirectory];
	if (destImage)
	{
		imageView.destImage = destImage;
		CGRect sz=imageView.destRect;
		if (sz.size.width==-1) {
			sz.size.width=destImage.size.width;
		}
		if (sz.size.height==-1) {
			sz.size.height=destImage.size.height;
		}
		imageView.destRect=sz;
	}
	
	BOOL isShake = [[layerItem objectForKey:@"isShake"] boolValue];
	imageView.isShake = isShake;
	
	BOOL isLastObject = [[layerItem objectForKey:@"lastObject"] boolValue];
	imageView.isLastObject = isLastObject;
	
	int index = [[layerItem objectForKey:@"index"] intValue];
	imageView.index = index;
	
	return imageView;
}

/**
 * Add by lh 2011/10/09
 * 可点击图片
 * 点击可以产生多种效果
 * 点击播放声音，点击产生选中效果，点击产生放大效果等等
 */
//+ (id)loadClickableImageView:(NSDictionary *)layerItem resDirectory:(NSString *)resDirectory
//{
//	ClickableImageView *imageView = nil;
//	
//	CGRect frame = CGRectFromString([layerItem objectForKey:@"frame"]);
//	imageView = [[[ClickableImageView alloc] initWithFrame:frame] autorelease];
//	
//	// Image
//	UIImage *image = [layerItem getImageForKey:@"image" resDirectory:resDirectory];
//	if (image)
//	{
//		imageView.image = image;
//	}
//	
//	// Audio
//	NSString *audioName = [layerItem objectForKey:@"audio"];
//	NSString *audioPath = [resDirectory stringByAppendingPathComponent:audioName];
//	if ([audioPath isFile])
//	{
//		imageView.audioPath = audioPath;
//	}
//	
//	// Right audio
//	NSString *rightAudioName = [layerItem objectForKey:@"rightAudio"];
//	NSString *rightAudioPath = [resDirectory stringByAppendingPathComponent:rightAudioName];
//	if ([rightAudioPath isFile])
//	{
//		imageView.rightAudioPath = rightAudioPath;
//	}
//	
//	// Wrong audio
//	NSString *wrongAudioName = [layerItem objectForKey:@"wrongAudio"];
//	NSString *wrongAudioPath = [resDirectory stringByAppendingPathComponent:wrongAudioName];
//	if ([wrongAudioPath isFile])
//	{
//		imageView.wrongAudioPath = wrongAudioPath;
//	}
//	
//	// 刚开始是否能点击
//	if ([[layerItem objectForKey:@"disclickedAtStart"] boolValue])
//	{
//		imageView.disclickedAtStart = YES;
//	}
//	
//	// 是否会自动播放声音
//	if ([[layerItem objectForKey:@"autoPlay"] boolValue])
//	{
//		imageView.autoPlay = YES;
//	}
//	
//	// 是否有选择动画
//	NSDictionary *select = [layerItem objectForKey:@"select"];
//	if ([select count])
//	{
//		AnimationView *animationView = [LayerParser parseLayerItem:select resDirectory:resDirectory];
//		imageView.animationSelect = animationView;
//	}
//	
//	// 是否点击播放声音
//	if ([layerItem objectForKey:@"clickedPlayAudio"])
//	{
//		imageView.clickedPlayAudio = YES;
//	}
//	
//	// 是否点击产生选中效果
//	if ([layerItem objectForKey:@"clickedSelect"])
//	{
//		imageView.clickedSelect = YES;
//	}
//	
//	// 是否点击产生放大效果
//	if ([layerItem objectForKey:@"clickedScale"])
//	{
//		imageView.clickedScale = YES;
//	}
//	
//	NSNumber *tag = [layerItem objectForKey:@"tag"];
//	imageView.tag = [tag intValue];
//	
//	return imageView;
//}

+ (id)loadPopoverView:(NSDictionary *)layerItem resDirectory:(NSString *)resDirectory{
	BBPopoverView *popoverView = nil;
	
	NSArray *images = [layerItem getImagesForKey:@"images" resDirectory:resDirectory];
	NSArray	*actions =  [layerItem objectForKey:@"actions"];
	int imagesCount = [images count];
	int actionsCount = [actions count];
	if (imagesCount == actionsCount && actionsCount>1){
		//frame
		CGRect rc = [layerItem getRectForKey:@"frame" fromImage:[images objectAtIndex:0]];
		
		if (CGRectGetWidth(rc)>0 && CGRectGetHeight(rc)>0){
			//staticPanelImage
			UIImage *staticPanelImage = [layerItem getImageForKey:@"staticPanelImage" resDirectory:resDirectory];
			//highlightImage
			UIImage *dynamicPanelImage = [layerItem getImageForKey:@"dynamicPanelImage" resDirectory:resDirectory];
			//direction
			BOOL isDownDirection = [[layerItem objectForKey:@"direction"] boolValue];
			
			//tag
			int tag = [[layerItem objectForKey:@"tag"] intValue];
			
			popoverView = [[[BBPopoverView alloc] initWithFrame:rc superViewBounds:rc direction:isDownDirection] autorelease];
			popoverView.images = images;
			popoverView.staticPanelImage = staticPanelImage;
			popoverView.dynamicPanelImage = dynamicPanelImage;
			popoverView.actions = actions;
			popoverView.tag = tag;
			
			//action
			NSNumber *actionValue = [layerItem objectForKey:@"action"];
			if (actionValue) {
				popoverView.action = [actionValue intValue];
			}
			
			//initializeData
			if (![popoverView initializeData]) {
				popoverView = nil;
				WriteLog(@"loadPopoverView ----------解析失败-------:\n%@",layerItem);
			}
	
		}else{
			WriteLog(@"loadPopoverView ----------解析失败-------:\n%@",layerItem);
		}
	}else{
		WriteLog(@"loadPopoverView ----------解析失败-------:\n%@",layerItem);
	}
	
	return popoverView;
}

+ (id)loadScrollView:(NSDictionary *)layerItem resDirectory:(NSString *)resDirectory{
	BBScrollView	*scrollView = nil;
	
	CGRect rc = [layerItem getRectForKey:@"frame"];
	if (CGRectGetWidth(rc)>0 && CGRectGetHeight(rc)>0){
		scrollView = [[[BBScrollView alloc] initWithFrame:rc dataSource:layerItem resDirectory:resDirectory] autorelease];
	}
	
	return scrollView;
}

//BooksCoverFlow
//+ (id)loadBooksCoverFlow:(NSDictionary *)layerItem resDirectory:(NSString *)resDirectory{
//    BooksCoverFlow  *booksCoverFlow = nil;
//    
//    CGRect rc = [layerItem getRectForKey:@"frame"];
//	if (CGRectGetWidth(rc)>0 && CGRectGetHeight(rc)>0){
//		booksCoverFlow = [[[BooksCoverFlow alloc] initWithFrame:rc dataSource:layerItem resDirectory:resDirectory] autorelease];
//	}
//	
//	return booksCoverFlow;
//}

@end
