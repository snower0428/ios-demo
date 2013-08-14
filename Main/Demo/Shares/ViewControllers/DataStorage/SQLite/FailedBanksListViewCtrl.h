//
//  FailedBanksListViewCtrl.h
//  Demo
//
//  Created by leihui on 13-8-7.
//
//

#import <UIKit/UIKit.h>

@interface FailedBanksListViewCtrl : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView     *_tableView;
    NSArray         *_failedBankInfos;
}

@property (nonatomic, retain) NSArray *failedBankInfos;

@end
