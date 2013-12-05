//
//  BrightnessContrastViewCtrl.m
//  GPUImageDemo
//
//  Created by leihui on 13-11-25.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "BrightnessContrastViewCtrl.h"

@interface BrightnessContrastViewCtrl ()
{
    GPUImageBrightnessFilter    *_filterBrightness;
    GPUImageContrastFilter      *_filterContrast;
    GPUImageSaturationFilter    *_filterSaturation;
    
    UISlider    *_sliderBrightness;
    UISlider    *_sliderContrast;
    UISlider    *_sliderSaturation;
}

@end

@implementation BrightnessContrastViewCtrl

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
    
    self.title = @"Brightness/Contrast";
    
    [self initGPUImageFilter];
    
    _sliderBrightness = [[self sliderWithValue:0.0 minimumValue:-1.0 maximumValue:1.0] retain];
    _sliderContrast = [[self sliderWithValue:1.0 minimumValue:0.0 maximumValue:4.0] retain];
    _sliderSaturation = [[self sliderWithValue:1.0 minimumValue:0.0 maximumValue:2.0] retain];
    
    CGFloat leftMargin = 10.f;
    CGFloat width = 300.f;
    CGFloat height = 30.f;
    _sliderBrightness.frame = CGRectMake(leftMargin, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-3*30, width, height);
    _sliderContrast.frame = CGRectMake(leftMargin, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-2*30, width, height);
    _sliderSaturation.frame = CGRectMake(leftMargin, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-30, width, height);
    
    [_sliderBrightness addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [_sliderContrast addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [_sliderSaturation addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_sliderBrightness];
    [self.view addSubview:_sliderContrast];
    [self.view addSubview:_sliderSaturation];
    
    [self createLocalNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override

- (void)resetAction:(id)sender
{
    _sliderBrightness.value = 0.0;
    _sliderContrast.value = 1.0;
    _sliderSaturation.value = 1.0;
    
    _filterBrightness.brightness = 0.0;
    _filterContrast.contrast = 1.0;
    _filterSaturation.saturation = 1.0;
    
    [_picture processImage];
}

#pragma mark - Private

- (void)createLocalNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    int hintTime = 7*24*60*60;
    int hintTime = 10;
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification != nil)
    {
        //提醒时间控制在9-22点之间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH"];
        NSString *curHour = [formatter stringFromDate:[NSDate date]];
        NSLog(@"curHour==[%@]",curHour);
        if (curHour && ([curHour intValue]<9 || [curHour intValue]>22))
            hintTime+= 60*60*10;
        [formatter release];
        NSLog(@"hintTime==[%d]",hintTime);
        NSDate *date = [NSDate date];
        notification.fireDate = [date dateByAddingTimeInterval:hintTime];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber = 1;
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.repeatInterval = kCFCalendarUnitMinute;
        //alert
        notification.alertBody = _(@"Dear,you havt not use 91Home for one week,we have some new wallpapers and themes,come to see them.");
        notification.alertAction = _(@"Show");
        
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"kLongTimeNoSee", @"kLongTimeLocalNotificationFlag", nil];
        notification.userInfo = dict;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    [notification release];
}

- (void)appDidEnterBackground
{
//    [self createLocalNotification];
}

- (void)initGPUImageFilter
{
    //创建输入源
    _picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:kTestImageFileName] smoothlyScaleOutput:YES];
    
    //创建滤镜
    _filterBrightness = [[GPUImageBrightnessFilter alloc] init];
    _filterContrast = [[GPUImageContrastFilter alloc] init];
    _filterSaturation = [[GPUImageSaturationFilter alloc] init];
    
    //创建输出界面
    GPUImageView *imageView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imageView];
    
    [_picture addTarget:_filterSaturation];
    [_filterSaturation addTarget:_filterContrast];
    [_filterContrast addTarget:_filterBrightness];
    [_filterBrightness addTarget:imageView];
    
    [imageView release];
    
    [_picture processImage];
}

- (void)sliderAction:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    CGFloat value = slider.value;
    
    if (slider == _sliderBrightness) {
        _filterBrightness.brightness = value;
    }
    else if (slider == _sliderContrast) {
        _filterContrast.contrast = value;
    }
    else if (slider == _sliderSaturation) {
        _filterSaturation.saturation = value;
    }
    
    [_picture processImage];
}

#pragma mark - dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_filterBrightness release];
    [_filterContrast release];
    [_filterSaturation release];
    [_sliderBrightness release];
    [_sliderContrast release];
    [_sliderSaturation release];
    
    [super dealloc];
}

@end
