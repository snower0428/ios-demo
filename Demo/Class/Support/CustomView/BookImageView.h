//
//  BookImageView.h
//  BabyBooks
//
//  Created by zhangtianfu on 11-1-18.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//
//	============  书架图标（点击有放大效果，可保存书本信息）	================

#import <UIKit/UIKit.h>


@interface BookImageView : UIImageView {
	NSDictionary				*m_bookInfo;
	BOOL				m_isAnmating;
	
	id				m_target;
	SEL				m_action;
}

@property(nonatomic, retain)	NSDictionary				*bookInfo;	//	书本信息接口（详见配置文档）

- (void)addTarget:(id)target action:(SEL)action;	//	处理点击书本事件

@end


