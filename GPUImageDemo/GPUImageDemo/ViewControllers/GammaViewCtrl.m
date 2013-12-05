//
//  GammaViewCtrl.m
//  GPUImageDemo
//
//  Created by leihui on 13-11-25.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "GammaViewCtrl.h"

@interface GammaViewCtrl ()
{
    GPUImageGammaFilter *_filter;
    UISlider    *_slider;
}

@end

@implementation GammaViewCtrl

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
    
    self.title = @"Gamma";
    
    _filter = (GPUImageGammaFilter *)[[self filterWithImage:[UIImage imageNamed:kTestImageFileName]] retain];
    _slider = [[self sliderWithValue:1.0 minimumValue:0.0 maximumValue:3.0] retain];
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
    return [GPUImageGammaFilter class];
}

- (void)resetAction:(id)sender
{
    _slider.value = 1.0;
    _filter.gamma = 1.0;
    [_picture processImage];
}

#pragma mark - Private

- (void)sliderAction:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    CGFloat value = slider.value;
    
    _filter.gamma = value;
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
