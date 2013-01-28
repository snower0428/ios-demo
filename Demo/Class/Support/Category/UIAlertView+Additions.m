//
//  UIAlertView+Additions.m
//  Demo
//
//  Created by hui lei on 13-1-26.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import "UIAlertView+Additions.h"
#import <objc/runtime.h>

static UIAlertView *kAlertViewHUD = nil;
static NSString *KEY_BLOCK_ITEM_LIST = @"KEY_BLOCK_ITEM_LIST";

@implementation UIAlertView(Additions)

+ (UIAlertView*)showAlertViewWithTitle:(NSString *)title  
                               message:(NSString *)message
{
    return [self showAlertViewWithTitle:title 
                                message:message 
                       cancelButtonItem:[BlockButtonItem itemWithTitle:@"确定" block:nil] 
                       otherButtonItems:nil];
}

+ (UIAlertView*)showAlertViewWithTitle:(NSString *)title 
                               message:(NSString *)message 
                      cancelButtonItem:(BlockButtonItem *)cancelButtonItem 
                      otherButtonItems:(BlockButtonItem *)otherButtonItems, ...
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title 
                                                        message:message 
                                               cancelButtonItem:cancelButtonItem 
                                               otherButtonItems:nil];
    if (otherButtonItems) {
        [alertView addButtonItem:otherButtonItems];
        
        va_list list;
        va_start(list, otherButtonItems);
        BlockButtonItem *item = nil;
        while ((item = va_arg(list, BlockButtonItem*))) {
            [alertView addButtonItem:item];
        }
        va_end(list);
    }
    [alertView show];
    [alertView release];
    
    return alertView;
}

- (id)initWithTitle:(NSString *)title 
            message:(NSString *)message 
   cancelButtonItem:(BlockButtonItem *)cancelButtonItem 
   otherButtonItems:(BlockButtonItem *)otherButtonItems, ...
{
    if (self = [self initWithTitle:title 
                           message:message 
                          delegate:self 
                 cancelButtonTitle:cancelButtonItem.title 
                 otherButtonTitles:nil]) {
        NSMutableArray *buttonItems = [NSMutableArray array];
        if (cancelButtonItem) {
            [buttonItems addObject:cancelButtonItem];
        }
        
        objc_setAssociatedObject(self, KEY_BLOCK_ITEM_LIST, buttonItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (otherButtonItems) {
            [self addButtonItem:otherButtonItems];
            
            va_list list;
            va_start(list, otherButtonItems);
            BlockButtonItem *item = nil;
            while ((item = va_arg(list, BlockButtonItem*))) {
                [self addButtonItem:item];
            }
            va_end(list);
        }
    }
    
    return self;
}

- (NSInteger)addButtonWithTitle:(NSString *)title block:(ButtonBlock)block
{
    return [self addButtonItem:[BlockButtonItem itemWithTitle:title block:block]];
}

- (NSInteger)addButtonItem:(BlockButtonItem *)item
{
    if (item) {
        NSMutableArray *buttonItems = objc_getAssociatedObject(self, KEY_BLOCK_ITEM_LIST);
        [buttonItems addObject:item];
        
        NSInteger index = [self addButtonWithTitle:item.title];
        return index;
    }
    
    return -1;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSArray *buttonItems = objc_getAssociatedObject(self, KEY_BLOCK_ITEM_LIST);
    if (buttonIndex < [buttonItems count]) {
        BlockButtonItem *item = [buttonItems objectAtIndex:buttonIndex];
        ButtonBlock block = item.block;
        if (block) {
            block();
        }
    }
}

/*AlertViewHUD*/
+ (UIAlertView *)showWaitingDialog:(NSString *)text
{
    if (nil == kAlertViewHUD) {
        kAlertViewHUD = [[UIAlertView alloc] initWithTitle:text 
                                                   message:nil 
                                                  delegate:nil 
                                         cancelButtonTitle:nil 
                                         otherButtonTitles:nil];
        [kAlertViewHUD show];
        [kAlertViewHUD release];
        
        float x = kAlertViewHUD.frame.size.width/2-10;
        float y = kAlertViewHUD.frame.size.height - 60;
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [indicatorView setCenter:CGPointMake(x, y)];
        [kAlertViewHUD addSubview:indicatorView];
        [indicatorView release];
        [indicatorView startAnimating];
    } else {
        [kAlertViewHUD setTitle:text];
    }
    
    return kAlertViewHUD;
}

+ (void)updateWaitingDialog:(NSString *)text
{
    [kAlertViewHUD setTitle:text];
}

+ (void)closeWaitingDialog
{
    [kAlertViewHUD dismissWithClickedButtonIndex:0 animated:YES];
    kAlertViewHUD = nil;
}

@end
