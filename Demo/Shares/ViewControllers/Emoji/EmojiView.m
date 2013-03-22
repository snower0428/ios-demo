//
//  EmojiView.m
//  Demo
//
//  Created by leihui on 13-3-22.
//
//

#import "EmojiView.h"
#import "JSON.h"

#define kEmojiWidth         45
#define kEmojiHeight        45

#define kNumberOfRow        3
#define kNumberOfColumn     7

@interface EmojiView ()
- (void)loadEmoji;
@end

@implementation EmojiView

@synthesize array = _array;

- (id)initWithFrame:(CGRect)frame array:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        self.array = array;
        
        [self loadEmoji];
    }
    
    return self;
}

- (void)loadEmoji
{
    for (int i = 0; i < kNumberOfRow; i++) {
        for (int j = 0; j < kNumberOfColumn; j++) {
            NSString *title = nil;
            int index = i*kNumberOfColumn + j;
            if (index < [self.array count]) {
                title = [self.array objectAtIndex:index];
                
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                button.backgroundColor = [UIColor clearColor];
                button.frame = CGRectMake(j*kEmojiWidth, i*kEmojiHeight, kEmojiWidth, kEmojiHeight);
                button.titleLabel.font = [UIFont fontWithName:@"AppleColorEmoji" size:29.0];
                [self addSubview:button];
                [button addTarget:self action:@selector(emojiSelected:) forControlEvents:UIControlEventTouchUpInside];
                
                [button setTitle:title forState:UIControlStateNormal];
                button.tag = index;
            }
        }
    }
}

- (void)emojiSelected:(id)sender
{
    
}

#pragma mark - dealloc

- (void)dealloc
{
//    self.array = nil;
    
    [super dealloc];
}

@end
