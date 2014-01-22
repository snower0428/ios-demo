//
//  CalendarWeeAppController.m
//  CalendarWeeApp
//
//  Created by leihui on 14-1-8.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "CalendarWeeAppController.h"
#import "UIImageManager.h"
#import "Kal.h"
#import "KalLogic.h"
#import "KalDate.h"

//缩放因子，默认为1.0
CGFloat kScaleFactor = 1.0;

static const CGFloat kalViewWidth = 280.f;
static const CGFloat kalViewHeight = 260.f;

@interface CalendarWeeAppController ()
{
    KalLogic            *_logic;
    KalTileStyle        _style;
    KalSkinType         _skinType;
    
    KalView             *_kalView;
}

@property (nonatomic, assign) KalTileStyle style;

@end

@implementation CalendarWeeAppController

@synthesize style = _style;

- (id)init
{
    self = [super init];
    if (self) {
        // Init
        _logic = [[KalLogic alloc] initForDate:[NSDate date]];
        _skinType = KalSkinTypeDefault;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(significantTimeChangeOccurred)
                                                     name:UIApplicationSignificantTimeChangeNotification
                                                   object:nil];
    }
    
    return self;
}

#pragma mark - BBWeeAppController

-(void)viewWillDisappear
{
    NSLog(@"==========viewWillDisappear==========");
}

-(void)viewDidAppear
{
    NSLog(@"==========viewDidAppear==========");
}

-(void)setPresentationView:(id)view
{
    NSLog(@"==========setPresentationView==========%@", view);
}

-(float)presentationHeight
{
    NSLog(@"==========presentationHeight==========");
    
    return 0.f;
}

-(void)unloadPresentationController
{
    NSLog(@"==========unloadPresentationController==========");
}

-(id)presentationControllerForMode:(int)mode
{
    NSLog(@"==========presentationControllerForMode==========%d", mode);
    
    return nil;
}

-(id)launchURLForTapLocation:(CGPoint)tapLocation
{
    NSLog(@"==========launchURLForTapLocation==========%@", NSStringFromCGPoint(tapLocation));
    
    return nil;
}

-(id)launchURL
{
    NSLog(@"==========launchURL==========");
    
    return nil;
}

-(void)loadView
{
    NSLog(@"==========loadView==========");
}

-(void)clearShapshotImage
{
    NSLog(@"==========clearShapshotImage==========");
}

-(void)unloadView
{
    NSLog(@"==========unloadView==========");
}

-(void)loadFullView
{
    NSLog(@"==========loadFullView==========");
}

-(void)loadPlaceholderView
{
    NSLog(@"==========loadPlaceholderView==========");
}

-(void)didRotateFromInterfaceOrientation:(int)interfaceOrientation
{
    NSLog(@"==========didRotateFromInterfaceOrientation==========%d", interfaceOrientation);
}

-(void)willAnimateRotationToInterfaceOrientation:(int)interfaceOrientation
{
    NSLog(@"==========willAnimateRotationToInterfaceOrientation==========%d", interfaceOrientation);
}

-(void)willRotateToInterfaceOrientation:(int)interfaceOrientation
{
    NSLog(@"==========willRotateToInterfaceOrientation==========%d", interfaceOrientation);
}

-(void)viewDidDisappear
{
    NSLog(@"==========viewDidDisappear==========");
}

-(void)viewWillAppear
{
    NSLog(@"==========viewWillAppear==========");
}

- (UIView *)view
{
	if (_view == nil)
	{
        CGFloat leftMargin = 2.f;
        CGFloat width = SCREEN_WIDTH-leftMargin*2;
		_view = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, 0, width, kalViewHeight)];
        
        UIImage *bg = [[[UIImageManager shareInstance] imageWithFileName:@"WeeAppBackground.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:35];
		UIImageView *bgView = [[UIImageView alloc] initWithImage:bg];
		bgView.frame = _view.bounds;
		[_view addSubview:bgView];
        [bgView release];
        
        [self createKalView:KalTileStyleSolarAndLunar];
	}
    
    NSLog(@"==========view==========%@", _view);
    
	return _view;
}

- (float)viewHeight
{
    NSLog(@"==========viewHeight==========");
    
	return kalViewHeight;
}

#pragma mark - Private

- (void)createKalViewWithFrame:(CGRect)frame style:(KalTileStyle)theStyle date:(NSDate *)date
{
    self.style = theStyle;
    [_logic moveToMonthForDate:date];
    
    CGRect kalFrame = CGRectZero;
    if (_kalView) {
        kalFrame = _kalView.frame;
        [_kalView removeFromSuperview];
        [_kalView release];
        _kalView = nil;
    } else {
        kalFrame = frame;
    }
    
    if (!CGRectEqualToRect(frame, CGRectZero)) {
        kalFrame = frame;
    }
    
    CGRect kalOriginFrame = CGRectMake(10, 0, kalViewWidth, kalViewHeight);
    CGRect rect = CGRectEqualToRect(kalFrame, CGRectZero) ? kalOriginFrame : kalFrame;
    
    _kalView = [[KalView alloc] initWithFrame:rect delegate:self logic:_logic style:theStyle];
    [_view addSubview:_kalView];
    [_kalView changeSkinWithType:_skinType];
    [_kalView selectDate:[KalDate dateFromNSDate:[NSDate date]]];
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

- (KalView *)calendarView
{
    return _kalView;
}

#pragma mark- Notification

- (void)significantTimeChangeOccurred
{
    [[self calendarView] jumpToSelectedMonth];
}

#pragma mark - KalViewDelegate

- (void)showPreviousMonth
{
    [_logic retreatToPreviousMonth];
    [[self calendarView] slideDown];
}

- (void)showFollowingMonth
{
    [_logic advanceToFollowingMonth];
    [[self calendarView] slideUp];
}

- (void)didSelectDate:(KalDate *)date
{
    NSLog(@"didSelectDate ---- %@", date);
}

#pragma mark - dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_logic release];
    [_kalView release];
    
    [super dealloc];
}

@end