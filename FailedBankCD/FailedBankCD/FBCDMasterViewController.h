//
//  FBCDMasterViewController.h
//  FailedBankCD
//
//  Created by leihui on 13-8-8.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBCDMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
