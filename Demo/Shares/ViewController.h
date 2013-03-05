//
//  ViewController.h
//  CommDemo
//
//  Created by leihui on 12-10-17.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSArray             *_arrayName;
    NSArray             *_arrayViewController;
    UITableView         *_tableView;
}

@end
