//
//  NSData+Additions.h
//  Demo
//
//  Created by hui lei on 13-1-26.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData(Additions)

//kCCEncrypt:加密
//kCCDecrypt:解密
//对data进行AES加密/解密; key最长32位
- (NSData *)AES256_CCOperation:(CCOperation)operation withKey:(NSString *)key32;
//对data进行DES加密/解密; key最长8位
- (NSData *)DES_CCOperation:(CCOperation)operation withKey:(NSString *)key8;

@end
