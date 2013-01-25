//
//  AppstoreManager.m
//  BabyReader
//
//  Created by tianfu zhang on 12-6-29.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import "AppstoreManager.h"


@implementation AppstoreManager

//打开appstore的评论连接
+ (void)openEvaluateView{
	NSString *appleid = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppleID"];
	if (appleid) {
		NSString *urlString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", 
							   appleid];  
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
	}
}

//app在iTunes上页面地址
+ (NSString*)appURLInAppstore{
    NSString *appleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppleID"];
#if 0
    appleID = @"424791480";//宝宝童书系列1,测试用
#endif
    NSString *URLString = [NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@", appleID];
    return URLString;
}

//检查appstore的最新版本
+ (BOOL)checkNewVersion{
    NSString *appleid = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppleID"];
#if 0
    appleid = @"424791480";//宝宝童书系列1,测试用
#endif
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appleid];
    
    NSError *error = nil;
    NSDictionary *jsonValue = [Utility jsonValueFromURLString:url error:&error];
    NSArray *results = [jsonValue objectForKey:@"results"];
    if (results && [results isKindOfClass:[NSArray class]] && [results count]>0) {
        NSDictionary *result = [results objectAtIndex:0];
        NSString *newVersion = [result objectForKey:@"version"];
        float newVersionValue = [[newVersion formatVersion] floatValue];
        NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        float currentVersionValue = [[currentVersion formatVersion] floatValue];
        if (newVersionValue > currentVersionValue) {
            //record data
            NSMutableDictionary *checkVersion = [NSMutableDictionary dictionaryWithDictionary:[Utility readUserDefaultsObjectForKey:@"checkVersion"]];
            [checkVersion setValue:newVersion forKey:@"version"];
            [checkVersion setValue:[NSNumber numberWithDouble:[NSDate timeIntervalSinceReferenceDate]] forKey:@"date"];
            [Utility saveUserDefaultsObject:checkVersion forKey:@"checkVersion"];
            
            //show alertview
            NSString *releaseNotes = [result objectForKey:@"releaseNotes"];
            NSString *title = [NSString stringWithFormat:@"发现新版本:V%@", newVersion];
            NSString *message = [NSString stringWithFormat:@"更新说明:\n%@", releaseNotes];
            [UIAlertView showAlertViewWithTitle:title 
                                        message:message 
                               cancelButtonItem:[BlockButtonItem itemWithTitle:@"取消" block:nil] 
                               otherButtonItems:[BlockButtonItem itemWithTitle:@"更新" block:^{
                NSString *trackViewUrl = [result objectForKey:@"trackViewUrl"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[trackViewUrl encodeURL]]];
            }], nil];
            
            return YES;
        }else{
            [UIAlertView showAlertViewWithTitle:@"当前已经是最新版本了！" message:[NSString stringWithFormat:@"version: %@",currentVersion]];
            return YES;
        }
    }else{
        if (error && [error code] == NSURLErrorNotConnectedToInternet) {
            [UIAlertView showAlertViewWithTitle:@"无法连接网络!" message:nil];
            return NO;
        }
    }

    [UIAlertView showAlertViewWithTitle:@"无法检测新版本！" message:nil];
    
    return NO;
}

+ (void)checkNewVersionWithoutAlert{
    NSString *appleid = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppleID"];
#if 0
    appleid = @"424791480";//宝宝童书系列1,测试用
#endif
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appleid];
    
    NSError *error = nil;
    NSDictionary *jsonValue = [Utility jsonValueFromURLString:url error:&error];
    NSArray *results = [jsonValue objectForKey:@"results"];
    if (results && [results isKindOfClass:[NSArray class]] && [results count]>0) {
        NSDictionary *result = [results objectAtIndex:0];
        NSString *newVersion = [result objectForKey:@"version"];
        float newVersionValue = [[newVersion formatVersion] floatValue];
        NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        float currentVersionValue = [[currentVersion formatVersion] floatValue];
        if (newVersionValue > currentVersionValue) {
            //record data
            NSMutableDictionary *checkVersion = [NSMutableDictionary dictionaryWithDictionary:[Utility readUserDefaultsObjectForKey:@"checkVersion"]];
            [checkVersion setValue:newVersion forKey:@"version"];
            [checkVersion setValue:[NSNumber numberWithDouble:[NSDate timeIntervalSinceReferenceDate]] forKey:@"date"];
            [Utility saveUserDefaultsObject:checkVersion forKey:@"checkVersion"];
            
            //show alertview
            NSString *releaseNotes = [result objectForKey:@"releaseNotes"];
            NSString *title = [NSString stringWithFormat:@"发现新版本:V%@", newVersion];
            NSString *message = [NSString stringWithFormat:@"更新说明:\n%@", releaseNotes];
            [UIAlertView showAlertViewWithTitle:title 
                                        message:message 
                               cancelButtonItem:[BlockButtonItem itemWithTitle:@"取消" block:nil] 
                               otherButtonItems:[BlockButtonItem itemWithTitle:@"更新" block:^{
                NSString *trackViewUrl = [result objectForKey:@"trackViewUrl"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[trackViewUrl encodeURL]]];
            }], nil];
        }
    }
}

+ (void)autoCheckNewVersion{
    NSMutableDictionary *checkVersion = [NSMutableDictionary dictionaryWithDictionary:[Utility readUserDefaultsObjectForKey:@"checkVersion"]];

    //先检查本地是否已经有保存记录
    NSString *version = [checkVersion objectForKey:@"version"];
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    if ([version formatVersion] > [currentVersion formatVersion]) {
        NSString *title = [NSString stringWithFormat:@"发现新版本:V%@", version];
        NSString *message = @"是否现在更新？";
        [UIAlertView showAlertViewWithTitle:title
                                    message:message 
                           cancelButtonItem:[BlockButtonItem itemWithTitle:@"取消" block:nil] 
                           otherButtonItems:[BlockButtonItem itemWithTitle:@"更新" block:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[AppstoreManager appURLInAppstore]]];
        }], nil];
    }else {//判断是否达到了检查条件
        NSTimeInterval interval = [[checkVersion objectForKey:@"date"] doubleValue];
        NSTimeInterval curentInterval = [NSDate timeIntervalSinceReferenceDate];
        if ((curentInterval - interval) > 7*24*3600){//do check
            [checkVersion setValue:[NSNumber numberWithDouble:curentInterval] forKey:@"date"];
            [Utility saveUserDefaultsObject:checkVersion forKey:@"checkVersion"];
            
            [AppstoreManager checkNewVersionWithoutAlert];
        }
    }
}

@end
