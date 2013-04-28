//
//  LauncherViewCtrl.h
//  Demo
//
//  Created by leihui on 13-4-16.
//
//

#import <UIKit/UIKit.h>
#import "HMLauncherView.h"
#import "LauncherService.h"
#import "HMLauncherData.h"

@interface LauncherViewCtrl : UIViewController <HMLauncherViewDelegate>
{
    LauncherService     *_launcherService;
    HMLauncherView      *_launcherView1;
    HMLauncherView      *_launcherView2;
}

@property (nonatomic, assign) HMLauncherView *currentDraggingView;

@end
