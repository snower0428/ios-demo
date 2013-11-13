//
//  ViewController.m
//  LHTwoDimDemo
//
//  Created by leihui on 13-11-2.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "ViewController.h"
#import "TDProduceViewCtrl.h"
#import <TwoDDecoderResult.h>
#import "SSTextView.h"

#if ZXingOpenFlag

#import <QRCodeReader.h>
#import "ScannerResultCtrl.h"

#define kRemoveIndicatorViewNotification    @"kRemoveIndicatorViewNotification"

const int kMaskViewTag = 20130828;

#endif

typedef enum
{
    ButtonActionZXingScan   = 100,  //二维码扫描
    ButtonActionProduce,            //生成二维码
    ButtonActionSelectFromAlbum,    //从相册选择
}ButtonAction;

const int kNumberOfButton = 3;

@interface ViewController ()
{
#if ZXingOpenFlag
    ZXingWidgetController       *_widgetCtrl;
#endif
    
    SSTextView      *_textView;
}

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat leftMargin = 10.f;
    CGFloat topMargin = 10.f;
    CGFloat width = 300.f;
    CGFloat height = 40.f;
    CGFloat interval = 20.f;
    
    if (SYSTEM_VERSION >= 7.0) {
        topMargin = STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT;
    }
    
    // TextView
    _textView = [[SSTextView alloc] initWithFrame:CGRectMake(10, topMargin, width, 100)];
    _textView.font = [UIFont systemFontOfSize:14.f];
    _textView.layer.borderColor = [UIColor blackColor].CGColor;
    _textView.layer.borderWidth = 1.0f;
    _textView.layer.cornerRadius = 5;
    _textView.editable = NO;
    _textView.placeholder = @"在这里显示结果";
    _textView.placeholderTextColor = [UIColor lightGrayColor];
    [self.view addSubview:_textView];
    
    NSArray *arrayTitle = [NSArray arrayWithObjects:@"二维码扫描", @"生成二维码", @"从相册选择", nil];
    
    for (int i = 0; i < kNumberOfButton; i++) {
        CGFloat top = _textView.frame.origin.y + _textView.frame.size.height + 10;
        CGRect frame = CGRectMake(leftMargin, top + i*(height+interval), width, height);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = frame;
        button.tag = ButtonActionZXingScan+i;
        if (i < [arrayTitle count]) {
            [button setTitle:[arrayTitle objectAtIndex:i] forState:UIControlStateNormal];
        }
        [self.view addSubview:button];
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
#if ZXingOpenFlag
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeIndicatorViewNotification:) name:kRemoveIndicatorViewNotification object:nil];
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)btnClicked:(id)sender
{
    int btnTag = ((UIButton *)sender).tag;
    
    switch (btnTag) {
        case ButtonActionZXingScan:
        {
#if ZXingOpenFlag
            //二维码扫描
            [self showTwoDimension];
#endif
            break;
        }
            
        case ButtonActionProduce:
        {
            //生成二维码
            TDProduceViewCtrl *ctrl = [[TDProduceViewCtrl alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
            [ctrl release];
            break;
        }
            
        case ButtonActionSelectFromAlbum:
        {
            //从相册选择
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.allowsEditing = YES;
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:^{}];
            break;
        }
            
        default:
            break;
    }
}

- (void)decodeImage:(UIImage *)image
{
    NSMutableSet *qrReader = [[NSMutableSet alloc] init];
    QRCodeReader *qrcoderReader = [[QRCodeReader alloc] init];
    [qrReader addObject:qrcoderReader];
    
    Decoder *decoder = [[Decoder alloc] init];
    decoder.delegate = self;
    decoder.readers = qrReader;
    if (![decoder decodeImage:image]) {
        NSLog(@"decoder failed...");
    }
}

- (void)outPutResult:(NSString *)result
{
    NSLog(@"result:%@", result);
    _textView.text = result;
}

#pragma mark - DecoderDelegate

- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)result
{
    [self outPutResult:result.text];
}

- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason
{
    [self outPutResult:[NSString stringWithFormat:@"解码失败！"]];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:^{[self decodeImage:image];}];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Two dimension code
#if ZXingOpenFlag

- (void)showTwoDimension
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
#pragma clang diagnostic pop
    
#if TARGET_IPHONE_SIMULATOR
    [self processResult:@"12345" Ctrl:self];
#else
    if (_widgetCtrl) {
        [_widgetCtrl release];
        _widgetCtrl = nil;
    }
    _widgetCtrl = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
#if 1
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    NSSet *readers = [[NSSet alloc] initWithObjects:qrcodeReader,nil];
    [qrcodeReader release];
#else
    NSMutableSet *readers = [[NSMutableSet alloc ] init];
    MultiFormatReader* reader = [[MultiFormatReader alloc] init];
    [readers addObject:reader];
    [reader release];
#endif
    _widgetCtrl.readers = readers;
    [readers release];
    
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:_widgetCtrl];
    [navCtrl setNavigationBarHidden:YES];
    [self presentModalViewController:navCtrl animated:YES];
    [navCtrl release];
#endif
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
    NSLog(@"===============time:%f", end - start);
#pragma clang diagnostic pop
}

- (void)processResult:(NSString *)result Ctrl:(UIViewController *)Ctrl
{
#if 1
#if TARGET_IPHONE_SIMULATOR//test
	result = @"fdsafadsfsa";
    result = @"http:www.baidu.com";
    //result = @"http://itunes.apple.com/us/app/id=436957167";
	//result = @"http://weixin.qq.com/r/D-WsTfEHQlihybSn6Ar";
	//result = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=436957167";
	//result = @"mailto:549039398@163.com;";
	//result = @"wifi:S:wireless;T:WPA;P:7392517fdfdsfdfdfdgfdgfdgfddddddddggffgfsgfdgfdsgfdgsdfgfdsgfdgfgdfjhkghhjdfhjgdfhdfshjghjfdgjhgsjgfhjfgdhjsj;;";
	//result = @"market://details?id=com.youba.flashlight";
	//result = @"itms-services://?action=download-manifest&url=http://blog.s135.com/demo/ios/jhsmyt.plist";
	//result = @"http://play.91.com/Download/3770";//android download url
	//result = @"http://www.intozgc.com";
	//result = @"geo:40.71872,-73.98905,100";//google 在美国纽约位置：北纬40.71872 西经：73.98905 高度：100米
	//result = @"smsto:15005921421:上班都不忘给你打招呼嘿嘿";
	//result = @"MATMSG:TO:549039398@163.com;SUB:TESThaha;BODY:This is a testhaha;";
	result = @"MECARD:N:王 奇;ORG:西安工业大学;DIV:新浪 15891768615;TIL:学生;TEL:15891768615;EMAIL:wangqi368@163.com;NOTE:MSN:wangqi368@msn.cn;";
	//result = @"MECARD:N:gaofei;ORG:haha;TIL:test;TEL:11001;URL:www.aab.com;DIV:dfafda@sina.com;EMAIL:23@163.com;ADR:dfasfas;NOTE:Qq :549039398;;";
	//result = @"CARD:N:陈石;TIL:律师;COR:浙江蓝泓律师事务所;ADR:浙江省宁波市江东区百丈东路28弄1号嘉汇国贸大厦B座704室;TEL:0574-87727123p601;FAX:0574-87972967;M:13567896937;EM:pelu@qq.com;IM:QQ:984409495;URL:http://www.langhom.com;收费标准：严格执行《浙江省律师服务收费标准》;;";
	//result = @"BEGIN:VEVENT\nSUMMARY:败笔\nDTSTART:20130715\nDTEND:20130715\nLOCATION:程序法\nDESCRIPTION:非典过后关注度\nEND:VEVENT";
#endif
	if (result) {
		ScannerResultCtrl *scannerCtrl = [[ScannerResultCtrl alloc] initWithScannerStr:result bSkip:NO];
		if ((!scannerCtrl.parseResult)||(!scannerCtrl.actions)||([scannerCtrl.actions count] != 1)) {
			[scannerCtrl release];
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:_(@"Can not progress URL")
																message:result
															   delegate:nil
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
        else {
			UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:scannerCtrl];
#if TARGET_IPHONE_SIMULATOR
			[self presentModalViewController:navCtrl animated:YES];
#else
			[_widgetCtrl presentModalViewController:navCtrl animated:YES];
#endif
			[scannerCtrl release];
			[navCtrl release];
		}
	}
    else {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:_(@"Two Dim Code is NULL") message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
#else
	parseResult = [[UniversalResultParser parsedResultForString:result] retain];
	actions = [[parseResult actions] retain];
	MLOG(@"actions:%@,parseResult:%@",actions,parseResult);
	if (result) {
		NSURL *nsUrl = [NSURL URLWithString:result];//chinese
		if (!nsUrl&&[result isKindOfClass:[NSString class]]) {
			result = [result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			nsUrl= [NSURL URLWithString:result];
		}
		BOOL res = [[UIApplication sharedApplication] canOpenURL:nsUrl];
		if (res&&([result hasPrefix:@"itms-services://"]||[result hasPrefix:@"http"])) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"扫描的二维码信息为:"
																message:[NSString stringWithFormat:@"%@\n是否打开?",result] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
			[alertView show];
			[alertView release];
		}
		else if ([actions count] == 1) {
			ResultAction *theAction = [actions objectAtIndex:0];
			if ([theAction respondsToSelector:@selector(performActionWithController:shouldConfirm:)]) {
				[theAction performActionWithController:Ctrl shouldConfirm:YES];
			}
		}else{
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法处理的URL:"
																message:result
															   delegate:nil
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
		
	}else{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"扫描的二维码信息为空" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
#endif
}

- (void)removeIndicatorViewNotification:(NSNotification *)notification
{
    UIView *maskView = [_widgetCtrl.view viewWithTag:kMaskViewTag];
    if (maskView) {
        [maskView removeFromSuperview];
    }
}

#pragma mark - ZXingDelegate

- (void)zxingControllerViewWillAppear
{
    NSLog(@"zxingControllerViewWillAppear.....................");
    
    UIView *maskView = [[[UIView alloc] initWithFrame:_widgetCtrl.view.bounds] autorelease];
    maskView.tag = kMaskViewTag;
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    
    UIActivityIndicatorView *indicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    indicatorView.frame = CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height - 50)/2, 50, 50);
    [maskView addSubview:indicatorView];
    [indicatorView startAnimating];
    
    NSString *text = _(@"Data Loading...");
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, 1000)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height - 50)/2, size.width, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.font = font;
    [maskView addSubview:label];
    [label release];
    
    // Recalc indicator and label frame
    CGFloat totalWidth = indicatorView.frame.size.width + label.frame.size.width;
    
    CGRect rect = indicatorView.frame;
    rect.origin.x = ([[UIScreen mainScreen] bounds].size.width - totalWidth)/2;
    indicatorView.frame = rect;
    
    rect = label.frame;
    rect.origin.x = indicatorView.frame.origin.x + indicatorView.frame.size.width + 5;
    label.frame = rect;
    // End indicator view
    
    [_widgetCtrl.view addSubview:maskView];
    
    [maskView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result
{
	//result = @"itms-services://?action=download-manifest&url=http://blog.s135.com/demo/ios/jhsmyt.plist";
    NSLog(@"result:%@", result);
	[self processResult:result Ctrl:self];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller
{
    [controller dismissModalViewControllerAnimated:YES];
}

#endif

#pragma mark - dealloc

- (void)dealloc
{
#if ZXingOpenFlag
    [_widgetCtrl release];
#endif
    
    [_textView release];
    
    [super dealloc];
}

@end
