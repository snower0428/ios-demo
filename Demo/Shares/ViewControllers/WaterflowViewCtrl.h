//
//  WaterflowViewCtrl.h
//  Demo
//
//  Created by leihui on 13-4-10.
//
//

#import <UIKit/UIKit.h>
#import "WaterflowView.h"

@interface WaterflowViewCtrl : UIViewController <WaterflowViewDatasource, WaterflowViewDelegate>
{
    WaterflowView       *_waterflowView;
    NSArray             *_imageUrls;
}

@end
