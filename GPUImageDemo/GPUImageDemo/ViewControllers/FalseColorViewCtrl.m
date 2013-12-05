//
//  FalseColorViewCtrl.m
//  GPUImageDemo
//
//  Created by leihui on 13-11-22.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "FalseColorViewCtrl.h"

#define kFirstColorSliderTag    1000
#define kSecondColorSliderTag   1100

static const int kComponents = 4;

@interface FalseColorViewCtrl ()
{
    UISlider        *_firstColorSlider[kComponents];
    UISlider        *_secondColorSlider[kComponents];
    CGFloat         _firstColorValue[kComponents];
    CGFloat         _secondColorValue[kComponents];
    
    GPUImagePicture             *_picture;
    GPUImageFalseColorFilter    *_filter;
}

@end

@implementation FalseColorViewCtrl

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
    _filter = [[GPUImageFalseColorFilter alloc] init];
//    _filter.firstColor = (GPUVector4){0.0f, 0.0f, 0.5f, 1.0f};   // Default Value
//    _filter.secondColor = (GPUVector4){1.0f, 0.0f, 0.0f, 1.0f};  // Default Value
    
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
    CGFloat leftMargin = 5.f;
    CGFloat interval = 10.f;
    CGFloat width = 150.f;
    CGFloat height = 30.f;
    CGRect frame = CGRectZero;
    
    for (int i = 0; i < kComponents; i++) {
        frame = CGRectMake(leftMargin, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-(kComponents-i)*30, width, height);
        _firstColorSlider[i] = [[UISlider alloc] initWithFrame:frame];
        _firstColorSlider[i].tag = kFirstColorSliderTag+i;
        _firstColorSlider[i].minimumValue = 0.0;
        _firstColorSlider[i].maximumValue = 1.0;
        [self firstColorValueWithIndex:i];
        
        [_firstColorSlider[i] addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_firstColorSlider[i]];
    }
    
    for (int i = 0; i < kComponents; i++) {
        frame = CGRectMake(leftMargin+width+interval, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-(kComponents-i)*30, width, height);
        _secondColorSlider[i] = [[UISlider alloc] initWithFrame:frame];
        _secondColorSlider[i].tag = kSecondColorSliderTag+i;
        _secondColorSlider[i].minimumValue = 0.0;
        _secondColorSlider[i].maximumValue = 1.0;
        [self secondColorValueWithIndex:i];
        
        [_secondColorSlider[i] addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_secondColorSlider[i]];
    }
}

- (void)resetAction:(id)sender
{
    for (int i = 0; i < kComponents; i++) {
        [self firstColorValueWithIndex:i];
    }
    
    for (int i = 0; i < kComponents; i++) {
        [self secondColorValueWithIndex:i];
    }
    
    [self updatePicture];
}

- (void)sliderAction:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    int tag = slider.tag;
    CGFloat value = slider.value;
    
    switch (tag) {
            
        case kFirstColorSliderTag:
        case kFirstColorSliderTag+1:
        case kFirstColorSliderTag+2:
        case kFirstColorSliderTag+3:
        {
            int index = tag-kFirstColorSliderTag;
            _firstColorValue[index] = value;
            break;
        }
        case kSecondColorSliderTag:
        case kSecondColorSliderTag+1:
        case kSecondColorSliderTag+2:
        case kSecondColorSliderTag+3:
        {
            int index = tag-kSecondColorSliderTag;
            _secondColorValue[index] = value;
            break;
        }
        default:
            break;
    }
    
    [self updatePicture];
}

- (void)firstColorValueWithIndex:(NSInteger)index
{
    if (index == 2) {
        _firstColorValue[index] = 0.5;
    }
    else if (index == 3) {
        _firstColorValue[index] = 1.0;
    }
    else {
        _firstColorValue[index] = 0.0;
    }
    _firstColorSlider[index].value = _firstColorValue[index];
}

- (void)secondColorValueWithIndex:(NSInteger)index
{
    if (index == 0 || index == 3) {
        _secondColorValue[index] = 1.0;
    }
    else {
        _secondColorValue[index] = 0.0;
    }
    _secondColorSlider[index].value = _secondColorValue[index];
}

- (void)updatePicture
{
    _filter.firstColor = (GPUVector4){_firstColorValue[0], _firstColorValue[1], _firstColorValue[2], _firstColorValue[3]};
    _filter.secondColor = (GPUVector4){_secondColorValue[0], _secondColorValue[1], _secondColorValue[2], _secondColorValue[3]};
    [_picture processImage];
}

#pragma mark - dealloc

- (void)dealloc
{
    for (int i = 0; i < kComponents; i++) {
        [_firstColorSlider[i] release];
        [_secondColorSlider[i] release];
    }
    
    [_filter release];
    [_picture release];
    
    [super dealloc];
}

@end
