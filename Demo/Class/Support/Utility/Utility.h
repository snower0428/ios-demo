//
//  Utility.h
//  BomBomBom
//
//  Created by zhangtianfu on 12-2-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utility : NSObject

#pragma mark --------------ProgressHUD-----------------------------
+ (void)displayProgressHUD:(NSString*)text onView:(UIView*)container;
+ (void)closeProgressHUD;
+ (void)setProgressHUDText:(NSString*)text;
+ (void)showText:(NSString*)text onView:(UIView*)container whileExecuting:(SEL)method onTarget:(id)target withObject:(id)object;

#pragma mark--------------UserDefaults-----------------------------
+ (id)readUserDefaultsObjectForKey:(NSString *)key;
+ (void)saveUserDefaultsObject:(id)object forKey:(NSString *)key;


//图标抖动
+ (void)shakeView:(UIView*)view animated:(BOOL)animated;

//检查Email是否合法
+ (BOOL)isValidEmail:(NSString *)checkString;

//GUID
+ (NSString *)GUIDString;

//将元素对拼接成URL
+ (NSString *)URLStringFromDictionary:(NSDictionary *)dict;

//中文字数
+ (int)getChineseCharacterLength:(NSString *)text;

+ (id)jsonValueFromURLString:(NSString *)URLString error:(NSError **)error;
@end

