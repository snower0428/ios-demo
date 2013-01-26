//
//  UIImageView+Additions.m
//  Demo
//
//  Created by hui lei on 13-1-26.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import "UIImageView+Additions.h"

@implementation UIImageView(Additions)

+ (id)imageViewWithFile:(NSString *)file
{
    return [self imageViewWithFile:file atPostion:CGPointZero];
}

+ (id)imageViewWithFile:(NSString *)file atPostion:(CGPoint)position
{
    UIImageView *view = nil;
    if (file) {
        UIImage *image = [UIImage imageFile:file];
        if (image) {
            view = [[[UIImageView alloc] initWithImage:image] autorelease];
            [view setFrame:CGRectMake(position.x, position.y, image.size.width, image.size.height)];
        }
    }
    
    return view;
}

@end
