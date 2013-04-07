//
//  EmojiView.h
//  Demo
//
//  Created by leihui on 13-3-22.
//
//

#import <UIKit/UIKit.h>

#define kEmojiSelectedNotification      @"kEmojiSelectedNotification"
#define kEmojiDeleteNotification        @"kEmojiDeleteNotification"

#define kOpenKeytop     0

@protocol EmojiViewDelegate;

#if kOpenKeytop
@interface EmojiViewLayer : CALayer
{
@private
    CGImageRef _keytopImage;;
}

@property (nonatomic, retain) UIImage *emoji;

@end
#endif

@interface EmojiView : UIView
{
    NSArray         *_array;
    
#if kOpenKeytop
    EmojiViewLayer  *_emojiLayer;
#endif
    
    id<EmojiViewDelegate>   _delegate;
}

@property (nonatomic, retain) NSArray *array;
@property (nonatomic, assign) id<EmojiViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame array:(NSArray *)array;
- (void)updateEmoji;

@end

//
//EmojiViewDelegate
//
@protocol EmojiViewDelegate <NSObject>

@optional

- (void)emojiDidSelected:(id)sender;


@end
