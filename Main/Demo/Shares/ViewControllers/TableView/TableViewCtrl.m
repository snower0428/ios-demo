//
//  TableViewCtrl.m
//  Demo
//
//  Created by leihui on 13-3-20.
//
//

#import "TableViewCtrl.h"
#import "CommenCtrl.h"

@interface TableViewCtrl ()

@end

@implementation TableViewCtrl

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
                  @"CustomTableView",
                  @"LivelyTableView",
                  @"EGORefreshTableView",
                  nil];
    
    _arrayViewController = [[NSArray alloc] initWithObjects:
                            NSStringFromClass([TableViewDemoCtrl class]),
                            NSStringFromClass([LivelyTableViewCtrl class]),
                            NSStringFromClass([EGORefreshTableViewCtrl class]),
                            nil];
    
    self.title = @"TableView";
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
