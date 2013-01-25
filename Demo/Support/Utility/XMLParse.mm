//
//  XMLParse.mm
//
//  Created by zhangtianfu on 10-4-29.
//  Copyright 2010 NetDragon Websoft Inc. All rights reserved.
//

#import "XMLParse.h"

#include <libxml/parser.h>
#include <libxml/xmlmemory.h>
#include <libxml/xmlwriter.h>

@interface XMLParse(PrivateMethod)

//解析xmldoc
- (void)parseDoc:(xmlDocPtr)doc;
//解析xmlnode
- (void)parseNode:(xmlNodePtr)node  withDictionary:(NSMutableDictionary *)dictionary  withArray:(NSMutableArray *)array;
//判断是有子节点是文本结点
- (BOOL)hasTextNodeChilden:(xmlNodePtr)node;
//判断当前结点是否是属性结点
- (BOOL)isAttriNode:(xmlNodePtr)node;
//空文本结点
- (BOOL)isEmptyContentNode:(xmlNodePtr)node;

//获得有效的子节点
- (xmlNodePtr)getChildrenNode:(xmlNodePtr)node;
//获得下一个兄弟结点
- (xmlNodePtr)getNextNode:(xmlNodePtr)node;
//写元素
- (void)writeElement:(xmlTextWriterPtr)xmlWriter element:(id)element;
//print xml
- (void)printXMLWithObject:(id)object level:(int)level;


@end


@implementation XMLParse

@synthesize isEmptyXML = m_isEmptyXML;

- (id)initWithFile:(NSString *)path
{	
	if (self = [super init])
	{		
		do
		{
			if (nil == path)
			{
				break;
			}
			
			xmlDocPtr doc = xmlReadFile([path UTF8String], NULL, XML_PARSE_NOBLANKS);
			if (NULL == doc)
				break;
			
			[self parseDoc:doc];
			xmlFreeDoc(doc);
			
		}
		while(0);
	}
	
	return  self;
}

- (id)initWithData:(char *)data size:(int)size
{
	if (self = [super init])
	{		
		do
		{
			if (NULL == data || 0 == size)
			{
				break;
			}
			
			xmlKeepBlanksDefault(0);		
			xmlDocPtr doc = xmlParseMemory(data, size);	
			if (NULL == doc)
				break;
			
			[self parseDoc:doc];
			xmlFreeDoc(doc);
			
		}
		while(0);
	}
	
	return  self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if (self = [super init])
	{
		if (m_rootDictionary != dictionary)
		{
			if (1 == [[dictionary allKeys] count])
			{
				[m_rootDictionary release];
				m_rootDictionary = (NSMutableDictionary *)dictionary;		
				[dictionary retain];
			}
		}
	}
	
	return self;
}


- (long)saveXMLFile:(NSString *)path version:(NSString *)version  encoding:(NSString *)encoding standalone:(NSString *)standalone;
{
	if (nil == path)
		return NO;
	
	if ([self isEmptyXML])
	{
		return NO;
	}
	
	NSString *pathDir = [path stringByDeletingLastPathComponent];
	NSFileManager *fileMng = [NSFileManager defaultManager];
	if (![fileMng fileExistsAtPath:pathDir])
	{
		[fileMng createDirectoryAtPath:pathDir withIntermediateDirectories:YES attributes:nil error:nil];	
	}
	
	xmlTextWriterPtr xmlWriter = xmlNewTextWriterFilename([path UTF8String], 0 );
	if (NULL == xmlWriter)
	{
		NSLog(@"create new text writer err" );
		return NO;
	}
	
	if (nil != version || nil != encoding || nil != standalone)
	{
		xmlTextWriterStartDocument(xmlWriter, [version UTF8String],  [encoding UTF8String], [standalone UTF8String]);
	}
	xmlTextWriterSetIndent(xmlWriter, 1);
	xmlTextWriterSetIndentString(xmlWriter, (xmlChar*)"\t");	
	[self writeElement:xmlWriter element:m_rootDictionary];		
	xmlTextWriterEndDocument(xmlWriter);
	xmlFreeTextWriter(xmlWriter);
	
	NSDictionary *dic = [fileMng attributesOfItemAtPath:path error:nil];
	long size = [[dic objectForKey:NSFileSize] intValue];
	return size;	
}

//解析xmldoc
- (void)parseDoc:(xmlDocPtr)doc
{
	xmlNodePtr rootNode = xmlDocGetRootElement(doc);
	if (NULL == rootNode)
	{		
		return;
	}
	
	m_rootDictionary = [[NSMutableDictionary alloc] init];	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	[self parseNode:rootNode withDictionary:m_rootDictionary withArray:array];	
	[array release];
}

//解析xmlnode
- (void)parseNode:(xmlNodePtr)node  withDictionary:(NSMutableDictionary *)dictionary  withArray:(NSMutableArray *)array
{
	if (NULL == node || NULL == node->name || nil == dictionary || nil == array)
		return;	
	
 	if (XML_ELEMENT_NODE == node->type)
	{	
		NSString *name = [NSString stringWithUTF8String:(const char*)node->name];		
		
		if ([self hasTextNodeChilden:node])
		{//子节点是文本结点
			NSString *content = @"";			
			if (NULL != node->children->content)
			{
				content = [NSString stringWithUTF8String:(const char*)node->children->content];
			}
			
			[dictionary setObject:content forKey:name];
			
		}
		else if ([self isAttriNode:node])
		{//属性结点
			[dictionary setObject:@"" forKey:name];
		}
		else if ([self isEmptyContentNode:node])
		{//空文本结点
			[dictionary setObject:@"" forKey:name];
		}
		else
		{
			[dictionary setObject:array forKey:name];
			
			
			xmlNodePtr curNode = [self getChildrenNode:node];
			while(NULL != curNode)
			{				
				NSMutableDictionary *subDictionary = [[NSMutableDictionary alloc] init]; 				
				[array addObject:subDictionary];
				[subDictionary release];
				
				NSMutableArray *subArray = [[NSMutableArray alloc] init];				
				[self parseNode:curNode withDictionary:subDictionary withArray:subArray];				
				[subArray release];
				
				curNode = [self getNextNode:curNode];
			}
		}	
	}
}

//解析元素写
- (void)writeElement:(xmlTextWriterPtr)xmlWriter element:(id)element
{
	if ([element isKindOfClass:[NSDictionary class]])
	{
		NSArray *keyArray = [[element keyEnumerator] allObjects];		
		for(NSString *key in keyArray)
		{
			id object = [element objectForKey:key];
			if ([object isKindOfClass:[NSString class]])
			{//是文本就进行写操作
				xmlTextWriterWriteElement(xmlWriter, (xmlChar *)[key UTF8String], (xmlChar *)[object UTF8String]);
			}
			else
			{//非文本结点就继续解析
				xmlTextWriterStartElement(xmlWriter, (xmlChar *)[key UTF8String]);
				[self writeElement:xmlWriter element:object];		
				xmlTextWriterEndElement(xmlWriter);
			}
		}
	}
	else if ([element isKindOfClass:[NSArray class]])
	{		
		for(NSDictionary *dic in element)
		{
			[self writeElement:xmlWriter element:dic];
		}
	}
}

- (id)getObjectFromPath:(NSString *)path indexArray:(int *)indexArray arraySize:(int)size
{
	if (nil == path || nil == m_rootDictionary)
		return  nil;
	
	return [self getObjectFromObject:m_rootDictionary path:path indexArray:indexArray arraySize:size];
}

- (id)getObjectFromObject:(id)object path:(NSString *)path indexArray:(int *)indexArray arraySize:(int)size
{
	if (nil == path || nil == object)
		return  nil;	
	
	path = [path stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" /"]];
	if ([path length] == 0)
	{
		return object;
	}
	
	NSArray *pathArray = [path componentsSeparatedByString:@"/"];
	
	int index = 0;
	id curObject = nil;
	for(NSString *nodeName in pathArray)
	{
		if ([nodeName length] == 0)
			continue;//传入path的有双“/”导致
		
		if (0 == index)
		{
			curObject = object;
		}	
		
		if ([curObject isKindOfClass:[NSDictionary class]])
		{
			NSArray *keyArray = [curObject allKeys];
			if ([keyArray count] != 1)
			{
				curObject = nil;
			}
			else
			{
				NSString *key = [keyArray objectAtIndex:0];
				if (NSOrderedSame == [nodeName caseInsensitiveCompare:key])
				{//忽略key大小写
					curObject = [curObject objectForKey:key];
				}
				else
				{
					curObject = nil;
				}
			}
		}
		else if ([curObject isKindOfClass:[NSArray class]])
		{			
			if (NULL == indexArray)
			{//未传入索引		
				
				BOOL bFind = NO;
				for(NSDictionary *dic in curObject)
				{
					NSArray *keyArray = [dic allKeys];
					if ([keyArray count]>0 && NSOrderedSame == [nodeName caseInsensitiveCompare:[keyArray objectAtIndex:0]])
					{
						curObject = [dic objectForKey:[keyArray objectAtIndex:0]]; 
						bFind  = YES;
						break;
					}
				}				
				
				if (!bFind)
				{
					curObject = nil;
					NSLog(@"can not find the node: %@", nodeName);
					break;
				}
			}
			else if (NULL != indexArray && index <size && indexArray[index]>=0  && indexArray[index] < [curObject count])
			{//传入索引且是合法值
				
				int tempIndex = indexArray[index];
				NSMutableArray *tempArray = [NSMutableArray array];
				for(NSDictionary *dic in curObject)
				{//搜索所有nodename名称的结点
					NSArray *keyArray = [dic allKeys];
					if ([keyArray count]>0 && NSOrderedSame == [nodeName caseInsensitiveCompare:[keyArray objectAtIndex:0]])
					{
						[tempArray addObject:[dic objectForKey:[keyArray objectAtIndex:0]]]; 
						
						if (0 == tempIndex)
						{
							break;
						}
					}
				}
				
				if ([tempArray count] > 0 && tempIndex < [tempArray count])
				{
					curObject = [tempArray objectAtIndex:tempIndex];
				}
				else
				{
					curObject = nil;
					NSLog(@"can not find the node: %@", nodeName);
					break;
				}
			}
			else 
			{
				curObject = nil;
				NSLog(@"the arrayindex is invalid");
				break;
			}
		}
		
		if (nil == curObject)
			break;
		
		index++;
	}
	
	return curObject;
}

- (NSString *)getStringFromPath:(NSString *)path indexArray:(int *)indexArray arraySize:(int)size
{
	id object = [self getObjectFromPath:path indexArray:indexArray arraySize:size];
	if ([object isKindOfClass:[NSString class]])
	{
		return (NSString *)object;
	}
	else
	{
		return nil;
	}
}

- (NSString *)getStringFromObject:(id)curObject path:(NSString *)path indexArray:(int *)indexArray arraySize:(int)size
{
	id object = [self getObjectFromObject:curObject path:path indexArray:indexArray arraySize:size];
	if ([object isKindOfClass:[NSString class]])
	{
		return (NSString *)object;
	}
	else
	{
		return nil;
	}
}

- (int)getIntFromPath:(NSString *)path indexArray:(int *)indexArray arraySize:(int)size
{
	id object = [self getObjectFromPath:path indexArray:indexArray arraySize:size];
	if ([object isKindOfClass:[NSString class]])
	{
		return [object intValue];
	}
	else
	{
		return -1;
	}
}

- (int)getIntFromObject:(id)curObject path:(NSString *)path indexArray:(int *)indexArray arraySize:(int)size
{
	id object = [self getObjectFromObject:curObject path:path indexArray:indexArray arraySize:size];
	if ([object isKindOfClass:[NSString class]])
	{
		return [object intValue];
	}
	else
	{
		return -1;
	}
}

//判断是有子节点是文本结点
- (BOOL)hasTextNodeChilden:(xmlNodePtr)node
{
	if (NULL != node	&&	NULL != node->children	&&	XML_TEXT_NODE == node->children->type)
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

//判断当前结点是否是属性结点
- (BOOL)isAttriNode:(xmlNodePtr)node
{
	if (NULL != node	&&	NULL == node->children	
		&&	NULL != node->properties && XML_ATTRIBUTE_NODE == node->properties->type)
	{		
		return YES;
	}
	else
	{
		return NO;
	}
}


//空文本结点
- (BOOL)isEmptyContentNode:(xmlNodePtr)node;
{
	if(NULL != node && NULL == node->children 
	   && NULL == node->content && NULL == node->properties)
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

//获得有效的子节点
- (xmlNodePtr)getChildrenNode:(xmlNodePtr)node
{
	if (NULL == node || NULL == node->children)
		return NULL;
	
	xmlNodePtr childrenNode = node->children;
	
	while(NULL != childrenNode && xmlIsBlankNode(childrenNode))
	{//过滤BlankNode
		childrenNode = childrenNode->next;
	}
	
	return childrenNode;
}

//获得下一个兄弟结点
- (xmlNodePtr)getNextNode:(xmlNodePtr)node
{
	if (NULL == node || NULL == node->next)
		return NULL;
	
	xmlNodePtr nextNode = node->next;
	
	while(NULL != nextNode && xmlIsBlankNode(nextNode))
	{//过滤BlankNode
		nextNode = nextNode->next;
	}
	
	return nextNode;
}

//打印xml
-(void)printXML
{
	[self printXMLWithObject:m_rootDictionary level:0];
}

- (void)printXMLWithObject:(id)object level:(int)level
{
	if (nil == object)
		return;
	
	if ([object isKindOfClass:[NSDictionary class]])
	{		
		NSArray *keys = [object allKeys];
		if ([keys count] == 1)
		{			
			for (int i=0; i<level; i++)
			{
				printf("    ");
			}	
			
			NSString *key = [keys objectAtIndex:0];
			printf("<%s>", [key UTF8String]);
			
			object = [object objectForKey:key];	
			if ([object isKindOfClass:[NSString class]])
			{
				printf("%s</%s>\n", [object UTF8String], [key UTF8String]);
			}
			else
			{
				printf("\n");
				
				[self printXMLWithObject:object level:level+1];
				
				for (int i=0; i<level; i++)
				{
					printf("    ");
				}	
				printf("</%s>\n", [key UTF8String]);
			}
		}
	}
	else if ([object isKindOfClass:[NSArray class]])
	{
		for (NSDictionary *item in object)
		{
			[self printXMLWithObject:item level:level];
		}
	}
}

//空的或非法xml
- (BOOL)isEmptyXML
{
	if (nil == m_rootDictionary || [[m_rootDictionary allKeys] count] == 0)
	{
		return YES;		
	}
	else
	{
		return NO;
	}
}

//插入数据到path下以key为结点名称
- (BOOL)addNodeToPath:(NSString *)nodePath key:(NSString *)nodeKey valueArray:(NSArray *)values keyArray:(NSArray *)keys
{
	if (nil == nodePath || nil == nodeKey ||nil == values || nil == keys || nil == m_rootDictionary)
		return NO;	
	
	int valueCount = [values count];
	int keyCount = [keys count];
	if (0 == valueCount || 0 == keyCount || valueCount != keyCount)
		return NO;	
	
	//去掉path两端的“/”和空格
	nodePath = [nodePath stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" /"]];	
	if ([nodePath length] == 0)
	{//无法插入根节点
		return NO;	
	}	
	
	NSMutableArray *nodeArray = [self getObjectFromPath:nodePath indexArray:NULL arraySize:0];
	if (nil == nodeArray || ![nodeArray isKindOfClass:[NSArray class]])
	{
		return NO;		
	}
	
	NSMutableArray *nodeContent = [[NSMutableArray alloc] init];	
	
	for(int i=0; i<valueCount; ++i)
	{	
		NSString *key   = [keys objectAtIndex:i];		
		NSString *value = [values objectAtIndex:i];
		
		[nodeContent addObject:[NSDictionary dictionaryWithObject:value forKey:key]];
	}
	
	[nodeArray addObject:[NSDictionary dictionaryWithObject:nodeContent forKey:nodeKey]];		
	[nodeContent release];
	
	return YES;
}


//获取path下的以key为名称的所有结点（每个元素是一个NSArray）
- (NSArray *)getNodeArrayFromPath:(NSString *)nodePath key:(NSString *)nodeKey
{
	if (nil == nodePath || nil == nodeKey)
		return nil;
	
	//去掉path两端的“/”和空格
	nodePath = [nodePath stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" /"]];	
	if ([nodePath length] == 0)
	{//如果是读取根结点则直接返回
		return nil;	
	}
	
	NSMutableArray *nodeArray = [self getObjectFromPath:nodePath indexArray:NULL arraySize:0];
	if (nil == nodeArray || ![nodeArray isKindOfClass:[NSArray class]])
	{
		return nil;		
	}
	
	NSMutableArray *arrayRet = [[NSMutableArray alloc] init];	
	
	int count = [nodeArray count];				
	for(int i= 0; i<count; ++i)
	{
		id node = [nodeArray objectAtIndex:i];
		if ([node isKindOfClass:[NSDictionary class]])
		{
			NSArray *keyArray = [node allKeys];
			for (NSString *key in keyArray)
			{
				if (NSOrderedSame == [nodeKey caseInsensitiveCompare:key])
				{
					id item  = [node objectForKey:key];
					if (nil != item)
					{
						[arrayRet addObject:item];
					}
					break;
				}
			}
			
		}			
	}		
	
	if ([arrayRet count] == 0)
	{
		[arrayRet release];
		return nil;
	}
	else
	{
		return [arrayRet autorelease];
	}
}

//获取path下的以key为名称的所有结点(每个元素是一个dictionray)
- (NSArray *)getNodeDictionaryArrayFromPath:(NSString *)nodePath key:(NSString *)nodeKey
{
	NSArray	*array = [self getNodeArrayFromPath:nodePath key:nodeKey];
	if (nil == array)
	{
		return nil;
	}
	
	NSMutableArray	*resultArray = [[NSMutableArray alloc] init];
	for	(NSArray *itemArray in array)
	{
		NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
		for (NSDictionary *item in itemArray)
		{
			NSString	*key = [[item allKeys] objectAtIndex:0];
			id object = [item objectForKey:key];
			[dic setValue:object forKey:key];
		}
		
		[resultArray addObject:dic];
		[dic release];	
	}
	
	if ([resultArray count] == 0)
	{
		[resultArray release];
		return nil;
	}
	else
	{
		return [resultArray autorelease];
	}
}

- (void)dealloc
{
	[m_rootDictionary release];		
	[super dealloc];
}

@end
