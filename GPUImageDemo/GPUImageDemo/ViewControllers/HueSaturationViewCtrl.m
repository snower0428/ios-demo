//
//  HueSaturationViewCtrl.m
//  GPUImageDemo
//
//  Created by leihui on 13-11-25.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "HueSaturationViewCtrl.h"

@interface HueSaturationViewCtrl ()
{
    GPUImageHueFilter           *_filterHue;
    GPUImageSaturationFilter    *_filterSaturation;
    
    UISlider    *_sliderHue;
    UISlider    *_sliderSaturaion;
}

@end

@implementation HueSaturationViewCtrl

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
    
    self.title = @"Hue/Saturation";
    
    [self initGPUImageFilter];
    
    _sliderHue = [[self sliderWithValue:90.0 minimumValue:0.0 maximumValue:360.0] retain];
    _sliderSaturaion = [[self sliderWithValue:1.0 minimumValue:0.0 maximumValue:2.0] retain];
    
    CGFloat leftMargin = 10.f;
    CGFloat width = 300.f;
    CGFloat height = 30.f;
    _sliderHue.frame = CGRectMake(leftMargin, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-2*30, width, height);
    _sliderSaturaion.frame = CGRectMake(leftMargin, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-30, width, height);
    
    [_sliderHue addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [_sliderSaturaion addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_sliderHue];
    [self.view addSubview:_sliderSaturaion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override

- (void)resetAction:(id)sender
{
    _sliderHue.value = 90.0;
    _sliderSaturaion.value = 1.0;
    
    _filterHue.hue = 90.0;
    _filterSaturation.saturation = 1.0;
    
    [_picture processImage];
}

#pragma mark - Private

- (void)initGPUImageFilter
{
    //创建输入源
    _picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:kTestImageFileName] smoothlyScaleOutput:YES];
    
    //创建滤镜
    _filterHue = [[GPUImageHueFilter alloc] init];
    _filterSaturation = [[GPUImageSaturationFilter alloc] init];
    
    //创建输出界面
    GPUImageView *imageView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imageView];
    
    [_picture addTarget:_filterSaturation];
    [_filterSaturation addTarget:_filterHue];
    [_filterHue addTarget:imageView];
    
    [imageView release];
    
    [_picture processImage];
}

- (void)sliderAction:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    CGFloat value = slider.value;
    
    if (slider == _sliderHue) {
        _filterHue.hue = value;
    }
    else if (slider == _sliderSaturaion) {
        _filterSaturation.saturation = value;
    }
    
    [_picture processImage];
}

#pragma mark - dealloc

- (void)dealloc
{
    [_filterHue release];
    [_filterSaturation release];
    [_sliderHue release];
    [_sliderSaturaion release];
    
    [super dealloc];
}

@end
