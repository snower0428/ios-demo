//
//  BlockButtonItem.h
//  BabyReader
//
//  Created by zhang tianfu on 12-3-17.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockButtonItem : NSObject{
    NSString    *m_title;
    ButtonBlock m_block;
}

@property(nonatomic, retain)    NSString    *title;
@property(nonatomic, copy)      ButtonBlock block;

+ (BlockButtonItem*)item;
+ (BlockButtonItem*)itemWithTitle:(NSString*)tile block:(ButtonBlock)block;

@end
