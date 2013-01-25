//
//  Galleries2dView.h
//  Gallery
//
//  Created by zhangtianfu on 11-11-4.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol Galleries2dViewDelegate;



@interface Galleries2dView : UIView {
	int		m_count;
	float	m_interval;
	int		m_centerImageIndex;
	int		m_centerPositionIndex;
	
	CGSize	m_gridSize;
	CGSize	m_centerGridSize;
	
	NSMutableArray	*m_positionIndexs;
	NSMutableArray	*m_positionRects;
	NSMutableArray	*m_gridImages;
	NSMutableArray	*m_gridViews;
	
	BOOL	m_touching;
	BOOL	m_isSingleTap;
	CGPoint	m_firstTouchPt;
	
	id<Galleries2dViewDelegate>	m_delegate;
}


@property(nonatomic, assign)	CGSize	gridSize;			//网格大小
@property(nonatomic, assign)	CGSize	centerGridSize;		//中心网格的大小
@property(nonatomic, assign)	int		centerIndex;		//中心网格的图片索引
@property(nonatomic, assign)	float	interval;			//每个网格的间距
@property(nonatomic, retain)	NSMutableArray	*gridImages;

@property(nonatomic, assign)	id<Galleries2dViewDelegate>	delegate;

@end

@protocol Galleries2dViewDelegate <NSObject>
@optional
- (void)galleries2dView:(Galleries2dView *)galleries2dView selectionDidChange:(int)index;
- (void)galleries2dView:(Galleries2dView *)galleries2dView imageSelected:(int)index;
@end
