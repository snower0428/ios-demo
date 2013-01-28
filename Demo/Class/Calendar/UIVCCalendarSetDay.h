//
//  UIVCCalendarSetDay.h
//  Weather
//
//  Created by nd on 11-6-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -

@interface UIVCCalendarSetDay : UIViewController {
    
	IBOutlet UILabel *lbGongli;
	IBOutlet UIButton *btnGongli, *btnNongli;
    IBOutlet UITableView *tabYear, *tabMonth, *tabDay;
    
    NSMutableArray    *dbYear, *dbMonth, *dbDay; 
    
	NSInteger nCurYear, nCurMonth, nCurDay;
	NSInteger nCurYear_nl, nCurMonth_nl, nCurDay_nl;
	NSInteger nCurRili;
    
    NSObject *class_func_owner; 
	SEL  class_func_responseData;  
    CGFloat lastTableViewYContentOffset;
}
@property(retain, nonatomic) NSMutableArray *dbYear, *dbMonth, *dbDay; 


+ (UIVCCalendarSetDay*) getInstance;
+ (void) free;

- (void) showSetDay: (NSInteger) _nCurYear  
			  month: (NSInteger) _nCurMonth 
				day: (NSInteger) _nCurDay 
		 parentView: (UIView *) FParentView
		parentClass: (NSObject*) FParentClass
	 responseMethod: (SEL) FResponseMethod;
- (void) showSetSpecDay:(NSInteger) _nCurRili   //判断是阳历还是农历
               year: (NSInteger) _nCurYear      //当前的年份
			  month: (NSInteger) _nCurMonth     //当前的月份
				day: (NSInteger) _nCurDay       //当前的日期
		 parentView: (UIView *) FParentView     //父视图
		parentClass: (NSObject*) FParentClass   //父类
	 responseMethod: (SEL) FResponseMethod;     //父类响应的方法
- (IBAction)returnBtnPress:(id)sender;
- (IBAction)pressCurDay:(id)sender;
- (IBAction)pressSetDay:(id)sender;

- (IBAction)btnGongliClick:(id)sender;
- (IBAction)btnNongliClick:(id)sender;

@end

