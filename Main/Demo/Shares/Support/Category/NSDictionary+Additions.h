//
//  NSDictionary+Additions.h
//  Demo
//
//  Created by hui lei on 13-1-25.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(Additions)

- (UIImage *)getImageForKey:(NSString *)key resDirectory:(NSString *)resDirectory;
- (UIImage *)getImageFromArray:(int)index forKey:(NSString *)key resDirectory:(NSString *)resDirectory;
- (NSArray *)getImagesForKey:(NSString *)key resDirectory:(NSString *)resDirectory;
- (CGRect)getRectForKey:(NSString *)key;
- (CGRect)getRectForKey:(NSString *)key fromImage:(UIImage *)image;

- (Class)getPageViewClass;

- (id)getValueWithLanguageType:(LanguageType)languageType;
- (id)getLayersWithLanguageType:(LanguageType)languageType;

@end
