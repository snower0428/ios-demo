//
//  InstagramArtworkViewController.m
//  CoreGraphicsDemo
//
//  Created by leihui on 13-12-23.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "InstagramArtworkViewController.h"
#import "RSInstagramArtworkView.h"

@interface InstagramArtworkViewController ()
{
    RSInstagramArtworkView      *_instagramView;
}

@end

@implementation InstagramArtworkViewController

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
    
    _instagramView = [[RSInstagramArtworkView alloc] initWithFrame:CGRectMake(0.0, 0.0, 400.0, 400.0)];
    // always center
    _instagramView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    // clear background
    _instagramView.opaque = NO;
    _instagramView.center = [self.view convertPoint:self.view.center fromView:self.view.superview];
    
    [self.view addSubview:_instagramView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dealloc

- (void)dealloc
{
    [_instagramView release];
    
    [super dealloc];
}

@end
