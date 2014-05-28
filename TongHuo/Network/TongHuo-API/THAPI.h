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

//{
//    "add_time" = 1398110279;
//    "category_id" = 50000436;
//    checked = 1;
//    "city_id" = 5;
//    "diy_cid" = ",30,50000436,";
//    "goods_type" = 0;
//    id = 982392;
//    "list_time" = 1401031396;
//    "market_id" = 701;
//    "num_iid" = 38319773892;
//    "pic_url" = "http://img04.taobaocdn.com/bao/uploaded/i4/T1Db.vFrNcXXXXXXXX_!!0-item_pic.jpg_160x160.jpg";
//    price = "28.00";
//    pv = 12;
//    "shop_id" = 16148;
//    "tb_price" = "56.00";
//    "team_url" = "http://item.taobao.com/item.htm?id=38319773892&spm=2014.21577410.0.0";
//    title = "\U590f\U5b63\U65b0\U6b3e \U7537\U88c5\U4f11\U95f2\U77ed\U8896t\U6064\U7537\U58eb\U97e9\U7248\U62fc\U63a5\U5706\U9886\U6f6e\U6d41\U62fc\U8272T\U6064\U75379602";
//    "top_end_time" = 0;
//    "top_level" = 99999;
//    "top_start_time" = 0;
//    "update_time" = 1401151403;
//    "user_id" = 0;
//}

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
