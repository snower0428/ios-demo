//
//  XMLParse.h
//
//  Created by zhangtianfu on 10-4-29.
//  Copyright 2010 NetDragon Websoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*------引用说明－－－－－－－
1、 添加libxml2.dylib
2、header search path：/usr/include/libxml2/
*/


/*

 --------------------------------------------------------------------------
 说明：
 1、对于传入的路径/a/b 和a/b 和/a/b/等都是等价的。处理的时候忽略左右两端“/”符号
 2、忽略传入路径和key大小写
 3、arraySize为indexArray的数组长度。如果indexArray为NULL,将忽略arraySize的值。
 ---------------------------------------------------------------------------
 具体看如下用例：
 <result>
	<name>pandaspace</name>
	<data>
		<count>2</count>
		<url>aaaa</url>
		<url>bbbb</url>
	</data>
 </result>
 （1）求count的值
 （2）获取aaaa
 （3）获取bbbb
 （4）获取以/result/data下所有url的结点
 ------------------------------------------------------------------------------ 
 XMLParse *parse = [[XMLParse alloc] initWithFile:@"/test/myExamply.xml"];
 （1）int count = [parse getIntFromPath:@"result/data/count" indexArray:NULL arraySize:0];
 （2）NSString *a = [parse getStringFromPath:@"result/data/url" indexArray:NULL arraySize:0];
 （3）int indexs[] = {0, 0, 1};
 NSString *b = [parse getStringFromPath:@"result/data/url" indexArray:indexs arraySize:3];
 其中数组indexs的元素：
 第一个为0表示result出现的索引，只有一个则为0，
 第二个为0表示data出现的索引，同上只有一个则为0，
 第三个为1表示url出现的索引，表示url有多个则取索引是1的那个（第二个）
 如果将第三个值也改为0，求得的索引是0的url的值，即为aaaa的值，因为不传indexArray默认都是取索引0的值，所以求aaaa的时候可以不传入数组
 （4）NSArray *urlArray = [parse getNodeArrayFromPath:@"result/data" key:@"url"];
 NSString *a = [urlArray objectAtIndex:0];
 NSString *b= [urlArray objectAtIndex:1];
 
 [parse release];
 
 */

@interface XMLParse : NSObject 
{
	NSMutableDictionary *m_rootDictionary;	
	BOOL				m_isEmptyXML;
}

@property(nonatomic, readonly, getter = isEmptyXML) BOOL isEmptyXML;

- (id)initWithFile:(NSString *)path;
- (id)initWithData:(char *)data size:(int)size;
- (id)initWithDictionary:(NSDictionary *)dictionary;

//保存xml到本地（返回xml的大小：单位字节）
- (long)saveXMLFile:(NSString *)path version:(NSString *)version  encoding:(NSString *)encoding standalone:(NSString *)standalone;

//从XML路径获取object
- (id)getObjectFromPath:(NSString *)path indexArray:(int *)indexArray arraySize:(int)size;
//从相对于传入object的XML路径下获取object
- (id)getObjectFromObject:(id)curObject path:(NSString *)path indexArray:(int *)indexArray arraySize:(int)size;

//从XML路径获取String
- (NSString *)getStringFromPath:(NSString *)path indexArray:(int *)indexArray arraySize:(int)size;
//从相对于传入object的XML路径下获取String
- (NSString *)getStringFromObject:(id)curObject path:(NSString *)path indexArray:(int *)indexArray arraySize:(int)size;

//从XML路径获取int（如果得不到int值将返回-1）
- (int)getIntFromPath:(NSString *)path indexArray:(int *)indexArray arraySize:(int)size;
//从相对于传入object的XML路径下获取int（如果得不到int值将返回-1）
- (int)getIntFromObject:(id)curObject path:(NSString *)path indexArray:(int *)indexArray arraySize:(int)size;

//插入数据到path下以key为结点名称
- (BOOL)addNodeToPath:(NSString *)nodePath key:(NSString *)nodeKey valueArray:(NSArray *)values keyArray:(NSArray *)keys;
//获取path下的以key为名称的所有结点（每个元素是一个NSArray）
- (NSArray *)getNodeArrayFromPath:(NSString *)nodePath key:(NSString *)nodeKey;
//获取path下的以key为名称的所有结点(每个元素是一个dictionray)
- (NSArray *)getNodeDictionaryArrayFromPath:(NSString *)nodePath key:(NSString *)nodeKey;

//以打印xml到控制台
- (void)printXML;
//判断是否是空的xml文件
- (BOOL)isEmptyXML;

@end
