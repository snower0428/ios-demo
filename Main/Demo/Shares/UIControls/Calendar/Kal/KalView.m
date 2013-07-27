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

@interface KalView ()
- (void)addSubviewsToHeaderView:(UIView *)headerView;
- (void)addSubviewsToContentView:(UIView *)contentView;
- (void)setHeaderTitleText:(NSString *)text;
@end

static const CGFloat kHeaderHeight = 66.f;
static const CGFloat kMonthLabelHeight = 17.f;

@implementation KalView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic style:(KalTileStyle)theStyle
{
    if ((self = [super initWithFrame:frame])) {
        delegate = theDelegate;
        logic = [theLogic retain];
        [logic addObserver:self forKeyPath:@"selectedMonthNameAndYear" options:NSKeyValueObservingOptionNew context:NULL];
        style = theStyle;
        
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.layer.cornerRadius = 5.0;
        self.clipsToBounds = YES;
        
        // 日历背景
        CGRect blackBgFrame = CGRectMake(0, 0, self.frame.size.width, kHeaderHeight);
        UIImageView *imageViewBlackBg = [[[UIImageView alloc] initWithFrame:blackBgFrame] autorelease];
        imageViewBlackBg.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        [self addSubview:imageViewBlackBg];
        
        CGRect whiteBgFrame = CGRectMake(0, kHeaderHeight-25, self.frame.size.width, self.frame.size.height - (kHeaderHeight-25));
        UIImageView *imageViewWhiteBg = [[[UIImageView alloc] initWithFrame:whiteBgFrame] autorelease];
        imageViewWhiteBg.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.35];
        [self addSubview:imageViewWhiteBg];
        
        UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, kHeaderHeight)] autorelease];
        headerView.backgroundColor = [UIColor clearColor];
        [self addSubviewsToHeaderView:headerView];
        [self addSubview:headerView];
        
        UIView *contentView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, kHeaderHeight, frame.size.width, frame.size.height - kHeaderHeight)] autorelease];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self addSubviewsToContentView:contentView];
        [self addSubview:contentView];
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
    if (!gridView.transitioning)
        [delegate showPreviousMonth];
}

- (void)showFollowingMonth
{
    if (!gridView.transitioning)
        [delegate showFollowingMonth];
}

- (void)addSubviewsToHeaderView:(UIView *)headerView
{
//    const CGFloat kChangeMonthButtonWidth = 46.0f;
//    const CGFloat kChangeMonthButtonHeight = 30.0f;
//    const CGFloat kMonthLabelWidth = 200.0f;
//    const CGFloat kHeaderVerticalAdjust = 12.f;
#if 0
    // 上一个月按钮
    CGRect previousMonthButtonFrame = CGRectMake(self.left, kHeaderVerticalAdjust, kChangeMonthButtonWidth, kChangeMonthButtonHeight);
    UIButton *previousMonthButton = [[UIButton alloc] initWithFrame:previousMonthButtonFrame];
    [previousMonthButton setImage:[UIImage imageNamed:@"Kal.bundle/vaccine_btn_prev.png"] forState:UIControlStateNormal];
    [previousMonthButton setImage:[UIImage imageNamed:@"Kal.bundle/vaccine_btn_prev_d.png"] forState:UIControlStateSelected];
    previousMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    previousMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [previousMonthButton addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:previousMonthButton];
#endif
    // 年月:如2012年11月
    CGRect monthLabelFrame = CGRectMake(0, 0, self.frame.size.width, 40);
    _labelTitle = [[UILabel alloc] initWithFrame:monthLabelFrame];
    _labelTitle.backgroundColor = [UIColor clearColor];
    _labelTitle.font = [UIFont boldSystemFontOfSize:18];
    _labelTitle.textColor = [UIColor whiteColor];
    _labelTitle.textAlignment = UITextAlignmentCenter;
    [headerView addSubview:_labelTitle];
    [self setHeaderTitleText:[logic selectedMonthNameAndYear]];
#if 0
    // 下一个月按钮
    CGRect nextMonthButtonFrame = CGRectMake(self.width - kChangeMonthButtonWidth, kHeaderVerticalAdjust, kChangeMonthButtonWidth, kChangeMonthButtonHeight);
    UIButton *nextMonthButton = [[UIButton alloc] initWithFrame:nextMonthButtonFrame];
    [nextMonthButton setImage:[UIImage imageNamed:@"Kal.bundle/vaccine_btn_next.png"] forState:UIControlStateNormal];
    [nextMonthButton setImage:[UIImage imageNamed:@"Kal.bundle/vaccine_btn_next_d.png"] forState:UIControlStateSelected];
    nextMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    nextMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [nextMonthButton addTarget:self action:@selector(showFollowingMonth) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:nextMonthButton];
#endif
    // Add column labels for each weekday (adjusting based on the current locale's first weekday)
//    NSArray *weekdayNames = [[[[NSDateFormatter alloc] init] autorelease] shortWeekdaySymbols];
    NSArray *fullWeekdayNames = [[[[NSDateFormatter alloc] init] autorelease] standaloneWeekdaySymbols];
//    NSUInteger firstWeekday = [[NSCalendar currentCalendar] firstWeekday];
//    NSUInteger i = firstWeekday - 1;
    
    NSArray *array = [NSArray arrayWithObjects:_(@"Sun"), _(@"Mon"), _(@"Tue"), _(@"Wed"), _(@"Thu"), _(@"Fri"), _(@"Sat"), nil];
    
    for (int i = 0; i < 7; i++) {
        CGRect weekdayFrame = CGRectMake(6+i*38.2f, 41.f, 38.2f, kHeaderHeight - 41.f);
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
        weekdayLabel.backgroundColor = [UIColor clearColor];
        weekdayLabel.font = [UIFont boldSystemFontOfSize:12.5];
        weekdayLabel.textAlignment = UITextAlignmentCenter;
        weekdayLabel.textColor = [UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1.0];
//        weekdayLabel.textColor = [UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:1.f];
//        weekdayLabel.shadowColor = [UIColor whiteColor];
//        weekdayLabel.shadowOffset = CGSizeMake(0.f, 1.f);
        weekdayLabel.text = [array objectAtIndex:i];
        [weekdayLabel setAccessibilityLabel:[fullWeekdayNames objectAtIndex:i]];
        [headerView addSubview:weekdayLabel];
        [weekdayLabel release];
    }
}

- (void)addSubviewsToContentView:(UIView *)contentView
{
    CGRect fullWidthAutomaticLayoutFrame = CGRectMake(6.f, 2.f, self.width, 0.f);
    
    // The tile grid (the calendar body)
    gridView = [[KalGridView alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:delegate style:style];
    [gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [contentView addSubview:gridView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == gridView && [keyPath isEqualToString:@"frame"]) {
        // This observer method will be called when gridView's height changes
    } else if ([keyPath isEqualToString:@"selectedMonthNameAndYear"]) {
        [self setHeaderTitleText:[change objectForKey:NSKeyValueChangeNewKey]];
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
    
    _labelTitle.text = [NSString stringWithFormat:@"%d - %02d", year, month];
}

- (void)jumpToSelectedMonth
{
    [gridView jumpToSelectedMonth];
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

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    _startPoint = point;
    
    [[self superview] bringSubviewToFront:self];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //计算位移=当前位置-起始位置
    CGPoint point = [[touches anyObject] locationInView:self];
    float dx = point.x - _startPoint.x;
    float dy = point.y - _startPoint.y;
    
    //计算移动后的view中心点
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    
    
    /* 限制用户不可将视图托出屏幕 */
    float halfx = CGRectGetMidX(self.bounds);
    //x坐标左边界
    newcenter.x = MAX(halfx, newcenter.x);
    //x坐标右边界
    newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
    
    //y坐标同理
    float halfy = CGRectGetMidY(self.bounds);
    newcenter.y = MAX(halfy, newcenter.y);
    newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);
    
    //移动view
    self.center = newcenter;
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc
{
    [logic removeObserver:self forKeyPath:@"selectedMonthNameAndYear"];
    [logic release];
    
    [gridView removeObserver:self forKeyPath:@"frame"];
    [gridView release];
    
    [super dealloc];
}

@end
