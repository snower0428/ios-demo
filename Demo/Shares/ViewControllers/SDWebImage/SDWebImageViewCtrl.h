//
//  SDWebImageViewCtrl.h
//  Demo
//
//  Created by lei hui on 13-3-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBaseViewController.h"

@interface SDWebImageViewCtrl : LHBaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray         *_objects;
    UITableView     *_tableView;
}

@end
