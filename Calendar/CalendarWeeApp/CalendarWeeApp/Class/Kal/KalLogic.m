/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalLogic.h"
#import "KalDate.h"
#import "KalPrivate.h"

@interface KalLogic ()
- (void)moveToMonthForDate:(NSDate *)date;
- (void)recalculateVisibleDays;
- (NSUInteger)numberOfDaysInPreviousPartialWeek;
- (NSUInteger)numberOfDaysInFollowingPartialWeek;

@property (nonatomic, retain) NSDate *fromDate;
@property (nonatomic, retain) NSDate *toDate;
@property (nonatomic, retain) NSArray *daysInSelectedMonth;
@property (nonatomic, retain) NSArray *daysInFinalWeekOfPreviousMonth;
@property (nonatomic, retain) NSArray *daysInFirstWeekOfFollowingMonth;

@end

@implementation KalLogic

@synthesize baseDate, fromDate, toDate, daysInSelectedMonth, daysInFinalWeekOfPreviousMonth, daysInFirstWeekOfFollowingMonth;
@synthesize currentYear = _currentYear;
@synthesize currentMonth = _currentMonth;

+ (NSSet *)keyPathsForValuesAffectingSelectedMonthNameAndYear
{
    return [NSSet setWithObjects:@"baseDate", nil];
}

- (id)initForDate:(NSDate *)date
{
    if ((self = [super init])) {
        monthAndYearFormatter = [[NSDateFormatter alloc] init];
        [monthAndYearFormatter setDateFormat:@"LLLL yyyy"];
        [self moveToMonthForDate:date];
        
//        NSLog(@"date:%@", [monthAndYearFormatter stringFromDate:date]);

        _currentYear = [date cc_year];
        _currentMonth = [date cc_month];
    }
    return self;
}

- (id)init
{
  return [self initForDate:[NSDate date]];
}

- (void)moveToMonthForDate:(NSDate *)date
{
  self.baseDate = [date cc_dateByMovingToFirstDayOfTheMonth];
  [self recalculateVisibleDays];
}

- (void)retreatToPreviousMonth
{
  [self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfThePreviousMonth]];
}

- (void)advanceToFollowingMonth
{
  [self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfTheFollowingMonth]];
}

- (NSString *)selectedMonthNameAndYear;
{
//    NSLog(@"self.baseDate:%@", [monthAndYearFormatter stringFromDate:self.baseDate]);
  return [monthAndYearFormatter stringFromDate:self.baseDate];
}

#pragma mark Low-level implementation details

- (NSUInteger)numberOfDaysInPreviousPartialWeek
{
//    NSLog(@"cc_weekday:%d", [self.baseDate cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[NSDate date] cc_weekday]);
//    
//    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-06-30"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-01"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-02"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-03"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-04"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-05"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-06"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-07"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-08"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-09"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-10"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-11"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-12"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-13"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-14"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-15"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-16"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-17"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-18"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-19"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-20"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-21"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-22"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-23"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-24"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-25"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-26"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-27"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-28"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-29"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-30"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-07-31"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-08-01"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-08-02"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-08-03"] cc_weekday]);
//    NSLog(@"cc_weekday:%d", [[formatter dateFromString:@"2013-08-04"] cc_weekday]);
    
  return [self.baseDate cc_weekday] - 1;
}

- (NSUInteger)numberOfDaysInFollowingPartialWeek
{
  NSDateComponents *c = [self.baseDate cc_componentsForMonthDayAndYear];
  c.day = [self.baseDate cc_numberOfDaysInMonth];
  NSDate *lastDayOfTheMonth = [[NSCalendar currentCalendar] dateFromComponents:c];
  return 7 - [lastDayOfTheMonth cc_weekday];
}

- (NSArray *)calculateDaysInFinalWeekOfPreviousMonth
{
  NSMutableArray *days = [NSMutableArray array];
  
  NSDate *beginningOfPreviousMonth = [self.baseDate cc_dateByMovingToFirstDayOfThePreviousMonth];
  int n = [beginningOfPreviousMonth cc_numberOfDaysInMonth];
  int numPartialDays = [self numberOfDaysInPreviousPartialWeek];
  NSDateComponents *c = [beginningOfPreviousMonth cc_componentsForMonthDayAndYear];
  for (int i = n - (numPartialDays - 1); i < n + 1; i++)
    [days addObject:[KalDate dateForDay:i month:c.month year:c.year]];
  
  return days;
}

- (NSArray *)calculateDaysInSelectedMonth
{
  NSMutableArray *days = [NSMutableArray array];
  
  NSUInteger numDays = [self.baseDate cc_numberOfDaysInMonth];
  NSDateComponents *c = [self.baseDate cc_componentsForMonthDayAndYear];
  for (int i = 1; i < numDays + 1; i++)
    [days addObject:[KalDate dateForDay:i month:c.month year:c.year]];
  
  return days;
}

- (NSArray *)calculateDaysInFirstWeekOfFollowingMonth
{
  NSMutableArray *days = [NSMutableArray array];
  
  NSDateComponents *c = [[self.baseDate cc_dateByMovingToFirstDayOfTheFollowingMonth] cc_componentsForMonthDayAndYear];
  NSUInteger numPartialDays = [self numberOfDaysInFollowingPartialWeek];
  
  for (int i = 1; i < numPartialDays + 1; i++)
    [days addObject:[KalDate dateForDay:i month:c.month year:c.year]];
  
  return days;
}

- (void)recalculateVisibleDays
{
  self.daysInSelectedMonth = [self calculateDaysInSelectedMonth];
  self.daysInFinalWeekOfPreviousMonth = [self calculateDaysInFinalWeekOfPreviousMonth];
  self.daysInFirstWeekOfFollowingMonth = [self calculateDaysInFirstWeekOfFollowingMonth];
  KalDate *from = [self.daysInFinalWeekOfPreviousMonth count] > 0 ? [self.daysInFinalWeekOfPreviousMonth objectAtIndex:0] : [self.daysInSelectedMonth objectAtIndex:0];
  KalDate *to = [self.daysInFirstWeekOfFollowingMonth count] > 0 ? [self.daysInFirstWeekOfFollowingMonth lastObject] : [self.daysInSelectedMonth lastObject];
  self.fromDate = [[from NSDate] cc_dateByMovingToBeginningOfDay];
  self.toDate = [[to NSDate] cc_dateByMovingToEndOfDay];
}

#pragma mark -

- (void) dealloc
{
  [monthAndYearFormatter release];
  [baseDate release];
  [fromDate release];
  [toDate release];
  [daysInSelectedMonth release];
  [daysInFinalWeekOfPreviousMonth release];
  [daysInFirstWeekOfFollowingMonth release];
  [super dealloc];
}

@end
