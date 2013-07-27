//
//  KalCalendarViewCtrl.h
//  PandaHome
//
//  Created by leihui on 13-7-5.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KalView.h"       // for the KalViewDelegate protocol
#import "KalBottomView.h"
//#import "TopBarView.h"
#import "SRMonthPicker.h"

@class KalLogic, KalDate;

@interface KalCalendarViewCtrl : UIViewController <KalViewDelegate,
                                                    KalBottomViewDelegate,
//                                                    TopBarViewDelegate,
                                                    SRMonthPickerDelegate,
                                                    UIGestureRecognizerDelegate,
                                                    UIActionSheetDelegate>
{
    KalLogic        *logic;
    NSDate          *initialDate;       // The date that the calendar was initialized with *or* the currently selected date
    // when the view hierarchy was torn down in order to satisfy a low memory warning.
    
    NSDate          *selectedDate;      // I cache the selected date because when we respond to a memory warning,
    // we cannot rely on the view hierarchy still being alive,
    // and thus we cannot always derive the selected date from KalView's selectedDate property.
    KalView         *_kalView;
    
    KalTileStyle    style;
    
    CGFloat firstX;
    CGFloat firstY;
    
    UIView              *_calendarContainer;
//    TopBarView          *_topBar;
    KalBottomView       *_bottomBar;
    UIView              *_pickerContainer;
    UIView              *_styleContainer;
    NSDate              *_currentDate;
    NSMutableArray      *_imageItems;
}

@property (nonatomic, retain, readonly) NSDate *selectedDate;
@property (nonatomic, assign) KalTileStyle style;
@property (nonatomic, retain) NSDate *currentDate;
@property (nonatomic, retain) NSMutableArray *imageItems;

/**
 *  designated initializer.
 *  When the calendar is first displayed to the user,
 *  the month that contains 'selectedDate' will be shown
 *  and the corresponding tile for 'selectedDate' will be automatically selected.
 *
 */
- (id)initWithSelectedDate:(NSDate *)selectedDate;

/**
 *  Updates the state of the calendar to display the specified date's month
 *  and selects the tile for that date.
 *
 */
- (void)showAndSelectDate:(NSDate *)date;

- (id)initWithCoverages:(NSMutableArray *)images;

@end