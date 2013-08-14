//
//  FBCDAppDelegate.h
//  FailedBankCD
//
//  Created by leihui on 13-8-8.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBCDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
