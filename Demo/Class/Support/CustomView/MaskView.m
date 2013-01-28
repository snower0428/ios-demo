//
//  MaskView.m
//  BabyBooks
//
//  Created by 雷 晖 on 12-3-23.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import "MaskView.h"

@interface MaskView(privateMehods)
- (void)initLayers;
- (void)addLayers:(NSArray *)layers;
@end

@implementation MaskView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame maskInfo:(NSDictionary *)maskInfo resDirectory:(NSString *)resDirectory target:(id)target
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        m_maskInfo = [maskInfo retain];
        m_resDirectory = [resDirectory retain];
        m_target = target;
        
        [self initLayers];
    }
    return self;
}

- (void)initLayers
{
	//layers
	NSArray *layersArray = [m_maskInfo objectForKey:@"layers"];
	m_layers = [[LayerParser parseLayers:layersArray resDirectory:m_resDirectory] retain];
    
    [self addLayers:m_layers];
}

- (void)addLayers:(NSArray *)layers
{
	for (id item in layers) {
		if (item != (id)[NSNull null]) {
			[self addSubview:item];
			
			//设置子view的相对坐标
			CGRect itemFrame = [item frame];
			itemFrame.origin.x -= self.frame.origin.x;
			itemFrame.origin.y -= self.frame.origin.y;
			[item setFrame:itemFrame];
		}
		
		if ([item isKindOfClass:[UIButton class]]){
			[(UIButton*)item addTarget:m_target action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
		}
	}
}

#pragma mark -------------------- dealloc --------------------

- (void)dealloc
{
    [m_maskInfo release];
    [m_resDirectory release];
    [m_layers release];
    [m_languageLayers release];
    
    [super dealloc];
}

@end
