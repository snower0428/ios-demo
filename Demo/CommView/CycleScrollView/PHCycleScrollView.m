//
//  PHCycleScrollView.m
//  PandaHome
//
//  Created by lei hui on 13-2-27.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PHCycleScrollView.h"

@interface PHCycleScrollView()
- (void)stopAutoScroll;
- (void)loadData;
- (void)getDisplayImagesWithCurpage:(int)page;
- (int)validPageValue:(NSInteger)value;
@end

@implementation PHCycleScrollView

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize currentPage = _curPage;
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize hidePageControl = _hidePageControl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        CGRect rect = self.bounds;
        rect.origin.y = rect.size.height - 30;
        rect.size.height = 30;
        _pageControl = [[UIPageControl alloc] initWithFrame:rect];
        _pageControl.userInteractionEnabled = NO;
        [self addSubview:_pageControl];
        
        _hidePageControl = NO;
        _curPage = 0;
    }
    return self;
}

- (void)setHidePageControl:(BOOL)hidePageControl
{
    _hidePageControl = hidePageControl;
    if (_hidePageControl) {
        _pageControl.hidden = YES;
    } else {
        _pageControl.hidden = NO;
    }
}

- (void)setAutoScrollInterval:(CGFloat)time
{
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}

- (void)stopAutoScroll
{
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)onTimer:(NSTimer *)timer
{
    CGPoint pt = _scrollView.contentOffset;
//    if(pt.x == _scrollView.frame.size.width * (_totalPages-1)) {
//        //        [_scrollView setContentOffset:CGPointMake(0, 0)];
//        [_scrollView scrollRectToVisible:CGRectMake(0,0,320,80) animated:YES];
//    } else {
        [_scrollView scrollRectToVisible:CGRectMake(pt.x+320,0,320,80) animated:YES];
//    }
}

- (void)setDataSource:(id<PHCycleScrollViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadData];
}

- (void)reloadData
{
    _totalPages = [_dataSource numberOfPages];
    if (_totalPages == 0) {
        return;
    }
    _pageControl.numberOfPages = _totalPages;
    [self loadData];
}

- (void)loadData
{
    _pageControl.currentPage = _curPage;
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [_scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:_curPage];
    
    for (int i = 0; i < 3; i++) {
        UIView *v = [_curViews objectAtIndex:i];
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [v addGestureRecognizer:singleTap];
        [singleTap release];
        v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
        [_scrollView addSubview:v];
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

- (void)getDisplayImagesWithCurpage:(int)page
{
    int pre = [self validPageValue:_curPage-1];
    int last = [self validPageValue:_curPage+1];
    
    if (!_curViews) {
        _curViews = [[NSMutableArray alloc] init];
    }
    
    [_curViews removeAllObjects];
    
    [_curViews addObject:[_dataSource pageAtIndex:pre]];
    [_curViews addObject:[_dataSource pageAtIndex:page]];
    [_curViews addObject:[_dataSource pageAtIndex:last]];
}

- (int)validPageValue:(NSInteger)value
{
    
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    
    return value;
    
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [_delegate didClickPage:self atIndex:_curPage];
    }
    
}

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
{
    if (index == _curPage) {
        [_curViews replaceObjectAtIndex:1 withObject:view];
        for (int i = 0; i < 3; i++) {
            UIView *v = [_curViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTap:)];
            [v addGestureRecognizer:singleTap];
            [singleTap release];
            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
            [_scrollView addSubview:v];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    int x = aScrollView.contentOffset.x;
    
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        _curPage = [self validPageValue:_curPage+1];
        [self loadData];
    }
    
    //往上翻
    if(x <= 0) {
        _curPage = [self validPageValue:_curPage-1];
        [self loadData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
}

#pragma mark - dealloc

- (void)dealloc
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    [_scrollView release];
    [_pageControl release];
    [_curViews release];
    [super dealloc];
}

@end
