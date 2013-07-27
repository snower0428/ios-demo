//
//  KalCalendarViewCtrl.m
//  PandaHome
//
//  Created by leihui on 13-7-5.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "KalCalendarViewCtrl.h"
#import "KalLogic.h"
#import "KalDate.h"
#import "KalPrivate.h"
//#import "PHUIImagesView.h"
//#import "UIImage+Category.h"
//#import "FTAnimation.h"

#define kPreviewViewTag     1000

typedef enum
{
    CalendarActionSolar   = 100,
    CalendarActionLunar,
    CalendarActionSolarAndLunar,
}CalendarAction;

@interface KalCalendarViewCtrl ()

@property (nonatomic, retain, readwrite) NSDate *initialDate;
@property (nonatomic, retain, readwrite) NSDate *selectedDate;

- (void)initCalendarContainer;
- (void)initBottomBar;
- (void)initMonthPicker;
- (void)initStyleContainer;
- (void)initTapGesture;

- (KalView *)calendarView;
- (void)createKalView:(KalTileStyle)style;
- (void)createKalView:(KalTileStyle)theStyle date:(NSDate *)date;
- (void)createKalViewWithFrame:(CGRect)frame style:(KalTileStyle)theStyle date:(NSDate *)date;
- (void)setNavStyle;
- (void)restoreNavStyle;
- (void)showMonthPicker;
- (void)hideMonthPicker;
- (void)showCalendarStyle:(BOOL)bShow;

@end

@implementation KalCalendarViewCtrl

@synthesize initialDate, selectedDate, style;
@synthesize currentDate = _currentDate;
@synthesize imageItems = _imageItems;

#pragma mark - Init

- (id)initWithSelectedDate:(NSDate *)date
{
    if ((self = [super init])) {
        if (date == nil) {
            date = [NSDate date];
        }
        
        self.initialDate = date;
        self.selectedDate = date;
        self.currentDate = date;
        
        logic = [[KalLogic alloc] initForDate:date];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(significantTimeChangeOccurred)
                                                     name:UIApplicationSignificantTimeChangeNotification
                                                   object:nil];
    }
    return self;
}

- (id)init
{
    return [self initWithSelectedDate:nil];
}

- (id)initWithCoverages:(NSMutableArray *)images
{
    if (self = [self init])
    {
    	self.imageItems = images;
    }
	return self;
}

#pragma mark - View Life Cycle

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, APP_VIEW_HEIGH)];
    self.view = view;
    [view release];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self initCalendarContainer];
    [self initBottomBar];
    [self initMonthPicker];
    [self initStyleContainer];
    
    [self createKalView:self.style];
    
    [self initTapGesture];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self setNavStyle];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [self restoreNavStyle];
}

- (void)didReceiveMemoryWarning
{
    self.initialDate = self.selectedDate; // must be done before calling super
    [super didReceiveMemoryWarning];
}

#pragma mark - Priavte

// Calendar container
- (void)initCalendarContainer
{
    _calendarContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    _calendarContainer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_calendarContainer];
}

// Bottom bar
- (void)initBottomBar
{
    _bottomBar = [[KalBottomView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width, 54)];
    _bottomBar.backgroundColor = [UIColor clearColor];
    _bottomBar.delegate = self;
    [self.view addSubview:_bottomBar];
}

// Month picker
- (void)initMonthPicker
{
    _pickerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-260, self.view.frame.size.width, 260)];
    
    SRMonthPicker *monthPicker = [[SRMonthPicker alloc] initWithFrame:CGRectMake(0, 44, _pickerContainer.frame.size.width, 216)];
    monthPicker.monthPickerDelegate = self;
    monthPicker.showsSelectionIndicator = YES;
    monthPicker.maximumYear = [NSNumber numberWithInt:2020];
    monthPicker.minimumYear = [NSNumber numberWithInt:1950];
    monthPicker.yearFirst = YES;
    monthPicker.wrapMonths = NO;
    [_pickerContainer addSubview:monthPicker];
    [monthPicker release];
    
    UIImage *imageBg = [UIImage imageNamed:@"Kal.bundle/calendar_date_bg.png"];
    UIImage *imageBgStretch = [imageBg stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    
    UIImageView *btnBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    btnBgView.backgroundColor = [UIColor clearColor];
    btnBgView.image = imageBgStretch;
    [_pickerContainer addSubview:btnBgView];
    [btnBgView release];
    
    UIImage *btnCancelBg = [UIImage imageNamed:@"Kal.bundle/btn_white_bg.png"];
    UIImage *btnCancelBgStretch = [btnCancelBg stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    
    // Button "Cancel"
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCancel.frame = CGRectMake(10, 8, 66, 27);
    [btnCancel setTitle:_(@"取消") forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:btnCancelBgStretch forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_pickerContainer addSubview:btnCancel];
    
    UIImage *btnCompleteBg = [UIImage imageNamed:@"Kal.bundle/btn_blue_bg.png"];
    UIImage *btnCompleteBgStretch = [btnCompleteBg stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    
    // Button "Complete"
    UIButton *btnComplete = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnComplete.frame = CGRectMake(_pickerContainer.frame.size.width-66-10, 8, 66, 27);
    [btnComplete setTitle:_(@"完成") forState:UIControlStateNormal];
    [btnComplete setBackgroundImage:btnCompleteBgStretch forState:UIControlStateNormal];
    [btnComplete addTarget:self action:@selector(completeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_pickerContainer addSubview:btnComplete];
    
    [self.view addSubview:_pickerContainer];
    _pickerContainer.hidden = YES;
}

// Style container
- (void)initStyleContainer
{
    _styleContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width, 54)];
    
    UIImage *btnBg = [UIImage imageFile:@"Kal.bundle/btn_white_bg.png"];
    UIImage *btnBgStretch = [btnBg stretchableImageWithLeftCapWidth:4 topCapHeight:0];
    
    UIButton *btnSolar = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSolar.frame = CGRectMake(20, 10, 120, 32);
    btnSolar.tag = KalBottomViewActionSolar;
    [btnSolar setTitle:@"Solar" forState:UIControlStateNormal];
    [btnSolar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnSolar setBackgroundImage:btnBgStretch forState:UIControlStateNormal];
    [btnSolar addTarget:self action:@selector(bottomBarItemSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_styleContainer addSubview:btnSolar];
    
    UIButton *btnSolarWithLunar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnSolarWithLunar.frame = CGRectMake(180, 10, 120, 32);
    btnSolarWithLunar.tag = KalBottomViewActionSolarAndLunar;
    [btnSolarWithLunar setTitle:@"SolarLunar" forState:UIControlStateNormal];
    [btnSolarWithLunar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnSolarWithLunar setBackgroundImage:btnBgStretch forState:UIControlStateNormal];
    [btnSolarWithLunar addTarget:self action:@selector(bottomBarItemSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_styleContainer addSubview:btnSolarWithLunar];
    
    [self.view addSubview:_styleContainer];
    _styleContainer.hidden = YES;
}

- (void)createKalViewWithFrame:(CGRect)frame style:(KalTileStyle)theStyle date:(NSDate *)date
{
    self.style = theStyle;
    [logic moveToMonthForDate:date];
    
    CGRect kalFrame = CGRectZero;
    if (_kalView) {
        kalFrame = _kalView.frame;
        [_kalView removeFromSuperview];
        _kalView = nil;
    } else {
        kalFrame = frame;
    }
    
    _kalView = [[KalView alloc] initWithFrame:CGRectEqualToRect(kalFrame, CGRectZero) ? CGRectMake(21, 30, 278, 261) : kalFrame delegate:self logic:logic style:theStyle];
    [_calendarContainer addSubview:_kalView];
    
#if 0
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [_kalView addGestureRecognizer:panRecognizer];
#endif
}

- (void)createKalView:(KalTileStyle)theStyle date:(NSDate *)date
{
    [self createKalViewWithFrame:CGRectZero style:theStyle date:date];
}

// Create calendar
- (void)createKalView:(KalTileStyle)theStyle
{
    [self createKalView:theStyle date:[NSDate date]];
}

// Tap gesture
- (void)initTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCalendarStyle:)];
    tap.delegate = self;
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tap];
}

- (void)move:(id)sender
{
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
//	[self.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
	CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
		firstX = [[sender view] center].x;
		firstY = [[sender view] center].y;
        
//        NSLog(@"firstX:%f firstY:%f", firstX, firstY);
	}
    
	translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY+translatedPoint.y);
    
	[[sender view] setCenter:translatedPoint];
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
		CGFloat finalX = translatedPoint.x + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self.view].x);
		CGFloat finalY = translatedPoint.y + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
        
//        NSLog(@"finalX:%f, finalY:%f", finalX, finalY);
        
        BOOL bOverBounds = NO;
        if(finalX - _kalView.frame.size.width/2 < 0) {
            finalX = _kalView.frame.size.width/2;
            bOverBounds = YES;
        } else if(finalX + _kalView.frame.size.width/2 > self.view.frame.size.width) {
            finalX = self.view.frame.size.width - _kalView.frame.size.width/2;
            bOverBounds = YES;
        }
        
        if(finalY - _kalView.frame.size.height/2 < 0) {
            finalY = _kalView.frame.size.height/2;
            bOverBounds = YES;
        }
        else if(finalY + _kalView.frame.size.height/2 > self.view.frame.size.height) {
            finalY = self.view.frame.size.height - _kalView.frame.size.height/2;
            bOverBounds = YES;
        }
        
        if (bOverBounds) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:.35];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [[sender view] setCenter:CGPointMake(finalX, finalY)];
            [UIView commitAnimations];
        }
	}
}

- (KalView *)calendarView
{
    return _kalView;
}

- (void)significantTimeChangeOccurred
{
    [[self calendarView] jumpToSelectedMonth];
}

- (void)showAndSelectDate:(NSDate *)date
{
    if ([[self calendarView] isSliding])
        return;
    
    [logic moveToMonthForDate:date];
    
    [[self calendarView] jumpToSelectedMonth];
    [[self calendarView] selectDate:[KalDate dateFromNSDate:date]];
}

- (void)setNavStyle
{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.navigationController.navigationBar.translucent = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)restoreNavStyle
{
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
	self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)cancelAction:(id)sender
{
    [self hideMonthPicker];
}

- (void)completeAction:(id)sender
{
    [self hideMonthPicker];
    
    for (UIView *view in _pickerContainer.subviews) {
        
        if (view && [view isKindOfClass:[SRMonthPicker class]]) {
            SRMonthPicker *monthPicker = (SRMonthPicker *)view;
            self.currentDate = monthPicker.date;
            [self createKalView:self.style date:monthPicker.date];
            NSLog(@"monthPicker.date:%@ ==== self.currentDate:%@", monthPicker.date, self.currentDate);
        }
    }
}

- (void)showPickerFrame
{
    _pickerContainer.frame = CGRectMake(0, self.view.frame.size.height-260, self.view.frame.size.width, 260);
}

- (void)hidePickerFrame
{
    _pickerContainer.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 260);
}

- (void)showMonthPicker
{
    if (_pickerContainer.hidden) {
        
        _pickerContainer.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 260);
        _pickerContainer.hidden = NO;
        
        __block __typeof(self) _self = self;
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationCurveEaseInOut
                         animations:^(void) {
                             [_self showPickerFrame];
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void)hideMonthPicker
{
    if (!_pickerContainer.hidden) {
        
        __block __typeof(self) _self = self;
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationCurveEaseInOut
                         animations:^(void) {
                             [_self hidePickerFrame];
                         }
                         completion:^(BOOL finished) {
                             _pickerContainer.hidden = YES;
                         }];
    }
}

- (void)hideCalendarStyle:(id)sender
{
    [self showCalendarStyle:NO];
}

#pragma mark - Setter

- (NSDate *)selectedDate
{
    return [self.calendarView.selectedDate NSDate];
}

#pragma mark - KalViewDelegate

- (void)didSelectDate:(KalDate *)date
{
    self.selectedDate = [date NSDate];
}

- (void)selectedDate:(KalDate *)date
{
    
}

- (void)showPreviousMonth
{
    [logic retreatToPreviousMonth];
    [[self calendarView] slideDown];
}

- (void)showFollowingMonth
{
    [logic advanceToFollowingMonth];
    [[self calendarView] slideUp];
}

- (void)showCalendarStyle:(BOOL)bShow
{
    if (bShow) {
        [self.view viewWithTag:KalBottomViewActionTime].hidden = YES;
        [self.view viewWithTag:KalBottomViewActionStyle].hidden = YES;
        _styleContainer.hidden = NO;
    }
    else {
        [self.view viewWithTag:KalBottomViewActionTime].hidden = NO;
        [self.view viewWithTag:KalBottomViewActionStyle].hidden = NO;
        _styleContainer.hidden = YES;
    }
}

#pragma mark - KalBottomViewDelegate

- (void)bottomBarItemSelected:(id)sender
{
    int btnTag = ((UIButton *)sender).tag;
    switch (btnTag) {
        case KalBottomViewActionTime:
        {
            
            if (_pickerContainer.hidden) {
                [self showMonthPicker];
            }
        }
            break;
            
        case KalBottomViewActionStyle:
        {
            
            [self showCalendarStyle:YES];
        }
            break;
            
        case KalBottomViewActionSolar:
        {
            
            [self showCalendarStyle:NO];
            [self createKalView:KalTileStyleSolar date:self.currentDate];
        }
            break;
            
        case KalBottomViewActionLunar:
        {
            
            [self showCalendarStyle:NO];
            [self createKalView:KalTileStyleLunar date:self.currentDate];
        }
            break;
            
        case KalBottomViewActionSolarAndLunar:
        {
            
            [self showCalendarStyle:NO];
            [self createKalView:KalTileStyleSolarAndLunar date:self.currentDate];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - SRMonthPickerDelegate

- (void)monthPickerWillChangeDate:(SRMonthPicker *)monthPicker
{
    NSLog(@"monthPickerWillChangeDate...");
}

- (void)monthPickerDidChangeDate:(SRMonthPicker *)monthPicker
{
    NSLog(@"monthPickerDidChangeDate...");
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return ([[touch.view class] isSubclassOfClass:[UIButton class]]) ? NO : YES;
}

#pragma mark - dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:nil];
    [initialDate release];
    [selectedDate release];
    [logic release];
    
    [_bottomBar release];
    [_imageItems release];
    [_calendarContainer release];
    [_kalView release];
    [_pickerContainer release];
    [_styleContainer release];
    
    [super dealloc];
}

@end
