//
//  CustomUIPageControl.h
//  Test
//
//  Created by zhangtianfu on 11-5-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//	============  页面指示器（可以自定义指示器图片）	================

#import <UIKit/UIKit.h>



@interface CustomUIPageControl : UIPageControl{
	UIImage *imagePageStateNormal;
	UIImage *imagePageStateHighlighted;
}

- (id)initWithFrame:(CGRect)frame;

@property (nonatomic, retain) UIImage *imagePageStateNormal;		//	指示器正常态
@property (nonatomic, retain) UIImage *imagePageStateHighlighted;	//	指示器高亮态

@end

