//
//  LHLyricsViewCtrl.m
//  Demo
//
//  Created by leihui on 13-8-15.
//
//

#import "LHLyricsViewCtrl.h"
#import "MusicLrcHelper.h"
#import "MusicLrcLine.h"

static NSString *kStr = @"Just for test lyric! test lyric, oh ye!!!";

@interface LHLyricsViewCtrl ()

@end

@implementation LHLyricsViewCtrl

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
    
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithTitle:@"Play"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self action:@selector(playAction:)];
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithTitle:@"Pause"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self action:@selector(pauseAction:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightItem1, rightItem2, nil];
    [rightItem1 release];
    [rightItem2 release];
    
    _labelLyric = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 20)];
    _labelLyric.backgroundColor = [UIColor clearColor];
    _labelLyric.text = kStr;
    _labelLyric.font = [UIFont boldSystemFontOfSize:18];
    [_labelLyric setTextColor:[UIColor blackColor]];
    [self.view addSubview:_labelLyric];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)playAction:(id)sender
{
    NSString *lrcPath = [[NSBundle mainBundle] pathForResource:@"王菲 - 致青春" ofType:@"lrc"];
    
    unsigned long encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *responseData = [NSData dataWithContentsOfFile:lrcPath];
    NSString *strContent = [[NSString alloc] initWithData:responseData encoding:encoding];
    
    MusicLrcHelper *helper = [[MusicLrcHelper alloc] init];
    NSArray *array = [helper parseLrc:strContent];
    for (MusicLrcLine *lrcLine in array) {
        NSLog(@"time:%f, text:%@", lrcLine.timeLine, lrcLine.songLineText);
    }
    
    [strContent release];
    
    if (_labelOver) {
        [_labelOver removeFromSuperview];
        _labelOver = nil;
    }
    
    CGRect frame = _labelLyric.frame;
    frame.size.width = 0;
    
    _labelOver = [[UILabel alloc] initWithFrame:frame];
    _labelOver.backgroundColor = [UIColor clearColor];
    _labelOver.text = kStr;
    _labelOver.font = [UIFont boldSystemFontOfSize:18];
    [_labelOver setTextColor:[UIColor blueColor]];
    [self.view addSubview:_labelOver];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:6.0];
    _labelOver.frame = _labelLyric.frame;
    [UIView commitAnimations];
}

- (void)pauseAction:(id)sender
{
    [_labelOver.layer removeAllAnimations];
}

#pragma mark - dealloc

- (void)dealloc
{
    [_labelLyric release];
    [_labelOver release];
    
    [super dealloc];
}

@end
