//
//  Wordlabel.h
//  BabyBooks
//
//  Created by nd on 11-4-25.
//  Copyright 2011 ND. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    VerticalAlignmentTop = 0,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,                   // could add justified in future
} VerticalAlignment;

@interface WordLabel : UILabel {
	UIColor *m_strokeColor;
	UIColor *m_renderingColor;
@private
    VerticalAlignment m_verticalAlignment;
}
-(CGFloat)adjustsWordsHeight;

@property (nonatomic,retain)UIColor * strokeColor; //字体描边 颜色
@property (nonatomic,retain)UIColor * renderingColor;//字体渲染 颜色
@property (nonatomic, assign) VerticalAlignment verticalAlignment;//字体显示位置（置顶显示 居中显示 靠底 ）


@end
