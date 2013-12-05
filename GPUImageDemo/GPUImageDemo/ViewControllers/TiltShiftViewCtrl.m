//
//  TiltShiftViewCtrl.m
//  GPUImageDemo
//
//  Created by leihui on 13-11-22.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "TiltShiftViewCtrl.h"

#define kSlideBaseTag       1000

static const int kCount = 4;

@interface TiltShiftViewCtrl ()
{
    GPUImagePicture             *_picture;
    GPUImageTiltShiftFilter     *_filter;
    
    UISlider        *_slider[kCount];
}

@end

@implementation TiltShiftViewCtrl

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
    _filter = [[GPUImageTiltShiftFilter alloc] init];
    
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
    
    for (int i = 0; i < kCount; i++) {
        frame = CGRectMake(leftMargin, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-(kCount-i)*30, width, height);
        _slider[i] = [[UISlider alloc] initWithFrame:frame];
        _slider[i].tag = kSlideBaseTag+i;
        if (i == 0) {
            _slider[i].minimumValue = 1.0;  // blurRadiusInPixels为0.0时会崩溃
            _slider[i].maximumValue = 100.0;
        }
        else {
            _slider[i].minimumValue = 0.0;
            _slider[i].maximumValue = 1.0;
        }
        [self sliderValueWithIndex:i];
        [_slider[i] addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_slider[i]];
    }
}

- (void)resetAction:(id)sender
{
    for (int i = 0; i < kCount; i++) {
        [self sliderValueWithIndex:i];
    }
    _filter.blurRadiusInPixels = 7.0;
    _filter.topFocusLevel = 0.4;
    _filter.bottomFocusLevel = 0.6;
    _filter.focusFallOffRate = 0.2;
    [_picture processImage];
}

- (void)sliderAction:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    int tag = slider.tag;
    CGFloat value = slider.value;
    
    switch (tag) {
        case kSlideBaseTag:
            _filter.blurRadiusInPixels = value;
            break;
        case kSlideBaseTag+1:
            _filter.topFocusLevel = value;
            break;
        case kSlideBaseTag+2:
            _filter.bottomFocusLevel = value;
            break;
        case kSlideBaseTag+3:
            _filter.focusFallOffRate = value;
            break;
            
        default:
            break;
    }
    
    [_picture processImage];
}

- (void)sliderValueWithIndex:(int)index
{
    switch (index) {
        case 0:
            _slider[index].value = 7.0;
            break;
        case 1:
            _slider[index].value = 0.4;
            break;
        case 2:
            _slider[index].value = 0.6;
            break;
        case 3:
            _slider[index].value = 0.2;
            break;
            
        default:
            break;
    }
}

#pragma mark - dealloc

- (void)dealloc
{
    [_filter release];
    [_picture release];
    
    for (int i = 0; i < kCount; i++) {
        [_slider[i] release];
    }
    
    [super dealloc];
}

@end
