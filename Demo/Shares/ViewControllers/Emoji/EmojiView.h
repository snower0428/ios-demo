//
//  EmojiView.h
//  Demo
//
//  Created by leihui on 13-3-22.
//
//

#import <UIKit/UIKit.h>

@interface EmojiView : UIView
{
    NSArray         *_array;
}

@property (nonatomic, retain) NSArray *array;

- (id)initWithFrame:(CGRect)frame array:(NSArray *)array;

@end
