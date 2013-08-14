//
//  SSCheckBoxViewCtrl.m
//  Demo
//
//  Created by leihui on 13-7-30.
//
//

#import "SSCheckBoxViewCtrl.h"
#import "SSCheckBoxView.h"

@interface SSCheckBoxViewCtrl ()

@end

@implementation SSCheckBoxViewCtrl

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
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    for (int i = 0; i < kSSCheckBoxViewStylesCount; i++) {
        CGRect rect = CGRectMake(10, 10+i*50, 300, 30);
        SSCheckBoxView *checkBoxView = [[SSCheckBoxView alloc] initWithFrame:rect style:i checked:NO];
        [checkBoxView setText:[NSString stringWithFormat:@"checkBox #%d", i+1]];
        [self.view addSubview:checkBoxView];
        [checkBoxView release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
