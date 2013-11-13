//
//  NSThreadViewCtrl.m
//  Demo
//
//  Created by leihui on 13-8-19.
//
//

#import "NSThreadViewCtrl.h"

#define kURL    @"http://p1.wo.baidu.com/1011/70/97ad3103a8f6ef2271bbd1fe36472b70/PictxVqPn.jpg"

@interface NSThreadViewCtrl ()

@end

@implementation NSThreadViewCtrl

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
    
    /**
     *  NSThread创建线程有两种方式：
     *  1. - (id)initWithTarget:(id)target selector:(SEL)selector object:(id)argument;
     *  2. + (void)detachNewThreadSelector:(SEL)selector toTarget:(id)target withObject:(id)argument;
     *
     */
//    [NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:kURL];
    _thread = [[NSThread alloc] initWithTarget:self selector:@selector(downloadImage:) object:kURL];
    [_thread start];
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

- (void)stopThread
{
    if (_thread) {
        [_thread cancel];
        [_thread release];
        _thread = nil;
    }
}

#pragma mark - dealloc

- (void)dealloc
{
    [_bgImageView release];
    [self stopThread];
    
    [super dealloc];
}

@end
