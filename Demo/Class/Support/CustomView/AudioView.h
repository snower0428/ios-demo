//
//  AudioView.h
//  BabyBooks
//
//  Created by zhangtianfu on 11-1-21.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//
//	============  可点击的音频 	================

#import <UIKit/UIKit.h>


@interface AudioView : UIView{
	BBAudioPlayer	*m_audio;
	CGRect			m_clickRect;
	NSString		*m_audioPath;
}

@property(nonatomic, readonly)   BBAudioPlayer	*audio;
@property(nonatomic, assign)  CGRect	clickRect;	

- (id)initWithFrame:(CGRect)frame audioPath:(NSString*)path;
- (void)play;
- (void)pause;
- (void)stop;
- (BOOL)isPlaying;

@end
