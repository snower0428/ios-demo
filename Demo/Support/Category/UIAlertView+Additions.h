//
//  UIAlertView+Additions.h
//  Demo
//
//  Created by hui lei on 13-1-26.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIAlertView(Additions)

+ (UIAlertView*)showAlertViewWithTitle:(NSString *)title  
                               message:(NSString *)message;
+ (UIAlertView*)showAlertViewWithTitle:(NSString *)title 
                               message:(NSString *)message 
                      cancelButtonItem:(BlockButtonItem *)cancelButtonItem 
                      otherButtonItems:(BlockButtonItem *)otherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

- (id)initWithTitle:(NSString *)title 
            message:(NSString *)message 
   cancelButtonItem:(BlockButtonItem *)cancelButtonItem 
   otherButtonItems:(BlockButtonItem *)otherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

- (NSInteger)addButtonWithTitle:(NSString *)title block:(ButtonBlock)block; 
- (NSInteger)addButtonItem:(BlockButtonItem *)item; 

/*AlertViewHUD*/
+ (UIAlertView *)showWaitingDialog:(NSString *)text;
+ (void)updateWaitingDialog:(NSString *)text;
+ (void)closeWaitingDialog;

@end
