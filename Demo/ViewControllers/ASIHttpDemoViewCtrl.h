//
//  ASIHttpDemoViewCtrl.h
//  CommDemo
//
//  Created by leihui on 12-11-14.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASINetworkQueue.h"

@interface ASIHttpDemoViewCtrl : UIViewController <ASIProgressDelegate, ASIHTTPRequestDelegate>
{
    ASINetworkQueue         *_networkQueue;
}

@end
