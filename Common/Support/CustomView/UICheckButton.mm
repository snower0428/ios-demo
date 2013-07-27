//
//  UICheckButton.mm
//
//  Created by zhangtianfu on 10-3-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UICheckButton.h"


@implementation UICheckButton

@synthesize check = m_check;
@synthesize checkImage = m_checkImage;
@synthesize uncheckImage = m_uncheckImage;
@synthesize delegate = m_delegate;


- (id)init{
	if (self = [super init]){
		self.check = NO;

		m_btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[self addSubview:m_btn];
		[m_btn addTarget:self action:@selector(onCheck:) forControlEvents:UIControlEventTouchUpInside];

	}
	
	return self;
}

- (id)initWithCheckImage:(UIImage *)checkImage UncheckImage:(UIImage *)uncheckImage{
	if (self = [super init])
	{
		self.checkImage = checkImage;
		self.uncheckImage = uncheckImage;
		self.check = NO;

		m_btn = [UIButton buttonWithType:UIButtonTypeCustom];
		m_btn.frame = self.bounds;
		[self addSubview:m_btn];
		[m_btn addTarget:self action:@selector(onCheck:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	return self;
}

-(void)layoutSubviews{
	m_btn.frame = self.bounds;
	self.check = self.check;
}


- (void)onCheck:(id)sender{
	self.check = !m_check;
	
	if (m_delegate && [m_delegate respondsToSelector:@selector(checkButtonChange:)])
	{
		[m_delegate checkButtonChange:self];
	}
}

- (void)setCheck:(bool)check{
	m_check = check;
	if (m_check){		
		[m_btn setImage:m_checkImage forState:UIControlStateNormal];
	}else{		
		[m_btn setImage:m_uncheckImage forState:UIControlStateNormal];
	}	
}

- (BOOL)isEnabled{
	return [m_btn isEnabled];
}

- (void)setEnabled:(BOOL)enabled{
	[m_btn setEnabled:enabled];
}

- (void)dealloc{
	[m_checkImage release];
	[m_uncheckImage release];
	[super dealloc];
}

@end
