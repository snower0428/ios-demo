//
//  JADockViewCtrl.h
//  Demo
//
//  Created by leihui on 13-3-20.
//
//

#import <UIKit/UIKit.h>
#import "JASidePanelController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "CenterViewController.h"

@interface JADockViewCtrl : JASidePanelController
{
    LeftViewController          *_leftCtrl;
    RightViewController         *_rightCtrl;
    CenterViewController        *_centerCtrl;
    UINavigationController      *_navCtrl;
}

@end
