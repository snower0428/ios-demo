//
//  NSData+Additions.m
//  Demo
//
//  Created by hui lei on 13-1-26.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import "NSData+Additions.h"

@implementation NSData(Additions)

//	对data进行AES加密/解密; key最长32位
- (NSData *)AES256_CCOperation:(CCOperation)operation withKey:(NSString *)key32
{
	NSData *returnData = nil;
	
	char keyPtr[kCCKeySizeAES256+1];
	bzero(keyPtr, sizeof(keyPtr));
	[key32 getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	
	NSUInteger dataLength = [self length];
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	
	size_t numBytesOfBufferOpeation = 0;
	CCCryptorStatus cryptStatus = CCCrypt(operation, kCCAlgorithmAES128,
										  kCCOptionPKCS7Padding | kCCOptionECBMode,
										  keyPtr, kCCBlockSizeAES128,
										  NULL,
										  [self bytes], dataLength,
										  buffer, bufferSize,
										  &numBytesOfBufferOpeation);
	
	if (cryptStatus == kCCSuccess) {
		returnData  = [[[NSData alloc] initWithBytes:buffer length:numBytesOfBufferOpeation] autorelease];
	} else if (cryptStatus == kCCParamError){
		NSLog(@"PARAM ERROR");
	} else if (cryptStatus == kCCBufferTooSmall){
		NSLog(@"BUFFER TOO SMALL");
	} else if (cryptStatus == kCCMemoryFailure){
		NSLog(@"MEMORY FAILURE");
	} else if (cryptStatus == kCCAlignmentError){ 
		NSLog(@"ALIGNMENT");
	} else if (cryptStatus == kCCDecodeError){
		NSLog(@"DECODE ERROR");
	} else if (cryptStatus == kCCUnimplemented){ 
		NSLog(@"UNIMPLEMENTED"); 
	}
	
	free(buffer);
	
	return returnData;
}

//	对data进行DES加密/解密; key最长8位
- (NSData *)DES_CCOperation:(CCOperation)operation withKey:(NSString *)key8
{
	NSData *returnData = nil;
	
	char keyPtr[kCCKeySizeDES+1];
	bzero(keyPtr, sizeof(keyPtr));
	[key8 getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	
	NSUInteger dataLength = [self length];
	size_t bufferSize = dataLength + kCCBlockSizeDES;
	void *buffer = malloc(bufferSize);
	
    //Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
	size_t numBytesOfBufferOpeation = 0;
	CCCryptorStatus cryptStatus = CCCrypt(operation, kCCAlgorithmDES,
										  kCCOptionPKCS7Padding|kCCOptionECBMode ,
										  keyPtr, kCCBlockSizeDES,
										  NULL,
										  [self bytes], dataLength,
										  buffer, bufferSize,
										  &numBytesOfBufferOpeation);
	
	if (cryptStatus == kCCSuccess) {
		returnData  = [[[NSData alloc] initWithBytes:buffer length:numBytesOfBufferOpeation] autorelease];
	} else if (cryptStatus == kCCParamError){
		NSLog(@"PARAM ERROR");
	} else if (cryptStatus == kCCBufferTooSmall){
		NSLog(@"BUFFER TOO SMALL");
	} else if (cryptStatus == kCCMemoryFailure){
		NSLog(@"MEMORY FAILURE");
	} else if (cryptStatus == kCCAlignmentError){ 
		NSLog(@"ALIGNMENT");
	} else if (cryptStatus == kCCDecodeError){
		NSLog(@"DECODE ERROR");
	} else if (cryptStatus == kCCUnimplemented){ 
		NSLog(@"UNIMPLEMENTED"); 
	}
    
	free(buffer);
	
	return returnData;
}

@end
