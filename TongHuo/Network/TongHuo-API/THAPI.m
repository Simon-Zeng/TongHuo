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
    
    _postManager.responseSerializer = [AFJSONResponseSerializer serializer];

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
    
    _postManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
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
    _getManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
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
    _getManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
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
    
    _postManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
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
    
    _getManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
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
    _postManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSNumber * pid = product.identifier;
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
    
    _postManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString * ordersJson = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:orders
                                                                                           options:NSJSONWritingPrettyPrinted
                                                                                             error:NULL]
                                                  encoding:NSUTF8StringEncoding];
    
    NSString * baseSecret = [NSString stringWithFormat:@"%@/do/%d/%@", _accountUserIdentifier, ordersJson.length, kSecret];
    
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
//fh =     (
//          {
//              address = "\U7fe0*\U5c0f\U533a\U4e16\U7eaa\U98ce\U7f51\U5427";
//              alipay = "<null>";
//              color = "\U9ed1\U8272";
//              count = 1;
//              createtime = 20140612;
//              cs = "\U5546\U6d1b\U5e02";
//              did = 1010;
//              dname = tmuffamad;
//              dq = "\U5c71\U9633\U53bf";
//              email = "<null>";
//              has = 0;
//              id = 477444;
//              kno = "<null>";
//              ktype = "<null>";
//              name = "\U6768**";
//              note = "null@//null";
//              oid = 406974;
//              pay = 0;
//              sf = "\U9655\U897f\U7701";
//              size = 39;
//              tel = "1839292****";
//              tno = 690566813758511;
//              type = 0;
//              uid = 18725;
//          }
//          );
//pro =     (
//           {
//               auth = 0;
//               buyer = "\U72ec\U5bb6\U8bb0\U5fc6406520";
//               cid = 0;
//               color = "\U9ed1\U8272";
//               count = 1;
//               courier = 690566813758511;
//               createtime = 20140612;
//               ctime = 1402476561000;
//               did = 1010;
//               dname = tmuffamad;
//               id = 406974;
//               isdf = 0;
//               no = "\U8fbe\U7075&DL-13";
//               numid = 37341771372;
//               orderid = 690566813758511;
//               pid = 0;
//               pimage = "http://img02.taobaocdn.com/bao/uploaded/i2/T1UgR_FyFbXXXXXXXX_!!0-item_pic.jpg";
//               price1 = 53;
//               price2 = 0;
//               ptitle = "\U51c9\U978b\U59732014\U590f\U5b63\U65b0\U6b3e\U95ea\U4eae\U725b\U76ae\U62fc\U8272\U9732\U8dbe\U6f06\U76ae\U5e73\U8ddf\U7b80\U7ea6 \U7693\U96c5\U5973\U978b\U5305\U90ae";
//               size = 39;
//               state = 0;
//               tel = "1839292****";
//               uid = 18725;
//           }
//           );
//sj =     (
//);
// @param products Array of Product
- (RACSignal *)postAndGetOrders:(NSArray *)products
{
    NSAssert(_accountUserIdentifier, @"The method has a logic error");
    
    _postManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString * productsJson = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:products
                                                                                             options:NSJSONWritingPrettyPrinted
                                                                                               error:NULL]
                                                    encoding:NSUTF8StringEncoding];
    
    NSString * baseSecret = [NSString stringWithFormat:@"%@/do/%d/%@", _accountUserIdentifier, productsJson.length, kSecret];
    
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
