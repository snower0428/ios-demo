//
//  ASIHttpDemoViewCtrl.h
//  CommDemo
//
//  Created by leihui on 12-11-14.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBaseViewController.h"
#import "ASINetworkQueue.h"

@interface ASIHttpDemoViewCtrl : LHBaseViewController <ASIProgressDelegate, ASIHTTPRequestDelegate>
{
    ASINetworkQueue         *_networkQueue;
}

@end
