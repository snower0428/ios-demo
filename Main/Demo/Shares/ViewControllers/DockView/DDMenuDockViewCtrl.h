//
//  DDMenuDockViewCtrl.h
//  Demo
//
//  Created by leihui on 13-3-20.
//
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "CenterViewController.h"

@interface DDMenuDockViewCtrl : DDMenuController
{
    LeftViewController          *_leftCtrl;
    RightViewController         *_rightCtrl;
    CenterViewController        *_centerCtrl;
    UINavigationController      *_navCtrl;
}

@end
