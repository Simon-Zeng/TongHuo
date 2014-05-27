//
//  THAPI.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-25.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THAPI : NSObject

+ (instancetype) apiCenter;

- (RACSignal *)signInWithUsername:(NSString *)username password:(NSString *)password;

- (RACSignal *)getTBAuthentication;
- (RACSignal *)getSellerCodeFor:(NSNumber *)productIdentifier;

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
- (RACSignal *)getShops;

// @return Array of market
//
//    Market:
//    {
//        "id":"700",
//        "name":"\u5e7f\u5dde\u65b0\u9a8a\u90fd",
//        "city_id":"5",
//        "address":"\u5e7f\u5dde\u5e02\u767d\u4e91\u533a"
//    }

- (RACSignal *)getMarkets;

- (RACSignal *)getJackpot;

- (RACSignal *)getGoodsForShop:(NSNumber *)shopIdentifier;

- (RACSignal *)postTBProduct:(NSDictionary *)product;

// @brief
//
// @param orders Array of Order
//
// @return
- (RACSignal *)postOrders:(NSArray *)orders;

// @brief sync un－deliveried products to server, and
//        request new orders from server
//
// @param products Array of Product
- (RACSignal *)postAndGetOrders:(NSArray *)products;

@end
