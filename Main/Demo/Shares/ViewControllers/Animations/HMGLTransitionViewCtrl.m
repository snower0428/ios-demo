//
//  HMGLTransitionViewCtrl.m
//  Demo
//
//  Created by leihui on 13-3-21.
//
//

#import "HMGLTransitionViewCtrl.h"
#import "Switch3DTransition.h"

@interface HMGLTransitionViewCtrl ()
- (void)createView;
@end

@implementation HMGLTransitionViewCtrl

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
    
    [self createView];
    
//    Switch3DTransition *transition = [[Switch3DTransition alloc] init];
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

#pragma mark - PrivateMethods

- (void)createView
{
    //
    //========================================
    //
    //View1
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 280, 140)];
    _view1.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_view1];
    
    UILabel *label1 = [UILabel labelWithName:@"This is View1"
                                        font:[UIFont systemFontOfSize:18]
                                       frame:CGRectMake(0, 5, 280, 30)
                                       color:[UIColor whiteColor]
                                   alignment:UITextAlignmentCenter];
    [_view1 addSubview:label1];
    
    UIButton *btnViewTransition1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnViewTransition1.frame = CGRectMake(20, 40, 240, 35);
    [btnViewTransition1 setTitle:@"UIView Transition" forState:UIControlStateNormal];
    [_view1 addSubview:btnViewTransition1];
    [btnViewTransition1 addTarget:self action:@selector(viewTransitionPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnCtrlTransition1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCtrlTransition1.frame = CGRectMake(20, 80, 240, 35);
    [btnCtrlTransition1 setTitle:@"ViewController Transition" forState:UIControlStateNormal];
    [_view1 addSubview:btnCtrlTransition1];
    [btnCtrlTransition1 addTarget:self action:@selector(ctrlTransitionPressed:) forControlEvents:UIControlEventTouchUpInside];
    //
    //========================================
    //
    //View2
    _view2 = [[UIView alloc] initWithFrame:_view1.frame];
    _view2.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_view2];
    
    UILabel *label2 = [UILabel labelWithName:@"This is View2"
                                        font:[UIFont systemFontOfSize:18]
                                       frame:label1.frame
                                       color:[UIColor whiteColor]
                                   alignment:UITextAlignmentCenter];
    [_view2 addSubview:label2];
    
    UIButton *btnViewTransition2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnViewTransition2.frame = btnViewTransition1.frame;
    [btnViewTransition2 setTitle:@"UIView Transition" forState:UIControlStateNormal];
    [_view2 addSubview:btnViewTransition2];
    [btnViewTransition2 addTarget:self action:@selector(viewTransitionPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnCtrlTransition2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCtrlTransition2.frame = btnCtrlTransition1.frame;
    [btnCtrlTransition2 setTitle:@"ViewController Transition" forState:UIControlStateNormal];
    [_view2 addSubview:btnCtrlTransition2];
    [btnCtrlTransition2 addTarget:self action:@selector(ctrlTransitionPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewTransitionPressed:(id)sender
{
    if (((UIButton *)sender).superview == _view1) {
        
    } else {
        
    }
}

- (void)ctrlTransitionPressed:(id)sender
{
    if (((UIButton *)sender).superview == _view1) {
        
    } else {
        
    }
}

#pragma mark - dealloc

- (void)dealloc
{
    [_view1 release];
    [_view2 release];
    
    [super dealloc];
}

@end
