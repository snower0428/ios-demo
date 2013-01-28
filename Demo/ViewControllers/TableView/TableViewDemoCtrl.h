//
//  TableViewDemoCtrl.h
//  CommDemo
//
//  Created by leihui on 12-11-20.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewDemoCtrl : UITableViewController
{
    NSMutableArray          *_thingsToLearn;
    NSMutableArray          *_thingsLearned;
}

@property(nonatomic, copy) NSMutableArray *thingsToLearn;
@property(nonatomic, copy) NSMutableArray *thingsLearned;

@end
