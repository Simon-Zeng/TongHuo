//
//  THConfigration.h
//  TongHuo
//
//  Created by zeng songgen on 14-6-8.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THConfigration : NSObject

@property (nonatomic, assign, getter = isPlatformsSynced) BOOL platformsSynced;
@property (nonatomic, assign, getter = isMarketsSynced) BOOL marketsSynced;
@property (nonatomic, assign, getter = isShopsSynced) BOOL shopsSynced;

@property (nonatomic, assign) BOOL hasOrdersToSync;
@property (nonatomic, assign) BOOL hasProductsToSync;


+ (instancetype) sharedConfigration;

@end
