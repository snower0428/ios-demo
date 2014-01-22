/*
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalView.h"
#import "KalGridView.h"
#import "KalLogic.h"
#import "KalPrivate.h"
#import "KalDate.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Category.h"
#import <CoreImage/CoreImage.h>
#import "UIColor+Expanded.h"
#import "KalSkinManager.h"
#import "UIImage+Category.h"
#import "UIButton+Additions.h"

#define kHeaderViewTag          2000
#define kWeekdayViewTag         2001
#define kMonthViewTag           2002
#define kWeekdayLabelBaseTag    2100

const NSInteger kalViewFrameTag = 13579;

static const int kDaysOfOneWeek = 7;

@interface KalView ()
{
    BOOL    _isInDiyMode;
}

- (void)addSubviewsToHeaderView:(UIView *)headerView;
- (void)addSubviewsToContentView:(UIView *)contentView;
- (void)setHeaderTitleText:(NSString *)text;

@end

static CGFloat kHeaderHeight = 65.f;
//static const CGFloat kMonthLabelHeight = 17.f;

@implementation KalView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic style:(KalTileStyle)theStyle
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        delegate = theDelegate;
        logic = [theLogic retain];
        [logic addObserver:self forKeyPath:@"selectedMonthNameAndYear" options:NSKeyValueObservingOptionNew context:NULL];
        style = theStyle;
        
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        if (_isInDiyMode) {
            self.layer.cornerRadius = 6*kScaleFactor;
            self.clipsToBounds = NO;
        }
        
        // ==================================================
        //
        // 日历背景
        //
#if 0
        CGRect headerFrame = CGRectMake(0, 0, self.frame.size.width, kHeaderHeight*kScaleFactor);
        UIImageView *header = [[[UIImageView alloc] initWithFrame:headerFrame] autorelease];
        header.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        header.tag = kHeaderViewTag;
        [self addSubview:header];
        
        CGFloat weekdayHeight = 25.f;
        CGRect weekdayFrame = CGRectMake(0, headerFrame.size.height-weekdayHeight*kScaleFactor, self.frame.size.width, weekdayHeight*kScaleFactor);
        UIImageView *weekday = [[[UIImageView alloc] initWithFrame:weekdayFrame] autorelease];
        weekday.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.25];
        weekday.tag = kWeekdayViewTag;
        [self addSubview:weekday];
        
        CGRect monthFrame = CGRectMake(0, headerFrame.size.height, self.frame.size.width, self.frame.size.height-headerFrame.size.height);
        UIImageView *month = [[[UIImageView alloc] initWithFrame:monthFrame] autorelease];
        month.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.25];
        month.tag = kMonthViewTag;
        [self addSubview:month];
#endif
        //
        // ==================================================
        //
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, kHeaderHeight*kScaleFactor)];
        headerView.backgroundColor = [UIColor clearColor];
        [self addSubviewsToHeaderView:headerView];
        [self addSubview:headerView];
        [headerView release];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, kHeaderHeight*kScaleFactor, frame.size.width, frame.size.height - kHeaderHeight*kScaleFactor)];
        contentView.backgroundColor = [UIColor clearColor];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self addSubviewsToContentView:contentView];
        [self addSubview:contentView];
        [contentView release];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic
{
    self = [self initWithFrame:frame delegate:theDelegate logic:theLogic style:KalTileStyleSolar];
    if (self) {
        //
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    [NSException raise:@"Incomplete initializer" format:@"KalView must be initialized with a delegate and a KalLogic. Use the initWithFrame:delegate:logic: method."];
    return nil;
}

- (void)resetMonthView
{
    CGRect monthFrame = CGRectMake(0, kHeaderHeight*kScaleFactor, self.frame.size.width, self.frame.size.height - kHeaderHeight*kScaleFactor);
    UIImageView *month = (UIImageView *)[self viewWithTag:kMonthViewTag];
    if (month) {
        month.frame = monthFrame;
    }
}

- (void)changeSkinWithType:(KalSkinType)type
{
    [[KalSkinManager shareInstance] setSkinType:type];
    
    // Header
    UIImageView *header = (UIImageView *)[self viewWithTag:kHeaderViewTag];
    if (header) {
        header.backgroundColor = [KalSkinManager shareInstance].headerBgColor;
    }
    [_btnTitle setTitleColor:[KalSkinManager shareInstance].headerTitleColor forState:UIControlStateNormal];
    
    // Weekday
    UIImageView *weekday = (UIImageView *)[self viewWithTag:kWeekdayViewTag];
    if (weekday) {
        weekday.backgroundColor = [KalSkinManager shareInstance].weekdayBgColor;
    }
    
    for (int i = 0; i < kDaysOfOneWeek; i++) {
        UILabel *weekdayLabel = (UILabel *)[self viewWithTag:kWeekdayLabelBaseTag+i];
        if (weekdayLabel) {
            weekdayLabel.textColor = [KalSkinManager shareInstance].weekdayColor;
        }
    }
    
    // Month
    UIImageView *month = (UIImageView *)[self viewWithTag:kMonthViewTag];
    if (month) {
//        month.backgroundColor = [KalSkinManager shareInstance].monthBgColor;
        UIImage *image = [UIImage imageWithColor:[KalSkinManager shareInstance].monthBgColor];
        month.image = image;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeSkinNotification object:nil];
}

- (void)redrawEntireMonth
{
    [self jumpToSelectedMonth];
}

- (void)slideDown
{
    [gridView slideDown];
}

- (void)slideUp
{
    [gridView slideUp];
}

- (void)showPreviousMonth
{
    if (!gridView.transitioning) {
        if (delegate && [delegate respondsToSelector:@selector(showPreviousMonth)]) {
            [delegate showPreviousMonth];
        }
    }
}

- (void)showFollowingMonth
{
    if (!gridView.transitioning) {
        if (delegate && [delegate respondsToSelector:@selector(showFollowingMonth)]) {
            [delegate showFollowingMonth];
        }
    }
}

- (void)addSubviewsToHeaderView:(UIView *)headerView
{
    CGFloat headerWidth = headerView.frame.size.width;
    CGFloat monthWidth = 150.f;
    CGFloat monthHeight = headerView.frame.size.height*0.6;
    CGFloat btnWidth = monthHeight;
    CGRect monthFrame = CGRectMake((headerWidth-monthWidth)/2, 0, monthWidth, monthHeight);
    
    // 年月:如2012年11月
    __block __typeof(delegate) theDelegate = delegate;
    _btnTitle = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _btnTitle.frame = monthFrame;
    _btnTitle.backgroundColor = [UIColor clearColor];
    _btnTitle.titleLabel.font = [UIFont boldSystemFontOfSize:18*kScaleFactor];
    [_btnTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [headerView addSubview:_btnTitle];
    [self setHeaderTitleText:[logic selectedMonthNameAndYear]];
    [_btnTitle handleControlEvents:UIControlEventTouchUpInside withBlock:^{
        if (theDelegate && [theDelegate respondsToSelector:@selector(showMonthPicker)]) {
            [theDelegate showMonthPicker];
        }
    }];
    
    if (_isInDiyMode) {
        // 在DIY模式下
        _btnTitle.enabled = NO;
    }
    else {
        // 上一个月
        __block __typeof(self) _self = self;
        UIButton *btnPrev = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPrev.frame = CGRectMake(monthFrame.origin.x-btnWidth, 0, btnWidth, btnWidth);
        [btnPrev setImage:[[UIImageManager shareInstance] imageWithFileName:@"Calendar/left_arrow.png"] forState:UIControlStateNormal];
        [headerView addSubview:btnPrev];
        [btnPrev handleControlEvents:UIControlEventTouchUpInside withBlock:^{
            [_self showPreviousMonth];
        }];
        
        // 下一个月
        UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
        btnNext.frame = CGRectMake(monthFrame.origin.x+monthWidth, 0, btnWidth, btnWidth);
        [btnNext setImage:[[UIImageManager shareInstance] imageWithFileName:@"Calendar/right_arrow.png"] forState:UIControlStateNormal];
        [headerView addSubview:btnNext];
        [btnNext handleControlEvents:UIControlEventTouchUpInside withBlock:^{
            [_self showFollowingMonth];
        }];
    }
    
    // 周日，周一，周二。。。
    NSArray *fullWeekdayNames = [[[[NSDateFormatter alloc] init] autorelease] standaloneWeekdaySymbols];
    NSArray *array = [NSArray arrayWithObjects:__(@"Sun"), __(@"Mon"), __(@"Tue"), __(@"Wed"), __(@"Thu"), __(@"Fri"), __(@"Sat"), nil];
    CGFloat left = 6.0*kScaleFactor;
    CGFloat width = 38.2*kScaleFactor;
    CGFloat height = headerView.frame.size.height*0.4;
    for (int i = 0; i < kDaysOfOneWeek; i++) {
        CGRect weekdayFrame = CGRectMake(left+i*width, monthHeight, width, height);
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
        weekdayLabel.backgroundColor = [UIColor clearColor];
        weekdayLabel.tag = kWeekdayLabelBaseTag+i;
        weekdayLabel.font = [UIFont boldSystemFontOfSize:12*kScaleFactor];
        weekdayLabel.textAlignment = UITextAlignmentCenter;
        weekdayLabel.textColor = [UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1.0];
        weekdayLabel.text = [array objectAtIndex:i];
        [weekdayLabel setAccessibilityLabel:[fullWeekdayNames objectAtIndex:i]];
        [headerView addSubview:weekdayLabel];
        [weekdayLabel release];
    }
}

- (void)addSubviewsToContentView:(UIView *)contentView
{
    CGFloat left = 6.0*kScaleFactor;
    CGFloat top = 2.0*kScaleFactor;
    CGRect fullWidthAutomaticLayoutFrame = CGRectMake(left, top, self.width, 0.f);
    
    // The tile grid (the calendar body)
    gridView = [[KalGridView alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:delegate style:style mode:_isInDiyMode];
    [gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [contentView addSubview:gridView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == gridView && [keyPath isEqualToString:@"frame"]) {
        // This observer method will be called when gridView's height changes
//        NSLog(@"gridView's height changes, %@", NSStringFromCGRect(gridView.frame));
    } else if ([keyPath isEqualToString:@"selectedMonthNameAndYear"]) {
        [self setHeaderTitleText:[change objectForKey:NSKeyValueChangeNewKey]];
//        NSLog(@"gridView.frame:%@", NSStringFromCGRect(gridView.frame));
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

// 设置年月：如2011年11月
- (void)setHeaderTitleText:(NSString *)text
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"LLLL yyyy"];
    NSDate *date = [formatter dateFromString:text];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:date];
    
    NSInteger year = components.year;
    NSInteger month = components.month;
    
    [formatter release];
    
    NSString *strTitle = [NSString stringWithFormat:@"%d - %02d", year, month];
    [_btnTitle setTitle:strTitle forState:UIControlStateNormal];
}

- (void)jumpToSelectedMonth
{
    [gridView jumpToSelectedMonth];
}

- (KalGridView *)gridView
{
    return gridView;
}

- (void)selectDate:(KalDate *)date
{
    [gridView selectDate:date];
}

- (BOOL)isSliding
{
    return gridView.transitioning;
}

- (void)markTilesForDates:(NSArray *)dates
{
    [gridView markTilesForDates:dates];
}

- (KalDate *)selectedDate
{
    return gridView.selectedDate;
}

#pragma mark - Touch

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isInDiyMode) {
        [super touchesMoved:touches withEvent:event];
    }
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc
{
    [logic removeObserver:self forKeyPath:@"selectedMonthNameAndYear"];
    [logic release];
    
    [gridView removeObserver:self forKeyPath:@"frame"];
    [gridView release];
    
    [_btnTitle release];
    
    [super dealloc];
}

@end
