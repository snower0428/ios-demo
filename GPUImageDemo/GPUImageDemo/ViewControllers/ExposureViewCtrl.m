//
//  ExposureViewCtrl.m
//  GPUImageDemo
//
//  Created by leihui on 13-11-25.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "ExposureViewCtrl.h"

@interface ExposureViewCtrl ()
{
    GPUImageExposureFilter  *_filter;
    UISlider    *_slider;
}

@end

@implementation ExposureViewCtrl

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
    
    self.title = @"Exposure";
    
    _filter = (GPUImageExposureFilter *)[[self filterWithImage:[UIImage imageNamed:kTestImageFileName]] retain];
    _slider = [[self sliderWithValue:0.0 minimumValue:-10.0 maximumValue:10.0] retain];
    [_slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_slider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override

- (Class)filterClass
{
    return [GPUImageExposureFilter class];
}

- (void)resetAction:(id)sender
{
    _slider.value = 0.0;
    _filter.exposure = 0.0;
    [_picture processImage];
}

#pragma mark - Private

- (void)sliderAction:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    CGFloat value = slider.value;
    
    _filter.exposure = value;
    [_picture processImage];
}

#pragma mark - dealloc

- (void)dealloc
{
    [_filter release];
    [_slider release];
    
    [super dealloc];
}

@end
