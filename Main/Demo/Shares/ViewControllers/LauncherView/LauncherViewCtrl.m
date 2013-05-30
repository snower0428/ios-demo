//
//  LauncherViewCtrl.m
//  Demo
//
//  Created by leihui on 13-4-16.
//
//

#import "LauncherViewCtrl.h"
#import "HMLauncherItem.h"
#import "BBAnimation.h"

#define BUTTON_SPACER 10
#define PAGECONTROL_HEIGHT 20

@interface LauncherViewCtrl ()
- (CGRect) centerRectForLauncherView:(HMLauncherView*) launcherView parentRect:(CGRect) parentRect;

@property(nonatomic, assign) BOOL dragIconHasMoved;
@end

@implementation LauncherViewCtrl

@synthesize currentDraggingView;
@synthesize dragIconHasMoved;

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
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    [view release];
    
    _launcherService = [[LauncherService alloc] init];
    [_launcherService loadLauncherData];
    
    _launcherView1 = [[HMLauncherView alloc] initWithFrame:CGRectMake(0, 0, 320, 230)];
    _launcherView1.backgroundColor = [UIColor grayColor];
    _launcherView1.persistKey = _launcherService.launcherDataLeft.persistKey;
    _launcherView1.dataSource = _launcherService;
    _launcherView1.delegate = self;
    [self.view addSubview:_launcherView1];
    [_launcherView1 reloadData];
    
    _launcherView2 = [[HMLauncherView alloc] initWithFrame:CGRectMake(0, 240, 320, 160)];
    _launcherView2.backgroundColor = [UIColor grayColor];
    _launcherView2.persistKey = _launcherService.launcherDataRight.persistKey;
    _launcherView2.dataSource = _launcherService;
    _launcherView2.delegate = self;
    [self.view addSubview:_launcherView2];
    [_launcherView2 reloadData];
    
    CGRect launcherView1Rect = [self centerRectForLauncherView:_launcherView1 parentRect:_launcherView1.frame];
    [_launcherView1 setFrame:launcherView1Rect];
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

#pragma mark - Private

- (CGRect) centerRectForLauncherView:(HMLauncherView*) launcherView parentRect:(CGRect) parentRect
{
    CGSize buttonDimensionsInLauncherView = [launcherView.dataSource buttonDimensionsInLauncherView:launcherView];
    
    int rows = [launcherView.dataSource numberOfRowsInLauncherView:launcherView];
    int cols = [launcherView.dataSource numberOfColumnsInLauncherView:launcherView];
    
    CGRect launcherViewRect = CGRectMake(parentRect.origin.x,
                                         parentRect.origin.y,
                                         cols * (buttonDimensionsInLauncherView.width + BUTTON_SPACER) ,
                                         (rows * buttonDimensionsInLauncherView.height) + PAGECONTROL_HEIGHT);
    
    CGRect centeredLauncherViewRect = launcherViewRect;
    centeredLauncherViewRect.origin.x = parentRect.origin.x + (parentRect.size.width / 2  - launcherViewRect.size.width / 2);
    centeredLauncherViewRect.origin.y = parentRect.origin.y;// + (parentRect.size.height / 2  - launcherViewRect.size.height / 2);
    
    return centeredLauncherViewRect;
}

#pragma mark - HMLauncherViewDelegate

- (void) launcherView:(HMLauncherView *)launcherView didTapLauncherIcon:(HMLauncherIcon *)icon
{
    NSLog(@"didTapLauncherIcon: %@", icon);
}

- (void) launcherView:(HMLauncherView *)launcherView didStartDragging:(HMLauncherIcon *)icon
{
    NSLog(@"didStartDragging");
    self.currentDraggingView = launcherView;
}

- (void) launcherView:(HMLauncherView *)launcherView didStopDragging:(HMLauncherIcon *)icon {
    NSLog(@"didStopDragging");
    self.currentDraggingView = nil;
    
    //    [self.launcherParentView.launcherViewLeft reloadData];
}

- (void) launcherView:(HMLauncherView*) launcherView willMoveIcon:(HMLauncherIcon *)icon fromIndex:(NSIndexPath *)fromIndex toIndex:(NSIndexPath *)toIndex {
    self.dragIconHasMoved = YES;
}

- (void) launcherView:(HMLauncherView*) launcherView willAddIcon:(HMLauncherIcon*) addedIcon {
    
}

- (void) launcherView:(HMLauncherView*) launcherView didDeleteIcon:(HMLauncherIcon*) deletedIcon {
    
}

- (void) launcherViewDidAppear:(HMLauncherView *)launcherView {
    
}

- (void) launcherViewDidDisappear:(HMLauncherView *)launcherView {
    
}

- (BOOL) launcherViewShouldStopEditingAfterDraggingEnds:(HMLauncherView *)launcherView {
    return self.dragIconHasMoved;
}

- (void) launcherViewDidStartEditing:(HMLauncherView*) launcherView {
    if (!_launcherView1.editing) {
        [_launcherView1 startEditing];
    }
    
    if (!_launcherView2.editing) {
        [_launcherView2 startEditing];
    }
}

- (void) launcherViewDidStopEditing:(HMLauncherView*) launcherView {
    self.dragIconHasMoved = NO;
    if (_launcherView1.editing) {
        [_launcherView1 stopEditing];
    }
    
    if (_launcherView2.editing) {
        [_launcherView2 stopEditing];
    }
}

- (HMLauncherView*) targetLauncherViewForIcon:(HMLauncherIcon *) icon {
    
    CGRect leftLauncherViewRectInKeyView = [icon.superview convertRect:_launcherView1.frame
                                                              fromView:_launcherView1.superview];
    
    CGRect rightLauncherViewRectInKeyView = [icon.superview convertRect:_launcherView2.frame
                                                               fromView:_launcherView2.superview];
    BOOL inLeftLauncherView = (CGRectContainsPoint(leftLauncherViewRectInKeyView, icon.center));
    BOOL inRightLauncherView = (CGRectContainsPoint(rightLauncherViewRectInKeyView, icon.center));
    
    if (inLeftLauncherView && inRightLauncherView) {
        // both launcherviews are overlapping. this is not intended.
        // in order to prevent a crash, the current draggingView will be returned.
    } else {
        if (inLeftLauncherView) {
            return _launcherView1;
        }
        
        if (inRightLauncherView) {
            return _launcherView2;
        }
    }
    return self.currentDraggingView;
}

#pragma mark - dealloc

- (void)dealloc
{
    [_launcherService release];
    [_launcherView1 release];
    [_launcherView2 release];
    
    [super dealloc];
}

@end
