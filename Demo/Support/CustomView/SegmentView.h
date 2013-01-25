//
//  SegmentView.h
//
//  Created by zhangtianfu on 11-1-19.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum
{
	SegmentViewStyleHorizontal = 0, //	水平分段
	SegmentViewStyleVertical   = 1,	// 垂直分段
}SegmentViewStyle;

@interface SegmentView : UIView {
	SegmentViewStyle	m_style;
	
	int				m_index;
	int				m_count;
	int				m_action;
	NSArray			*m_actions;
	NSArray			*m_images;
	NSMutableArray	*m_btns;
	UIImage		    *m_bgImage;

	id				m_target;
	SEL				m_selector;
    
    BOOL            m_enableRepeatClick;
    BOOL            m_enabled;
}


@property(nonatomic,readonly)	SegmentViewStyle    style;
@property(nonatomic, retain)	UIImage				*image;	// 背景图（一般不用）
@property(nonatomic, retain)	NSArray				*images; //分段图片数组
@property(nonatomic, retain)	NSArray				*actions; //事件数组
@property(nonatomic, assign)	int					action;	//当前索引对应的事件
@property(nonatomic, assign)	BOOL			enableRepeatClick;	//重复点击
@property(nonatomic, assign)    BOOL            enabled;

- (id)initWithFrame:(CGRect)frame Style:(SegmentViewStyle)style;
- (void)addTarget:(id)target action:(SEL)action;
- (BOOL)initializeData;

@end





