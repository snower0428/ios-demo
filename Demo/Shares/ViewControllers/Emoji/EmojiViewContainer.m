//
//  EmojiViewContainer.m
//  Demo
//
//  Created by leihui on 13-3-22.
//
//

#import "EmojiViewContainer.h"
#import "EmojiView.h"
#import "EmojiCoding.h"

@implementation EmojiViewContainer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
        
        CGRect scrollFrame = CGRectMake(0, 20, self.frame.size.width, kEmojiBoardHeight-20);
        for (int i = 0; i < kNumberOfEmojiSort; i++) {
            _scrollView[i] = [[UIScrollView alloc] initWithFrame:scrollFrame];
            _scrollView[i].backgroundColor = [UIColor lightGrayColor];
            _scrollView[i].delegate = self;
            _scrollView[i].pagingEnabled = YES;
            _scrollView[i].showsHorizontalScrollIndicator = NO;
            _scrollView[i].showsVerticalScrollIndicator = NO;
            
            NSArray *allEmoji = [EmojiCoding emojiAll];
            NSArray *arrayEmoji = nil;
            if (i < [allEmoji count]) {
                arrayEmoji = [allEmoji objectAtIndex:i];
            }
            
            int count = 0;
            if ([arrayEmoji count]%kNumberOfEmojiPerPage == 0) {
                count = [arrayEmoji count]/kNumberOfEmojiPerPage;
            } else {
                count = [arrayEmoji count]/kNumberOfEmojiPerPage + 1;
            }
            
            for (int j = 0; j < count; j++) {
                NSRange range = NSMakeRange(0, 0);
                if (j*kNumberOfEmojiPerPage + kNumberOfEmojiPerPage < [arrayEmoji count]) {
                    range = NSMakeRange(j*kNumberOfEmojiPerPage, kNumberOfEmojiPerPage);
                } else {
                    range = NSMakeRange(j*kNumberOfEmojiPerPage, [arrayEmoji count] - j*kNumberOfEmojiPerPage);
                }
                NSArray *subArray = [arrayEmoji subarrayWithRange:range];
                CGRect emojiFrame = CGRectMake(j*scrollFrame.size.width, 0, scrollFrame.size.width, scrollFrame.size.height);
                EmojiView *emojiView = [[EmojiView alloc] initWithFrame:emojiFrame array:subArray];
                [_scrollView[i] addSubview:emojiView];
                [emojiView release];
            }
            _scrollView[i].contentSize = CGSizeMake(count*scrollFrame.size.width, scrollFrame.size.height);
            [self addSubview:_scrollView[i]];
            
            CGRect pageControlFrame = CGRectMake(0, 0, self.frame.size.width, 20);
            _pageControl[i] = [[UIPageControl alloc] initWithFrame:pageControlFrame];
            _pageControl[i].backgroundColor = [UIColor lightGrayColor];
            _pageControl[i].numberOfPages = count;
            _pageControl[i].currentPage = 0;
            _pageControl[i].hidesForSinglePage = YES;
            [self addSubview:_pageControl[i]];
        }
        
        UIButton *btnSmiley = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnSmiley.frame = CGRectMake(0, self.frame.size.height - 30, 100, 30);
        [btnSmiley setTitle:@"Smiley" forState:UIControlStateNormal];
        [self addSubview:btnSmiley];
        [btnSmiley addTarget:self action:@selector(showSmiley:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btnFlower = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnFlower.frame = CGRectMake(110, self.frame.size.height - 30, 100, 30);
        [btnFlower setTitle:@"Flower" forState:UIControlStateNormal];
        [self addSubview:btnFlower];
        [btnFlower addTarget:self action:@selector(showFlower:) forControlEvents:UIControlEventTouchUpInside];
        
        [self bringSubviewToFront:_scrollView[0]];
        [self bringSubviewToFront:_pageControl[0]];
    }
    return self;
}

#pragma mark - Buttons Action

- (void)showSmiley:(id)sender
{
    _currentSort = 0;
    [self bringSubviewToFront:_scrollView[0]];
    [self bringSubviewToFront:_pageControl[0]];
}

- (void)showFlower:(id)sender
{
    _currentSort = 1;
    [self bringSubviewToFront:_scrollView[1]];
    [self bringSubviewToFront:_pageControl[1]];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int x = scrollView.contentOffset.x;
    int currentPage = x/scrollView.frame.size.width;
    
    _currentPage = currentPage;
    _pageControl[_currentSort].currentPage = currentPage;
}

#pragma mark - dealloc

- (void)dealloc
{
    for (int i = 0; i < kNumberOfEmojiSort; i++) {
        [_scrollView[i] release];
        [_pageControl[i] release];
    }
    
    [super dealloc];
}

@end
