//
//  MaskView.h
//  BabyBooks
//
//  Created by 雷 晖 on 12-3-23.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaskView : UIView
{
    NSDictionary            *m_maskInfo;
    NSString                *m_resDirectory;
    id                      m_target;
    
    NSArray                 *m_layers;
    NSArray                 *m_languageLayers;
}

- (id)initWithFrame:(CGRect)frame maskInfo:(NSDictionary *)maskInfo resDirectory:(NSString *)resDirectory target:(id)target;

@end
