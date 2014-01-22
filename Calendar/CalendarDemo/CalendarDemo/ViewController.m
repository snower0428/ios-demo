//
//  ViewController.m
//  CalendarDemo
//
//  Created by leihui on 14-1-8.
//  Copyright (c) 2014年 ND WebSoft Inc. All rights reserved.
//

#import "ViewController.h"

static const int kCalendarTag = 1000;

@interface ViewController ()

@end

@implementation ViewController

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
    
    self.view.backgroundColor = [UIColor grayColor];
    
    CGFloat yOffset = 0.f;
    if (iPhone5) {
        yOffset = 64;
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(10, 10+yOffset, 300, 50);
    [btn setTitle:@"Calendar" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)btnClicked:(id)sender
{
    NSString *path = @"/Users/leihui/Snower0428/ios-demo/Calendar/CalendarWeeApp/build/Debug-iphonesimulator/CalendarWeeApp.bundle";
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    
    // Pincipal class
    Class class = [bundle principalClass];
    NSLog(@"className: %@", NSStringFromClass(class));
    
    UIView *view = [self.view viewWithTag:kCalendarTag];
    if (view != nil) {
        [view removeFromSuperview];
        view = nil;
    }
    
    id ctrl = [[class alloc] init];
    if (ctrl != nil) {
        UIView *view = [ctrl view];
        view.tag = kCalendarTag;
        CGRect rect = view.frame;
        rect.origin.y = 200;
        view.frame = rect;
        [self.view addSubview:view];
        [ctrl release];
    }
}

#pragma mark - dealloc

- (void)dealloc
{
    [super dealloc];
}

@end
