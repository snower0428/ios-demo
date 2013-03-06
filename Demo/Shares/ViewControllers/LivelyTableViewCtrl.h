//
//  LivelyTableViewCtrl.h
//  Demo
//
//  Created by lei hui on 13-3-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBaseViewController.h"
#import "ADLivelyTableView.h"

@interface LivelyTableViewCtrl : LHBaseViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    NSMutableArray          *_array;
    ADLivelyTableView       *_tableView;
}

@end
