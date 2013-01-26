//
//  NSDictionary+Additions.m
//  Demo
//
//  Created by hui lei on 13-1-25.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import "NSDictionary+Additions.h"

@implementation NSDictionary(Additions)

- (UIImage *)getImageForKey:(NSString *)key resDirectory:(NSString *)resDirectory
{
	NSString *imageName = [self objectForKey:key];
	NSString *imagePath = [resDirectory stringByAppendingPathComponent:imageName];
	UIImage *image = [UIImage imageWithContentsOfFileEx:imagePath];
	if (imageName && !image) {
		WriteLog(@"%@ ========%@", key, imagePath);
	}
	
	return image;
}

- (UIImage *)getImageFromArray:(int)index forKey:(NSString *)key resDirectory:(NSString *)resDirectory
{
	NSArray *images = [self objectForKey:key];
	int count = [images count];
	if (index == -1) {
		index = count-1;
	}
	
	if (index>=0 && index<count) {
		NSString *item = [images objectAtIndex:index];
		NSString *path = [resDirectory  stringByAppendingPathComponent:item];
		UIImage *image = [UIImage imageWithContentsOfFileEx:path];
		return image;
	}
	
	return nil;
}

- (NSArray *)getImagesForKey:(NSString *)key resDirectory:(NSString *)resDirectory
{
	NSArray *images = [self objectForKey:key];
	if ([images isKindOfClass:[NSArray class]]) {
		return [images getImages:resDirectory];
	} else {
		return nil;
	}
}

- (CGRect)getRectForKey:(NSString *)key
{
	NSString *frameString = [self objectForKey:key];
	CGRect rect = CGRectFromString(frameString);
	return rect;
}

- (CGRect)getRectForKey:(NSString *)key fromImage:(UIImage *)image
{
	CGRect rect = [self getRectForKey:key];
	
	if (image) {
		if (rect.size.width == -1) {
			rect.size.width = image.size.width;
		}
		
		if (rect.size.height == -1) {
			rect.size.height = image.size.height;
		}
	}
    
	return rect;
}

- (Class)getPageViewClass
{
	NSString *className = [self objectForKey:@"className"];
	if (self && nil == className) {
		className = @"PageView";
	}
	
	Class object= NSClassFromString(className);
	return object;
}

- (id)getValueWithLanguageType:(LanguageType)languageType
{
	if (LanguageTypeEnglish == languageType){
		return [self objectForKey:@"EN"];
	} else if (LanguageTypezh_CN == languageType) {
		return [self objectForKey:@"CN"];
	} else if (LanguageTypezh_FT == languageType) {
		return  [self objectForKey:@"FT"];
	}
	
	return nil;
}

- (id)getLayersWithLanguageType:(LanguageType)languageType
{
	if (LanguageTypeEnglish == languageType) {
		return [self objectForKey:@"layers_EN"];
	} else if (LanguageTypezh_CN == languageType) {
		return [self objectForKey:@"layers_CN"];
	} else if (LanguageTypezh_FT == languageType) {
		return [self objectForKey:@"layers_FT"];
	}
	
	return nil;
}

@end
