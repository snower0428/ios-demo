//
//  NumberView.h
//  FindDifferent
//
//  Created by zhangtianfu on 12-1-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumberView : UIView{
    NSString        *m_resDirectory;
    NSDictionary    *m_numbersSource;
    NSMutableDictionary *m_numberImages;
    
    float       m_maxNumberHeight;
    NSString    *m_currentNumberString;
}

- (id)initWithFrame:(CGRect)frame dataSource:(NSDictionary*)source resDirectory:(NSString*)resDirectory;
- (void)updateNumber:(NSString*)numberString;
@end
