//
//  LHDataStorageViewCtrl.m
//  Demo
//
//  Created by leihui on 13-8-7.
//
//

#import "LHDataStorageViewCtrl.h"

@interface LHDataStorageViewCtrl ()

@end

@implementation LHDataStorageViewCtrl

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
                  @"SQLite",
                  @"CoreData",
                  nil];
    
    _arrayViewController = [[NSArray alloc] initWithObjects:
                            NSStringFromClass([FailedBanksListViewCtrl class]),
                            NSStringFromClass([SDScaffoldIndexViewController class]),
                            nil];
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
