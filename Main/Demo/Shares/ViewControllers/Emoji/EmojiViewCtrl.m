//
//  EmojiViewCtrl.m
//  Demo
//
//  Created by leihui on 13-3-21.
//
//

#import "EmojiViewCtrl.h"
#import "EmojiViewContainer.h"
#import "EmojiView.h"
#import "EmojiCoding.h"
#import "EmojiRecentManager.h"

#define kEmojiViewContainerTag  500
#define kSearchBarTag           501

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
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Emoji" style:UIBarButtonItemStyleBordered target:self action:@selector(showEmoji)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    searchBar.tag = kSearchBarTag;
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    [searchBar release];
    
    CGRect emojiViewFrame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, kEmojiBoardHeight);
    EmojiViewContainer *container = [[EmojiViewContainer alloc] initWithFrame:emojiViewFrame];
    container.tag = kEmojiViewContainerTag;
    [self.view addSubview:container];
    container.hidden = YES;
    [container release];
    
//    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emojiDidSelected:) name:kEmojiSelectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emojiDidDelete:) name:kEmojiDeleteNotification object:nil];
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

- (void)didTapAnywhere:(UITapGestureRecognizer *)recognizer
{
    UISearchBar *searchBar = (UISearchBar *)[self.view viewWithTag:kSearchBarTag];
    if (searchBar) {
        [searchBar resignFirstResponder];
    }
}

- (void)showEmoji
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Keyboard"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(showKeyboard)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    UISearchBar *searchBar = (UISearchBar *)[self.view viewWithTag:kSearchBarTag];
    if (searchBar) {
        [searchBar resignFirstResponder];
    }
    EmojiViewContainer *container = (EmojiViewContainer *)[self.view viewWithTag:kEmojiViewContainerTag];
    if (container) {
        [self.view bringSubviewToFront:container];
    }
    
    _emojiBoardIsShow = YES;
    container.hidden = NO;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                         CGRect emojiViewFrame = CGRectMake(0, self.view.frame.size.height - kEmojiBoardHeight, self.view.frame.size.width, kEmojiBoardHeight);
                         container.frame = emojiViewFrame;
                     }completion:^(BOOL finished){
                         
                     }];
}

- (void)showKeyboard
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Emoji"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(showEmoji)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    UISearchBar *searchBar = (UISearchBar *)[self.view viewWithTag:kSearchBarTag];
    if (searchBar) {
        [searchBar becomeFirstResponder];
    }
    
    EmojiViewContainer *container = (EmojiViewContainer *)[self.view viewWithTag:kEmojiViewContainerTag];
    if (container) {
        [self.view bringSubviewToFront:container];
    }
    
    _emojiBoardIsShow = NO;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                         CGRect emojiViewFrame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, kEmojiBoardHeight);
                         container.frame = emojiViewFrame;
                     }completion:^(BOOL finished){
                         container.hidden = YES;
                     }];
}

#pragma mark - Notifications

- (void)emojiDidSelected:(NSNotification *)notification
{
    NSString *emoji = (NSString *)[notification object];
    
    UISearchBar *searchBar = (UISearchBar *)[self.view viewWithTag:kSearchBarTag];
    if (searchBar) {
        NSString *text = searchBar.text;
        if (text == nil) {
            text = @"";
        }
        text = [text stringByAppendingFormat:@"%@", emoji];
        searchBar.text = text;
        NSLog(@"text:%@", text);
    }
    [[EmojiRecentManager shareInstance] saveRecentEmoji:emoji];
}

- (void)emojiDidDelete:(NSNotification *)notification
{
    UISearchBar *searchBar = (UISearchBar *)[self.view viewWithTag:kSearchBarTag];
    if (searchBar) {
        NSString *text = searchBar.text;
        if ([text isEqualToString:@""]) {
            return;
        }
        
        if (text.length == 1) {
            searchBar.text = [text substringToIndex:text.length-1];
            return;
        }
        
        if (text.length - 1 > 0) {
            NSString *textToDelete = [text substringFromIndex:text.length-2];
            NSArray *emojiAll = [EmojiCoding emojiAll];
            for (NSArray *array in emojiAll) {
                if ([array containsObject:textToDelete]) {
                    searchBar.text = [text substringToIndex:text.length-2];
                    break;
                } else {
                    searchBar.text = [text substringToIndex:text.length-1];
                }
            }
        }
        NSLog(@"text:%@", text);
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self showKeyboard];
}

#pragma mark - dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [EmojiRecentManager exitInstance];
//    [_tapRecognizer release];
    
    [super dealloc];
}

@end
