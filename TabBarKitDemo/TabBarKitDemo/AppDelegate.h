//
//  AppDelegate.h
//  TabBarKitDemo
//
//  Created by lei hui on 13-5-30.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarKit.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, TBKTabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TBKTabBarController *viewController;

@end
