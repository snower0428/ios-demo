//
//  BabyCompleteViewController.m
//  CommDemo
//
//  Created by leihui on 12-10-22.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import "BabyCompleteViewController.h"
#import "PlistPathManager.h"
#import "BBAnimation.h"

#define ANIMATION_BOUNCE_KEY    @"bounceAnimation"
#define ANIMATION_MOVE_KEY      @"moveAnimation"

@interface BabyCompleteViewController ()
- (void)initBackground;
@end

@implementation BabyCompleteViewController

- (id)init
{
    if (self = [super init]) {
        // Init
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // bg
    UIImageView *bg = [UIImageView imageViewWithFile:@"baby_info_bg.png"];
    [self.view addSubview:bg];
    // 顶部“完成”
    UIImageView *imageViewTop = [UIImageView imageViewWithFile:@"title_complete.png"];
    [self.view addSubview:imageViewTop];
    
    [self initBackground];
    
    // 盒子落下动画
    NSString *babyCompletePlistPath = [PlistPathManager babyCompletePlist];
    NSDictionary *babyCompletePlist = [NSDictionary dictionaryWithContentsOfFile:babyCompletePlistPath];
    if (babyCompletePlist) {
        _animationBox = [LayerParser parseLayerItem:babyCompletePlist resDirectory:RES_DIRECTORY];
        [self.view addSubview:_animationBox];
        [_animationBox setStopSelector:@selector(boxPlayFinished:) target:self context:_animationBox];
    }
    
    // 太阳
    _imageViewSun = [UIImageView imageViewWithFile:@"baby_guide_sun.png" atPostion:CGPointMake(200, 360)];
    [self.view addSubview:_imageViewSun];
    
    // 完成
    _btnComplete = [UIButton buttonWithBackgroundNormalFile:@"btn_complete.png" downFile:@"btn_complete_d.png"];
    _btnComplete.frame = CGRectMake(198, 358, _btnComplete.frame.size.width, _btnComplete.frame.size.height);
    _btnComplete.tag = BabyCompleteActionTypeComplete;
    [self.view addSubview:_btnComplete];
    [_btnComplete addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _imageViewSun.hidden = YES;
    _btnComplete.hidden = YES;
    
#if 1
    // 返回
    UIButton *btnReturn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnReturn.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    btnReturn.frame = CGRectMake(0, 0, 100, 30);
    [btnReturn setTitle:@"返回" forState:UIControlStateNormal];
    [self.view addSubview:btnReturn];
    
    [btnReturn handleControlEvents:UIControlEventTouchUpInside withBlock:^(void) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
#endif
}

- (void)initBackground
{
    // 小背景
    _imageViewBg = [UIImageView imageViewWithFile:@"complete_bg.png" atPostion:CGPointMake(12, 80)];
    _imageViewBg.layer.anchorPoint = CGPointMake(0, 1);
    _imageViewBg.frame = CGRectOffset(_imageViewBg.frame, -_imageViewBg.frame.size.width/2, _imageViewBg.frame.size.height/2);
    
    // 小背景上半部view
    CGRect topFrame = CGRectMake(_imageViewBg.frame.origin.x, _imageViewBg.frame.origin.y,
                                 _imageViewBg.frame.size.width, _imageViewBg.frame.size.height/2);
    _imageViewPortrait = [[UIImageView alloc] initWithFrame:topFrame];
    _imageViewPortrait.backgroundColor = [UIColor clearColor];
    
    
    // 小背景下半部view
    CGRect bottomFrame = CGRectMake(_imageViewBg.frame.origin.x, _imageViewBg.frame.origin.y+_imageViewBg.frame.size.height/2,
                                    _imageViewBg.frame.size.width, _imageViewBg.frame.size.height/2);
    _imageViewLove = [[UIImageView alloc] initWithFrame:bottomFrame];
    _imageViewLove.backgroundColor = [UIColor clearColor];
    
    // 头像
    UIImageView *portrait = [UIImageView imageViewWithFile:@"portrait.png" atPostion:CGPointMake(20, 20)];
    // 头像框
    UILabel *labelPortrait = [UILabel labelWithName:@"头像框"
                                               font:ARIAL_BOLDFONT(18)
                                              frame:CGRectMake(10, 90, 100, 30)
                                              color:[UIColor whiteColor]
                                          alignment:UITextAlignmentCenter];
    // 头像框描述
    UILabel *labelPortraitDes = [UILabel labelWithName:@"        可以换上，宝宝可爱的照片哦！"
                                                  font:ARIAL_BOLDFONT(16)
                                                 frame:CGRectMake(140, 40, 150, 50)
                                                 color:[UIColor whiteColor]];
    labelPortraitDes.numberOfLines = 2;
    
    // 爱心
    UIImageView *love = [UIImageView imageViewWithFile:@"love.png" atPostion:CGPointMake(20, 0)];
    // 爱心罐
    UILabel *labelLove = [UILabel labelWithName:@"爱心罐"
                                           font:ARIAL_BOLDFONT(18)
                                            frame:CGRectMake(10, 70, 100, 30)
                                            color:[UIColor whiteColor]
                                        alignment:UITextAlignmentCenter];
    // 爱心罐描述
    UILabel *labelLoveDes = [UILabel labelWithName:@"        储蓄爱心的神奇罐子,爱心能换好多礼物哦！"
                                              font:ARIAL_BOLDFONT(16)
                                             frame:CGRectMake(100, 30, 190, 50)
                                             color:[UIColor whiteColor]];
    labelLoveDes.numberOfLines = 2;
    
    [self.view          addSubview:_imageViewBg];
    [self.view          addSubview:_imageViewPortrait];
    [self.view          addSubview:_imageViewLove];
    [_imageViewPortrait addSubview:portrait];
    [_imageViewPortrait addSubview:labelPortrait];
    [_imageViewPortrait addSubview:labelPortraitDes];
    [_imageViewLove     addSubview:love];
    [_imageViewLove     addSubview:labelLove];
    [_imageViewLove     addSubview:labelLoveDes];
    
    _imageViewBg.hidden = YES;
    _imageViewPortrait.hidden = YES;
    _imageViewLove.hidden = YES;
    
    [_imageViewPortrait release];
    [_imageViewLove release];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 播放盒子动画
    if (![_animationBox isAnimating]) {
        [_animationBox startAnimating];
    }
    // 显示太阳
    _imageViewSun.hidden = NO;
    
    CGPoint imageCenter = CGPointMake(_imageViewSun.frame.origin.x+_imageViewSun.frame.size.width/2, _imageViewSun.frame.origin.y+_imageViewSun.frame.size.height/2);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, imageCenter.x, self.view.bounds.size.height);
    CGPathAddLineToPoint(path, NULL, imageCenter.x, imageCenter.y-15);
    CGPathAddLineToPoint(path, NULL, imageCenter.x, imageCenter.y+10);
    CGPathAddLineToPoint(path, NULL, imageCenter.x, imageCenter.y-5);
    CGPathAddLineToPoint(path, NULL, imageCenter.x, imageCenter.y);
    
    CAKeyframeAnimation *animation = [BBAnimation keyframeAnimation:path duration:0.5 repeateCount:1];
    [_imageViewSun.layer addAnimation:animation forKey:nil];
    
    CGPathRelease(path);
}

#pragma mark --------------------  buttonClicked --------------------

- (void)boxPlayFinished:(id)context
{
    _imageViewBg.hidden = NO;
    
    CAKeyframeAnimation *animation = [BBAnimation bounceAnimationWith:self duration:0.5];
    [animation setValue:@"bgImageViewBounce" forKey:ANIMATION_BOUNCE_KEY];
    [_imageViewBg.layer addAnimation:animation forKey:nil];
}

- (void)showPortrait
{
    if (_imageViewPortrait.hidden) {
        _imageViewPortrait.hidden = NO;
    }
    CAKeyframeAnimation *animation = [BBAnimation bounceAnimationWith:self duration:0.3];
    [animation setValue:@"showPortrait" forKey:ANIMATION_BOUNCE_KEY];
    [_imageViewPortrait.layer addAnimation:animation forKey:nil];
}

- (void)showLove
{
    if (_imageViewLove.hidden) {
        _imageViewLove.hidden = NO;
    }
    CAKeyframeAnimation *animation = [BBAnimation bounceAnimationWith:self duration:0.3];
    [animation setValue:@"showLove" forKey:ANIMATION_BOUNCE_KEY];
    [_imageViewLove.layer addAnimation:animation forKey:nil];
}

- (void)showCompleteButton
{
    [UIView beginAnimations:@"RotateButton" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:_imageViewSun cache:YES];
    [UIView setAnimationDelegate:self];
    _imageViewSun.image = [UIImage imageNamed:@"btn_complete.png"];
    [UIView commitAnimations];
}

- (void)buttonClicked:(UIButton *)button
{
    int buttonTag = button.tag;
    
    switch (buttonTag) {
        case BabyCompleteActionTypeComplete:
        {
            // 完成
            CABasicAnimation *animation = [BBAnimation moveY:[NSNumber numberWithFloat:200] target:self duration:0.3];
            [animation setValue:@"completeButton" forKey:ANIMATION_MOVE_KEY];
            [_btnComplete.layer addAnimation:animation forKey:nil];
        }break;
            
        default:
            break;
    }
}

- (void)onComplete
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^(void){
                         self.view.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [self.navigationController popToRootViewControllerAnimated:NO];
                     }];
}

#pragma mark --------------------  delegate --------------------

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:ANIMATION_BOUNCE_KEY] isEqualToString:@"bgImageViewBounce"]) {
        // 小背景动画结束
        [self showPortrait];
        [self performSelector:@selector(showLove) withObject:nil afterDelay:0.3];
    } else if ([[anim valueForKey:ANIMATION_BOUNCE_KEY] isEqualToString:@"showLove"]) {
        // 显示完成按钮
        [self showCompleteButton];
    } else if ([[anim valueForKey:ANIMATION_MOVE_KEY] isEqualToString:@"completeButton"]) {
        // 完成按钮动画结束
        NSLog(@"完成按钮动画结束");
        [self onComplete];
    }
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"RotateButton"]) {
       
        if (_imageViewSun) {
            [_imageViewSun removeFromSuperview];
            _imageViewSun = nil;
        }
        
         _btnComplete.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    if (_animationBox && [_animationBox isAnimating]) {
        [_animationBox stopAnimating];
    }
    [super dealloc];
}

@end
