//
//  QRCodeViewModel.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-7.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "QRCodeViewModel.h"

#import "Shops+Access.h"

@implementation QRCodeViewModel

- (id)init
{
    if (self = [super init])
    {
        [self commandInit];
    }
    
    return self;
}

- (id)initWithModel:(id)model
{
    if (self = [super initWithModel:model])
    {
        [self commandInit];
    }
    
    return self;
}

- (void)commandInit
{

}

- (BOOL)canOpenShop:(NSNumber *)shopId
{
    BOOL canOpen = NO;
    
    if ([Shops isShopExists:shopId])
    {
        canOpen = YES;
    }
    
    return canOpen;
}

@end
