//
//  UIDatePickerCtrl.h
//  Demo
//
//  Created by lei hui on 13-1-29.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TABLE_VIEW_HEIGHT       99
#define CLICK_CLOSE             0   //点击其它地方关闭

typedef enum
{
    DPActionTypeOk      = 100,  //确定
    DPActionTypeCacel   = 101,  //取消
    DPActionTypeToday   = 102,  //今日
    DPActionTypeSolor   = 103,  //阳历
    DPActionTypeLunar   = 104,  //农历
}DPActionType;

@interface UIDatePickerCtrl : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView         *_tableViewYear;
    UITableView         *_tableViewMonth;
    UITableView         *_tableViewDay;
    
    NSMutableArray      *_arrayYear;
    NSMutableArray      *_arrayMonth;
    NSMutableArray      *_arrayDay;
    
    BOOL                _isSolar;       //是否为阳历，默认为YES
    
    NSInteger           _solarYear;     //阳历年、月、日
    NSInteger           _solarMonth;
    NSInteger           _solarDay;
    
    NSInteger           _lunarYear;     //阴历年、月、日
    NSInteger           _lunarMonth;
    NSInteger           _lunarDay;
    
    CGFloat             _lastTableViewYContentOffset;
    
    id                  _delegate;
    SEL                 _selector;
    
    UIView              *_parentView;
}

+ (UIDatePickerCtrl *)shareInstance;
+ (void)exitInstance;
- (void)showDatePicker:(BOOL)isSolar date:(NSDate *)date parent:(UIView *)parent delegate:(id)delegate selector:(SEL)selector;

@end
