//
//  THAPI.m
//  TongHuo
//
//  Created by zeng songgen on 14-5-25.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THAPI.h"

#import "THNetwork.h"
#import "THAuthorizer.h"
#import "Goods.h"

#import "Account.h"


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


@interface THAPI ()

@property (nonatomic, readwrite, strong) NSNumber * accountUserIdentifier;

@property (nonatomic, readwrite, strong) AFHTTPRequestOperationManager * getManager;
@property (nonatomic, readwrite, strong) AFHTTPRequestOperationManager * postManager;

@property (nonatomic, strong) AFJSONResponseSerializer * jsonResponseSerializer;

@end

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


#pragma mark - Instance methods
@synthesize getManager = _getManager;
@synthesize postManager = _postManager;

- (id) init
{
    if (self = [super init]) {
        _getManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[THNetwork sharedNetwork].baseURL];
        _postManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[THNetwork sharedNetwork].adminURL];
        
        
        AFJSONResponseSerializer * jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        
        NSMutableSet * acceptableContentTypes = [[NSMutableSet alloc] initWithSet:jsonResponseSerializer.acceptableContentTypes];
        [acceptableContentTypes addObject:@"text/plain"];
        [acceptableContentTypes addObject:@"text/html"];
        
        [jsonResponseSerializer setAcceptableContentTypes:acceptableContentTypes];
        
        self.jsonResponseSerializer = jsonResponseSerializer;
        
        
        RACSignal * updateSignal = [THAuthorizer sharedAuthorizer].updateSignal;
        
        @weakify(self);
        [updateSignal subscribeNext:^(NSManagedObjectID * x) {
            @strongify(self);
            if (x)
            {
                NSManagedObjectContext * context = [THCoreDataStack defaultStack].threadManagedObjectContext;
                
                [context performBlockAndWait:^{
                    Account * account = (Account *)[context objectWithID:x];
                    
                    [account willAccessValueForKey:nil];
                    
                    self.accountUserIdentifier = account.identifier;
                }];
            }
        }];
    }
    
    return self;
}

#pragma mark -

- (RACSignal *)signInWithUsername:(NSString *)username password:(NSString *)password
{
    NSAssert(username, @"The method has a logic error");
    NSAssert(password, @"The method has a logic error");

    _postManager.responseSerializer = self.jsonResponseSerializer;

    RACSignal * signal = [_postManager rac_POST:kSignInURI
                                     parameters:(@{
                                                   @"mod": @"login",
                                                   @"userinfo.loginname" : username,
                                                   @"userinfo.password": password
                                                   })];
    return signal;
}

- (RACSignal *)getTBAuthenticationFor:(NSNumber *)accountUserIdentifier
{
    NSAssert(accountUserIdentifier, @"The method has a logic error");
    
    _postManager.responseSerializer = self.jsonResponseSerializer;
    
    NSString * baseSecret = [NSString stringWithFormat:@"%@/do/%@", accountUserIdentifier, kSecret];
    
    CocoaSecurityResult * encrypted = [CocoaSecurity md5:baseSecret];

    NSString * m = encrypted.hexLower;
    
    RACSignal * signal = [_postManager rac_POST:kTBAuthenticationURI
                                     parameters:(@{
                                                   @"mod" : @"tuser",
                                                   @"uid": accountUserIdentifier,
                                                   @"m": m
                                                   })];
    return signal;
}


- (RACSignal *)getSellerCodeFor:(NSNumber *)productIdentifier
{
    NSAssert(productIdentifier, @"The method has a logic error");
    
    _getManager.responseSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:nil];
    
    RACSignal * signal = [_getManager rac_GET:kGetSellerCode
                                     parameters:(@{
                                                   @"m": @"GetSn",
                                                   @"num_iid" : productIdentifier
                                                   })];
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
    _getManager.responseSerializer = self.jsonResponseSerializer;
    
    RACSignal * signal = [_getManager rac_GET:kGetShopsURI
                                   parameters:(@{
                                                 @"m" : @"GetShop",
                                                 @"type": @2
                                                 })];
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
    _getManager.responseSerializer =  self.jsonResponseSerializer;
    
    RACSignal * signal = [_getManager rac_GET:kGetMarketsURI
                                   parameters:(@{
                                                 @"m" : @"GetMarket",
                                                 @"type": @1
                                                 })];
    return signal;
}

- (RACSignal *)getJackpot
{
    NSAssert(_accountUserIdentifier, @"The method has a logic error");
    
    _postManager.responseSerializer = self.jsonResponseSerializer;
    
    _postManager.responseSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:nil];

    RACSignal * signal = [_postManager rac_POST:kGetJackpot
                                     parameters:(@{
                                                   @"mod" : @"doj",
                                                   @"uid": _accountUserIdentifier
                                                   })];
    return signal;
}

- (RACSignal *)getGoodsForShop:(NSNumber *)shopIdentifier
{
    NSAssert(shopIdentifier, @"The method has a logic error");
    
    _getManager.responseSerializer = self.jsonResponseSerializer;
    
    RACSignal * signal = [_getManager rac_GET:kGetGoods
                                   parameters:(@{
                                                 @"m" : @"GetGoods",
                                                 @"shop_id": shopIdentifier
                                                 })];
    return signal;
}

//    mod 固定值 up
//    uid  当前用户id
//    tid  授权账号id
//    num_iid  产品id
//    title  标题（小于32个汉字字节）
//    outid 商家编码（需要通过接口获取）
//    price 售价
//
// kPostProductURI @"/sendTB.zzl"

- (RACSignal *)postTBProduct:(Goods *)product withCode:(NSString *)sellerCode  toTBShop:(NSNumber *)tbShopID
{
    _postManager.responseSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:nil];
    
    NSNumber * pid = product.numIid;
    NSString * title = product.title;
    NSNumber * price = product.price;
    
    NSNumber * tid = tbShopID;
    
    
    NSAssert(_accountUserIdentifier, @"The method has a logic error");
    
    NSAssert(pid, @"The method has a logic error");
    NSAssert(title, @"The method has a logic error");
    NSAssert(price, @"The method has a logic error");
    NSAssert(sellerCode, @"The method has a logic error");
    NSAssert(price, @"The method has a logic error");
    
    
    RACSignal * signal = [_postManager rac_POST:kPostProductURI
                                     parameters:(@{
                                                   @"mod" : @"up",
                                                   @"uid": _accountUserIdentifier,
                                                   @"tid": tid,
                                                   @"num_iid": pid,
                                                   @"title": title,
                                                   @"outid": sellerCode,
                                                   @"price": price
                                                   })];
    return signal;
}

// @brief
//
// @param orders Array of Order
//
// @return
- (RACSignal *)postOrders:(NSArray *)orders
{
    NSAssert(_accountUserIdentifier, @"The method has a logic error");
    
    _postManager.responseSerializer =  self.jsonResponseSerializer;
    
    NSString * ordersJson = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:orders
                                                                                           options:NSJSONWritingPrettyPrinted
                                                                                             error:NULL]
                                                  encoding:NSUTF8StringEncoding];
    
    NSString * baseSecret = [NSString stringWithFormat:@"%@/do/%lu/%@", _accountUserIdentifier, (unsigned long)ordersJson.length, kSecret];
    
    CocoaSecurityResult * encrypted = [CocoaSecurity md5:baseSecret];
    
    NSString * m = encrypted.hexLower;
    
    RACSignal * signal = [_postManager rac_POST:kPostOrdersURI
                                     parameters:(@{
                                                   @"mod" : @"do",
                                                   @"uid": _accountUserIdentifier,
                                                   @"data": ordersJson,
                                                   @"m": m
                                                   })];
    return signal;
}

// @brief sync un－deliveried products to server, and
//        request new orders from server
//
//{"pro":[
//    {
//        "uid":4830,
//        "count":1,
//        "dname":"新宇悦尚",
//        "no":"大西622_#6332",
//        "tel":"1868675****",
//        "state":0,
//        "courier":"778219458399339",
//        "did":2493,
//        "pid":0,
//        "ctime":1408439495000,
//        "numid":"40289645284",
//        "cid":0,
//        "size":"均码",
//        "id":758160,
//        "createtime":20140826,
//        "isdf":0,
//        "ptitle":"新款几何图案穗穗装饰针织开衫 披风外套 5 色 有薄厚两款",
//        "color":"杏色厚款",
//        "buyer":"魂兮归与君同",
//        "pimage":"http://img01.taobaocdn.com/bao/uploaded/i1/T1EcyxFxNdXXXXXXXX_!!0-item_pic.jpg",
//        "orderid":"778219458399339",
//        "auth":0,
//        "price2":0,
//        "price1":77}
//        ],
//    "sj":[],
//    "fh":[
//    {
//        "uid":4830,
//        "count":1,
//        "dname":"新宇悦尚",
//        "tel":"1868675****",
//        "did":2493,
//        "sf":"黑龙江省",
//        "type":0,
//        "has":0,
//        "size":"均码",
//        "cs":"哈尔滨市",
//        "id":828614,
//        "createtime":20140826,
//        "alipay":null,
//        "color":"杏色厚款",
//        "email":null,
//        "address":"复华**街**小区C7**单元403",
//        "oid":758160,
//        "name":"王**",
//        "pay":0,
//        "tno":"778219458399339",
//        "ktype":null,
//        "kno":null,
//        "dq":"南岗区",
//        "note":"null@//null"
//    }
//          ]
//}
//
// @param products Array of Product
- (RACSignal *)postAndGetOrders:(NSArray *)products
{
    NSAssert(_accountUserIdentifier, @"The method has a logic error");
    
    _postManager.responseSerializer = self.jsonResponseSerializer;
    
    NSString * productsJson = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:products
                                                                                             options:NSJSONWritingPrettyPrinted
                                                                                               error:NULL]
                                                    encoding:NSUTF8StringEncoding];
    
    NSString * baseSecret = [NSString stringWithFormat:@"%@/do/%lu/%@", _accountUserIdentifier, (unsigned long)productsJson.length, kSecret];
    
    CocoaSecurityResult * encrypted = [CocoaSecurity md5:baseSecret];
    
    NSString * m = encrypted.hexLower;
    
    RACSignal * signal = [_postManager rac_POST:kPostAndGetOrdersURI
                                     parameters:(@{
                                                   @"mod" : @"do",
                                                   @"uid": _accountUserIdentifier,
                                                   @"data": productsJson,
                                                   @"m": m
                                                   })];
    return signal;
}


@end
