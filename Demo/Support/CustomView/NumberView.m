//
//  NumberView.m
//  FindDifferent
//
//  Created by zhangtianfu on 12-1-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NumberView.h"


#define NUMBER_COLON_KEY        @"colon"
#define NUMBER_SEPARATE_KEY     @"separate"

@interface NumberView(privateMethod)
- (void)loadSource;
@end

@implementation NumberView

- (id)initWithFrame:(CGRect)frame dataSource:(NSDictionary*)numbersSource resDirectory:(NSString*)resDirectory{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        
        m_numbersSource = [numbersSource retain];
        m_resDirectory = [resDirectory retain];
        m_numberImages = [[NSMutableDictionary alloc] init];
        m_maxNumberHeight = 0;
        
        [self loadSource];
    }
    
    return self;
}

- (void)loadSource{
    //load images
    NSArray *allKeys = [m_numbersSource allKeys];
    for (NSString *key in allKeys) {
        NSString *value = [m_numbersSource objectForKey:key];
        NSString *path = [m_resDirectory stringByAppendingPathComponent:value];
        UIImage *image = [UIImage imageWithContentsOfFileEx:path];
        if (image) {
            [m_numberImages setValue:image forKey:key];
            
            if (image.size.height >  m_maxNumberHeight) {
                m_maxNumberHeight = image.size.height;
            }
        }else{
            NSLog(@"numbers====%@",path);
        }
    }
}


- (void)updateNumber:(NSString*)numberString{
    if ([m_currentNumberString isEqualToString:numberString]){
        return;
    }
    
    [m_currentNumberString release];
    m_currentNumberString = [numberString retain];

    if ([[self subviews] count]) {
        [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
 
    if (nil == numberString) {
        return;
    }
    
    float x = 0;
    float y = 0;

    int count = [numberString length];
    for (int i=0; i<count; i++) {
        unichar ch = [numberString characterAtIndex:i];
        NSString *number = [NSString stringWithCharacters:&ch length:1];
        
        if ([@":" isEqualToString:number]){
            number = NUMBER_COLON_KEY;
        }else if ([@"/" isEqualToString:number]){
            number = NUMBER_SEPARATE_KEY;
        }else if (!isnumber(ch)){
            continue;//非数字非冒号
        }
        
        UIImage *image = [m_numberImages objectForKey:number];
        if (image) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = CGRectMake(x, y, image.size.width, image.size.height);
            [self addSubview:imageView];
            [imageView release];
            
            x+= image.size.width;
        }
    }
    
    //调整区域
    if ([self.subviews count] > 0) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, x, m_maxNumberHeight);
        
        for (UIView *view in self.subviews) {
            if (CGRectGetHeight(view.frame) < m_maxNumberHeight) {
                view.center = CGPointMake(view.center.x, m_maxNumberHeight/2);//垂直居中
            }
        }
    }
}

- (void)dealloc{
    [m_resDirectory release];
    [m_numbersSource release];
    [m_numberImages release];
    [m_currentNumberString release];
    [super dealloc];
}

@end
