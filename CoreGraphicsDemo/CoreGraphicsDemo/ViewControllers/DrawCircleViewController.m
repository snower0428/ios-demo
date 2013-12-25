//
//  DrawCircleViewController.m
//  CoreGraphicsDemo
//
//  Created by leihui on 13-12-18.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "DrawCircleViewController.h"
#import "DrawCircleView.h"

@interface DrawCircleViewController ()

@end

@implementation DrawCircleViewController

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
    
    DrawCircleView *view = [[DrawCircleView alloc] initWithFrame:CGRectMake(0, kTopOrigin, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    [view release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
