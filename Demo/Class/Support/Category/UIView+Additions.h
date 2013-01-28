//
//  UIView+Additions.h
//  Demo
//
//  Created by lei hui on 13-1-25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(Additions)

//当前view所属的UIViewController
- (id)viewController;

//截屏
- (UIImage *)captureScreen;
- (void)setPosition:(CGPoint)pt;
- (void)scaleFrameWithSize:(CGSize)size;

@end
