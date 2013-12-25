//
//  HMGLTransitionViewCtrl.h
//  Demo
//
//  Created by leihui on 13-3-21.
//
//

#import <UIKit/UIKit.h>
#import "HMGLTransitionManager.h"

@interface HMGLTransitionViewCtrl : UIViewController
{
    UIView          *_viewContainer;
    UIView          *_view1;
    UIView          *_view2;
    
    HMGLTransition  *_transition;
}

@end
