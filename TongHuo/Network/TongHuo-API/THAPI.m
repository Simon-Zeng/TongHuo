//
//  THAPI.m
//  TongHuo
//
//  Created by zeng songgen on 14-5-25.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THAPI.h"

#define kSecret @"UUIJ98239JS89UJWQ3XM9I%&*ui ncd^"

//    userinfo.loginname
//    userinfo.password
#define kSignInURI @"/mlogin.zzl"

//    mod 固定值tbuser
//    uid 登录用户的id
//    m  验证参数  MD5(uid+”/do/”+通讯参数)
#define kTBAuthenticationURI @"/msysdata.zzl"

//    mod 固定值 up
//    uid  当前用户id
//    tid  授权账号id
//    num_iid  产品id
//    title  标题（小于32个汉字字节）
//    outid 商家编码（需要通过接口获取）
//    price 售价

#define kPostProductURI @"/sendTB.zzl"

//    num_iid  产品ID
#define kGetSellerCode @"/"

//    mod 固定值 do
//    uid  当前用户id
//    data  订单JSON数组Orderinfo
//    m  验证参数  MD5(uid+”/do/"+data.length()+"/"+通讯参数)
#define kPostOrdersURI @"/msysdelivery.zzl"

//    m  GetShop
//    type 2
#define kGetShopsURI @"/"

//    m  GetMarket
//    type 1
#define kGetMarketsURI @"/"

//    m  GetGoods
//    shop_id  产品ID
#define kGetGoods @"/"

//    mod 固定 doj
//    uid  用户id
#define kGetJackpot @"/mjackpot.zzl"

//    mod 固定值 do
//    uid  当前用户id
//    data  标记未提货的订单JSON数组products
//    m  验证参数  MD5(uid+”/do/"+data.length()+"/"+通讯参数)
#define kPostAndGetOrdersURI @"/msysdata.zzl"

@implementation THAPI


+ (instancetype) apiCenter
{
    static THAPI * api = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[self alloc] init];
    });
    
    return api;
}

- (RACSignal *)signInWithUsername:(NSString *)username password:(NSString *)password
{
    RACSignal * signal = nil;
    
    
    
    return signal;
}

- (RACSignal *)getTBAuthentication
{
    RACSignal * signal = nil;
    
    return signal;
}


- (RACSignal *)getSellerCodeFor:(NSNumber *)productIdentifier
{
    RACSignal * signal = nil;
    
    return signal;
}

// Array of shop object
//
//    Shop:
//    {
//        "id":"10269",
//        "name":"\u542f\u822a\u670d\u9970",
//        "address":"\u5973\u4eba\u8857106",
//        "market_id":"6",
//        "mobile":"13602824403",
//        "phone":"",
//        "update_time":"1400951416"
//    }
- (RACSignal *)getShops
{
    RACSignal * signal = nil;
    
    return signal;
}

// @return Array of market
//
//    Market:
//    {
//        "id":"700",
//        "name":"\u5e7f\u5dde\u65b0\u9a8a\u90fd",
//        "city_id":"5",
//        "address":"\u5e7f\u5dde\u5e02\u767d\u4e91\u533a"
//    }

- (RACSignal *)getMarkets
{
    RACSignal * signal = nil;
    
    return signal;
}

- (RACSignal *)getJackpot
{
    RACSignal * signal = nil;
    
    return signal;
}

- (RACSignal *)getGoodsForShop:(NSNumber *)shopIdentifier
{
    RACSignal * signal = nil;
    
    return signal;
}

- (RACSignal *)postTBProduct:(NSDictionary *)product
{
    RACSignal * signal = nil;
    
    return signal;
}

// @brief
//
// @param orders Array of Order
//
// @return
- (RACSignal *)postOrders:(NSArray *)orders
{
    RACSignal * signal = nil;
    
    return signal;
}

// @brief sync un－deliveried products to server, and
//        request new orders from server
//
// @param products Array of Product
- (RACSignal *)postAndGetOrders:(NSArray *)products
{
    RACSignal * signal = nil;
    
    return signal;
}


@end
