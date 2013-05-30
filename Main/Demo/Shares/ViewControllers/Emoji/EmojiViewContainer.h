//
//  EmojiViewContainer.h
//  Demo
//
//  Created by leihui on 13-3-22.
//
//

#import <UIKit/UIKit.h>

#define kEmojiBoardHeight           216
#define kEmojiPageControlHeight     20
#define kEmojiBottomHeight          54
#define kEmojiButtonWidth           45
#define kNumberOfEmojiPerPage       21
#define kNumberOfEmojiSort          6
#define kBottomCount                6

#define kButtonBaseTag              1000
#define kButtonDeleteTag            2000

typedef enum
{
    EmojiTypeRecent = 0,
    EmojiTypeSmiley,
    EmojiTypeFlower,
    EmojiTypeBell,
    EmojiTypeVehicle,
    EmojiTypeNumber,
}EmojiType;

@interface EmojiViewContainer : UIView <UIScrollViewDelegate>
{
    UIScrollView        *_scrollView[kNumberOfEmojiSort];
    UIPageControl       *_pageControl[kNumberOfEmojiSort];
    UILabel             *_label;
    int                 _currentPage;
    EmojiType           _emojiType;
    
    UIButton            *_lastSelectedButton;
}

@end
