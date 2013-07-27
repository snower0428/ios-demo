//
//  DockViewCtrl.m
//  Demo
//
//  Created by leihui on 13-3-20.
//
//

#import "DockViewCtrl.h"

@interface DockViewCtrl ()

@end

@implementation DockViewCtrl

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
    [super loadView];
    
    _arrayName = [[NSArray alloc] initWithObjects:
                  @"JADockView",
                  @"DDMemu",
                  nil];
    
    _arrayViewController = [[NSArray alloc] initWithObjects:
                            NSStringFromClass([JADockViewCtrl class]),
                            NSStringFromClass([DDMenuDockViewCtrl class]),
                            nil];
    
    self.title = @"DockView";
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

#pragma mark - dealloc

- (void)dealloc
{
    [_arrayName release];
    [_arrayViewController release];
    
    [super dealloc];
}

@end
