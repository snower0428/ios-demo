//
//  BabySelectViewController.m
//  CommDemo
//
//  Created by leihui on 12-10-18.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import "BabySelectViewController.h"
#import "BabyInputViewCtrl.h"
#import "BBAnimation.h"

@interface BabySelectViewController ()
- (void)showBounceAnimationOnView:(UIView *)view;
- (void)showNextButton;
- (void)initPregnancyButton;
- (void)initHasBabyButton;
//- (void)updateButtonState;
@end

@implementation BabySelectViewController

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
    
    // 顶部“选择时期”
    _imageViewTitle = [UIImageView imageViewWithFile:@"title_select.png"];
    [self.view addSubview:_imageViewTitle];
    
    // 底部“请选择时期”
    _imageViewBottom = [UIImageView imageViewWithFile:@"cloud_bg.png" atPostion:CGPointMake(0, 0)];
    
    UILabel *label = [UILabel labelWithName:@"请选择时期"
                                       font:ARIAL_BOLDFONT(20)
                                      frame:CGRectMake(0, 5, _imageViewBottom.frame.size.width, _imageViewBottom.frame.size.height)
                                      color:nil
                                  alignment:UITextAlignmentCenter];
    [_imageViewBottom addSubview:label];
    
    UIImageView *maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 418, 320, 42)];
    maskView.clipsToBounds = YES;
    maskView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:maskView];
    [maskView release];
    [maskView addSubview:_imageViewBottom];
    
    // 分隔线
    UIImageView *separate = [UIImageView imageViewWithFile:@"separate.png" atPostion:CGPointMake(15, 230)];
    [self.view addSubview:separate];
    
    // 太阳
    _imageViewSun = [UIImageView imageViewWithFile:@"baby_guide_sun.png" atPostion:CGPointMake(250, 390)];
    [self.view addSubview:_imageViewSun];
    
    [self initPregnancyButton];
    [self initHasBabyButton];
    
    // 下一步
    _btnNext = [UIButton buttonWithBackgroundNormalFile:@"btn_next.png" downFile:@"btn_next_d.png"];
    _btnNext.frame = CGRectMake(248, 388, _btnNext.frame.size.width, _btnNext.frame.size.height);
    [self.view addSubview:_btnNext];
    [_btnNext addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnNext.tag = BabySelectActionTypeNext;
#if 1
    // 返回
    UIButton *btnReturn = [UIButton buttonWithBackgroundNormalFile:@"btn_return.png" downFile:@"btn_return_d.png"];
    btnReturn.frame = CGRectMake(15, 418, btnReturn.frame.size.width, btnReturn.frame.size.height);
    [self.view addSubview:btnReturn];
    
    [btnReturn handleControlEvents:UIControlEventTouchUpInside withBlock:^(void){
        [self.navigationController popViewControllerAnimated:YES];
    }];
#endif
    _btnPregnancy.hidden = YES;
    _btnHasBaby.hidden = YES;
    _btnNext.hidden = YES;
    
    _imageViewTitle.frame = CGRectOffset(_imageViewTitle.frame, 0, -100);
    maskView.frame = CGRectOffset(maskView.frame, self.view.bounds.size.width, 0);
    _imageViewBottom.frame = CGRectOffset(_imageViewBottom.frame, -self.view.bounds.size.width, 0);
    
    [UIView animateWithDuration:0.8
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                         _imageViewTitle.frame = CGRectOffset(_imageViewTitle.frame, 0, 100);
                         maskView.frame = CGRectOffset(maskView.frame, -self.view.bounds.size.width, 0);
                         _imageViewBottom.frame = CGRectOffset(_imageViewBottom.frame, self.view.bounds.size.width, 0);
                     }
                     completion:^(BOOL finished){
                         [self showBounceAnimationOnView:_btnPregnancy];
                         [self performSelector:@selector(showBounceAnimationOnView:) withObject:_btnHasBaby afterDelay:0.5];
                     }];
    
//    [self updateButtonState];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

// 初始化怀孕期按钮
- (void)initPregnancyButton
{
    _btnPregnancy = [UIButton buttonWithBackgroundNormalFile:@"btn_pregnancy.png" downFile:@"btn_pregnancy_d.png"];
    _btnPregnancy.frame = CGRectMake(0, 65, _btnPregnancy.frame.size.width, _btnPregnancy.frame.size.height);
    [self.view addSubview:_btnPregnancy];
    [_btnPregnancy addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnPregnancy.tag = BabySelectActionTypePregnancy;
    
    UILabel *labelPregnancy = [UILabel labelWithName:@"怀孕期" font:ARIAL_BOLDFONT(20) frame:CGRectMake(165, 45, 100, 30) color:[UIColor whiteColor]];
    [_btnPregnancy addSubview:labelPregnancy];
    
    UILabel *labelPregnancyDes1 = [UILabel labelWithName:@"输入预产期"
                                                    font:ARIAL_BOLDFONT(16)
                                                   frame:CGRectMake(165, labelPregnancy.frame.origin.y+40, 120, 20)
                                                   color:[UIColor whiteColor]];
    [_btnPregnancy addSubview:labelPregnancyDes1];
    
    UILabel *labelPregnancyDes2 = [UILabel labelWithName:@"或最后月经时间"
                                                    font:ARIAL_BOLDFONT(16)
                                                   frame:CGRectMake(165, labelPregnancy.frame.origin.y+60, 120, 20)
                                                   color:[UIColor whiteColor]];
    [_btnPregnancy addSubview:labelPregnancyDes2];
}

// 初始化有宝宝按钮
- (void)initHasBabyButton
{
    _btnHasBaby = [UIButton buttonWithBackgroundNormalFile:@"btn_has_baby.png" downFile:@"btn_has_baby_d.png"];
    _btnHasBaby.frame = CGRectMake(15, 235, _btnHasBaby.frame.size.width, _btnHasBaby.frame.size.height);
    [self.view addSubview:_btnHasBaby];
    [_btnHasBaby addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnHasBaby.tag = BabySelectActionTypeHasBaby;
    
    UILabel *labelHasBaby = [UILabel labelWithName:@"有宝宝" font:ARIAL_BOLDFONT(20) frame:CGRectMake(25, 40, 100, 30) color:[UIColor whiteColor]];
    [_btnHasBaby addSubview:labelHasBaby];
    
    UILabel *labelHasBabyDes = [UILabel labelWithName:@"选择宝宝性别输入宝宝生日"
                                                 font:ARIAL_BOLDFONT(16)
                                                frame:CGRectMake(25, labelHasBaby.frame.origin.y+40, 110, 40)
                                                color:[UIColor whiteColor]];
    labelHasBabyDes.numberOfLines = 2;
    [_btnHasBaby addSubview:labelHasBabyDes];
}

//- (void)updateButtonState
//{
//    if ([PubFunction stringIsNullOrEmpty:[[CommBusiness getInstance] currentRoleID]]) {
//        [_btnPregnancy setBackgroundImage:[UIImage imageNamed:@"btn_pregnancy.png"] forState:UIControlStateNormal];
//        [_btnHasBaby setBackgroundImage:[UIImage imageNamed:@"btn_has_baby.png"] forState:UIControlStateNormal];
//    }else if (CommBusiness.babyInfo.isConceive) {
//        [_btnPregnancy setBackgroundImage:[UIImage imageNamed:@"btn_pregnancy_d.png"] forState:UIControlStateNormal];
//        [_btnHasBaby setBackgroundImage:[UIImage imageNamed:@"btn_has_baby.png"] forState:UIControlStateNormal];
//        _btnNext.hidden = NO;
//        _hasBaby = NO;
//    }else {
//        [_btnPregnancy setBackgroundImage:[UIImage imageNamed:@"btn_pregnancy.png"] forState:UIControlStateNormal];
//        [_btnHasBaby setBackgroundImage:[UIImage imageNamed:@"btn_has_baby_d.png"] forState:UIControlStateNormal];
//        _btnNext.hidden = NO;
//        _hasBaby = YES;
//    }
//}

- (void)buttonClicked:(UIButton *)button
{
    int buttonTag = button.tag;
    
    switch (buttonTag) {
        case BabySelectActionTypePregnancy:
        {
            // 怀孕期
            [_btnPregnancy setBackgroundImage:[UIImage imageNamed:@"btn_pregnancy_d.png"] forState:UIControlStateNormal];
            [_btnHasBaby setBackgroundImage:[UIImage imageNamed:@"btn_has_baby.png"] forState:UIControlStateNormal];
            
            if (_btnNext.hidden) {
                [self showNextButton];
            }
            
            _hasBaby = NO;
        }break;
            
        case BabySelectActionTypeHasBaby:
        {
            // 有宝宝
            [_btnPregnancy setBackgroundImage:[UIImage imageNamed:@"btn_pregnancy.png"] forState:UIControlStateNormal];
            [_btnHasBaby setBackgroundImage:[UIImage imageNamed:@"btn_has_baby_d.png"] forState:UIControlStateNormal];
            
            if (_btnNext.hidden) {
                [self showNextButton];
            }
            
            _hasBaby = YES;
        }break;
            
        case BabySelectActionTypeNext:
        {
            // 下一步
            BabyInputViewCtrl *babyInputCtrl = [[BabyInputViewCtrl alloc] initWithBaby:_hasBaby];
            [self.navigationController pushViewController:babyInputCtrl animated:YES];
            [babyInputCtrl release];
        }break;
            
        default:
            break;
    }
}

- (void)showBounceAnimationOnView:(UIView *)view
{
    if (view.isHidden) {
        view.hidden = NO;
    }
    
    CAKeyframeAnimation *animation = [BBAnimation bounceAnimationWith:self duration:0.5];
	[view.layer addAnimation:animation forKey:nil];
}

- (void)showNextButton
{
    [UIView beginAnimations:@"RotateButton" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:_imageViewSun cache:YES];
    
    _imageViewSun.image = [UIImage imageNamed:@"btn_next.png"];
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"animationDidStop:finished:");
    
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"RotateButton"]) {
        _btnNext.hidden = NO;
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
    [super dealloc];
}

@end
