//
//  CommDemoDefines.h
//  CommDemo
//
//  Created by leihui on 12-11-14.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#ifndef CommDemo_CommDemoDefines_h
#define CommDemo_CommDemoDefines_h

//#define INTERNAL_NET     //内网标志：URL访问的域名不一样

#ifdef INTERNAL_NET
#if 1
//babybook内网域名
#define BABYBOOK_DOMAIN  @"http://admin.babybook.test.91.com/"
//hosts映射 192.168.94.17   admin.babybook.test.91.com
//          192.168.94.19   uap19.91.com
//          192.168.9.128   uap128.91.com
#else
//babybook服务端开发者域名
#define BABYBOOK_DOMAIN  @"http://babybook.admin.dev.91.com/"  //hosts映射 192.168.57.22   admin.babybook.dev.91.com
#endif
#else
//babybook外网域名
#define BABYBOOK_DOMAIN  @"http://admin.babybook.91.com/"    //不需要映射
#endif

#define URL_HEADER_REGISTER             BABYBOOK_DOMAIN"interface/public/App_Register.ashx?"
#define URL_HEADER_LOGIN                BABYBOOK_DOMAIN"Interface/public/App_Login_In.ashx?"
#define URL_HEADER_FEEDBACK             BABYBOOK_DOMAIN"Interface/Ipad/AddFeedback.ashx?"
#define URL_HEADER_SALERULE             BABYBOOK_DOMAIN"Interface/ipad/GetBookListOfSaleRule.ashx?"
#define URL_HEADER_TAG                  BABYBOOK_DOMAIN"interface/ipad/GetBookListOfTag.ashx?"
#define URL_HEADER_RANK                 BABYBOOK_DOMAIN"interface/ipad/GetBookListOfRank.ashx?"
#define URL_HEADER_SEND                 BABYBOOK_DOMAIN"interface/ipad/GetBookListOfSend.ashx?"
#define URL_HEADER_SIGN                 BABYBOOK_DOMAIN"Interface/Ipad/SignInDay.ashx?"
#define URL_HEADER_GETSIGNLIST          BABYBOOK_DOMAIN"interface/ipad/GetSignInDayInfo.ashx?"
#define URL_HEADER_ALLBOOK              BABYBOOK_DOMAIN"Interface/ipad/GetAllBookList.ashx?"
#define URL_HEADER_SUBCATEBOOKLIST      BABYBOOK_DOMAIN"Interface/ipad/GetBookListOfCate.ashx?"
#define URL_HEADER_SEARCH               BABYBOOK_DOMAIN"Interface/ipad/GetBookListOfSearch.ashx?"
#define URL_HEADER_DETAIL               BABYBOOK_DOMAIN"Interface/ipad/GetDetailOfBook.ashx?"
#define URL_HEADER_USERCOMMENT          BABYBOOK_DOMAIN"Interface/Ipad/GetMyCommentOfBook.ashx?"
#define URL_HEADER_ADDCOMMENT           BABYBOOK_DOMAIN"Interface/Ipad/AddCommentOfBook.ashx?"
#define URL_HEADER_COMMENTLIST          BABYBOOK_DOMAIN"Interface/ipad/GetCommentListOfBook.ashx?"
#define URL_HEADER_VALIDCOMMENTLIST     BABYBOOK_DOMAIN"Interface/Ipad/GetNotNullCommentOfBook.ashx?"
#define URL_HEADER_BOOKOWNER            BABYBOOK_DOMAIN"Interface/Ipad/GetIfBuy.ashx?"
#define URL_HEADER_PARENTCATELIST       BABYBOOK_DOMAIN"interface/ipad/GetParentCateList.ashx"
#define URL_HEADER_SUBCATELIST          BABYBOOK_DOMAIN"Interface/ipad/GetCateList.ashx?"
#define URL_HEADER_SEARCHHOTKEY         BABYBOOK_DOMAIN"Interface/ipad/GetHotKeyWord.ashx?"
#define URL_HEADER_GETFAVORITES         BABYBOOK_DOMAIN"Interface/ipad/GetMyFavorites.ashx?"
#define URL_HEADER_ADDFAVORITES         BABYBOOK_DOMAIN"Interface/Ipad/AddFavorites.ashx?"
#define URL_HEADER_GETSHOPPINGCART      BABYBOOK_DOMAIN"Interface/Ipad/GetShoppingCart.ashx?"
#define URL_HEADER_ADDSHOPPINGCART      BABYBOOK_DOMAIN"Interface/Ipad/AddShoppingCart.ashx?"
#define URL_HEADER_PAYSHOPPINGCART      BABYBOOK_DOMAIN"Interface/Ipad/ShoppingCartPay.ashx?"
#define URL_HEADER_GETUSERINFO          BABYBOOK_DOMAIN"Interface/Ipad/GetUserInfo.ashx?"
#define URL_HEADER_RECHARGE             BABYBOOK_DOMAIN"Interface/Ipad/AddRecharge.ashx"
#define URL_HEADER_ADDPURCHASE          BABYBOOK_DOMAIN"Interface/Ipad/AddPurchase.ashx?"
#define URL_HEADER_GETDOWNLOADURL       BABYBOOK_DOMAIN"Interface/Ipad/GetDownInfoOfBook.ashx?"
#define URL_HEADER_GETPURCHASELIST      BABYBOOK_DOMAIN"Interface/ipad/GetPurchaseList.ashx?"
#define URL_HEADER_GETCATELISTFORSIGN   BABYBOOK_DOMAIN"Interface/ipad/GetCateListForSign.ashx?"

#endif
