//
//  BaseViewCtrl.m
//  GPUImageDemo
//
//  Created by leihui on 13-11-25.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "BaseViewCtrl.h"

@interface BaseViewCtrl ()

@end

@implementation BaseViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initRightNavigationItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)initRightNavigationItem
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
}

- (GPUImageOutput<GPUImageInput> *)filterWithImage:(UIImage *)image
{
    //创建输入源
    _picture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
    
    //创建滤镜
    GPUImageOutput<GPUImageInput> *filter = [[[self filterClass] alloc] init];
    
    //创建输出界面
    GPUImageView *imageView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imageView];
    
    [_picture addTarget:filter];
    
    [filter addTarget:imageView];
    [imageView release];
    
    [_picture processImage];
    
    return filter;
}

- (UISlider *)sliderWithValue:(CGFloat)value minimumValue:(CGFloat)minimumValue maximumValue:(CGFloat)maximumValue
{
    CGFloat leftMargin = 10.f;
    CGFloat width = 300.f;
    CGFloat height = 30.f;
    CGRect frame = CGRectZero;
    
    frame = CGRectMake(leftMargin, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-30, width, height);
    UISlider *slider = [[[UISlider alloc] initWithFrame:frame] autorelease];
    slider.minimumValue = minimumValue;
    slider.maximumValue = maximumValue;
    slider.value = value;
    
    return slider;
}

- (void)resetAction:(id)sender
{
    NSLog(@"implemented by subclass");
}

- (Class)filterClass
{
    return [GPUImageFilter class];
}

#pragma mark - dealloc

- (void)dealloc
{
    [_picture release];
    
    [super dealloc];
}

@end
