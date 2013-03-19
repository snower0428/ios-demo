//
//  UIImageCategoryViewCtrl.m
//  Demo
//
//  Created by leihui on 13-3-19.
//
//

#import "UIImageCategoryViewCtrl.h"

@interface UIImageCategoryViewCtrl ()

@end

@implementation UIImageCategoryViewCtrl

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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, APP_HEIGHT)];
    view.backgroundColor = [UIColor grayColor];
    self.view = view;
    [view release];
    
    UIImage *image = [UIImage imageNamed:@"test.jpg"];
    UIImage *imageRounded = [image roundedCornerImage:20 borderSize:10];
    UIImage *imageCropped = [image croppedImage:CGRectMake(0, 0, 160, 240)];
//    UIImage *imageCropped = [image transparentBorderImage:20];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:imageRounded];
    imageView1.backgroundColor = [UIColor blueColor];
    imageView1.frame = CGRectMake(0, 0, 160, 240);
    [self.view addSubview:imageView1];
    [imageView1 release];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:imageCropped];
    imageView2.backgroundColor = [UIColor purpleColor];
    imageView2.frame = CGRectMake(160, 0, 160, 240);
    [self.view addSubview:imageView2];
    [imageView2 release];
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
    [super dealloc];
}

@end
