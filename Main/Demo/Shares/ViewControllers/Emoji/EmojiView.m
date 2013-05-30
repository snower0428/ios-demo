//
//  EmojiView.m
//  Demo
//
//  Created by leihui on 13-3-22.
//
//

#import "EmojiView.h"
#import "EmojiRecentManager.h"

#define kEmojiWidth             45
#define kEmojiHeight            45

#define kNumberOfRow            3
#define kNumberOfColumn         7

#define kEmojiButtonBaseTag     1000

#define kEmojiViewKeytopWidth   82
#define kEmojiViewKeytopHeight  111
#define kEmojiKeyTopSize        35


#pragma mark - EmojiViewLayer

#if kOpenKeytop
@implementation EmojiViewLayer

@synthesize emoji = _emoji;

- (id)init
{
    self = [super init];
    if (self) {
        //Init
    }
    return self;
}

- (void)drawInContext:(CGContextRef)context
{
    //从后台返回需要重新获取图片,Fixes Bug
    _keytopImage = [[[ResourcesManager shareInstance] imageWithFileName:@"/Emoji/emoji_touch.png"] CGImage];
    
    UIGraphicsBeginImageContext(CGSizeMake(kEmojiViewKeytopWidth, kEmojiViewKeytopHeight));
    CGContextTranslateCTM(context, 0.0, kEmojiViewKeytopHeight);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0, 0, kEmojiViewKeytopWidth, kEmojiViewKeytopHeight), _keytopImage);
    UIGraphicsEndImageContext();
    
    //
    UIGraphicsBeginImageContext(CGSizeMake(kEmojiKeyTopSize, kEmojiKeyTopSize));
    CGContextDrawImage(context, CGRectMake((kEmojiViewKeytopWidth - kEmojiKeyTopSize) / 2 , 45, kEmojiKeyTopSize, kEmojiKeyTopSize), [_emoji CGImage]);
    UIGraphicsEndImageContext();
}

- (void)dealloc
{
    _keytopImage = nil;
    _emoji = nil;
    
    [super dealloc];
}

@end

#endif

#pragma mark - EmojiView

@interface EmojiView ()
- (void)loadEmoji;
@end

@implementation EmojiView

@synthesize array = _array;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame array:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        self.array = array;
        
        [self loadEmoji];
        
#if kOpenKeytop
        _emojiLayer = [EmojiViewLayer layer];
        [self.layer addSublayer:_emojiLayer];
#endif
        self.clipsToBounds = YES;
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
//                [button addTarget:self action:@selector(emojiDidBeginSelected:) forControlEvents:UIControlEventTouchDown];
                
                [button setTitle:title forState:UIControlStateNormal];
                button.tag = kEmojiButtonBaseTag + index;
            }
        }
    }
}

- (void)updateEmoji
{
    self.array = [[EmojiRecentManager shareInstance] getRecentEmoji];
    
    NSArray *subviews = [self subviews];
    for (UIView *view in subviews) {
        if (view && [view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    [self loadEmoji];
}

- (void)emojiSelected:(id)sender
{
    UIButton *button = (UIButton *)sender;
    int index = button.tag - kEmojiButtonBaseTag;
    if (index < [self.array count]) {
        NSString *emoji = [self.array objectAtIndex:index];
        if (_delegate && [_delegate respondsToSelector:@selector(emojiDidSelected:)]) {
            [_delegate emojiDidSelected:emoji];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kEmojiSelectedNotification object:emoji];
    }
}

#if kOpenKeytop
- (void)emojiDidBeginSelected:(id)sender
{
    UIButton *button = (UIButton *)sender;
    int index = button.tag - kEmojiButtonBaseTag;
    if (index < [self.array count]) {
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        [self updateWithIndex:index];
        [CATransaction commit];
    }
}

- (UIImage *)imageFromText:(NSString *)text
{
    UIFont *font = [UIFont systemFontOfSize:30.0];
    CGSize size  = CGSizeMake(40.0, 40.0);
    if (UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    [text drawAtPoint:CGPointMake(0.0, 0.0) withFont:font];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)updateWithIndex:(NSUInteger)index
{
    if(index < [self.array count]) {
        
        if (_emojiLayer.opacity != 1.0) {
            _emojiLayer.opacity = 1.0;
        }
        
        float originX = (self.bounds.size.width / kNumberOfColumn) * (index % kNumberOfColumn) + ((self.bounds.size.width / kNumberOfColumn) - kEmojiWidth ) / 2;
        float originY = (index / kNumberOfColumn) * (self.bounds.size.width / kNumberOfColumn) + ((self.bounds.size.width / kNumberOfColumn) - kEmojiWidth ) / 2;
        
        NSString *strEmoji = [self.array objectAtIndex:index];
        
        UIImage *image = [self imageFromText:strEmoji];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, 50, 50);
        [self addSubview:imageView];
        [imageView release];
        
        [_emojiLayer setEmoji:image];
        [_emojiLayer setFrame:CGRectMake(originX - (kEmojiViewKeytopWidth - kEmojiWidth) / 2, originY - (kEmojiViewKeytopHeight - kEmojiWidth), kEmojiViewKeytopWidth, kEmojiViewKeytopHeight)];
        [_emojiLayer setNeedsDisplay];
    }
}
#endif

#pragma mark - dealloc

- (void)dealloc
{
    self.array = nil;
    
    [super dealloc];
}

@end
