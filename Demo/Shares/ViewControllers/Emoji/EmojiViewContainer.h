//
//  EmojiViewContainer.h
//  Demo
//
//  Created by leihui on 13-3-22.
//
//

#import <UIKit/UIKit.h>

#define kEmojiBoardHeight           300
#define kNumberOfEmojiPerPage       21
#define kNumberOfEmojiSort           2

@interface EmojiViewContainer : UIView <UIScrollViewDelegate>
{
    UIScrollView        *_scrollView[kNumberOfEmojiSort];
    UIPageControl       *_pageControl[kNumberOfEmojiSort];
    int                 _currentPage;
    int                 _currentSort;
}

@end
