//
//  EmojiViewCtrl.m
//  Demo
//
//  Created by leihui on 13-3-21.
//
//

#import "EmojiViewCtrl.h"
#import "Emoji.h"
#import "EmojiEmoticons.h"
#import "EmojiMapSymbols.h"
#import "EmojiPictographs.h"
#import "EmojiTransport.h"

@interface EmojiViewCtrl ()

@end

@implementation EmojiViewCtrl

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
    
    NSArray *arrayEmoticons = [EmojiEmoticons allEmoticons];
    NSArray *arrayMapSymbols = [EmojiMapSymbols allMapSymbols];
    NSArray *arrayPictographs = [EmojiPictographs allPictographs];
    NSArray *arrayTransport = [EmojiTransport allTransport];
    NSArray *arrayEmoji = [Emoji allEmoji];
    NSLog(@"%d----------%d----------%d----------%d----------%d",
          [arrayEmoticons count], [arrayMapSymbols count], [arrayPictographs count], [arrayTransport count], [arrayEmoji count]);
    
//    NSString *str = @"";
//    for (int i = 0; i < [arrayEmoticons count]; i++) {
//        str = [str stringByAppendingFormat:@"%@", [arrayEmoticons objectAtIndex:i]];
//    }
//    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
//    label.backgroundColor = [UIColor clearColor];
//    label.text = str;
//    label.textAlignment = UITextAlignmentLeft;
//    label.lineBreakMode = UILineBreakModeWordWrap;
//    label.numberOfLines = 20;
//    [self.view addSubview:label];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Emoji" style:UIBarButtonItemStyleBordered target:self action:@selector(showEmoji)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    [self.view addSubview:searchBar];
    [searchBar release];
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

- (void)showEmoji
{
    
}

#pragma mark - dealloc

- (void)dealloc
{
    [super dealloc];
}

@end
