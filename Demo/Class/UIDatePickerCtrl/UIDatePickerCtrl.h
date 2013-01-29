//
//  UIDatePickerCtrl.h
//  Demo
//
//  Created by lei hui on 13-1-29.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDatePickerCtrl : UIViewController
{
    UITableView         *_tableViewYear;
    UITableView         *_tableViewMonth;
    UITableView         *_tableViewDay;
    
    NSMutableArray      *_arrayYear;
    NSMutableArray      *_arrayMonth;
    NSMutableArray      *_arrayDay;
}

- (void)showDatePicker:(UIView *)FParentView;

@end
