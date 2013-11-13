//
//  ScannerResultCtrl.m
//  PHScannerBundle
//
//  Created by Ye Gaofei on 13-7-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ScannerResultCtrl.h"
#import "OpenAPPUrlAction.h"
#import "OpenUrlAction.h"
#import "AddContactAction.h"

#import "CallAction.h"
#import "EmailAction.h"
#import "ShowMapAction.h"
#import "SMSAction.h"
#import "TextAction.h"
#import "WifiAction.h"
#import "RichengAction.h"

#import "UIWebViewCtrl.h"

#define cellFontSize     [UIFont systemFontOfSize:16]
#define kImageViewTag         1000
#define kTypeNameTag          1001
#define kContentStringTag     1002

//二维码白名单配置文件
#define TwoDimCodeWhiteListPath     [DOCUMENTS_DIRECTORY stringByAppendingPathComponent:@"TwoDimCodeWhiteList.plist"]

@interface ScannerResultCtrl(private)

- (BOOL)autoSkipOut;
- (int)judgeInWhiteList:(NSString *)strIn;

@end

@implementation ScannerResultCtrl

@synthesize scannerStr;
@synthesize actions;
@synthesize parseResult;

- (void)dealloc
{
	self.scannerStr = nil;
	
	[contentCellArr release];
	contentCellArr = nil;
	
	[allActionArr release];
	allActionArr = nil;
	
	[parseResult release];
	parseResult = nil;	
	[actions release];
	actions = nil;
	animate = NO;
    
	[super dealloc];
}

- (id)initWithScannerStr:(NSString *)twoDimStr bSkip:(BOOL)bSkip
{
    self = [super init];
    if (self) {
		bSkipOut = bSkip;
		
		MLOG(@"init begin twoDimStr:%@",twoDimStr);
		self.scannerStr = twoDimStr;
        // Custom initialization
		parseResult = [[UniversalResultParser parsedResultForString:twoDimStr] retain];
		if (parseResult) {
			actions = [[parseResult actions] retain];
		}
		theAction = nil;
		MLOG(@"actions:%@,parseResult:%@",actions,parseResult);
		countItem = 0;
		animate = NO;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
		animate = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)BackToView
{
	[self.navigationController dismissModalViewControllerAnimated:animate];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	animate = YES;
    [super viewDidLoad];
	
	UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:_(@"Back") style:UIBarButtonItemStyleBordered target:self action:@selector(BackToView)];
	self.navigationItem.leftBarButtonItem = leftBtn;
	[leftBtn release];
	
	if ([actions count] == 1) {
		theAction = [actions objectAtIndex:0];
		allActionArr = [[theAction propertys] retain];
		countItem = [allActionArr count];		
		
		if ([theAction isMemberOfClass:[AddContactAction class]])
		{
			if (countItem >1) {
				NSRange range = NSMakeRange(1, countItem -1);
				contentCellArr = [(NSMutableArray *)[allActionArr subarrayWithRange:range] retain];
				MLOG(@"contentCellArr:%@,contentCellArr count:%d",contentCellArr,[contentCellArr count]);
				heightCellArr = [[NSMutableArray alloc] initWithCapacity:countItem-1];
			}				
		}else{
			contentCellArr = [allActionArr retain];
			heightCellArr = [[NSMutableArray alloc] initWithCapacity:countItem];
		}
		
		//calc the cell height
		for (int index = 0; index<[contentCellArr count]; index++) {
			ItemAction *infoItem = [contentCellArr objectAtIndex:index];
			if ([infoItem isKindOfClass:[ItemAction class]]) {
				NSString *cellStr = nil;
				if ([infoItem.itemData isKindOfClass:[NSString class]]) {
					cellStr = infoItem.itemData;
				}else if([infoItem.itemData isKindOfClass:[NSArray class]]){
					NSString *showStr = [(NSArray *)infoItem.itemData objectAtIndex:0];
					if ([showStr isKindOfClass:[NSString class]]) {
						cellStr = showStr;
					}					
				}
				CGSize maximumSize = CGSizeMake(200,960);
				CGSize expectedLabelSize = CGSizeMake(200,40);
				if (cellStr) {
					expectedLabelSize = [cellStr sizeWithFont:cellFontSize constrainedToSize:maximumSize lineBreakMode:UILineBreakModeWordWrap];
				}	
				//y:24+textHeight+22;
				[heightCellArr insertObject:[NSNumber numberWithInt:(24+expectedLabelSize.height+22)] atIndex:index];
			}
		}
		
	}

	//if (![self autoSkipOut]) 
	{
		resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT) style:UITableViewStyleGrouped];
		resultTableView.delegate = self;
		resultTableView.dataSource = self;
		resultTableView.backgroundColor = kTableViewBackgroundColor;
        
		UIView *viewBG = [[[UIView alloc] initWithFrame:resultTableView.bounds] autorelease];
		viewBG.backgroundColor = kTableViewBackgroundColor;
		resultTableView.backgroundView = viewBG;
		//resultTableView.backgroundView = nil;
		resultTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
		//resultTableView.separatorColor = [UIColor clearColor];
		resultTableView.showsHorizontalScrollIndicator = NO;
		resultTableView.showsVerticalScrollIndicator = YES;
		[self.view addSubview:resultTableView];
		[resultTableView release];
	}	
		
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - action 
- (void)releaseBarWindow
{
	if (bSkipOut) {
		animate = NO;
		[self BackToView];
		[NSThread sleepForTimeInterval:0.1];
		//send notify to release barWindow
//		[[NSNotificationCenter defaultCenter] postNotificationName:ReleaseMainCtrlNotification object:nil];
	}
}

- (BOOL)openURLAction:(NSURL *)nsUrl
{
	BOOL res = NO;
	if (nsUrl) {
		MLOG(@"open url:%@,bSkipOut:%d",nsUrl,bSkipOut);
		if (bSkipOut) {
			MLOG(@"open begin url:%@,bSkipOut:%d",nsUrl,bSkipOut);
			if ([[UIApplication sharedApplication] canOpenURL:nsUrl]) {
				MLOG(@"open can begin url:%@,bSkipOut:%d",nsUrl,bSkipOut);
				res = [[UIApplication sharedApplication] openURL:nsUrl];
				MLOG(@"open can end url:%@,bSkipOut:%d,res:%d",nsUrl,bSkipOut,res);
			}
			MLOG(@"open end url:%@,bSkipOut:%d",nsUrl,bSkipOut);
		}else{
			MLOG(@"web view begin url:%@,bSkipOut:%d",nsUrl,bSkipOut);
			UIWebViewCtrl *ctrl = [[[UIWebViewCtrl alloc] initWithWebAddress:nsUrl] autorelease];
			[self.navigationController pushViewController:ctrl animated:YES];
		}
														
	}
	return res;
}

- (BOOL)openAPPURLAction:(NSURL *)nsUrl
{
	BOOL res = NO;
	if (nsUrl) {
#if 1
		if (bSkipOut) {
			if ([[UIApplication sharedApplication] canOpenURL:nsUrl]) {
//				if ([[UIApplication sharedApplication] respondsToSelector:@selector(applicationOpenURL:)])
//				{
//					[[UIApplication sharedApplication] applicationOpenURL:nsUrl];
//					res = YES;
//				}
                [[UIApplication sharedApplication] openURL:nsUrl];
                res = YES;
			}
		}else{
			UIWebViewCtrl *ctrl = [[[UIWebViewCtrl alloc] initWithWebAddress:nsUrl] autorelease];
			[self.navigationController pushViewController:ctrl animated:YES];
		}
#else
		MLOG(@"open app url:%@",nsUrl);
		if ([[UIApplication sharedApplication] canOpenURL:nsUrl]) {
			MLOG(@"open app begin url:%@,res:%d",nsUrl,res);
			res = [[UIApplication sharedApplication] openURL:nsUrl];
			MLOG(@"UIApplication app end url:%@,res:%d",nsUrl,res);
		}
		MLOG(@"open app end url:%@,res:%d",nsUrl,res);
#endif
														
	}
	return res;
}
#if ShowWhiteList
- (BOOL)autoSkipOut
{
	BOOL res = NO;
	if ([theAction isMemberOfClass:[OpenAPPUrlAction class]]) {//没有协议的连接
		OpenAPPUrlAction * openURLAction =(OpenAPPUrlAction *)theAction; 
		//if the url is in the whiteList then open url
		int index = [self judgeInWhiteList:[openURLAction.URL absoluteString]];
		if (index >= 0) {
			//行为统计
//			NSString *labelStr = [NSString stringWithFormat:@"L_%d",index];
//			[recordUserActionOpt recordUserActionEvent:Trd_FG_TwoDimCodeLink label:labelStr];
			
			BOOL res = NO;
			NSURL *nsUrl = openURLAction.URL;			
			if ([[UIApplication sharedApplication] canOpenURL:nsUrl]) {
				if ([[UIApplication sharedApplication] respondsToSelector:@selector(applicationOpenURL:)])
				{
					[[UIApplication sharedApplication] openURL:nsUrl];
					res = YES;
				}
			}
			//BOOL res = [self openAPPURLAction:openURLAction.URL];				
			if (res) {
				[self releaseBarWindow];
				//				if (bSkipOut) {
				//					[[NSNotificationCenter defaultCenter] postNotificationName:ReleaseMainCtrlNotification object:nil];
				//				}
			}
			
		}
	}else if ([theAction isMemberOfClass:[OpenUrlAction class]]) {//协议获取到的连接
		OpenUrlAction * openURL =(OpenUrlAction *)theAction; 
		//if the url is in the whiteList then open url
		int index = [self judgeInWhiteList:[openURL.URL absoluteString]];
		if (index >= 0) {
			//行为统计
//			NSString *labelStr = [NSString stringWithFormat:@"L_%d",index];
//			[recordUserActionOpt recordUserActionEvent:Trd_FG_TwoDimCodeLink label:labelStr];
			
			//BOOL res = [self openURLAction:openURL.URL];
			BOOL res = NO;
			NSURL *nsUrl = openURL.URL;			
			if ([[UIApplication sharedApplication] canOpenURL:nsUrl]) 
			{
				if ([[UIApplication sharedApplication] respondsToSelector:@selector(applicationOpenURL:)])
				{
					[[UIApplication sharedApplication] openURL:nsUrl];
					res = YES;
				}
			}
			if (res) {
				[self releaseBarWindow];
				//				if (bSkipOut) {
				//					[[NSNotificationCenter defaultCenter] postNotificationName:ReleaseMainCtrlNotification object:nil];
				//				}
				
			}//crash in 6.x
		}
	}
	return res;
}
static BOOL bCanSkip = YES;
- (void)viewWillAppear:(BOOL)animated
{
	
}
- (void)viewDidAppear:(BOOL)animated
{
	if (bCanSkip) {
		[self autoSkipOut];
		//[self performSelector:@selector(autoSkipOut) withObject:nil afterDelay:0.5f];
		bCanSkip = NO;
	}
	
}
#endif
- (BOOL)copyToBorad:(NSString *)copyText
{
	BOOL res = NO;
	if (copyText) {
		UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
		[pasteboard setString:copyText];
		if(bSkipOut)
		{
			[pasteboard setPersistent:YES];
			[pasteboard setValue:copyText forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
		}
		res = YES;
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:_(@"copySuccess") delegate:self cancelButtonTitle:_(@"Confirm") otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	return res;
}
- (BOOL)callAction:(NSString *)numberStr
{
	BOOL res = NO;
	if (numberStr&&[numberStr isKindOfClass:[NSString class]]) {
		if (bSkipOut) {
			numberStr = [NSString stringWithFormat:@"tel://%@",numberStr];
			NSURL *phoneUrl= [NSURL URLWithString:numberStr];
			if (!phoneUrl&&[numberStr isKindOfClass:[NSString class]]) {
				numberStr = [numberStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				phoneUrl= [NSURL URLWithString:numberStr];
			}
			res =[self openURLAction:phoneUrl];
		}else{			
			//numberStr = [NSString stringWithFormat:@"telprompt://%@",numberStr];
			//NSURL *phoneUrl= [NSURL URLWithString:numberStr];							
			//res =[self openURLAction:phoneUrl];
			numberStr = [NSString stringWithFormat:@"tel://%@",numberStr];
			NSURL *phoneUrl= [NSURL URLWithString:numberStr];
			if (!phoneUrl&&[numberStr isKindOfClass:[NSString class]]) {
				numberStr = [numberStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				phoneUrl= [NSURL URLWithString:numberStr];
			}			
			if (!phoneCallWebView) {
				phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
			}
			[phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
		}
			
	}
	return res;
}



//邮件完成处理

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
	
	switch (result) {
		case MFMailComposeResultCancelled:
			MLOG(@"sms canceled");
			break;
			
		case MFMailComposeResultSaved:
			MLOG(@"sms MFMailComposeResultSaved");
			break;
		case MFMailComposeResultSent:
		{
			MLOG(@"sms send");
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:_(@"邮件已发送") delegate:self cancelButtonTitle:_(@"Confirm") otherButtonTitles:nil];
			[alertView show];
			[alertView release];
			break;
		}			
		case MFMailComposeResultFailed:
		{
			MLOG(@"sms failed:%@",error);
			if (error) {
				NSString *errMsg = [NSString stringWithFormat:@"%@:%@",_(@"邮件发送失败"),error];
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:errMsg delegate:self cancelButtonTitle:_(@"Confirm") otherButtonTitles:nil];
				[alertView show];
				[alertView release];
			}else{
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:_(@"邮件已发送") delegate:self cancelButtonTitle:_(@"Confirm") otherButtonTitles:nil];
				[alertView show];
				[alertView release];
			}			
			break;
		}			
		default:
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
	
}
//发送邮件

-(BOOL)sendMail:(NSString *)toRecipient subject:(NSString *)subject content:(NSString *)content{
    BOOL res = NO;
	MFMailComposeViewController *controller = [[[MFMailComposeViewController alloc] init] autorelease];
    if([MFMailComposeViewController canSendMail])	
    {
		if (toRecipient&&[toRecipient isKindOfClass:[NSString class]]) {
			[controller setToRecipients:[NSArray arrayWithObject:toRecipient]];
		}
		if (subject&&[subject isKindOfClass:[NSString class]]) {
			[controller setSubject:subject];
		}
        if (content&&[content isKindOfClass:[NSString class]]) {
			[controller setMessageBody:content isHTML:NO];
		}        		
        controller.mailComposeDelegate = self;		
        [self presentModalViewController:controller animated:YES];
		res = YES;
    }    
	return res;
}
//@"mailto:549039398@163.com;subject=;body="
- (NSString *)MailtoString:(NSString *)to sub:(NSString *)sub body:(NSString *)body
{	
	NSMutableString *result = nil;
	if (to&&[to isKindOfClass:[NSString class]]) {
		result = [NSMutableString stringWithFormat:@"mailto:%@", 
				  [to stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		
	}else{
		return nil;
	}
	if (sub&&[sub isKindOfClass:[NSString class]]) {
		[result appendFormat:@"?subject=%@", [sub stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	}
	if (body&&[body isKindOfClass:[NSString class]]) {
		[result appendFormat:@"&body=%@", [body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	}
	return result;
}
- (BOOL)sendEmailTo:(NSString *)toRecipient subject:(NSString *)subject content:(NSString *)content 
{
	if (bSkipOut) {
		BOOL res = NO;
		NSString *sendMailStr = [self MailtoString:toRecipient sub:subject body:content];		
		NSURL *nsURL= [NSURL URLWithString:sendMailStr];
		if (!nsURL&&[sendMailStr isKindOfClass:[NSString class]]) {
			sendMailStr = [sendMailStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			nsURL= [NSURL URLWithString:sendMailStr];
		}		
		res = [self openURLAction:nsURL];
		return res;
	}else{
		BOOL canSendEmail = NO;
		Class messageClass = (NSClassFromString(@"MFMailComposeViewController"));
		if (messageClass != nil) {   
			// Check whether the current device is configured for sending SMS messages		  
			canSendEmail = [self sendMail:toRecipient subject:subject content:content];   
		}
		return canSendEmail;
	}	
}

- (BOOL)sendSMSTo:(NSString *)smsNumber smsBody:(NSString *)smsBody {
	MLOG(@"sendSMSTo begin");
	
	if (bSkipOut) {
		BOOL res = NO;
		NSMutableString *result = nil;
		if (smsNumber&&[smsNumber isKindOfClass:[NSString class]]) {
			result = [NSMutableString stringWithFormat:@"sms:%@",smsNumber];		
		}else if (smsNumber == nil||[smsNumber isKindOfClass:[NSNull class]])
		{
			result = [NSMutableString stringWithFormat:@"sms:"];
		}
		if (SYSTEM_VERSION >= 4.0 && SYSTEM_VERSION < 5.0) {
			if (smsBody&&[smsBody isKindOfClass:[NSString class]]) {
				[result appendFormat:@"?body=%@", [smsBody stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			}
		}
		NSURL *nsURL= [NSURL URLWithString:result];
		if (!nsURL&&[result isKindOfClass:[NSString class]]) {
			result = (NSMutableString *)[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			nsURL= [NSURL URLWithString:result];
		}
		res = [self openURLAction:nsURL];
		return res;
	}else{
		
		//BOOL canSendSMS = [MFMessageComposeViewController canSendText];
		//MLOG(@"can send SMS [%d]", canSendSMS);	
		//if (canSendSMS) {
		BOOL canSendSMS = NO;
		//  The MFMessageComposeViewController class is only available in iPhone OS 4.0 or later.   
		//  So, we must verify the existence of the above class and log an error message for devices   
		//      running earlier versions of the iPhone OS. Set feedbackMsg if device doesn't support   
		//      MFMessageComposeViewController API.   
		Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));   
		if (messageClass != nil) {   
		// Check whether the current device is configured for sending SMS messages 
		canSendSMS = [messageClass canSendText];
		if (canSendSMS) {
			MLOG(@"canSendSMS begin");	
			MFMessageComposeViewController *picker = [[[MFMessageComposeViewController alloc] init] autorelease];
			if (smsBody&&[smsBody isKindOfClass:[NSString class]]) {
				picker.body = smsBody;
			}		
			if (smsNumber&&[smsNumber isKindOfClass:[NSString class]]) {
				picker.recipients = [NSArray arrayWithObject:smsNumber];
			}
			picker.messageComposeDelegate = self;
			//picker.navigationBar.tintColor = [UIColor blackColor];
			//picker.modalTransitionStyle = UIModalTransitionStylePartialCurl;
			MLOG(@"picker begin:%@",picker);
			if (picker) {
				[self presentModalViewController:picker animated:YES];
				MLOG(@"picker end");
			}	
			//[picker release];
			//it will crash
		}   
		/*else {   
		 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:_(@"设备没有短信功能") delegate:self cancelButtonTitle:_(@"Confirm") otherButtonTitles:nil];
		 [alertView show];
		 [alertView release];   
		 }*/   
		}
		//}
		return canSendSMS;

	}
}

// Dismisses the message composition interface when users tap Cancel or Send. Proceeds to update the 
// feedback message field with the result of the operation.
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
				 didFinishWithResult:(MessageComposeResult)result {	
	// Notifies users about errors associated with the interface
	switch (result) {
		case MessageComposeResultCancelled:
			MLOG(@"sms canceled");
			break;
		case MessageComposeResultSent:
		{
			MLOG(@"sms send");
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:_(@"短信已发送") delegate:self cancelButtonTitle:_(@"Confirm") otherButtonTitles:nil];
			[alertView show];
			[alertView release];
			break;
		}			
		case MessageComposeResultFailed:
		{
			MLOG(@"sms failed");
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:_(@"短信发送失败") delegate:self cancelButtonTitle:_(@"Confirm") otherButtonTitles:nil];
			[alertView show];
			[alertView release];
			break;
		}			
		default:
			break;
	}
	[self dismissModalViewControllerAnimated:YES];	
}


- (BOOL)openLocation:(NSString *)locationStr
{
	BOOL res = NO;
	if (locationStr) {
		NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", 
							   [locationStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		NSURL *nsURL= [NSURL URLWithString:urlString];
		if (!nsURL&&[urlString isKindOfClass:[NSString class]]) {
			urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			nsURL= [NSURL URLWithString:urlString];
		}
		res = [self openURLAction:nsURL];
	}
	return res;
}


/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}*/

- (void)btnClick:(id)sender
{
	if ([theAction isMemberOfClass:[OpenAPPUrlAction class]]) {//没有协议的连接
		OpenAPPUrlAction * openURLAction =(OpenAPPUrlAction *)theAction; 
		//[openURLAction linkURL];
		NSString *strUrl = [openURLAction.URL absoluteString];
		if (strUrl&&[strUrl isKindOfClass:[NSString class]]) {
			if([strUrl length]>25)
				strUrl = [strUrl substringWithRange:NSMakeRange(0, 25)];
//			NSString *labelStr = [NSString stringWithFormat:@"L0_%@",strUrl];
//			[recordUserActionOpt recordUserActionEvent:Trd_FG_TwoDimCodeLink label:labelStr];
		}
		BOOL res = [self openAPPURLAction:openURLAction.URL];	
		if (res) {
			[self releaseBarWindow];
		}
	}else if ([theAction isMemberOfClass:[OpenUrlAction class]]) {//协议获取到的连接
		OpenUrlAction * openURL =(OpenUrlAction *)theAction; 
		//[openURL openURL];
		NSString *strUrl = [openURL.URL absoluteString];
		if (strUrl&&[strUrl isKindOfClass:[NSString class]]) {
			if([strUrl length]>25)
				strUrl = [strUrl substringWithRange:NSMakeRange(0, 25)];
//			NSString *labelStr = [NSString stringWithFormat:@"L1_%@",strUrl];
//			[recordUserActionOpt recordUserActionEvent:Trd_FG_TwoDimCodeLink label:labelStr];
		}
		BOOL res = [self openURLAction:openURL.URL];	
		if (res) {
			[self releaseBarWindow];
		}
	}else if([theAction isMemberOfClass:[AddContactAction class]]){
		AddContactAction * addContact =(AddContactAction *)theAction; 
		[addContact performAction:self];
	}else if([theAction isMemberOfClass:[CallAction class]]){
		CallAction * callAction =(CallAction *)theAction;
		if ([self callAction:callAction.number]) {
			[self releaseBarWindow];
		}
	}else if([theAction isMemberOfClass:[EmailAction class]]){
		EmailAction * emailAction =(EmailAction *)theAction;
		if (bSkipOut) {
			BOOL res = [self sendEmailTo:emailAction.recipient subject:emailAction.subjectStr content:emailAction.bodyStr];
			if (res) {
				[self releaseBarWindow];
			}
		}else{
			[self sendEmailTo:emailAction.recipient subject:emailAction.subjectStr content:emailAction.bodyStr];
		}
		
	}else if([theAction isMemberOfClass:[ShowMapAction class]]){
		ShowMapAction * showMapAction =(ShowMapAction *)theAction;
		if ([self openLocation:showMapAction.location]) {
			[self releaseBarWindow];
		}
	}else if([theAction isMemberOfClass:[SMSAction class]]){
		SMSAction * smsAction =(SMSAction *)theAction;
		if ([self sendSMSTo:smsAction.number smsBody:smsAction.body]) {
			[self releaseBarWindow];
		}
	}else if([theAction isMemberOfClass:[TextAction class]]){
		TextAction * textAction =(TextAction *)theAction;
		[self copyToBorad:textAction.textStr];
	}
}

- (NSArray *)defaultWhiteListCreate
{
	NSArray *whiteListArr = [NSArray arrayWithObjects:@"weixin.qq.com",
							 @"app.91.com",
							 @"itunes.apple.com",
							 nil];
	return whiteListArr;
}
- (int)judgeInWhiteList:(NSString *)strIn
{
	int resIndex = -1;
	if (strIn&&[strIn isKindOfClass:[NSString class]]) {
		NSArray *whiteListArr = nil;
		NSFileManager *fileMgr = [NSFileManager defaultManager];
		if ([fileMgr fileExistsAtPath:TwoDimCodeWhiteListPath]) {
			whiteListArr = [NSArray arrayWithContentsOfFile:strIn];
			if ([whiteListArr count]) {
				MLOG(@"whiteListArr:%@",whiteListArr);
			}else{
				whiteListArr = [self defaultWhiteListCreate];
				[whiteListArr writeToFile:TwoDimCodeWhiteListPath atomically:YES];
			}
		}else{
			whiteListArr = [self defaultWhiteListCreate];
			[whiteListArr writeToFile:TwoDimCodeWhiteListPath atomically:YES];
		}
		//whiteListArr
		for (int index = 0;index <[whiteListArr count];index++) {
			NSString *itemWhiteStr = [whiteListArr objectAtIndex:index];
			if (itemWhiteStr&&[itemWhiteStr isKindOfClass:[NSString class]]) {
				NSRange searchRange = [strIn rangeOfString:itemWhiteStr options:NSCaseInsensitiveSearch];
				if (searchRange.location != NSNotFound) {
					resIndex = index;					
				}
			}
		}
	}
	return resIndex;
}
#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat heightCell = 61.0f;
	int index = indexPath.row;
	
	if (index >= 0 && index < [heightCellArr count]) {
		heightCell = [[heightCellArr objectAtIndex:index] intValue];
	}
	/*if ([theAction isMemberOfClass:[OpenAPPUrlAction class]]
		||[theAction isMemberOfClass:[OpenUrlAction class]]) {
		heightCell =  80.0f;
	}else{
		heightCell = 70.0f;
	}*/
	return heightCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 124.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	NSString *typeStr = [theAction title];	
	
	UIButton *btnAction = [UIButton buttonWithType:UIButtonTypeCustom];
	btnAction.backgroundColor = [UIColor clearColor];
	[btnAction addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
	NSString *btnTitle = nil;
	NSString *iconName = nil;
	
	if ([theAction isMemberOfClass:[OpenAPPUrlAction class]] ||[theAction isMemberOfClass:[OpenUrlAction class]]) {
		btnTitle = _(@"openLink");
		iconName = @"td_openLink.png";
	}
    else if([theAction isMemberOfClass:[AddContactAction class]]) {
		btnTitle = _(@"addContact");
		iconName = @"td_addContact.png";
	}
    else if([theAction isMemberOfClass:[CallAction class]]) {
		btnTitle = _(@"callPhone");
		iconName = @"td_default.png";
	}
    else if([theAction isMemberOfClass:[EmailAction class]]) {
		btnTitle = _(@"sendMail");
		iconName = @"td_default.png";
	}
    else if([theAction isMemberOfClass:[ShowMapAction class]]) {
		btnTitle = _(@"showMap");
		iconName = @"td_default.png";
	}
    else if([theAction isMemberOfClass:[SMSAction class]]) {
		btnTitle = _(@"sendSMS");
		iconName = @"td_default.png";
	}
    else if([theAction isMemberOfClass:[TextAction class]]) {
		btnTitle = _(@"copyText");
		iconName = @"td_default.png";
	}
    else if([theAction isMemberOfClass:[WifiAction class]]) {
		btnTitle = _(@"WIFI");
		iconName = @"td_default.png";
	}
    else if([theAction isMemberOfClass:[RichengAction class]]) {
		btnTitle = _(@"Richeng");
		iconName = @"td_default.png";
	}
    else {
		btnTitle = _(@"openLink");
		iconName = @"td_default.png";
	}
	MLOG(@"btnTitle:%@, iconName:%@", btnTitle, iconName);
	
	btnAction.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	UIImage *imageBtn = [[ResourcesManager shareInstance] imageWithFileName:@"TwoDimension/td_btnLink.png"];
	imageBtn =[imageBtn stretchableImageWithLeftCapWidth:6 topCapHeight:14];
	[btnAction setBackgroundImage:imageBtn forState:UIControlStateNormal];
	[btnAction setTitle:btnTitle forState:UIControlStateNormal];
	btnAction.frame = CGRectMake(100, 38+20+15, 86, 29);
	
	UILabel *nameStr = [[[UILabel alloc] initWithFrame:CGRectMake(100, 38, 200, 20)] autorelease];
	nameStr.font = [UIFont boldSystemFontOfSize:18];
	nameStr.backgroundColor = [UIColor clearColor];
	nameStr.textColor = [UIColor blackColor];	
	if ([theAction isMemberOfClass:[AddContactAction class]]) {
		NSMutableArray *arrProperty = allActionArr;
		if ([arrProperty count]) {
			ItemAction *infoItem = [arrProperty objectAtIndex:0];
			if ([infoItem isKindOfClass:[ItemAction class]]) {
				if ([infoItem.itemData isKindOfClass:[NSString class]]) {
					nameStr.text = [NSString stringWithFormat:@"%@",_(infoItem.itemData)];
				}
			}
		}
	}
    else {
		nameStr.text = [NSString stringWithFormat:@"%@", _(typeStr)];
	}
	
    UIImage *image = [[ResourcesManager shareInstance] imageWithFileName:[NSString stringWithFormat:@"TwoDimension/%@", iconName]];
	UIImageView *iconImage = [[[UIImageView alloc] initWithFrame:CGRectMake(14, 28, 70, 70)] autorelease];
    iconImage.backgroundColor = [UIColor clearColor];
	iconImage.image = image;
	
	UIView *headerView = nil;
	headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 124)] autorelease];
	[headerView addSubview:iconImage];
	if ((![theAction isMemberOfClass:[WifiAction class]]) && (![theAction isMemberOfClass:[RichengAction class]]))
	{
		[headerView addSubview:btnAction];
	}	
	[headerView addSubview:nameStr];
	
	return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ([theAction isMemberOfClass:[AddContactAction class]]) {
		return countItem - 1;
	}
	return countItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int section = indexPath.section;
	int index = indexPath.row;
	static NSString *CellIdentifier = @"Cell"; 
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@-%d-%d", CellIdentifier, section,index]];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
    } 
	
	MLOG(@"contentCellArr:%@,contentCellArr count:%d",contentCellArr,[contentCellArr count]);
	if ((index >= 0 )&&index<[contentCellArr count]) {
		id info = [contentCellArr objectAtIndex:index];
		if ([info isKindOfClass:[ItemAction class]]) {
			ItemAction *infoItem = info;			
			CGFloat contentHeight = 61;
			if (index>=0&&index<[heightCellArr count]) {
				contentHeight = [[heightCellArr objectAtIndex:index] intValue];
			}
			if (contentHeight<61) {
				contentHeight = 61;
			}
			UIView *view = nil;
			MLOG(@"index:%d,infoItem:%@,name:%@,infoItem.itemData:%@,contentHeight:%f",index,infoItem,_([infoItem nameStr]),infoItem.itemData,contentHeight);
            
			NSString *typeName = [NSString stringWithFormat:@"%@:",_([infoItem nameStr])];
			CGSize sizeName = [typeName sizeWithFont:[UIFont systemFontOfSize:18]];
			if (sizeName.width>100) {
				sizeName.width = 100;
			}
			view = [cell.contentView viewWithTag:kTypeNameTag];
			if (!view) {
				//type name
				UILabel *typeInfo = [[[UILabel alloc] initWithFrame:CGRectMake(25,24,sizeName.width,20)] autorelease];
				typeInfo.font = [UIFont systemFontOfSize:18];
				typeInfo.tag = kTypeNameTag;
				typeInfo.backgroundColor = [UIColor clearColor];
				typeInfo.text = typeName;
				[cell.contentView addSubview:typeInfo];
			}else{
				((UILabel *)view).text = typeName;
			}
			
			contentHeight = contentHeight - 24 - 22;
			view = [cell.contentView viewWithTag:kContentStringTag];
			if (!view) {				
				//content
				UILabel *showLable = [[[UILabel alloc] initWithFrame:CGRectMake(25+sizeName.width+7,23,200-sizeName.width+50,contentHeight)] autorelease];
				showLable.font = cellFontSize;	
				showLable.lineBreakMode = UILineBreakModeWordWrap;
				showLable.numberOfLines = 0;				
				showLable.textAlignment = UITextAlignmentLeft;
				showLable.backgroundColor = [UIColor clearColor];
				showLable.tag = kContentStringTag;
				MLOG(@"first infoItem.itemData:%@",infoItem.itemData);
				if ([infoItem.itemData isKindOfClass:[NSString class]]) {
					showLable.text = infoItem.itemData;
				}else if([infoItem.itemData isKindOfClass:[NSArray class]]){
					NSString *showStr = [(NSArray *)infoItem.itemData objectAtIndex:0];
					if ([showStr isKindOfClass:[NSString class]]) {
						showLable.text = showStr;
					}					
				}			
				[cell.contentView addSubview:showLable];
				[showLable sizeToFit];
			}else{	
				((UILabel *)view).backgroundColor = [UIColor clearColor];
				if ([infoItem.itemData isKindOfClass:[NSString class]]) {
					((UILabel *)view).text = infoItem.itemData;
				}else if([infoItem.itemData isKindOfClass:[NSArray class]]){
					NSString *showStr = [(NSArray *)infoItem.itemData objectAtIndex:0];
					if ([showStr isKindOfClass:[NSString class]]) {
						((UILabel *)view).text = showStr;
					}					
				}
				((UILabel *)view).frame = CGRectMake(25+50+7,23,200,contentHeight);
				[((UILabel *)view) sizeToFit];
			}
		}
	}
	
	return cell;
	
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//copy text, call phone, email ,sms,add to contact
	int index = indexPath.row;
	NSString *titleText = nil;
	NSString *msgText = nil;
	NSInteger tagAlert = 0;
	if (index>=0 && index< [contentCellArr count]) {
		ItemAction *infoItem = [contentCellArr objectAtIndex:index];
		if ([infoItem isKindOfClass:[ItemAction class]]) {
			MLOG(@"select index:%d,infoItem.itemType:%d",index,infoItem.itemType);
			switch (infoItem.itemType) {
				case URLType://open url
					titleText = _(@"do you want to open link");
					if ([infoItem.itemData isKindOfClass:[NSString class]]) {
						msgText = infoItem.itemData;
					}					
					tagAlert = AlertBaseTag + index;
					break;
				case OpenURLType://application open action
					titleText = _(@"do you want to open link");
					if ([infoItem.itemData isKindOfClass:[NSString class]]) {
						msgText = infoItem.itemData;
					}
					tagAlert = AlertBaseTag + index;
					break;
				case NameType:
				case NoteType://copy text
				case AddressType:
				case OrganizationType:
				case JobTitleType:
				case WeiBoStrType:
					titleText = _(@"do you want to copy text");
					//if ([infoItem.itemData isKindOfClass:[NSString class]]) {
						//msgText = infoItem.itemData;
					//}
					tagAlert = AlertBaseTag + index;
					break;
				case PhoneNumbersType://call action
					titleText = _(@"do you want to call phone");
					if ([infoItem.itemData isKindOfClass:[NSArray class]]) {
						NSString *str = [infoItem.itemData objectAtIndex:0];
						if ([str isKindOfClass:[NSString class]]) {
							msgText = str;
						}						
					}else if ([infoItem.itemData isKindOfClass:[NSString class]]) {							
						msgText = infoItem.itemData;						
					}
					tagAlert = AlertBaseTag + index;
					break;
				case EmailType://send email action
					titleText = _(@"do you want to send email");
					if ([infoItem.itemData isKindOfClass:[NSString class]]) {
						msgText = infoItem.itemData;						
					}
					tagAlert = AlertBaseTag + index;
					break;
				case EmailToType:
					titleText = _(@"do you want to send email");
					if ([infoItem.itemData isKindOfClass:[NSArray class]]) {
						msgText = [(NSArray *)infoItem.itemData objectAtIndex:0];	
						if (![msgText isKindOfClass:[NSString class]]) {
							msgText = nil;
						}
					}
					tagAlert = AlertBaseTag + index;
					break;
				case SMSNumberType:	
				case SMSBodyType://send sms action
				case SMSNumberBodyType:
					titleText = _(@"do you want to send message");
					if ([infoItem.itemData isKindOfClass:[NSString class]]) {
						msgText = infoItem.itemData;						
					}else if([infoItem.itemData isKindOfClass:[NSArray class]]) {
						msgText = [infoItem.itemData objectAtIndex:0];	
						if (![msgText isKindOfClass:[NSString class]]) {
							msgText = nil;
						}
					}
					tagAlert = AlertBaseTag + index;
					break;
				case LocationType://location map address action
					titleText = _(@"do you want to show address");
					if ([infoItem.itemData isKindOfClass:[NSString class]]) {
						msgText = infoItem.itemData;						
					}
					tagAlert = AlertBaseTag + index;
					break;
				default:
					break;
			} 
		}
	}
	
	[self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
	
	if (titleText) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:titleText message:msgText delegate:self cancelButtonTitle:_(@"Cancel") otherButtonTitles:_(@"Confirm"),nil];
		alertView.tag = tagAlert;
		[alertView show];
		[alertView release];
	}
	
	
}

- (void)deselect
{
	if (resultTableView) {
		[resultTableView deselectRowAtIndexPath:[resultTableView indexPathForSelectedRow] animated:YES];
	}
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	BOOL res = NO;
	if (alertView.cancelButtonIndex != buttonIndex) {		
		int indexArr = alertView.tag - AlertBaseTag;
		if (indexArr>=0 && indexArr<[contentCellArr count]) {
			ItemAction *infoItem = [contentCellArr objectAtIndex:indexArr];
			MLOG(@"indexArr:%d,infoItem:%@",indexArr,infoItem);
			if ([infoItem isKindOfClass:[ItemAction class]]) {
				MLOG(@"infoItem.itemType:%d",infoItem.itemType);
				switch (infoItem.itemType) {
					case URLType:
					{
						NSURL *nsUrl = nil;
						if ([infoItem.itemData isKindOfClass:[NSString class]]) {
							NSString *urlStr = [NSString stringWithFormat:@"%@",(NSString *)infoItem.itemData];
							nsUrl= [NSURL URLWithString:urlStr];
							if (!nsUrl&&[urlStr isKindOfClass:[NSString class]]) {
								urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
								nsUrl= [NSURL URLWithString:urlStr];
							}
						}									
						MLOG(@"URLType nsUrl:%@",nsUrl);
						res = [self openURLAction:nsUrl];	
						if (res) {
							[self releaseBarWindow];
						}						
						break;
					}
					case OpenURLType:
					{
						NSURL *nsUrl = nil;
						if ([infoItem.itemData isKindOfClass:[NSString class]]) {
							NSString *urlStr = [NSString stringWithFormat:@"%@",(NSString *)infoItem.itemData];
							nsUrl= [NSURL URLWithString:urlStr];
							if (!nsUrl&&[urlStr isKindOfClass:[NSString class]]) {
								urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
								nsUrl= [NSURL URLWithString:urlStr];
							}							
						}	
						MLOG(@"OpenURLType nsUrl:%@",nsUrl);
						res = [self openAPPURLAction:nsUrl];	
						if (res) {
							[self releaseBarWindow];
						}
						
						break;
					}
					case NameType:
					case NoteType://copy text
					case AddressType:
					case OrganizationType:
					case JobTitleType:
					case WeiBoStrType:
					{						
						//copy action
						NSString *copyText = nil;
						if ([infoItem.itemData isKindOfClass:[NSString class]]) {
							copyText= (NSString *)infoItem.itemData;
						}
						[self copyToBorad:copyText];
						break;
					}
					case PhoneNumbersType://call action
					{
						NSString *numberStr = nil;
						if ([infoItem.itemData isKindOfClass:[NSArray class]]) {
							NSString *str = [infoItem.itemData objectAtIndex:0];
							if ([str isKindOfClass:[NSString class]]) {
								numberStr = str;
							}						
						}else if ([infoItem.itemData isKindOfClass:[NSString class]]) {							
							numberStr = infoItem.itemData;						
						}
						res = [self callAction:numberStr];
						if (res) {
							[self releaseBarWindow];
						}	
						break;
					}
					case EmailType://send email action
					{
						NSString *sendEmail = nil;
						if ([infoItem.itemData isKindOfClass:[NSString class]]) {
							sendEmail= (NSString *)infoItem.itemData;
						}
						if (bSkipOut) {
							res = [self sendEmailTo:sendEmail subject:nil content:nil];
							if (res) {
								[self releaseBarWindow];
							}
						}else{
							res = [self sendEmailTo:sendEmail subject:nil content:nil];
						}
						break;
					}
					case EmailToType:
					{
						NSArray *sendEmails = nil;
						NSString *str1 = nil;
						NSString *str2 = nil;
						NSString *str3 = nil;
						if ([infoItem.itemData isKindOfClass:[NSArray class]]) {
							sendEmails= (NSArray *)infoItem.itemData;
							if ([sendEmails count] == 3) {//to,sub,body
								str1 = [sendEmails objectAtIndex:0];
								str2 = [sendEmails objectAtIndex:1];
								str3 = [sendEmails objectAtIndex:2];
							}
						}
						if (bSkipOut) {
							res =[self sendEmailTo:str1 subject:str2 content:str3];
							if (res) {
								[self releaseBarWindow];
							}
						}else{
							res = [self sendEmailTo:str1 subject:str2 content:str3];
						}
								
						break;
					}
						
					case SMSNumberType:
					{
						NSString *sendSMSNumber = nil;
						if ([infoItem.itemData isKindOfClass:[NSString class]]) {
							sendSMSNumber= (NSString *)infoItem.itemData;
						}
						if (bSkipOut) {
							BOOL res = [self sendSMSTo:sendSMSNumber smsBody:nil];
							if (res) {
								[self releaseBarWindow];
							}
						}else{
							res = [self sendSMSTo:sendSMSNumber smsBody:nil];
						}

						break;
					}
					case SMSBodyType:
					{
						NSString *sendSMSBody = nil;
						if ([infoItem.itemData isKindOfClass:[NSString class]]) {
							sendSMSBody= (NSString *)infoItem.itemData;
						}
						if (bSkipOut) {
							res = [self sendSMSTo:nil smsBody:sendSMSBody];
							if (res) {
								[self releaseBarWindow];
							}
						}else{
							res = [self sendSMSTo:nil smsBody:sendSMSBody];
						}

						break;
					}
					case SMSNumberBodyType://send sms action
					{
						NSArray *sendSMSNumberBodys = nil;
						NSString *str1 = nil;
						NSString *str2 = nil;
						if ([infoItem.itemData isKindOfClass:[NSArray class]]) {
							sendSMSNumberBodys = (NSArray *)infoItem.itemData;
							if ([sendSMSNumberBodys count] == 2) {//number,body
								str1 = [sendSMSNumberBodys objectAtIndex:0];
								str2 = [sendSMSNumberBodys objectAtIndex:1];		
							}
						}
						if (bSkipOut) {
							res = [self sendSMSTo:str1 smsBody:str2];
							if (res) {
								[self releaseBarWindow];
							}
						}else{
							res = [self sendSMSTo:str1 smsBody:str2];
						}
						
						break;
					}
						
					case LocationType://location map address action
					{
						NSString *locationStr = nil;
						if ([infoItem.itemData isKindOfClass:[NSString class]]) {
							locationStr= (NSString *)infoItem.itemData;
						}
						res = [self openLocation:locationStr];
					    if (res) {
							[self releaseBarWindow];
						}
						
						break;	
					}
						
					default:
						res = YES;
						break;
				}
			}
			
		}
		
	}
	
}
@end
