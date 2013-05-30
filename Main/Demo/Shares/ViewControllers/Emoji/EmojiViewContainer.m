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
#import "EmojiRecentManager.h"

@interface EmojiViewContainer ()
- (void)showViewAtIndex:(int)index;
@end

@implementation EmojiViewContainer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
        self.clipsToBounds = YES;
        
        UIImageView *topSeparator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        topSeparator.backgroundColor = [UIColor blackColor];
        [self addSubview:topSeparator];
        [topSeparator release];
        
        CGRect scrollFrame = CGRectMake(0, kEmojiPageControlHeight, self.frame.size.width, kEmojiBoardHeight-kEmojiPageControlHeight-kEmojiBottomHeight);
        for (int i = 0; i < kNumberOfEmojiSort; i++) {
            _scrollView[i] = [[UIScrollView alloc] initWithFrame:scrollFrame];
            _scrollView[i].backgroundColor = [UIColor clearColor];
            _scrollView[i].delegate = self;
            _scrollView[i].pagingEnabled = YES;
            _scrollView[i].showsHorizontalScrollIndicator = NO;
            _scrollView[i].showsVerticalScrollIndicator = NO;
            
            if (i == 0) {
                //最近记录
                NSArray *recentEmoji = [[EmojiRecentManager shareInstance] getRecentEmoji];
                CGRect emojiFrame = CGRectMake(0, 0, scrollFrame.size.width, scrollFrame.size.height);
                EmojiView *emojiView = [[EmojiView alloc] initWithFrame:emojiFrame array:recentEmoji];
                [_scrollView[i] addSubview:emojiView];
                [emojiView release];
                _scrollView[i].contentSize = CGSizeMake(scrollFrame.size.width, scrollFrame.size.height);
                [self addSubview:_scrollView[i]];
                
                _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
                _label.backgroundColor = [UIColor clearColor];
                _label.text = _(@"Recents");
                _label.font = [UIFont systemFontOfSize:12];
                _label.textColor = [UIColor blackColor];
                _label.textAlignment = UITextAlignmentCenter;
                [self addSubview:_label];
            } else {
                NSArray *allEmoji = [EmojiCoding emojiAll];
                NSArray *arrayEmoji = nil;
                int index = i-1;
                if (index >= 0 && index < [allEmoji count]) {
                    arrayEmoji = [allEmoji objectAtIndex:index];
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
                
                CGRect pageControlFrame = CGRectMake(0, 1, self.frame.size.width, 20);
                _pageControl[i] = [[UIPageControl alloc] initWithFrame:pageControlFrame];
                _pageControl[i].backgroundColor = [UIColor clearColor];
                _pageControl[i].numberOfPages = count;
                _pageControl[i].currentPage = 0;
                _pageControl[i].hidesForSinglePage = YES;
                [_pageControl[i] addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
                [self addSubview:_pageControl[i]];
            }
        }
        
        //底部按钮
        CGRect bottomFrame = CGRectMake(0, self.frame.size.height - kEmojiBottomHeight, self.frame.size.width, kEmojiBottomHeight);
        UIView *bottom = [[UIView alloc] initWithFrame:bottomFrame];
        
        for (int i = 0; i < kBottomCount; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*(kEmojiButtonWidth+1), 0, kEmojiButtonWidth, kEmojiBottomHeight);
            button.tag = kButtonBaseTag + i;
            
            UIImage *bgImageNormal = [UIImage imageNamed:@"Emoji.bundle/emoji_bg.png"];
            bgImageNormal = [bgImageNormal stretchableImageWithLeftCapWidth:1 topCapHeight:0];
            
            UIImage *bgImageHighlight = [UIImage imageNamed:@"Emoji.bundle/emoji_bg_d.png"];
            bgImageHighlight = [bgImageHighlight stretchableImageWithLeftCapWidth:1 topCapHeight:0];
            
            UIImage *imageNormal = [UIImage imageNamed:[NSString stringWithFormat:@"Emoji.bundle/emoji-0%d.png", i]];
            UIImage *imageHighlight = [UIImage imageNamed:[NSString stringWithFormat:@"Emoji.bundle/emoji-0%d_d.png", i]];
            
            [button setBackgroundImage:bgImageNormal forState:UIControlStateNormal];
            [button setBackgroundImage:bgImageHighlight forState:UIControlStateHighlighted];
            [button setImage:imageNormal forState:UIControlStateNormal];
            [button setImage:imageHighlight forState:UIControlStateHighlighted];
            
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [bottom addSubview:button];
            
            //分隔线
            UIImage *separatorImage = [UIImage imageNamed:@"Emoji.bundle/separator.png"];
            UIImageView *separator = [[UIImageView alloc] initWithImage:separatorImage];
            separator.frame = CGRectMake(button.frame.origin.x+button.frame.size.width, 0, 1, kEmojiBottomHeight);
            [bottom addSubview:separator];
            [separator release];
        }
        
        //删除按钮
        UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDelete.frame = CGRectMake(bottomFrame.size.width - 45, 0, 45, kEmojiBottomHeight);
        btnDelete.tag = kButtonDeleteTag;
        
        UIImage *bgImageNormal = [UIImage imageNamed:@"Emoji.bundle/emoji_del_bg.png"];
        UIImage *bgImageHighlight = [UIImage imageNamed:@"Emoji.bundle/emoji_del_bg_d.png"];
        UIImage *imageNormal = [UIImage imageNamed:@"Emoji.bundle/emoji-del.png"];
        UIImage *imageHighlight = [UIImage imageNamed:@"Emoji.bundle/emoji-del_d.png"];
        
        [btnDelete setBackgroundImage:bgImageNormal forState:UIControlStateNormal];
        [btnDelete setBackgroundImage:bgImageHighlight forState:UIControlStateHighlighted];
        [btnDelete setImage:imageNormal forState:UIControlStateNormal];
        [btnDelete setImage:imageHighlight forState:UIControlStateHighlighted];
        
        [btnDelete addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottom addSubview:btnDelete];
        
        [self addSubview:bottom];
        [bottom release];
        
        //默认显示Smiley
        [self performSelector:@selector(buttonClicked:) withObject:[bottom viewWithTag:kButtonBaseTag+1]];
    }
    return self;
}

- (void)showViewAtIndex:(int)index
{
    for (int i = 0; i < kNumberOfEmojiSort; i++) {
        if (i == index) {
            _pageControl[i].hidden = NO;
            _scrollView[i].hidden = NO;
        } else {
            _label.hidden = YES;
            _pageControl[i].hidden = YES;
            _scrollView[i].hidden = YES;
        }
    }
    
    if (index == 0) {
        NSArray *subviews = [_scrollView[index] subviews];
        for (UIView *view in subviews) {
            if (view && [view isKindOfClass:[EmojiView class]]) {
                EmojiView *emojiView = (EmojiView *)view;
                [emojiView updateEmoji];
            }
        }
        _label.hidden = NO;
        _pageControl[index].hidden = YES;
    }
}

- (void)frontViewWith:(int)index
{
    [self bringSubviewToFront:_scrollView[index]];
    [self bringSubviewToFront:_pageControl[index]];
}

- (void)focusSelectedButton:(UIButton *)button
{
    int index = button.tag - kButtonBaseTag;
    
    UIImage *bgImageNormal = [UIImage imageNamed:@"Emoji.bundle/emoji_bg.png"];
    bgImageNormal = [bgImageNormal stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    
    UIImage *bgImageHighlight = [UIImage imageNamed:@"Emoji.bundle/emoji_bg_d.png"];
    bgImageHighlight = [bgImageHighlight stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    
    UIImage *imageNormal = [UIImage imageNamed:[NSString stringWithFormat:@"Emoji.bundle/emoji-0%d.png", index]];
    UIImage *imageHighlight = [UIImage imageNamed:[NSString stringWithFormat:@"Emoji.bundle/emoji-0%d_d.png", index]];
    
    UIImage *tmpImage = [[_lastSelectedButton imageForState:UIControlStateNormal] copy];
    [_lastSelectedButton setBackgroundImage:bgImageNormal forState:UIControlStateNormal];
    [_lastSelectedButton setImage:[_lastSelectedButton imageForState:UIControlStateHighlighted] forState:UIControlStateNormal];
    [_lastSelectedButton setImage:tmpImage forState:UIControlStateHighlighted];
    [tmpImage release];
    
    [button setBackgroundImage:bgImageHighlight forState:UIControlStateNormal];
    [button setImage:imageNormal forState:UIControlStateHighlighted];
    [button setImage:imageHighlight forState:UIControlStateNormal];
}

- (void)pageChanged:(UIPageControl *)pageControl
{
    _currentPage = pageControl.currentPage;
    
    CGFloat scrollWidth = _scrollView[_emojiType].frame.size.width;
    CGFloat scrollHeight = _scrollView[_emojiType].frame.size.height;
    
    [_scrollView[_emojiType] scrollRectToVisible:CGRectMake(_currentPage*scrollWidth, 0, scrollWidth, scrollHeight) animated:YES];
}

#pragma mark - Buttons Action

- (void)buttonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (_lastSelectedButton == button) {
        return;
    }
    
    //设置选中
    [self focusSelectedButton:button];
    
    int index = button.tag - kButtonBaseTag;
    _emojiType = (EmojiType)index;
    [self showViewAtIndex:_emojiType];
    
    //保存上次选中的按钮
    _lastSelectedButton = button;
}

- (void)deleteAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kEmojiDeleteNotification object:nil];
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
    _pageControl[_emojiType].currentPage = currentPage;
}

#pragma mark - dealloc

- (void)dealloc
{
    for (int i = 0; i < kNumberOfEmojiSort; i++) {
        [_scrollView[i] release];
        [_pageControl[i] release];
    }
    [_label release];
    
    [super dealloc];
}

@end
