//
//  MultiSwitchView.h
//  BabyBooks
//
//  Created by zhangtianfu on 11-5-24.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//
//	============  多功能开关（UISwitch的扩展）	================

#import <UIKit/UIKit.h>


@interface MultiSwitchView : UIView {
	NSArray			*m_images;
	UIImage		    *m_bgImage;
	int				m_index;
	int				m_count;
	id				m_target;
	SEL				m_selector;
}


@property(nonatomic, retain)	UIImage			*image;//	背景图(一般不用)
@property(nonatomic, retain)	NSArray			*images;//	每个开关层对应的元素
@property(nonatomic, retain)	NSArray				*actions; //事件数组
@property(nonatomic, assign)	int					action;	//当前索引对应的事件

- (void)addTarget:(id)target action:(SEL)action;



@end



