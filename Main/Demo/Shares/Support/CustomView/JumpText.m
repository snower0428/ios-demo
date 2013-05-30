//
//  JumpText.m
//  JumpWord
//
//  Created by zhangtianfu on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JumpText.h"

@interface JumpText(privateMethod)
- (void)loadJumpWords;
- (void)loadAudios;
- (float)getMaxWordWidth:(UIFont*)font pinyin:(BOOL)pinyin;
- (float)getLineHeight:(UIFont*)font pinyin:(BOOL)pinyin;
- (void)createScrollView;
- (UILabel*)createJumpLabel:(CGRect)frame text:(NSString*)text;
- (BOOL)playWithSection:(NSNumber*)sectionIndexValue;
- (void)stopTimer;
- (void)jumpUp:(UILabel*)label;
- (void)jumpDown:(UILabel*)label;
- (BOOL)shouldScrollNextScreen:(int)nextSectionIndex;
- (void)scrollNextScreen;
@end

@implementation JumpText

@synthesize delegate = m_delegate;
@synthesize isPlaying = m_isPlaying;

- (id)initWithDataSource:(NSDictionary*)dataSource resDirectory:(NSString*)resDirectory  languageType:(LanguageType)languageType{
    CGRect  frame = CGRectFromString([dataSource objectForKey:@"frame"]);
    if (self = [super initWithFrame:frame]) {
        m_dataSource = [dataSource retain];
        m_resDirectory = [resDirectory retain];
        self.backgroundColor = [UIColor clearColor];
        
        if (languageType == LanguageTypeEnglish) {
            m_sectionTexts = [[m_dataSource objectForKey:@"texts_EN"] retain];
        }else if (languageType == LanguageTypezh_CN){
            m_sectionTexts = [[m_dataSource objectForKey:@"texts_CN"] retain];
        }else if (languageType == LanguageTypezh_FT){
            m_sectionTexts = [[m_dataSource objectForKey:@"texts_FT"] retain];
        }
        
        if (nil == m_sectionTexts) {
            m_sectionTexts = [[m_dataSource objectForKey:@"texts"] retain];
        }
        
        if (frame.size.width == -1 || frame.size.height == -1) {
            m_autoAjustFrame = YES;
        }
    }
    
    return  self;
}


- (void)parse:(NSDictionary*)defaultConfig{
    //fontSize
    NSNumber *fontSizeValue = [m_dataSource objectForKey:@"fontSize"];
    if (!fontSizeValue) {
        fontSizeValue = [defaultConfig objectForKey:@"fontSize"];
    }
    //fontName
    NSString *fontName = [m_dataSource objectForKey:@"fontName"];
    if (!fontName) {
        fontName = [defaultConfig objectForKey:@"fontName"];
    }
    int fontSize = [fontSizeValue intValue];
    if (fontSize == 0) {
        fontSize = 20;
    }
    //font
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    if (!font) {
        font = [UIFont systemFontOfSize:fontSize];
    }
    m_font = [font retain];
    
    //textColor
    NSString *textColorValue = [m_dataSource objectForKey:@"textColor"];
    if (!textColorValue) {
        textColorValue = [defaultConfig objectForKey:@"textColor"];
    }
    m_textColor = [[textColorValue getColor] retain];
    
    //pinyin
    NSNumber *pinyinValue = [m_dataSource objectForKey:@"pinyin"];
    if (!pinyinValue) {
        pinyinValue = [defaultConfig objectForKey:@"pinyin"];
    }
    m_pinyin = [pinyinValue boolValue];
    
    //wordSpace
    NSNumber *wordSpaceValue = [m_dataSource objectForKey:@"wordSpace"];
    if (!wordSpaceValue) {
        wordSpaceValue = [defaultConfig objectForKey:@"wordSpace"];
    }
    m_wordSpace = [wordSpaceValue floatValue];
    
    //wordWidth
    NSNumber *wordWidthValue = [m_dataSource objectForKey:@"wordWidth"];
    if (!wordWidthValue) {
        wordWidthValue = [defaultConfig objectForKey:@"wordWidth"];
    }
    m_wordWidth = [wordWidthValue floatValue];
    if (m_wordWidth == 0) {
        m_wordWidth = [self getMaxWordWidth:m_font pinyin:m_pinyin];
    }
    
    //lineSpace
    NSNumber *lineSpaceValue = [m_dataSource objectForKey:@"lineSpace"];
    if (!lineSpaceValue) {
        lineSpaceValue = [defaultConfig objectForKey:@"lineSpace"];
    }
    m_lineSpace = [lineSpaceValue floatValue];
    
    
    //topSpace
    NSNumber *topSpaceValue = [m_dataSource objectForKey:@"topSpace"];
    if (!topSpaceValue) {
        topSpaceValue = [defaultConfig objectForKey:@"topSpace"];
    }
    m_topSpace = [topSpaceValue floatValue];
    
    //bottomSpace
    NSNumber *bottomSpaceValue = [m_dataSource objectForKey:@"bottomSpace"];
    if (!bottomSpaceValue) {
        bottomSpaceValue = [defaultConfig objectForKey:@"bottomSpace"];
    }
    m_bottomSpace = [bottomSpaceValue floatValue];
    
    //leftSpace
    NSNumber *leftSpaceValue = [m_dataSource objectForKey:@"leftSpace"];
    if (!leftSpaceValue) {
        leftSpaceValue = [defaultConfig objectForKey:@"leftSpace"];
    }
    m_leftSpace = [leftSpaceValue floatValue];
    
    //rightSpace
    NSNumber *rightSpaceValue = [m_dataSource objectForKey:@"rightSpace"];
    if (!rightSpaceValue) {
        rightSpaceValue = [defaultConfig objectForKey:@"rightSpace"];
    }
    m_rightSpace = [rightSpaceValue floatValue];
    
    //scrollLineNumber
    NSNumber *scrollLineNumberValue = [m_dataSource objectForKey:@"scrollLineNumber"];
    if (!scrollLineNumberValue) {
        scrollLineNumberValue = [defaultConfig objectForKey:@"scrollLineNumber"];
    }
    m_scrollLineNumber = [scrollLineNumberValue intValue];
    
    //loadJumpWords
    [self loadJumpWords];
    
    //loadAudios
    [self loadAudios];
}


- (void)loadJumpWords{
    int lineCount = 1;
    int scrollIndex = 0;
    float lineHeight = [self getLineHeight:m_font pinyin:m_pinyin];
    float maxLineWidth = 0;
    float x = m_leftSpace;
    float y = m_topSpace;
    
    NSMutableArray *jumpSections = [NSMutableArray array];//保存所有section的数据
    
    //逐个音频文字段解析
    for (NSString *sectionText in m_sectionTexts) {
        NSMutableArray *jumpSection = [NSMutableArray array];//保存一个section的数据
        NSString *text = [sectionText restoreEnterSymbol];
        if (m_pinyin) {//有拼音解析 
            NSArray *array = [text componentsSeparatedByString:@")"];
            
            for (NSString *item in array) {
                if ([item length] == 0) {
                    continue;//过滤由于在最末位的")"产生的空数据
                }
                
                NSString *topText = nil;    //拼音
                NSString *bottomText = nil; //汉字
                
                NSRange range = [item rangeOfString:@"("];
                if (range.location != NSNotFound) {//----------含拼音部分
                    bottomText = [item substringToIndex:range.location];
                    if (bottomText == nil) {
                        bottomText = @"";
                    }
                    bottomText = [bottomText removeEnterSymbol];
                    
                    topText = [item substringFromIndex:range.location+1];
                    if (topText == nil) {
                        topText = @"";
                    }
                    topText = [topText removeEnterSymbol];
                    
                    BOOL jump = NO;
                    if ([topText length] > 0) {
                        jump = YES;
                    }
                    
                    //jumpWord
                    NSString *jumpWord = [NSString stringWithFormat:@"%@\n%@", topText, bottomText];
                    
                    //createLabel
                    CGSize size = [jumpWord sizeWithFont:m_font constrainedToSize:CGSizeMake(10000, 10000)];
                    float width = jump ? m_wordWidth : size.width;
                    UILabel *label = [self createJumpLabel:CGRectMake(x, y, width, size.height) text:jumpWord];
                    label.tag = scrollIndex+1;
                    [self addSubview:label];
                    
                    //记录一个jumpword
                    if (jump) {
                        [jumpSection addObject:label];
                    }
                    
                    x += width + m_wordSpace;
                }else{//------------不含拼音部分
                    int itemCount = [item length];
                    for (int i=0; i<itemCount; i++) {
                        unichar ch = [item characterAtIndex:i];
                        if (!isblank(ch)&&isspace(ch)) {//换行
                            lineCount++;
                            
                            if ((x - m_wordSpace + m_rightSpace) > maxLineWidth) {
                                maxLineWidth = (x - m_wordSpace + m_rightSpace);//扣掉多算的wordSpace
                            }
                            
                            //一个scroll屏幕的初始行
                            if (m_scrollLineNumber > 0 && (lineCount%m_scrollLineNumber == 1)) {
                                x = m_leftSpace;
                                y += lineHeight + m_bottomSpace + m_topSpace;
                                
                                scrollIndex++;
                            }else{
                                x = m_leftSpace;
                                y += lineHeight + m_lineSpace;
                            }
                        }else{
                            BOOL jump = NO;
                            //jumpWord
                            topText = @"";
                            bottomText = [NSString  stringWithCharacters:&ch length:1];
                            
                            NSString *jumpWord = [NSString stringWithFormat:@"%@\n%@", topText, bottomText];
                            //createLabel
                            CGSize size = [jumpWord sizeWithFont:m_font constrainedToSize:CGSizeMake(10000, 10000)];
                            float width = jump ? m_wordWidth : size.width;
                            UILabel *label = [self createJumpLabel:CGRectMake(x, y, width, size.height) text:jumpWord];
                            label.tag = scrollIndex+1;
                            [self addSubview:label];
                            
                            //记录一个jumpword
                            if (jump) {
                                [jumpSection addObject:label];
                            }
                            
                            x += width + m_wordSpace;
                        }
                    }
                }
            }
        }else{//无拼音解析
            int sectionTextCount = [text length];
            for (int i=0; i<sectionTextCount; i++) {
                unichar ch = [text characterAtIndex:i];
                if (!isblank(ch)&&isspace(ch)) {//换行
                    lineCount++;
                    
                    if ((x - m_wordSpace + m_rightSpace) > maxLineWidth) {
                        maxLineWidth = (x - m_wordSpace + m_rightSpace);//扣掉多算的wordSpace
                    }
                    
                    //一个scroll屏幕的初始行
                    if (m_scrollLineNumber > 0 && (lineCount%m_scrollLineNumber == 1)) {
                        x = m_leftSpace;
                        y += lineHeight + m_bottomSpace + m_topSpace;
                        
                        scrollIndex++;
                    }else{
                        x = m_leftSpace;
                        y += lineHeight + m_lineSpace;
                    }
                    
                    continue;
                }
                
                //word
                NSString *word =  [NSString stringWithCharacters:&ch length:1];
                
                //判断是否是汉字
                BOOL jump = NO;
                if (strlen([word UTF8String]) == 3 && ![word isChineseSymbol]) {
                    jump = YES;
                }
                
                //createLabel
                CGSize size = [word sizeWithFont:m_font constrainedToSize:CGSizeMake(10000, 10000)];
                float width = jump ? m_wordWidth : size.width;
                UILabel *label = [self createJumpLabel:CGRectMake(x, y, width, size.height) text:word];
                label.tag = scrollIndex+1;
                [self addSubview:label];
                
                //判断是否是汉字
                if (jump) {
                    [jumpSection addObject:label]; //记录一个jumpword
                }
                
                x += width + m_wordSpace;
            }
        }
        
        //记录一个section
        [jumpSections addObject:jumpSection];
    }
    
    m_jumpSections = [jumpSections retain];
    
    
    if (m_scrollLineNumber > 0 && lineCount>m_scrollLineNumber) {
        m_scrollEnable = YES;//表示需要添加scrollView
        m_scrollCount = lineCount/m_scrollLineNumber + (lineCount%m_scrollLineNumber >0);
    }
    
    //autoAjustFrame
    if (m_autoAjustFrame) {
        if ((x - m_wordSpace + m_rightSpace) > maxLineWidth) {
            maxLineWidth = (x - m_wordSpace + m_rightSpace);//扣掉多算的wordSpace
        }
        
        CGRect frame = self.frame;
        //width
        frame.size.width = maxLineWidth;
        //height
        if (m_scrollEnable) {
            frame.size.height = m_topSpace + m_scrollLineNumber*lineHeight + (m_scrollLineNumber-1)*m_lineSpace + m_bottomSpace;
        }else{
            frame.size.height = y + lineHeight + m_bottomSpace;
        }
        
        self.frame = frame;
    }
    
    //scroll
    if (m_scrollEnable) {
        [self createScrollView];
    }
}


- (void)loadAudios{
    //audios
    NSArray *audios = [m_dataSource objectForKey:@"audios"];
    NSMutableArray  *audioSections = [NSMutableArray array];
    for (NSString    *name in audios) {
        NSString    *path = [m_resDirectory stringByAppendingPathComponent:name];
        BOOL isDirectory = YES;
        if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory) {
            AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL  fileURLWithPath:path] error:nil];
            if (player) {
                player.delegate = self;
                [player prepareToPlay];
                [audioSections addObject:player];
                [player release];
            }else{
                [audioSections addObject:[NSNull null]];
            }
        }else{
            [audioSections addObject:[NSNull null]];
        }
    }
    
    if (m_audioSections) {
        [m_audioSections removeAllObjects];
        [m_audioSections release];
    }
    m_audioSections = [audioSections retain];
}

- (float)getMaxWordWidth:(UIFont*)font pinyin:(BOOL)pinyin{
    NSString    *testText = nil;
    if (pinyin) {
        testText = @"zhuang";   // zhuang > shuang
    }else{
        testText = @"啊";
    }
    
    CGSize size = [testText sizeWithFont:font constrainedToSize:CGSizeMake(10000, 10000)];
    return  size.width;
}

- (float)getLineHeight:(UIFont*)font pinyin:(BOOL)pinyin{
    NSString    *testText = nil;
    if (pinyin) {
        testText = @"shuang\n啊";
    }else{
        testText = @"啊";
    }
    
    CGSize size = [testText sizeWithFont:font constrainedToSize:CGSizeMake(10000, 10000)];
    return  size.height;
}

- (void)createScrollView{
    m_scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    m_scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)*m_scrollCount);
    m_scrollView.pagingEnabled = YES;
    m_scrollView.scrollEnabled = YES;
    [self addSubview:m_scrollView];
    [m_scrollView release];
    
    for (UILabel *label in self.subviews) {
        if (![label isKindOfClass:[UIScrollView class]]) {
            [m_scrollView insertSubview:label aboveSubview:self];
        }
    }
}

- (UILabel*)createJumpLabel:(CGRect)frame text:(NSString*)text{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = m_font;
    label.numberOfLines = 2;
    label.textColor = m_textColor;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    return [label autorelease];
}

- (BOOL)shouldScrollToScreen:(int)nextSectionIndex{
    BOOL shouldScroll = NO;
    
    int count = [m_jumpSections count];
    if (nextSectionIndex >=0 && nextSectionIndex<count) {
        NSArray *jumpSection = [m_jumpSections objectAtIndex:nextSectionIndex];
        UILabel *label = [jumpSection lastObject];
        if (label.tag-1 != m_scrollIndex) {
            return  YES;
        }
    }
    
    return  shouldScroll;
}

- (void)scrollToScreen:(int)scrollIndex{
    CGPoint contentOffset = m_scrollView.contentOffset;
    float yOffset = CGRectGetHeight(self.bounds)*m_scrollIndex;
    if (yOffset != contentOffset.y) {
        contentOffset.y = yOffset;
        [m_scrollView setContentOffset:contentOffset animated:YES];
    }
}

- (void)play{
    //m_sectionIndex = 0;
    //m_scrollIndex = 0;
    // Add by lh 2012/03/10
    // 在4.2.1版本下，没播放完，先stop再play的情况下，play会失败，所以重新load一次(只否是固件的问题？)
    [self loadAudios];
    [self scrollToScreen:m_scrollIndex];
    [self playWithSection:[NSNumber numberWithInt:m_sectionIndex]];
}

- (void)pause{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self stopTimer];
    
    for (AVAudioPlayer *player in m_audioSections) {
        if (player != (id)[NSNull null]) {
            [player stop];
        }
    }
}

- (void)stop{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self stopTimer];
    
    for (AVAudioPlayer *player in m_audioSections) {
        if (player != (id)[NSNull null]) {
            [player stop];
            player.currentTime = 0;
        }
    }
    
    m_sectionIndex = 0;
    m_jumpWordIndex = 0;
    m_scrollIndex = 0;
}

- (BOOL)playWithSection:(NSNumber*)sectionIndexValue{
    int sectionIndex = [sectionIndexValue intValue];
    
    [self stopTimer];
    
    int count = [m_audioSections count];
    
    if (sectionIndex >=0 && sectionIndex <count) {
        m_sectionIndex = sectionIndex;
        
        AVAudioPlayer *player = [m_audioSections objectAtIndex:sectionIndex];
        if (player != (id)[NSNull null]) {
            if (![player play])
            {
                NSLog(@"play failed...");
            }
            
            if (m_sectionIndex >=0 && m_sectionIndex < [m_jumpSections count]) {
                NSArray *jumpSection = [m_jumpSections objectAtIndex:m_sectionIndex];
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:player, @"audio", jumpSection, @"jumpSection", nil];
                m_timer = [[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(update:) userInfo:userInfo repeats:YES] retain];
            }
            
            m_isPlaying = YES;
            m_scrollView.scrollEnabled = NO;//禁止滑动
            return YES;
        }
    }
    
    m_isPlaying = NO;
    return NO;
}

- (void)stopTimer{
    if (m_timer) {
        [m_timer invalidate];
        [m_timer release];
        m_timer = nil;
    }
}

- (void)update:(NSTimer*)timer{
//    NSLog(@"update...");
    NSDictionary *userInfo = [timer userInfo];
    AVAudioPlayer *player = [userInfo objectForKey:@"audio"];
    NSArray *jumpSection = [userInfo objectForKey:@"jumpSection"];
    
    int count = [jumpSection count];
    float wordDuration = player.duration / count;
    float startOffset = m_jumpWordIndex *wordDuration;
    
    float currentTime = player.currentTime;
    if (currentTime >= startOffset) {
        if (m_jumpWordIndex>=0 && m_jumpWordIndex<count) {
            //NSLog(@"jumpWord:%@  Index:%d  startOffset:%f   currentTime:%f", label.text, m_jumpWordIndex, startOffset, currentTime);
            
            UILabel *label = [jumpSection objectAtIndex:m_jumpWordIndex];
            [self jumpUp:label];
            m_jumpWordIndex++;
        }
    }
}

- (void)jumpUp:(UILabel*)label{
    [UIView beginAnimations:@"jumpUp" context:label];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    CGRect frame = [label frame];
    frame.origin.y -= 10;
    label.frame = frame;
#ifdef TARGET_IPAD
    label.transform = CGAffineTransformMakeScale(2,2);
#else
    label.transform = CGAffineTransformMakeScale(1.2,1.2);
#endif
    [UIView commitAnimations];
}

- (void)jumpDown:(UILabel*)label{
    [UIView beginAnimations:@"jumpDown" context:label];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    CGRect frame = [label frame];
    frame.origin.y += 10;
    label.frame = frame;
    label.transform = CGAffineTransformMakeScale(1,1);
    //label.textColor = [UIColor blueColor];
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    if ([animationID isEqualToString:@"jumpUp"]) {
        UILabel *label = (UILabel*)context;
        
        [self jumpDown:label];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self stopTimer];
    
    if (flag) {
        m_jumpWordIndex = 0;
        
        if (m_scrollEnable && [self shouldScrollToScreen:m_sectionIndex+1]) {
            m_scrollIndex++;
            [self scrollToScreen:m_scrollIndex];
            m_sectionIndex++;
            [self performSelector:@selector(playWithSection:) withObject:[NSNumber numberWithInt:m_sectionIndex] afterDelay:0.5];
        }else{
            [self playWithSection:[NSNumber numberWithInt:m_sectionIndex+1]];
            
            //全部播放完了
            if (!m_isPlaying) {
                m_scrollView.scrollEnabled = YES;//播放完允许滑动
                if (m_delegate && [m_delegate respondsToSelector:@selector(jumpTextDidFinishPlaying:)]) {
                    [m_delegate performSelector:@selector(jumpTextDidFinishPlaying:) withObject:self];
                }
            }
        }
    }
}

- (void)dealloc{
    [self stop];
    [m_sectionTexts release];
    [m_dataSource release];
    [m_resDirectory release];
    [m_font release];
    [m_textColor release];
    [m_jumpSections release];
    [m_audioSections release];
    
    
    [super dealloc];
}

@end
