/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>
#import "Kal.h"

@class KalTileView, KalDate;

@interface KalMonthView : UIView
{
    NSUInteger numWeeks;
}

@property (nonatomic) NSUInteger numWeeks;

- (id)initWithFrame:(CGRect)frame style:(KalTileStyle)theStyle mode:(BOOL)theMode;
- (id)initWithFrame:(CGRect)frame style:(KalTileStyle)theStyle;
- (id)initWithFrame:(CGRect)rect; // designated initializer

- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *)trailingAdjacentDates;
- (KalTileView *)firstTileOfMonth;
- (KalTileView *)tileForDate:(KalDate *)date;
- (void)markTilesForDates:(NSArray *)dates;

@end
