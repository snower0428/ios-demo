//
//  UIDatePickerCtrl.h
//  Demo
//
//  Created by lei hui on 13-1-29.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

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
}

- (void)showDatePicker:(UIView *)FParentView;

@end
