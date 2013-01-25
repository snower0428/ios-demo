//
//  BBPopoverView.h
//  Test
//
//  Created by zhangtianfu on 11-10-26.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BBPopoverView : UIView {
	int m_index;
	int	m_count;
	int m_tag;
	int	m_action;
	NSArray	*m_actions;
	NSArray	*m_images;
	
	BOOL	m_downDirection;
	BOOL	m_isPopover;
	id		m_target;
	SEL		m_selector;
	
	UIImageView		*m_dynamicPanel;
	UIImageView		*m_staticPanel;
	UIImage			*m_staticPanelImage;
	UIImage			*m_dynamicPanelImage;
	UIButton		*m_btn;
}

@property(nonatomic, assign)	int				action;
@property(nonatomic, retain)	UIImage			*staticPanelImage; //静态面板图
@property(nonatomic, retain)	UIImage			*dynamicPanelImage; //动态面板图
@property(nonatomic, retain)	NSArray			*images; //分段图片数组
@property(nonatomic, retain)	NSArray			*actions; //事件

- (id)initWithFrame:(CGRect)frame superViewBounds:(CGRect)superViewBounds direction:(BOOL)isDown;
- (BOOL)initializeData;
- (void)addTarget:(id)target action:(SEL)selector;

@end
