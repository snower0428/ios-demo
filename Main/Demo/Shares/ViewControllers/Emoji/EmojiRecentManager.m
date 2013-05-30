//
//  EmojiRecentManager.m
//  Demo
//
//  Created by leihui on 13-3-25.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "EmojiRecentManager.h"

#define kMaxRecentCount     21

static EmojiRecentManager *kEmojiRecentManager = nil;

@implementation EmojiRecentManager

+ (EmojiRecentManager *)shareInstance
{
    @synchronized(self)
    {
        if (nil == kEmojiRecentManager) {
            kEmojiRecentManager = [[EmojiRecentManager alloc] init];
        }
    }
    return kEmojiRecentManager;
}

+ (void)exitInstance
{
    @synchronized(self)
    {
        if (kEmojiRecentManager != nil) {
            [kEmojiRecentManager release];
            kEmojiRecentManager = nil;
        }
    }
}

- (NSArray *)getRecentEmoji
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSArray *recentEmoji = [user objectForKey:kRecentEmojiKey];
    return recentEmoji;
}

- (void)saveRecentEmoji:(NSString *)emoji
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recentEmoji = [NSMutableArray arrayWithArray:[user objectForKey:kRecentEmojiKey]];
    if (recentEmoji == nil) {
        [user setObject:[NSArray arrayWithObject:emoji] forKey:kRecentEmojiKey];
        [user synchronize];
    } else {
        if (![recentEmoji containsObject:emoji]) {
            [recentEmoji insertObject:emoji atIndex:0];
            if ([recentEmoji count] > kMaxRecentCount) {
                [recentEmoji removeObjectsInRange:NSMakeRange(kMaxRecentCount, [recentEmoji count] - kMaxRecentCount)];
            }
            [user setObject:recentEmoji forKey:kRecentEmojiKey];
            [user synchronize];
        }
    }
}

#pragma mark - dealloc

- (void)dealloc
{
    [super dealloc];
}

@end
