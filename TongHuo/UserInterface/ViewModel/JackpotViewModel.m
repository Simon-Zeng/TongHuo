//
//  JackpotViewModel.m
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "JackpotViewModel.h"

#import "THAPI.h"

#define kTotalJackpotsNumberKey @"kTotalJackpotsNumberKey"

@implementation JackpotViewModel

@synthesize shakeCommand = _shakeCommand;

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
    //
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    _total = [defaults valueForKey:kTotalJackpotsNumberKey];
    
    // Command
    _shakeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal * jackpotSignal = [[THAPI apiCenter] getJackpot];
        
        return jackpotSignal;
    }];
}

- (void)setTotal:(NSNumber *)total
{
    if (![_total isEqual:total])
    {
        _total = total;
        
        //
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

        [defaults setValue:total forKey:kTotalJackpotsNumberKey];
        [defaults synchronize];
    }
}

@end
