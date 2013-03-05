//
//  ASIHttpDemoViewCtrl.m
//  CommDemo
//
//  Created by leihui on 12-11-14.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import "ASIHttpDemoViewCtrl.h"
#import "ASIHTTPRequest.h"

@interface ASIHttpDemoViewCtrl ()
- (void)onSynchronous;
- (void)onASynchronous;
@end

@implementation ASIHttpDemoViewCtrl

- (id)init
{
    if (self = [super init]) {
        // Init
        self.view.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    self.navigationItem.leftBarButtonItem = item;
    [item release];
    
    __block __typeof(self) _self = self;
#if 0
    // Return
    UIButton *btnReturn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnReturn.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    btnReturn.frame = CGRectMake(0, 0, 100, 30);
    [btnReturn setTitle:@"返回" forState:UIControlStateNormal];
    [self.view addSubview:btnReturn];
    
    [btnReturn handleControlEvents:UIControlEventTouchUpInside withBlock:^(void){
        [_self.navigationController popViewControllerAnimated:YES];
    }];
#endif
    // Synchronous
    UIButton *btnSync = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnSync.frame = CGRectMake(10, 100, 200, 50);
    [btnSync setTitle:@"Synchronous" forState:UIControlStateNormal];
    [self.view addSubview:btnSync];
    
    [btnSync handleControlEvents:UIControlEventTouchUpInside withBlock:^(void){
        [_self onSynchronous];
    }];
    
    // Asynchronous
    UIButton *btnAsync = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnAsync.frame = CGRectMake(10, btnSync.frame.origin.y+btnSync.frame.size.height+10, 200, 50);
    [btnAsync setTitle:@"Asynchronous" forState:UIControlStateNormal];
    [self.view addSubview:btnAsync];
    
    [btnAsync handleControlEvents:UIControlEventTouchUpInside withBlock:^(void){
        [_self onASynchronous];
    }];
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSynchronous
{
    NSURL *url = [NSURL URLWithString:@"http://www.google.cn"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"response = %@", response);
    }
}

- (void)onASynchronous
{
    if (_networkQueue) {
        [_networkQueue reset];
        [_networkQueue release];
        _networkQueue = nil;
    }
    _networkQueue = [[ASINetworkQueue alloc] init];
    _networkQueue.delegate = self;
    _networkQueue.downloadProgressDelegate = self;
    _networkQueue.showAccurateProgress = YES;
    [_networkQueue setRequestDidFinishSelector:@selector(imageFetchComplete:)];
    [_networkQueue setRequestDidFailSelector:@selector(imageFetchFailed:)];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://allseeing-i.com/ASIHTTPRequest/tests/images/small-image.jpg"]];
    [request setDownloadDestinationPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"1.png"]];
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"request1" forKey:@"name"]];
    [request setDownloadProgressDelegate:self];
    request.delegate = self;
    [_networkQueue addOperation:request];
    
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://allseeing-i.com/ASIHTTPRequest/tests/images/medium-image.jpg"]];
    [request setDownloadDestinationPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"2.png"]];
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"request2" forKey:@"name"]];
    [request setDownloadProgressDelegate:self];
    request.delegate = self;
    [_networkQueue addOperation:request];
    
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://allseeing-i.com/ASIHTTPRequest/tests/images/large-image.jpg"]];
    [request setDownloadDestinationPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"3.png"]];
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"request3" forKey:@"name"]];
    [request setDownloadProgressDelegate:self];
    request.delegate = self;
    [_networkQueue addOperation:request];
    
    [_networkQueue go];
}

#pragma mark -------------------- delegate --------------------

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    NSString *requestValue = [[request userInfo] objectForKey:@"name"];
    if ([requestValue isEqualToString:@"request1"]) {
        NSLog(@"request1 -------------------- bytes = %lld", bytes);
    } else if ([requestValue isEqualToString:@"request2"]) {
        NSLog(@"request2 -------------------- bytes = %lld", bytes);
    } else if ([requestValue isEqualToString:@"request3"]) {
        NSLog(@"request3 -------------------- bytes = %lld", bytes);
    } else {
        NSLog(@"----------------------------------------------------------------------------------------------------");
    }
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"responseHeaders = %@", responseHeaders);
}

- (void)imageFetchComplete:(ASIHTTPRequest *)request
{
    NSString *requestValue = [[request userInfo] objectForKey:@"name"];
    if ([requestValue isEqualToString:@"request1"]) {
        NSLog(@"request1 ---------------------------------------- imageFetchComplete");
    } else if ([requestValue isEqualToString:@"request2"]) {
        NSLog(@"request2 ---------------------------------------- imageFetchComplete");
    } else if ([requestValue isEqualToString:@"request3"]) {
        NSLog(@"request3 ---------------------------------------- imageFetchComplete");
    } else {
        NSLog(@"----------------------------------------------------------------------------------------------------");
    }
}

- (void)imageFetchFailed:(ASIHTTPRequest *)request
{
    NSString *requestValue = [[request userInfo] objectForKey:@"name"];
    if ([requestValue isEqualToString:@"request1"]) {
        NSLog(@"request1 ---------------------------------------- imageFetchFailed");
    } else if ([requestValue isEqualToString:@"request2"]) {
        NSLog(@"request2 ---------------------------------------- imageFetchFailed");
    } else if ([requestValue isEqualToString:@"request3"]) {
        NSLog(@"request3 ---------------------------------------- imageFetchFailed");
    } else {
        NSLog(@"----------------------------------------------------------------------------------------------------");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSArray *operations = [_networkQueue operations];
    for (ASIHTTPRequest *request in operations) {
        [request clearDelegatesAndCancel];
    }
    if (_networkQueue) {
        [_networkQueue reset];
        [_networkQueue release];
        _networkQueue = nil;
    }
    [super dealloc];
}

@end
