//
//  JumpText.h
//  JumpWord
//
//  Created by zhangtianfu on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JumpTextDelegate;


@interface JumpText : UIView<AVAudioPlayerDelegate>{
    NSDictionary        *m_dataSource;
    NSString            *m_resDirectory;
    NSArray              *m_sectionTexts;
    id<JumpTextDelegate> m_delegate;
    
    //config
    UIFont          *m_font;
    UIColor         *m_textColor;
    BOOL            m_pinyin;
    float           m_wordSpace;
    float           m_wordWidth;
    float           m_lineSpace;
    float           m_topSpace;
    float           m_bottomSpace;
    float           m_leftSpace;
    float           m_rightSpace;
    
    //jump
    NSMutableArray      *m_jumpSections;
    NSMutableArray      *m_audioSections;
    int                 m_sectionIndex;
    int                 m_jumpWordIndex;
    NSTimer             *m_timer;

    //scroll
    int                 m_scrollLineNumber;
    int                 m_scrollCount;
    int                 m_scrollIndex;
    UIScrollView        *m_scrollView;
    BOOL                m_scrollEnable;
    
    BOOL                m_autoAjustFrame;
    BOOL                m_isPlaying;
}

@property(nonatomic, assign)    id<JumpTextDelegate>     delegate;
@property(nonatomic, assign)    BOOL isPlaying;

- (id)initWithDataSource:(NSDictionary*)dataSource resDirectory:(NSString*)resDirectory  languageType:(LanguageType)languageType;
- (void)parse:(NSDictionary*)defaultConfig;
- (void)play;
- (void)pause;
- (void)stop;


@end

@protocol JumpTextDelegate<NSObject>
- (void)jumpTextDidFinishPlaying:(JumpText*)jumpText;
@end
