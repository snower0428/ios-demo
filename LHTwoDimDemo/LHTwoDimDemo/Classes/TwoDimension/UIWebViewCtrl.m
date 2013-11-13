//
//  UIWebViewCtrl.m
//  PHScannerBundle
//
//  Created by Ye Gaofei on 13-7-11.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "UIWebViewCtrl.h"
#import <QuartzCore/QuartzCore.h>
#import <sys/utsname.h>


#define NavigationHight      44
#define ToolBarHeight        44
#define ActivityViewWidth    44
#define ActivityViewHeight   44


#define kTransitionTag        13000
#define kActViewTag           14000
#define kApplicationLabTag    15000

@implementation UIWebViewCtrl
@synthesize netAddress;

- (id)initWithWebAddress:(NSURL *)address
{
    self = [super init];
    if (self) {
        // Custom initialization
		_webView = nil;
		toolbar = nil;
		loadingIndicator = nil;
		self.netAddress = address;
    }
    return self;
}
- (void)dealloc
{
	self.netAddress = nil;
	if (_webView) {
		_webView.delegate = nil;
		[_webView stopLoading];
		[_webView release];
		_webView = nil;
	}
	/*[loadingIndicator stopAnimating];
	[loadingIndicator release];
	loadingIndicator = nil;*/
	
	[_backButton release];
	_backButton = nil;
	[_forwardButton release];
	_forwardButton = nil;
	[_stopButton release];
	_stopButton = nil;
	[_refreshButton release];
	_refreshButton = nil;
	[_actionButton release];
	_actionButton = nil;
	[vSpace release];
	vSpace = nil;
	[fSpace release];
	fSpace = nil;
	
	[toolbar release];
	toolbar = nil;
	
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
#pragma mark--
#pragma mark activityIndicatorview 
- (void)showActivityProc:(NSString *)name
{
	UIView *procView = [[UIView alloc]initWithFrame:CGRectMake(110, (460-NavigationHight-ToolBarHeight-100)/2, 100, 80)];
	procView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.9];
	procView.layer.cornerRadius = 10.0f;
	procView.layer.masksToBounds = YES;
	procView.tag = kTransitionTag;
	UIActivityIndicatorView *actyView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	actyView.frame = CGRectMake(40, 25, 20, 20);
	actyView.tag = kActViewTag;
	[actyView startAnimating];
	[procView addSubview:actyView];
	[actyView release];
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 55, 80, 20)];
	label.backgroundColor = [UIColor clearColor];
	label.text = name;
	label.textColor = [UIColor whiteColor];
	label.tag = kApplicationLabTag;
	[procView addSubview:label];
	[label release];
	[self.view addSubview:procView];
	[procView release];
}
//删除过渡页面
- (void)removeProcView
{
	UIView *procView = (UIView *)[self.view viewWithTag:kTransitionTag];
	if (procView != nil) 
	{
		UIActivityIndicatorView *actyView = (UIActivityIndicatorView *)[procView viewWithTag:kActViewTag];
		if (actyView != nil) 
		{
			[actyView stopAnimating];
			[actyView removeFromSuperview];
		}
		UILabel *label = (UILabel *)[procView viewWithTag:kApplicationLabTag];
		if (label != nil) 
		{
			[label removeFromSuperview];
		}
		[procView removeFromSuperview];
	}
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/
#pragma mark - UIActionSheetDelegate
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0 && ! [[[[_webView request] URL] absoluteString] isEqualToString:@""]) {
		[[UIApplication sharedApplication] openURL:[[_webView request] URL]];
	}
}

- (void)actionButtonPressed {
	UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:_(@"Open in Safari") delegate:self cancelButtonTitle:_(@"Cancel") destructiveButtonTitle:nil otherButtonTitles:_(@"Confirm"), nil];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if (self.view.superview) {
            [as showInView:self.view.superview];
        } else {
            [as showInView:self.view];
        }
    } else {
        [as showFromBarButtonItem:_actionButton animated:YES];
    }
	[as release];
}
- (void)backAction {
	[_webView goBack];
}

- (void)forwardAction {
	[_webView goForward];
}

- (void)refreshAction {
	[_webView reload];
}

- (void)stopAction {
	[_webView stopLoading];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	_backButton.enabled = _webView.canGoBack;
	_forwardButton.enabled = _webView.canGoForward;
	
	/*NSMutableArray *toolBarItems = [NSMutableArray arrayWithObjects:
									_backButton,
									fSpace,
									_forwardButton,
									fSpace,
									_stopButton,
									vSpace,
									_actionButton,
									nil];
	[toolbar setItems:toolBarItems];*/
	
	[toolbar replaceItem:_refreshButton withItem:_stopButton];
	//[loadingIndicator startAnimating];
	[self showActivityProc:_(@"Data Loading")];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	_backButton.enabled = _webView.canGoBack;
	_forwardButton.enabled = _webView.canGoForward;
	/*NSMutableArray *toolBarItems = [NSMutableArray arrayWithObjects:
									_backButton,
									fSpace,
									_forwardButton,
									fSpace,
									_refreshButton,
									vSpace,
									_actionButton,
									nil];
	[toolbar setItems:toolBarItems];*/
	[toolbar replaceItem:_stopButton withItem:_refreshButton];
	
	//[loadingIndicator stopAnimating];
	[self removeProcView];
	_firstRequest = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	if ([error code] != NSURLErrorCancelled) {
		//if ([error code] >=100&&[error code] <=104) {				    
			BOOL res = NO;
			if ([[UIApplication sharedApplication] canOpenURL:self.netAddress]) {
				res = [[UIApplication sharedApplication] openURL:self.netAddress];
			}			
		//}
		/*else if ([error code] == 102) {				    
			//无法下载该文件
			NSString *errorMsg = [NSString stringWithFormat:@"Could not download file:%d",[error code]];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_(@"Error") message:errorMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
			[alert show];
			[alert release];
		}*//*else{
			NSString *errorMsg = [NSString stringWithFormat:@"Could not connect to server.code:%d",[error code]];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_(@"Error") message:errorMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
			[alert show];
			[alert release];
		}	*/	
	}
	
	[self webViewDidFinishLoad:webView];
	
}
//-(BOOL)isHDMachine
//{
//	struct utsname systemInfo;
//    uname(&systemInfo);
//    NSString *machineName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
//	
//	NSArray *machineTypeArr = [NSArray arrayWithObjects:@"iPhone1,1", @"iPhone1,2", @"iPhone2,1", 
//							   @"iPod1,1", @"iPod2,1", @"iPod2,2", @"iPod3,1", 
//							   @"iPad1,1", nil];
//	if ([machineTypeArr containsObject:machineName])
//		return NO;
//	return YES;
//}
#pragma mark - Toolbar Buttons
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

- (void)setToolbarButtons {
	
    vSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                            target:nil
                                                                            action:nil];
	fSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                            target:nil
                                                                            action:nil];
	fSpace.width = 28.0f;
	
	NSString *iconName = @"td_backIcon.png";
    NSString *fileName = [NSString stringWithFormat:@"TwoDimension/%@", iconName];
    UIImage *image = [[ResourcesManager shareInstance] imageWithFileName:fileName];
    
	_backButton = [[UIBarButtonItem alloc] initWithImage:image
												   style:UIBarButtonItemStylePlain
												  target:self
												  action:@selector(backAction)];
	
	iconName = @"td_forwardIcon.png";
	fileName = [NSString stringWithFormat:@"TwoDimension/%@", iconName];
    image = [[ResourcesManager shareInstance] imageWithFileName:fileName];
    
	_forwardButton = [[UIBarButtonItem alloc] initWithImage:image
													  style:UIBarButtonItemStylePlain
													 target:self
													 action:@selector(forwardAction)];
	
	_actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
																  target:self
																  action:@selector(actionButtonPressed)];
	
	_refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																   target:self
																   action:@selector(refreshAction)];
	_refreshButton.tag = 3;
	
	_stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
																target:self
																action:@selector(stopAction)];
	_stopButton.tag = 3;
	
    //_doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered
                                                  //target:self
                                                  //action:@selector(doneButtonPressed)];
    
	NSMutableArray *toolBarItems;
    toolBarItems = [NSMutableArray arrayWithObjects:
                    _backButton,
                    fSpace,
                    _forwardButton,
                    fSpace,
                    _refreshButton,
                    vSpace,
                    _actionButton,
                    nil];
    
	//if (showDoneButton) {
        //[toolBarItems addObject:fSpace];
        //[toolBarItems addObject:_doneButton];
    //}
	
	[toolbar setItems:toolBarItems];

	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{	
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	if (self.netAddress) {	
		CGRect rectFrame = self.view.bounds;
		if (!_webView) {
			_webView = [[UIWebView alloc] initWithFrame:CGRectMake(rectFrame.origin.x, rectFrame.origin.y, rectFrame.size.width, rectFrame.size.height - NavigationHight-ToolBarHeight)];
			_webView.backgroundColor = [UIColor whiteColor];	
			_webView.delegate = self;
			_webView.scalesPageToFit = YES;
			/*BOOL res = NO;
			if ([[UIApplication sharedApplication] canOpenURL:self.netAddress]) {
				res = [[UIApplication sharedApplication] openURL:self.netAddress];
			}*/
		}
		if ([_webView isLoading]) [_webView stopLoading];
		[_webView loadRequest:[NSURLRequest requestWithURL:self.netAddress]];
		[self.view addSubview:_webView];
		
		if (!toolbar) {
			toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(rectFrame.origin.x, rectFrame.origin.y+rectFrame.size.height - NavigationHight - ToolBarHeight, rectFrame.size.width, ToolBarHeight)];
			[self setToolbarButtons];
			[self.view addSubview:toolbar];
		}
			
		/*if (!loadingIndicator) {
			loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((rectFrame.size.width-ActivityViewWidth)/2, (rectFrame.size.height-NavigationHight-ActivityViewHeight)/2, ActivityViewWidth, ActivityViewHeight)];
			loadingIndicator.center = CGPointMake(rectFrame.size.width/2, rectFrame.size.height/2);
		}*/
		
	}
	
}


- (void)viewDidUnload {
	[super viewDidUnload];
	
	_webView.delegate = nil;
	[_webView stopLoading];
}

/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}*/



@end

#pragma mark - UIToolbar (TTCategory)
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@implementation UIToolbar (UIWebViewCtrl)

- (void)replaceItem:(UIBarButtonItem *)oldItem withItem:(UIBarButtonItem *)item {
	NSInteger buttonIndex = 0;
	for (UIBarButtonItem *button in self.items) {
		if (button == oldItem) {
			NSMutableArray* newItems = [NSMutableArray arrayWithArray:self.items];
			[newItems replaceObjectAtIndex:buttonIndex withObject:item];
			self.items = newItems;
			break;
		}
		++buttonIndex;
	}
}
@end