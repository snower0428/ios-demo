//
//  ViewController.m
//  BundleDemo
//
//  Created by lei hui on 13-1-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 10, 100, 50);
    [button setTitle:@"Test" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(Test) forControlEvents:UIControlEventTouchUpInside];
}

- (void)Test
{
    NSString *path = @"/Users/leihui/Snower0428/ios-demo/BundleDemo/Bundle/build/Debug-iphonesimulator/Bundle.bundle";
    NSBundle *bundle = [NSBundle bundleWithPath:path];
#if 1
    // 使用Pincipal class
    Class class = [bundle principalClass];
#else
    // 使用自己定义的类
	NSDictionary *dict = [bundle infoDictionary];
	NSString *className = [dict objectForKey:@"TestClass"];
	Class class = [bundle classNamed:className];
#endif
    NSLog(@"className: %@", NSStringFromClass(class));
	
	id ctrl = [[class alloc] init];
	if ([ctrl isKindOfClass:[UIViewController class]])
	{
		NSLog(@"MainClass is create correct");
        
        UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
        [self presentModalViewController:navCtrl animated:YES];
        [ctrl release];
        [navCtrl release];
	}
	else
	{
		NSLog(@"MainClass is not UIViewCtrl");
		[ctrl release];
		ctrl = nil;
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
