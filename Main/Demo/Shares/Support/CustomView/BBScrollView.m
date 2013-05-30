//
//  BBScrollView.m
//  BabyBooks
//
//  Created by zhangtianfu on 11-12-5.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import "BBScrollView.h"


@implementation BBScrollView


- (id)initWithFrame:(CGRect)frame dataSource:(NSDictionary*)dataSource resDirectory:(NSString*)resDirectory{
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		
		m_dataSource = [dataSource retain];
		m_resDirectory = [resDirectory retain];
		[self performSelector:@selector(initData)];
	}
	
	return self;
}

- (void)initData{
	//BackgroundImage
	NSString *bgName = [m_dataSource objectForKey:@"BackgroundImage"];
	NSString *bgPath = [m_resDirectory stringByAppendingPathComponent:bgName];
	if ([bgPath isFile]){
		m_bgImage = [[UIImage alloc] initWithContentsOfFileEx:bgPath];
	}else{
		if (bgName){
			NSLog(@"BackgroundImage====%@",bgPath);
		}
	}
	
	//pageIndex
	NSNumber *pageIndexValue = [m_dataSource objectForKey:@"pageIndex"];
	m_pageIndex = [pageIndexValue intValue];
	if (m_pageIndex < 0) {
		m_pageIndex = 0;
	}
	
	NSArray	*scrollPagesSource = [m_dataSource objectForKey:@"scrollPages"];
	//pageCount
	m_pageCount = [scrollPagesSource count];
	
	
	//ScrollView
	m_scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
	m_scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds)*m_pageCount, CGRectGetHeight(self.bounds));
	m_scrollView.pagingEnabled = YES;
	m_scrollView.scrollEnabled = YES;
	m_scrollView.showsHorizontalScrollIndicator = NO;
	m_scrollView.showsVerticalScrollIndicator = NO;
	m_scrollView.delegate = self;
	m_scrollView.backgroundColor = [UIColor clearColor];
	[self addSubview:m_scrollView];
	[m_scrollView release];
	
	//pageItems
	for (int i=0; i<m_pageCount; i++) {
		NSArray *pageSource = [scrollPagesSource objectAtIndex:i];
		NSArray *pageLayer = [LayerParser parseLayers:pageSource resDirectory:m_resDirectory];
		
		for (id item in pageLayer){
			if (item != (id)[NSNull null]){
				[m_scrollView addSubview:item];
				
				//设置子view的相对坐标
				CGRect itemFrame = [item frame];
				itemFrame.origin.x	=	itemFrame.origin.x - self.frame.origin.x + i*CGRectGetWidth(self.bounds);
				itemFrame.origin.y	-=	self.frame.origin.y;
				[item setFrame:itemFrame];
			}
		}
	}
	
	//pageIndicator
	NSDictionary *pageIndicatorSource = [m_dataSource objectForKey:@"pageIndicator"];
	UIPageControl	*pageControl =  [LayerParser loadPageIndicator:pageIndicatorSource resDirectory:m_resDirectory];
	if (pageControl) {
		CGRect frame = [pageControl frame];
		frame.origin.x	-=	self.frame.origin.x;
		frame.origin.y	-=	self.frame.origin.y;
		[pageControl setFrame:frame];
		
		pageControl.numberOfPages = m_pageCount;
		[self addSubview:pageControl];
		m_pageControl = pageControl;
		[m_pageControl performSelector:@selector(updateDots)];
	}
}

- (void)addTarget:(id)target{
	m_target = target;
	
	for (id item in m_scrollView.subviews) {
		//注册响应事件
		if ([item isKindOfClass:[UIButton class]]){
			[item addTarget:m_target action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
		}else if ([item isMemberOfClass:[SegmentView class]]){
			[item addTarget:m_target action:@selector(clickSegment:)];
		}else if ([item isMemberOfClass:[BookImageView class]]) {
			[item addTarget:m_target action:@selector(clickBookImage:)];
		}
	}
}

#pragma mark --------------UIScrollViewDelegate-------------------

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (!decelerate) {
		[self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:scrollView];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{	
	int currentIndex = scrollView.contentOffset.x / m_scrollView.bounds.size.width;
	if (m_pageIndex != currentIndex) {
		m_pageIndex = currentIndex;

		[NSObject cancelPreviousPerformRequestsWithTarget:self];
		
		//设置页码
		m_pageControl.currentPage = currentIndex;
		[m_pageControl performSelector:@selector(updateDots)];
	}
}


- (void)drawRect:(CGRect)rect{
	if (m_bgImage) {
		[m_bgImage drawInRect:rect];
	}
}

- (void)dealloc {
	[m_resDirectory release];
	[m_dataSource release];
	[m_bgImage release];
    [super dealloc];
}


@end
