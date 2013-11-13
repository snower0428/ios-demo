//
//  ScannerResultCtrl.h
//  PHScannerBundle
//
//  Created by Ye Gaofei on 13-7-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversalResultParser.h"
#import "ResultAction.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#define AlertBaseTag          2000
#define AlertActionClickTag   3000


@interface ScannerResultCtrl : UIViewController<UITableViewDataSource,
                                                UITableViewDelegate,
                                                UIAlertViewDelegate,
                                                MFMailComposeViewControllerDelegate,
												MFMessageComposeViewControllerDelegate>
{
	NSString *scannerStr;	
	ParsedResult *parseResult;
	NSArray *actions;
	ResultAction *theAction;
	
	UITableView *resultTableView;
	NSInteger    countItem;
	NSMutableArray *allActionArr;
	NSMutableArray *contentCellArr;
	BOOL animate;
	BOOL bSkipOut;
	UIWebView *phoneCallWebView;
	NSMutableArray *heightCellArr;//cell 高度的数组
}
@property (nonatomic,retain) NSString *scannerStr;
@property (nonatomic,readonly) NSArray *actions;
@property (nonatomic,readonly) ParsedResult *parseResult;

- (id)initWithScannerStr:(NSString *)twoDimStr bSkip:(BOOL)bSkip;

@end
