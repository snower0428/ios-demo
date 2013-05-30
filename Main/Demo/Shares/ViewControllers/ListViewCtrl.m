//
//  ListViewCtrl.m
//  Demo
//
//  Created by leihui on 13-4-10.
//
//

#import "ListViewCtrl.h"

@interface ListViewCtrl ()

@end

@implementation ListViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, APP_VIEW_HEIGH)];
    view.backgroundColor = [UIColor grayColor];
    self.view = view;
    [view release];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, APP_VIEW_HEIGH - TOOLBAR_HEIGHT, 320, TOOLBAR_HEIGHT)];
    [self.view addSubview:toolBar];
    [toolBar release];
    
    /**
     *  指定100以上的UIButton的buttonWithType就可以得到非公开的按钮风格
     *  其中100～102是UINavigationButton风格的按钮
     */
    UIButton *btnDirection = [UIButton buttonWithType:100];
    btnDirection.frame = CGRectMake(10, 8, 80, 26);
    [btnDirection setTitle:@"Direction" forState:UIControlStateNormal];
    [btnDirection setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDirection addTarget:self action:@selector(onDirection:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnBack = [UIButton buttonWithType:100];
    btnBack.frame = CGRectMake(180, 8, 60, 26);
    [btnBack setTitle:@"Back" forState:UIControlStateNormal];
    [btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnForward = [UIButton buttonWithType:100];
    btnForward.frame = CGRectMake(240, 8, 70, 26);
    [btnForward setTitle:@"Forward" forState:UIControlStateNormal];
    [btnForward setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnForward addTarget:self action:@selector(onForward:) forControlEvents:UIControlEventTouchUpInside];
    
    [toolBar addSubview:btnDirection];
    [toolBar addSubview:btnBack];
    [toolBar addSubview:btnForward];
    
    _listView = [[JTListView alloc] initWithFrame:CGRectMake(0, 0, 320, APP_VIEW_HEIGH - TOOLBAR_HEIGHT)];
    _listView.dataSource = self;
    _listView.delegate = self;
    [self.view addSubview:_listView];
    
    [_listView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons Action

- (void)onDirection:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Direction"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Left to Right", @"Right to Left", @"Top to Bottom", @"Bottom to Top", nil];
    [actionSheet showFromToolbar:self.navigationController.toolbar];
}

- (void)onBack:(id)sender
{
    [_listView goBack:YES];
}

- (void)onForward:(id)sender
{
    [_listView goForward:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    JTListViewLayout layout;
    switch (buttonIndex)
    {
        case 0: layout = JTListViewLayoutLeftToRight; break;
        case 1: layout = JTListViewLayoutRightToLeft; break;
        case 2: layout = JTListViewLayoutTopToBottom; break;
        case 3: layout = JTListViewLayoutBottomToTop; break;
        default: return; break;
    }
    _listView.layout = layout;
}

#pragma mark - JTListViewDataSource

- (NSUInteger)numberOfItemsInListView:(JTListView *)listView
{
    return 100;
}

- (UIView *)listView:(JTListView *)listView viewForItemAtIndex:(NSUInteger)index
{
    UIView *view = [listView dequeueReusableView];
    
    if (!view) {
        view = [[[UIView alloc] init] autorelease];
        
        UILabel *label = [[[UILabel alloc] initWithFrame:view.bounds] autorelease];
        label.center = view.center;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0];
        label.textAlignment = UITextAlignmentCenter;
        label.tag = 1;
        
        [view addSubview:label];
    }
    
    view.backgroundColor = [UIColor colorWithHue:(float)(index % 7) / 7.0 saturation:0.75 brightness:1.0 alpha:1.0];
    [(UILabel *)[view viewWithTag:1] setText:[NSString stringWithFormat:@"#%u", index]];
    
    return view;
}

#pragma mark - JTListViewDelegate

- (CGFloat)listView:(JTListView *)listView widthForItemAtIndex:(NSUInteger)index
{
    return (CGFloat)(index % 7 * 60 + 60);
}

- (CGFloat)listView:(JTListView *)listView heightForItemAtIndex:(NSUInteger)index
{
    return (CGFloat)(index % 7 * 60 + 60);
}

#pragma mark - dealloc

- (void)dealloc
{
    [_listView release];
    
    [super dealloc];
}

@end
