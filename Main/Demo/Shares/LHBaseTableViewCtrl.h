//
//  LHBaseTableViewCtrl.h
//  Demo
//
//  Created by leihui on 13-3-20.
//
//

#import <UIKit/UIKit.h>

@interface LHBaseTableViewCtrl : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSArray             *_arrayName;
    NSArray             *_arrayViewController;
    
    UITableView         *_tableView;
}

@end
