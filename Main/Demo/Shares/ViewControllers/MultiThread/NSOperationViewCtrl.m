//
//  NSOperationViewCtrl.m
//  Demo
//
//  Created by leihui on 13-8-20.
//
//

#import "NSOperationViewCtrl.h"

#define kURL    @"http://www.blackberry-wallpapers.com/uploads/allimg/110330/2-1103301120260-L.jpg"

@interface NSOperationViewCtrl ()

@end

@implementation NSOperationViewCtrl

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
    
    _bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _bgImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bgImageView];
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage:) object:kURL];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
    [operation release];
    [queue release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)updateUI:(UIImage *)image
{
    _bgImageView.image = image;
}

- (void)downloadImage:(NSString *)url
{
    NSLog(@"url:%@", url);
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [[UIImage alloc] initWithData:data];
    
    if (image == nil) {
        NSLog(@"downloadImage failed...");
    }
    else {
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES];
    }
    
    [image release];
    [data release];
}

#pragma mark - dealloc

- (void)dealloc
{
    [_bgImageView release];
    
    [super dealloc];
}

@end
