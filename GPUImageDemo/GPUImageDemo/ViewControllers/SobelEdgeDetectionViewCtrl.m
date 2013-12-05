//
//  SobelEdgeDetectionViewCtrl.m
//  GPUImageDemo
//
//  Created by leihui on 13-11-22.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "SobelEdgeDetectionViewCtrl.h"

#define kTexelWidthSliderTag        1000
#define kTexelHeightSliderTag       1001
#define kEdgeStrengthSliderTag      1002

@interface SobelEdgeDetectionViewCtrl ()
{
    GPUImagePicture                     *_picture;
    GPUImageSobelEdgeDetectionFilter    *_filter;
    
    UISlider        *_texelWidthSlider;
    UISlider        *_texelHeightSlider;
    UISlider        *_edgeStrengthSlider;
}

@end

@implementation SobelEdgeDetectionViewCtrl

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
    [self initGPUImageView];
    [self initSlider];
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

- (void)initGPUImageView
{
    //创建输入源
    UIImage *image = [UIImage imageNamed:kTestImageFileName];
    _picture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
    
    //创建滤镜
    _filter = [[GPUImageSobelEdgeDetectionFilter alloc] init];
    
    //创建输出界面
    GPUImageView *imageView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imageView];
    
    [_picture addTarget:_filter];
    [_filter addTarget:imageView];
    [imageView release];
    
    [_picture processImage];
}

- (void)initSlider
{
    CGFloat leftMargin = 10.f;
    CGFloat width = 300.f;
    CGFloat height = 30.f;
    CGRect frame = CGRectZero;
    
    frame = CGRectMake(leftMargin, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-90, width, height);
    _texelWidthSlider = [[UISlider alloc] initWithFrame:frame];
    _texelWidthSlider.tag = kTexelWidthSliderTag;
    _texelWidthSlider.minimumValue = 0.0;
    _texelWidthSlider.maximumValue = 0.01;
    _texelWidthSlider.value = 0.003125;
    [_texelWidthSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_texelWidthSlider];
    
    frame = CGRectMake(leftMargin, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-60, width, height);
    _texelHeightSlider = [[UISlider alloc] initWithFrame:frame];
    _texelHeightSlider.tag = kTexelHeightSliderTag;
    _texelHeightSlider.minimumValue = 0.0;
    _texelHeightSlider.maximumValue = 0.01;
    _texelHeightSlider.value = 0.002083;
    [_texelHeightSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_texelHeightSlider];
    
    frame = CGRectMake(leftMargin, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-30, width, height);
    _edgeStrengthSlider = [[UISlider alloc] initWithFrame:frame];
    _edgeStrengthSlider.tag = kEdgeStrengthSliderTag;
    _edgeStrengthSlider.minimumValue = 0.0;
    _edgeStrengthSlider.maximumValue = 1.0;
    _edgeStrengthSlider.value = 1.0;
    [_edgeStrengthSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_edgeStrengthSlider];
}

- (void)resetAction:(id)sender
{
    _texelWidthSlider.value = 0.003125;
    _texelHeightSlider.value = 0.002083;
    _edgeStrengthSlider.value = 1.0;
    
    _filter.texelWidth = 0.003125;
    _filter.texelHeight = 0.002083;
    _filter.edgeStrength = 1.0;
    [_picture processImage];
}

- (void)sliderAction:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    int tag = slider.tag;
    CGFloat value = slider.value;
    
    switch (tag) {
            
        case kTexelWidthSliderTag:
        {
            _filter.texelWidth = value;
            break;
        }
            
        case kTexelHeightSliderTag:
        {
            _filter.texelHeight = value;
            break;
        }
            
        case kEdgeStrengthSliderTag:
        {
            _filter.edgeStrength = value;
            break;
        }
            
        default:
            break;
    }
    
    [_picture processImage];
    
    NSLog(@"texelWidth:%f, texelHeight:%f", _filter.texelWidth, _filter.texelHeight);
}

#pragma mark - dealloc

- (void)dealloc
{
    [_filter release];
    [_picture release];
    
    [_edgeStrengthSlider release];
    [_texelWidthSlider release];
    [_texelHeightSlider release];
    
    [super dealloc];
}

@end
