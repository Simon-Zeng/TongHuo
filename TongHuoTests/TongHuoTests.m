//
//  TongHuoTests.m
//  TongHuoTests
//
//  Created by zeng songgen on 14-5-23.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ReactiveCocoa.h"
#import "ReactiveCoreData.h"

#import "THAPI.h"
#import "Goods+Access.h"

@interface TongHuoTests : XCTestCase

@end

@implementation TongHuoTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test01Login
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

    THAPI * apiCenter = [THAPI apiCenter];
    
//    RACSignal * signal = [apiCenter signInWithUsername:@"zengconggen" password:@"123456"];

    RACSignal * signal = [apiCenter signInWithUsername:@"miukoo" password:@"123456"];
 
    [signal subscribeNext:^(RACTuple *result) {
        NSLog(@"--- Result: %@", result);
        RACTupleUnpack(AFHTTPRequestOperation * httpRequest) = result;
        
        NSLog(@"------ ResponseString: %@", httpRequest.responseString);
        
        dispatch_semaphore_signal(sema);
    } error:^(NSError *error){
        NSLog(@"--- error: %@", error);
        
        dispatch_semaphore_signal(sema);
    } completed:^(void){
        NSLog(@"--- test01Login completed");
        
        dispatch_semaphore_signal(sema);
    }];
    
   dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

- (void)test02TBAuth
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    THAPI * apiCenter = [THAPI apiCenter];

    RACSignal * signal = [apiCenter getTBAuthenticationFor:@111];
    
    [signal subscribeNext:^(RACTuple *result) {
        NSLog(@"--- Result: %@", result);
        
        RACTupleUnpack(AFHTTPRequestOperation *httpRequest) = result;
        
        NSLog(@"--- ResponseString: %@", httpRequest.responseString);
        
        dispatch_semaphore_signal(sema);
    } error:^(NSError *error){
        NSLog(@"--- error: %@", error);
        
        dispatch_semaphore_signal(sema);
    } completed:^(void){
        NSLog(@"--- test02TBAuth completed");
        
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}


- (void)test03SellerCode
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSNumber * productIdentifier = @36920712729;
    
    THAPI * apiCenter = [THAPI apiCenter];
    
    RACSignal * signal = [apiCenter getSellerCodeFor:productIdentifier];
    
    [signal subscribeNext:^(RACTuple *result) {
        RACTupleUnpack(AFHTTPRequestOperation *httpRequest) = result;
        NSLog(@"--- Result: %@", httpRequest);
        
        NSLog(@"--- ResponseString: %@", httpRequest.responseString);
        
        dispatch_semaphore_signal(sema);
    } error:^(NSError *error){
        NSLog(@"--- error: %@", error);
        
        dispatch_semaphore_signal(sema);
    } completed:^(void){
        NSLog(@"--- test03SellerCode completed");
        
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

- (void)test04Shops
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    THAPI * apiCenter = [THAPI apiCenter];
    
    RACSignal * signal = [apiCenter getShops];
    
    [signal subscribeNext:^(RACTuple *result) {
        NSLog(@"--- Result: %@", result);
        
        dispatch_semaphore_signal(sema);
    } error:^(NSError *error){
        NSLog(@"--- error: %@", error);
        
        dispatch_semaphore_signal(sema);
    } completed:^(void){
        NSLog(@"--- test04Shops completed");
        
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}


- (void)test05Markets
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    THAPI * apiCenter = [THAPI apiCenter];
    
    RACSignal * signal = [apiCenter getMarkets];
    
    [signal subscribeNext:^(RACTuple *result) {
        NSLog(@"--- Result: %@", result);
        
        dispatch_semaphore_signal(sema);
    } error:^(NSError *error){
        NSLog(@"--- error: %@", error);
        
        dispatch_semaphore_signal(sema);
    } completed:^(void){
        NSLog(@"--- test05Markets completed");
        
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}


- (void)test06Jackpot
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    THAPI * apiCenter = [THAPI apiCenter];
    
    RACSignal * signal = [apiCenter getJackpot];
    
    [signal subscribeNext:^(RACTuple *result) {
        NSLog(@"--- Result: %@", result);
        
        RACTupleUnpack(AFHTTPRequestOperation *httpRequest) = result;
        
        NSLog(@"--- ResponseString: %@", httpRequest.responseString);
        
        dispatch_semaphore_signal(sema);
    } error:^(NSError *error){
        NSLog(@"--- error: %@", error);
        
        dispatch_semaphore_signal(sema);
    } completed:^(void){
        NSLog(@"--- test06Jackpot completed");
        
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}


- (void)test07GoodsForShop
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSNumber * shopIdentifier = @16148;
    
    THAPI * apiCenter = [THAPI apiCenter];
    
    RACSignal * signal = [apiCenter getGoodsForShop:shopIdentifier];
    
    [signal subscribeNext:^(RACTuple *result) {
        NSLog(@"--- Result: %@", result);
        
        dispatch_semaphore_signal(sema);
    } error:^(NSError *error){
        NSLog(@"--- error: %@", error);
        
        dispatch_semaphore_signal(sema);
    } completed:^(void){
        NSLog(@"--- test07GoodsForShop completed");
        
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}


- (void)test08PostProduct
{
    return;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSDictionary * product = (@{
                                @"identifier": @10,
                                @"title": @"Test Product",
                                @"price": @"10.0"
                                });
    
    THAPI * apiCenter = [THAPI apiCenter];
    
    RACSignal * signal = [apiCenter postTBProduct:[Goods objectFromDictionary:product] withCode:@""  toTBShop:@11];
    
    [signal subscribeNext:^(RACTuple *result) {
        NSLog(@"--- Result: %@", result);
        
        dispatch_semaphore_signal(sema);
    } error:^(NSError *error){
        NSLog(@"--- error: %@", error);
        
        dispatch_semaphore_signal(sema);
    } completed:^(void){
        NSLog(@"--- test08PostProduct completed");
        
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}


- (void)test09PostOrders
{
    return;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSArray * orders = [NSArray array];
    
    THAPI * apiCenter = [THAPI apiCenter];
    
    RACSignal * signal = [apiCenter postOrders:orders];
    
    [signal subscribeNext:^(RACTuple *result) {
        NSLog(@"--- Result: %@", result);
        
        dispatch_semaphore_signal(sema);
    } error:^(NSError *error){
        NSLog(@"--- error: %@", error);
        
        dispatch_semaphore_signal(sema);
    } completed:^(void){
        NSLog(@"--- test09PostOrders completed");
        
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}


- (void)test10PostAndGetOrders
{
    return;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSArray * orders = [NSArray array];
    
    THAPI * apiCenter = [THAPI apiCenter];
    
    RACSignal * signal = [apiCenter postAndGetOrders:orders];
    
    [signal subscribeNext:^(RACTuple *result) {
        NSLog(@"--- Result: %@", result);
        
        dispatch_semaphore_signal(sema);
    } error:^(NSError *error){
        NSLog(@"--- error: %@", error);
        
        dispatch_semaphore_signal(sema);
    } completed:^(void){
        NSLog(@"--- test10PostAndGetOrders completed");
        
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}


@end
