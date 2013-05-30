//
//  DragableImageView.h
//  ImageConnect
//
//  Created by Hui.Lei on 11-8-1.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  DragableImageViewDelegate;
@interface DragableImageView : UIImageView
{
	CGPoint			m_startPoint;		// 开始点
	CGPoint			m_startFrame;		// 开始矩形左上角点
	CGRect          m_destRect;			// 最终区域
	CGRect			m_destRectExt;		// 最终区域扩展(用来扩大周边区域范围)
	
	id				m_target;
	SEL				m_action;
	UIImage			*m_destImage;
	
	NSString		*m_dragViewAudioPath;	// 点击播放音频的路径
	NSString		*m_rightAudioPath;		// 正确的声音路径
	NSString		*m_wrongAudioPath;		// 错误的声音路径
	BBAudioPlayer	*m_dragViewPlayer;
	
	BOOL			m_isShake;				// 是否可以抖动
	NSTimer			*m_timer;
	
	BOOL			m_isRight;				// 是否拖到正确的位置
	BOOL			m_isLastObject;			// 是否是一组里最后一个对象
	int				m_index;
	BOOL			m_isDragableDisabled;	// 拖动是否被禁掉(就是不能拖)
	BOOL			m_hasAnimation;			// 是否具有动画
	
	//czg
	CGRect m_frameOriginal;	
	UIImage *m_imageOriginal;
	id<DragableImageViewDelegate> m_delegate;
}
@property (nonatomic, assign) id<DragableImageViewDelegate> delegate;
@property (nonatomic, assign) CGRect destRect;
@property (nonatomic, assign) CGRect destRectExt;

@property (nonatomic, retain) UIImage *destImage;
@property (nonatomic, getter=m_isRight)     BOOL isRight;
@property (nonatomic, assign) BOOL isShake;
@property (nonatomic, assign) BOOL isLastObject;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) BOOL isDragableDisabled;
@property (nonatomic, assign) BOOL hasAnimation;

@property (nonatomic, retain) NSString *dragViewAudioPath;
@property (nonatomic, retain) NSString *rightAudioPath;
@property (nonatomic, retain) NSString *wrongAudioPath;

- (void)addTarget:(id)target action:(SEL)action;
- (void)reset;
- (void)setOriginalFrame:(CGRect)rt;
- (void)sound;
- (void)stopAudio;
- (void)moveUpAndDown;

@end

@protocol DragableImageViewDelegate<NSObject>
@optional
- (void)dragableImageStart:(DragableImageView *)dragable;
- (void)dragableImageViewClicked:(DragableImageView *)dragable;
@end