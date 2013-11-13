//
//  TDTextViewCtrl.m
//  LHTwoDimDemo
//
//  Created by leihui on 13-11-3.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "TDTextViewCtrl.h"
#import "TDResultViewCtrl.h"
#import "SSTextField.h"

#define kAddContactsButtonTag       1000

@interface TDTextViewCtrl ()
{
    UITextView      *_textView;
    SSTextField     *_textField;
    SSTextField     *_textFieldMailTitle;
    
    NSString        *_produceUrl;
}

@property (nonatomic, retain) NSString *produceUrl;

- (void)initTextInfo;
- (void)initCall;
- (void)initSMS;
- (void)initUrl;
- (void)initMail;

- (void)addContactsButton;
- (void)hiddenAddContactsButton:(BOOL)hidden;

@end

@implementation TDTextViewCtrl

@synthesize produceType = _produceType;
@synthesize produceUrl = _produceUrl;

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
    NSLog(@"self.view.frame:%@", NSStringFromCGRect(self.view.frame));
    
    if (_produceType == TDProduceTypeText || _produceType == TDProduceTypePasteboard) {
        //文本信息和剪贴板
        [self initTextInfo];
    }
    else if (_produceType == TDProduceTypeCall) {
        //电话
        [self initCall];
        [self addContactsButton];
    }
    else if (_produceType == TDProduceTypeSMS) {
        //短信
        [self initSMS];
    }
    else if (_produceType == TDProduceTypeUrl) {
        //网址
        [self initUrl];
    }
    else if (_produceType == TDProduceTypeMail) {
        //邮箱
        [self initMail];
    }
    
    // Right item
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"生成"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(onProduce)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)initTextInfo
{
    CGFloat top = 0.f;
    if (SYSTEM_VERSION >= 7.0) {
        top = STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT;
    }
    
    // TextView
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, top+10, 300, 150)];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.font = [UIFont systemFontOfSize:14.f];
    _textView.layer.borderColor = [UIColor blackColor].CGColor;
    _textView.layer.borderWidth = 1.0f;
    _textView.layer.cornerRadius = 10;
    [self.view addSubview:_textView];
    
    if (_produceType == TDProduceTypePasteboard) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        NSLog(@"pasteboard.string:%@", pasteboard.string);
        _textView.text = pasteboard.string;
    }
    
    if (_textView) {
        [_textView becomeFirstResponder];
    }
}

- (void)initCall
{
    CGFloat top = 0.f;
    if (SYSTEM_VERSION >= 7.0) {
        top = STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT;
    }
    
    _textField = [[SSTextField alloc] initWithFrame:CGRectMake(10, top+10, 300, 30)];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.delegate = self;
    _textField.font = [UIFont systemFontOfSize:14];
    _textField.keyboardType = UIKeyboardTypePhonePad;
    _textField.placeholder = @"请输入电话号码";
    _textField.placeholderTextColor = [UIColor lightGrayColor];
    _textField.textEdgeInsets = UIEdgeInsetsMake(6, 10, 0, 0);
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.layer.borderColor = [UIColor blackColor].CGColor;
    _textField.layer.borderWidth = 1.0f;
    _textField.layer.cornerRadius = 15.f;
    [self.view addSubview:_textField];
    
    [_textField becomeFirstResponder];
}

- (void)initMailTitle
{
    CGFloat top = 0.f;
    if (SYSTEM_VERSION >= 7.0) {
        top = STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT;
    }
    
    _textFieldMailTitle = [[SSTextField alloc] initWithFrame:CGRectMake(10, top+50, 300, 30)];
    _textFieldMailTitle.backgroundColor = [UIColor clearColor];
    _textFieldMailTitle.delegate = self;
    _textFieldMailTitle.font = [UIFont systemFontOfSize:14];
    _textFieldMailTitle.keyboardType = UIKeyboardTypeDefault;
    _textFieldMailTitle.returnKeyType = UIReturnKeyNext;
    _textFieldMailTitle.placeholder = @"请输入邮件主题";
    _textFieldMailTitle.placeholderTextColor = [UIColor lightGrayColor];
    _textFieldMailTitle.textEdgeInsets = UIEdgeInsetsMake(6, 10, 0, 0);
    _textFieldMailTitle.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textFieldMailTitle.layer.borderColor = [UIColor blackColor].CGColor;
    _textFieldMailTitle.layer.borderWidth = 1.0f;
    _textFieldMailTitle.layer.cornerRadius = 15.f;
    [self.view addSubview:_textFieldMailTitle];
}

- (void)initSMS
{
    [self initCall];
    [self addContactsButton];
    [self initTextInfo];
    
    _textView.frame = CGRectOffset(_textView.frame, 0, 40);
}

- (void)initUrl
{
    [self initCall];
    [self hiddenAddContactsButton:YES];
    
    _textField.placeholder = @"请输入网址";
    _textField.keyboardType = UIKeyboardTypeURL;
}

- (void)initMail
{
    [self initCall];
    [self addContactsButton];
    [self initMailTitle];
    [self initTextInfo];
    
    _textField.placeholder = @"请输入邮箱地址";
    _textField.keyboardType = UIKeyboardTypeEmailAddress;
    _textField.returnKeyType = UIReturnKeyNext;
    
    _textView.frame = CGRectOffset(_textView.frame, 0, 80);
    _textView.returnKeyType = UIReturnKeyDefault;
}

- (void)showResultWithUrl:(NSString *)url
{
    TDResultViewCtrl *ctrl = [[TDResultViewCtrl alloc] init];
    ctrl.strTDUrl = url;
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

- (void)onProduce
{
    switch (_produceType) {
        case TDProduceTypeText:
        case TDProduceTypePasteboard:
        {
            NSString *strUrl = _textView.text;
            [self showResultWithUrl:strUrl];
            break;
        }
            
        case TDProduceTypeCall:
        {
            NSString *strUrl = _textField.text;
            [self showResultWithUrl:strUrl];
            break;
        }
            
        case TDProduceTypeSMS:
        {
            //smsto:13905910429:content
            NSString *strPhoneNumber = _textField.text;
            NSString *strContent = _textView.text;
            NSString *strUrl = [NSString stringWithFormat:@"smsto:%@:%@", strPhoneNumber, strContent];
            [self showResultWithUrl:strUrl];
            break;
        }
            
        case TDProduceTypeUrl:
        {
            NSString *strUrl = _textField.text;
            [self showResultWithUrl:strUrl];
        }
            
        case TDProduceTypeMail:
        {
            //MATMSG:TO:snower_tt@139.com;SUB:title;BODY:content;
            NSString *strMailAddress = _textField.text;
            NSString *strMailTitle = _textFieldMailTitle.text;
            NSString *strMailContent = _textView.text;
            NSString *strUrl = [NSString stringWithFormat:@"MATMSG:TO:%@;SUB:%@;BODY:%@;", strMailAddress, strMailTitle, strMailContent];
            [self showResultWithUrl:strUrl];
            break;
        }
            
        default:
            break;
    }
}

- (void)addContacts:(id)sender
{
    NSLog(@"addContacts...");
}

- (void)addContactsButton
{
    UIButton *btnAddContacts = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btnAddContacts.frame = CGRectMake(_textField.frame.size.width - 35, 0, 30, 30);
    btnAddContacts.tag = kAddContactsButtonTag;
    [_textField addSubview:btnAddContacts];
    [btnAddContacts addTarget:self action:@selector(addContacts:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)hiddenAddContactsButton:(BOOL)hidden
{
    UIButton *btnAddContacts = (UIButton *)[_textField viewWithTag:kAddContactsButtonTag];
    if (btnAddContacts) {
        btnAddContacts.hidden = hidden;
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (_produceType == TDProduceTypeText || _produceType == TDProduceTypePasteboard) {
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
    }
    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string   // return NO to not change text
{
    NSLog(@"shouldChangeCharactersInRange:%@-----range:%@-----string:%@", textField.text, NSStringFromRange(range), string);
    
    if ([string isEqualToString:@""] && textField.text.length == 1) {
        [self hiddenAddContactsButton:NO];
    }
    else {
        [self hiddenAddContactsButton:YES];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField               // called when clear button pressed. return NO to ignore (no notifications)
{
    NSLog(@"textFieldShouldClear:%@", textField.text);
    
    [self hiddenAddContactsButton:NO];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    if (_produceType == TDProduceTypeMail) {
        if (textField == _textField) {
            [textField resignFirstResponder];
            [_textFieldMailTitle becomeFirstResponder];
        }
        else if (textField == _textFieldMailTitle) {
            [textField resignFirstResponder];
            [_textView becomeFirstResponder];
        }
    }
    
    return YES;
}

#pragma mark - dealloc

- (void)dealloc
{
    [_textView release];
    [_textField release];
    [_textFieldMailTitle release];
    
    [super dealloc];
}

@end
