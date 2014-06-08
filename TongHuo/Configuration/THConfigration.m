//
//  THConfigration.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-8.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THConfigration.h"

@implementation THConfigration
#pragma mark Class methods

+ (instancetype) sharedConfigration
{
    static THConfigration * configration = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configration = [[self alloc] init];
    });
    
    return configration;
}

#pragma mark - Instance Methods

@synthesize platformsSynced = _platformsSynced;
@synthesize marketsSynced = _marketsSynced;
@synthesize shopsSynced = _shopsSynced;
@synthesize hasOrdersToSync = _hasOrdersToSync;
@synthesize hasProductsToSync = _hasProductsToSync;

- (id)init
{
    if (self = [super init])
    {
        _platformsSynced = NO;
        _marketsSynced = NO;
        _shopsSynced = NO;
        
        _hasOrdersToSync = YES;
        _hasProductsToSync = YES;
    }
    
    return self;
}

- (BOOL)isPlatformsSynced
{
    return _platformsSynced;
}

- (BOOL)isMarketsSynced
{
    return _marketsSynced;
}

- (BOOL)isShopsSynced
{
    return _shopsSynced;
}

@end
