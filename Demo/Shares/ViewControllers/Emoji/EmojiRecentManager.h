//
//  EmojiRecentManager.h
//  Demo
//
//  Created by leihui on 13-3-25.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRecentEmojiKey     @"RecentEmoji"

@interface EmojiRecentManager : NSObject

+ (EmojiRecentManager *)shareInstance;
+ (void)exitInstance;
- (NSArray *)getRecentEmoji;
- (void)saveRecentEmoji:(NSString *)emoji;

@end
