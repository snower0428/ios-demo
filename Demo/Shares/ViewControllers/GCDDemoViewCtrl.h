//
//  GCDDemoViewCtrl.h
//  Demo
//
//  Created by leihui on 13-3-19.
//
//

#import <UIKit/UIKit.h>

@interface GCDDemoViewCtrl : UIViewController
{
    NSArray         *_array;
    BOOL            _stopFlag;
    UILabel         *_label;
}

@property (nonatomic, assign) BOOL stopFlag;

@end
