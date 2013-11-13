//
//  TDProduceType.h
//  LHTwoDimDemo
//
//  Created by leihui on 13-11-3.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#ifndef LHTwoDimDemo_TDProduceType_h
#define LHTwoDimDemo_TDProduceType_h

/**
 *  二维码生成类型的定义
 */
typedef enum
{
    TDProduceTypeContacts = 0,  //通讯录
    TDProduceTypeCard,          //名片
    TDProduceTypeText,          //文本
    TDProduceTypePasteboard,    //剪贴板
    TDProduceTypeCall,          //电话
    TDProduceTypeSMS,           //短信
    TDProduceTypeUrl,           //网址
    TDProduceTypeMail,          //邮箱
    TDProduceTypeLocation,      //位置
}TDProduceType;

#endif
