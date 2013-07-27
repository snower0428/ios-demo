//
//  KalBottomView.m
//  PandaHome
//
//  Created by leihui on 13-7-9.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "KalBottomView.h"

@interface KalBottomView ()

- (void)createItems;

@end

@implementation KalBottomView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createItems];
    }
    return self;
}

#pragma mark - Private

- (void)createItems
{
    NSArray *arrayTitle = [NSArray arrayWithObjects:_(@"Time"), _(@"Style"), nil];
    UIImage *image = [UIImage imageFile:@"Kal.bundle/btn_white_bg.png"];
    UIImage *stretchImage = [image stretchableImageWithLeftCapWidth:4 topCapHeight:0];
    
    UIImage *imagePreview = [UIImage imageFile:@"Kal.bundle/btn_blue_bg.png"];
    UIImage *stretchImagePreview = [imagePreview stretchableImageWithLeftCapWidth:4 topCapHeight:0];
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20+i*120+i*40, 10, 120, 32);
        
        if (i < [arrayTitle count]) {
            [button setTitle:[arrayTitle objectAtIndex:i] forState:UIControlStateNormal];
        }
        button.tag = KalBottomViewActionTime+i;
        
        if (i == 0) {
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor colorWithWhite:1.0 alpha:1.0] forState:UIControlStateNormal];
            [button setBackgroundImage:stretchImagePreview forState:UIControlStateNormal];
        }
        else {
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button setTitleColor:[UIColor colorWithRed:36.0/255.0 green:36.0/255.0 blue:36.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [button setBackgroundImage:stretchImage forState:UIControlStateNormal];
        }
        
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)btnClicked:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(bottomBarItemSelected:)]) {
        [_delegate bottomBarItemSelected:sender];
    }
}

#pragma mark - dealloc

- (void)dealloc
{
    [super dealloc];
}

@end
