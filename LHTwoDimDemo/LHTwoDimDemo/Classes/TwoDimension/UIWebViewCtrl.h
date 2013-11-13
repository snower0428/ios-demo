//
//  UIWebViewCtrl.h
//  PHScannerBundle
//
//  Created by Ye Gaofei on 13-7-11.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebViewCtrl : UIViewController<UIWebViewDelegate,UIActionSheetDelegate>
{
	NSURL *netAddress;
	UIWebView *_webView;
	UIActivityIndicatorView *loadingIndicator;
	UIToolbar *toolbar;
	
	UIBarButtonItem *_backButton;
	UIBarButtonItem *_forwardButton;
	UIBarButtonItem *_stopButton;
	UIBarButtonItem *_refreshButton;
	UIBarButtonItem *_actionButton;
	UIBarButtonItem *_doneButton;
	UIBarButtonItem *vSpace;
	UIBarButtonItem *fSpace;
	BOOL _firstRequest;
}
@property (nonatomic,retain) NSURL *netAddress;

- (id)initWithWebAddress:(NSURL *)address;

@end
#pragma mark - UIToolbar (TTCategory)
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface UIToolbar(UIWebViewCtrl)

- (void)replaceItem:(UIBarButtonItem *)oldItem withItem:(UIBarButtonItem *)item;
@end