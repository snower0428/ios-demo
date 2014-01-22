/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>
#import "Kal.h"
#import "KalSkinManager.h"

@class KalGridView, KalLogic, KalDate;
@protocol KalViewDelegate;

/*
 *    KalView
 *    ------------------
 *
 *    Private interface
 *
 *  As a client of the Kal system you should not need to use this class directly
 *  (it is managed by KalViewController).
 *
 */

@interface KalView : UIView
{
    KalGridView             *gridView;
    id<KalViewDelegate>     delegate;
    KalLogic                *logic;
    KalTileStyle            style;
    
    UIButton                *_btnTitle;
}

@property (nonatomic, assign) id<KalViewDelegate> delegate;
@property (nonatomic, readonly) KalDate *selectedDate;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic style:(KalTileStyle)theStyle;
- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic;

- (BOOL)isSliding;
- (void)selectDate:(KalDate *)date;
- (void)markTilesForDates:(NSArray *)dates;
- (void)redrawEntireMonth;

// These 3 methods are exposed for the delegate. They should be called 
// *after* the KalLogic has moved to the month specified by the user.
- (void)slideDown;
- (void)slideUp;
- (void)jumpToSelectedMonth;    // change months without animation (i.e. when directly switching to "Today")
- (KalGridView *)gridView;
- (void)resetMonthView;

- (void)changeSkinWithType:(KalSkinType)type;

@end

#pragma mark -

@class KalDate;

@protocol KalViewDelegate <NSObject>

- (void)showPreviousMonth;
- (void)showFollowingMonth;
- (void)didSelectDate:(KalDate *)date;
@optional
- (void)selectedDate:(KalDate *)date;
- (void)showMonthPicker;

@end
