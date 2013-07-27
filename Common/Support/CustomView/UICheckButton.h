//
//  UICheckButton.h
//  Test
//
//  Created by zhangtianfu on 10-3-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//	============  勾选框	================

#import <UIKit/UIKit.h>


@protocol  UICheckButtonDelegate;

@interface UICheckButton : UIView{
	bool m_check;
	UIImage *m_checkImage;
	UIImage *m_uncheckImage;
	id<UICheckButtonDelegate> m_delegate;
	
	UIButton	*m_btn;
}

@property(nonatomic, setter = setCheck:) bool check; // 勾选状态
@property(nonatomic, retain) UIImage *checkImage;	// 勾选图片
@property(nonatomic, retain) UIImage *uncheckImage;	// 未勾选图片
@property(nonatomic, assign) id<UICheckButtonDelegate> delegate;
@property(nonatomic, getter=isEnabled, setter=setEnabled:) BOOL	enabled;

- (id)initWithCheckImage:(UIImage *)checkImage UncheckImage:(UIImage *)uncheckImage;

//	设置勾选状态
- (void)setCheck:(bool)check; 

@end


@protocol  UICheckButtonDelegate<NSObject>
- (void)checkButtonChange:(UICheckButton*)checkBtn; // 勾选框点击变化的代理
@end