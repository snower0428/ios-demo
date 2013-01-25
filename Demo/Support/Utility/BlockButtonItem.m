//
//  BlockButtonItem.m
//  BabyReader
//
//  Created by zhang tianfu on 12-3-17.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import "BlockButtonItem.h"

@implementation BlockButtonItem

@synthesize title = m_title;
@synthesize block = m_block;


+ (BlockButtonItem*)item{
    return [[[self alloc] init] autorelease];
}

+ (BlockButtonItem*)itemWithTitle:(NSString*)tile block:(ButtonBlock)block{
    BlockButtonItem *item = [BlockButtonItem item];
    item.title = tile;
    item.block = block;
    return item;
}

- (void)setBlock:(ButtonBlock)block{
    if (m_block) {
        Block_release(m_block);
        m_block = nil;
    }
    m_block = Block_copy(block);
}

- (void)dealloc{
    self.title = nil;
    self.block = nil;
    [super dealloc];
}
@end
