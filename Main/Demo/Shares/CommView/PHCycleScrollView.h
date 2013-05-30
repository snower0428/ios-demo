//
//  PHCycleScrollView.h
//  PandaHome
//
//  Created by lei hui on 13-2-27.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PHCycleScrollViewDelegate;
@protocol PHCycleScrollViewDataSource;

@interface PHCycleScrollView : UIView<UIScrollViewDelegate>
{
    id<PHCycleScrollViewDelegate>       _delegate;
    id<PHCycleScrollViewDataSource>     _dataSource;
    
    UIScrollView        *_scrollView;
    UIPageControl       *_pageControl;
    
    NSInteger           _totalPages;
    NSInteger           _curPage;
    
    NSMutableArray      *_curViews;
    
    BOOL                _hidePageControl;
    NSTimer             *_timer;
}

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) UIPageControl *pageControl;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign, setter = setDataSource:) id<PHCycleScrollViewDataSource> dataSource;
@property (nonatomic, assign, setter = setDelegate:) id<PHCycleScrollViewDelegate> delegate;
@property (nonatomic, assign) BOOL hidePageControl;

- (void)reloadData;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;

- (void)setAutoScrollInterval:(CGFloat)time;
- (void)stopAutoScroll;

@end

//
//PHCycleScrollViewDelegate
//
@protocol PHCycleScrollViewDelegate <NSObject>
@optional

- (void)didClickPage:(PHCycleScrollView *)csView atIndex:(NSInteger)index;

@end

//
//PHCycleScrollViewDataSource
//
@protocol PHCycleScrollViewDataSource <NSObject>
@required

- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;

@end