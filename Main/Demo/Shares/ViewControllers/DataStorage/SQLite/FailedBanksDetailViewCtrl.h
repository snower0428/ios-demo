//
//  FailedBanksDetailViewCtrl.h
//  Demo
//
//  Created by leihui on 13-8-7.
//
//

#import <UIKit/UIKit.h>

@interface FailedBanksDetailViewCtrl : UIViewController
{
    UILabel *_nameLabel;
    UILabel *_cityLabel;
    UILabel *_stateLabel;
    UILabel *_zipLabel;
    UILabel *_closedLabel;
    UILabel *_updatedLabel;
    int     _uniqueId;
}

@property (nonatomic, assign) int uniqueId;

@end
