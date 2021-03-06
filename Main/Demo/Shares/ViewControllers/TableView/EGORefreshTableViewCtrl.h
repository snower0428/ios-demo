//
//  EGORefreshTableViewCtrl.h
//  Demo
//
//  Created by hui lei on 13-2-2.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBaseViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface EGORefreshTableViewCtrl : LHBaseViewController <UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate>
{
    UITableView                 *_tableView;
    EGORefreshTableHeaderView   *_refreshHeaderView;
    EGORefreshTableHeaderView   *_refreshFooterView;
    
    // Reloading var should really be your tableviews datasource
	// Putting it here for demo purposes 
	BOOL _reloading;
}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
