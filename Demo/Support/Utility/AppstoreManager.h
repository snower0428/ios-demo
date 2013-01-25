//
//  AppstoreManager.h
//  BabyReader
//
//  Created by tianfu zhang on 12-6-29.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppstoreManager : NSObject

//打开appstore的评论连接
+ (void)openEvaluateView;

//app在iTunes上页面地址
+ (NSString*)appURLInAppstore;

//检查appstore的最新版本
+ (BOOL)checkNewVersion;

//自动检查更新（超过7天检查一次）
+ (void)autoCheckNewVersion;
@end
