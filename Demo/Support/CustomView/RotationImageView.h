//
//  RotationImageView.h
//  BabyBooks
//
//  Created by zhangtianfu on 11-3-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//	============  旋转图片（未正式使用，预留）	================

#import <UIKit/UIKit.h>

@protocol RotationImageViewDelegate;

@interface RotationImageView : UIImageView {
	int		m_repeatCount;
	double	m_duration;
	BOOL	m_autoReverses;
	int		m_timingFunction;
	int		m_fillModeValue;
	BOOL	m_removedOnCompletionValue;
	
	NSDictionary *m_xAxis;
	NSDictionary *m_yAxis;
	NSDictionary *m_zAxis;
    
    BOOL    m_rotationFinished;
    id <RotationImageViewDelegate>      m_delegate;
}

@property(nonatomic)  int repeatCountValue;	// 重复次数
@property(nonatomic)  double durationValue;	//	一次持续事件
@property(nonatomic)  BOOL autoReversesValue;//	是否逆转
@property(nonatomic)  int timingFunctionValue;//动画变化类型
@property(nonatomic)  int fillModeValue;
@property(nonatomic)  BOOL removedOnCompletionValue;
@property(nonatomic, retain)  NSDictionary* xAxis;	//x轴参数（初始角度fromAngle、目标角度toAngle，持续时间duration）
@property(nonatomic, retain)  NSDictionary* yAxis;	//y轴参数
@property(nonatomic, retain)  NSDictionary* zAxis;	//z轴参数
@property(nonatomic, assign)  BOOL rotationFinished;
@property(nonatomic, assign)  id <RotationImageViewDelegate> delegate;

//	开始旋转
- (void)startRotation;

//	停止旋转
- (void)stopRotation;

@end

@protocol RotationImageViewDelegate <NSObject>

@optional

- (void)rotationImageViewFinished:(RotationImageView *)rotationImageView;

@end
