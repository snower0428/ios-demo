//
//  CommenViewCtrl.m
//  Demo
//
//  Created by leihui on 13-3-20.
//
//

#import "CommenViewCtrl.h"
#import "CommenCtrl.h"

@interface CommenViewCtrl ()

@end

@implementation CommenViewCtrl

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
                  @"CMPopTipView",
                  @"CycleScrollView",
                  @"MKHorizMenu",
                  @"JSBadgeView",
                  @"LKBadgeView",
                  @"MTStatusBarOverlay",
                  @"Carousel",
                  @"FlipEffects",
                  @"UIImageCategory",
                  nil];
    
    _arrayViewController = [[NSArray alloc] initWithObjects:
                            NSStringFromClass([CMPopTipViewCtrl class]),
                            NSStringFromClass([CycleScrollViewCtrl class]),
                            NSStringFromClass([MKHorizMenuViewCtrl class]),
                            NSStringFromClass([JSBadgeViewCtrl class]),
                            NSStringFromClass([LKBadgeViewCtrl class]),
                            NSStringFromClass([MTStatusBarOverlayViewCtrl class]),
                            NSStringFromClass([CarouselViewCtrl class]),
                            NSStringFromClass([FlipEffectsViewCtrl class]),
                            NSStringFromClass([UIImageCategoryViewCtrl class]),
                            nil];
    
    self.title = @"CommenView";
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
