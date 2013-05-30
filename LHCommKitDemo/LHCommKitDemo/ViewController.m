//
//  ViewController.m
//  LHCommKitDemo
//
//  Created by leihui on 13-5-17.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 10, 100, 30);
    [button setTitle:@"Print" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnClicked:(id)sender
{
    NSString *bundlePath = @"/Users/leihui/Demo/ios-demo/LHCommKitDemo/build/Debug-iphonesimulator/LHCommKit.framework";
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    if (bundle) {
//        [LHCommKitText printMessage:@"Scoop..."];
//        Class class = [bundle principalClass];
//        if (class) {
//            id ctrl = [[class alloc] init] ;
//            if ([ctrl isKindOfClass:[UIViewController class]])
//            {
//                UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
//                [ctrl release];
//                [self presentModalViewController:navCtrl animated:YES];
//                [navCtrl release];
//            }
//            else
//            {
//                [ctrl release];
//                ctrl = nil;
//            }
//        }
    }
//    [LHCommKitText printMessage:@"123"];
}

#pragma mark - dealloc

- (void)dealloc
{
    [super dealloc];
}

@end
