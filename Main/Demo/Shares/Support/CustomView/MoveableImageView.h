//
//  MoveableImageView.h
//  BabyBooks
//
//  Created by zhangtianfu on 11-3-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//	============  可移动的图片（还未正式使用，预留）	================

#import <UIKit/UIKit.h>


@interface MoveableImageView : UIImageView {
	int		m_repeatCount;
	double	m_duration;
	BOOL	m_autoReverses;
	int		m_timingFunction;
	CGPoint	m_fromValue;
	CGPoint	m_toValue;
    double  m_delayTime;
	
	NSString		*m_movableImageViewAudioPath;
	BBAudioPlayer	*m_movableImageViewPlayer;
}

@property(nonatomic)  int		repeatCountValue;	//	重复次数
@property(nonatomic)  double	durationValue;		//	一次的持续事件
@property(nonatomic)  BOOL		autoReversesValue;	//	是否逆转
@property(nonatomic)  int		timingFunctionValue;//	动画变化类型
@property(nonatomic)  CGPoint	fromValue;			//	初始值
@property(nonatomic)  CGPoint	toValue;			//	目标值
@property(nonatomic)  double    delayTime;          //  延迟时间
@property(nonatomic, retain) NSString *movableImageViewAudioPath;

// 开始运动
- (void)startMovement; 

//	停止运动
- (void)stopMovement;

@end


#if 0//*配置实例
<dict>
	<key>type</key>
	<integer>2</integer>

	<key>frame</key>
	<string>{{-1024,0},{-1,-1}}</string>

	<key>image</key>
	<string>cover/yun.png</string>

	<key>repeatCount</key>
	<integer>-1</integer>

	<key>timingFunction</key>
	<integer>0</integer>

	<key>fromValue</key>
	<string>{0,384}</string>

	<key>toValue</key>
	<string>{1024,384}</string>

	<key>autoReverses</key>
	<false/>

	<key>duration</key>
	<real>100</real>
</dict>
#endif
