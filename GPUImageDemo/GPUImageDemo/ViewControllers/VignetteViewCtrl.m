//
//  VignetteViewCtrl.m
//  GPUImageDemo
//
//  Created by leihui on 13-11-25.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "VignetteViewCtrl.h"

@interface VignetteViewCtrl ()
{
    GPUImageVignetteFilter  *_vignetteFilter;
    UISlider    *_startSlider;
    UISlider    *_endSlider;
}

@end

@implementation VignetteViewCtrl

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
    
    self.title = @"Vignette";
    
    _vignetteFilter = (GPUImageVignetteFilter *)[[self filterWithImage:[UIImage imageNamed:kTestImageFileName]] retain];
    _startSlider = [[self sliderWithValue:0.3 minimumValue:0.0 maximumValue:1.0] retain];
    _endSlider = [[self sliderWithValue:0.75 minimumValue:0.0 maximumValue:1.0] retain];
    
    [_startSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [_endSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    
    CGFloat leftMargin = 10.f;
    CGFloat width = 300.f;
    CGFloat height = 30.f;
    _startSlider.frame = CGRectMake(leftMargin, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-2*30, width, height);
    _endSlider.frame = CGRectMake(leftMargin, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-30, width, height);
    
    [self.view addSubview:_startSlider];
    [self.view addSubview:_endSlider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override

- (GPUImageOutput<GPUImageInput> *)filterWithImage:(UIImage *)image
{
    _picture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
    
    GPUImageSepiaFilter *sepiaFilter = [[[GPUImageSepiaFilter alloc] init] autorelease];
    GPUImageVignetteFilter *vignetteFilter = [[[GPUImageVignetteFilter alloc] init] autorelease];
    vignetteFilter.vignetteColor = (GPUVector3){ 1.0f, 0.0f, 0.0f };
    
    GPUImageView *imageView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imageView];
    
    [_picture addTarget:sepiaFilter];
    [sepiaFilter addTarget:vignetteFilter];
    [vignetteFilter addTarget:imageView];
    
    [imageView release];
    
    [_picture processImage];
    
    return vignetteFilter;
}

- (void)resetAction:(id)sender
{
    _startSlider.value = 0.3;
    _endSlider.value = 0.75;
    
    _vignetteFilter.vignetteStart = 0.3;
    _vignetteFilter.vignetteEnd = 0.75;
    
    [_picture processImage];
}

#pragma mark - Private

- (void)sliderAction:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    CGFloat value = slider.value;
    
    if (slider == _startSlider) {
        _vignetteFilter.vignetteStart = value;
    }
    else {
        _vignetteFilter.vignetteEnd = value;
    }
    
    [_picture processImage];
}

#pragma mark - dealloc

- (void)dealloc
{
    [_vignetteFilter release];
    [_startSlider release];
    [_endSlider release];
    
    [super dealloc];
}

@end
