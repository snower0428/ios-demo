//
//  CustomButton.h
//  BabyBooks
//
//  Created by zhangtianfu on 11-9-2.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomButton : UIButton {
	NSString *m_openPagePlist;
	int		m_closePageTag;
	BOOL	m_isExclusive;
	BOOL	m_autoClick;
	int		m_pageIndex;	// 点击按钮打开指定页面的索引
}

@property(nonatomic, retain)	NSString *openPagePlist;
@property(nonatomic, assign)	int		closePageTag;
@property(nonatomic, assign)	BOOL	isExclusive;
@property(nonatomic, assign)	BOOL	autoClick;
@property(nonatomic, assign)	int		pageIndex;

@end
