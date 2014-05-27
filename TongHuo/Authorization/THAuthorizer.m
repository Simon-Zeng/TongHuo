//
//  THAuthorize.m
//  TongHuo
//
//  Created by zeng songgen on 14-5-25.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THAuthorizer.h"

#import "THAPI.h"
#import "THSettings.h"
#import "UICKeyChainStore.h"

#define kUsernameKey @"username"
#define kPasswordKey @"password"

@interface THAuthorizer ()

- (void) loadAuthentication;
- (void) saveAuthentication;
- (void) removeAuthentication;

- (RACSignal *)performSignIn;

@end

@implementation THAuthorizer

#pragma mark Class methods

+ (instancetype) sharedAuthorizer
{
    static THAuthorizer * authorizer = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        authorizer = [[self alloc] init];
    });
    
    return authorizer;
}

#pragma mark - Instance Methods

#pragma mark Life Cycle
- (id)init
{
    if (self = [super init])
    {
        _username = nil;
        _password = nil;
        
        _autoSignInEnabled = NO;
        
        [self loadAuthentication];
    }
    
    return self;
}

#pragma mark - Public

@synthesize username = _username;
@synthesize password = _password;

@synthesize autoSignInEnabled = _autoSignInEnabled;

- (RACSignal *)signInWithUsername:(NSString *)username password:(NSString *)password
{
    RACSignal * signInSignal = nil;
    
    if (![_username isEqual:username] || ![_password isEqual:password])
    {
        _username = username;
        _password = password;
        
        if (username && password)
        {
            signInSignal = [self performSignIn];
        }
        
        if (_autoSignInEnabled)
        {
            [self saveAuthentication];
        }
        else
        {
            [self removeAuthentication];
        }
    }
    
    return signInSignal;
}

- (BOOL)isAutoSignInEnabled
{
    return _autoSignInEnabled;
}

#pragma mark - Private

- (void) loadAuthentication
{
    UICKeyChainStore * keyChain = [UICKeyChainStore keyChainStoreWithService:kServericeName];
    
    NSString * username = [keyChain stringForKey:kUsernameKey];
    NSString * password = [keyChain stringForKey:kPasswordKey];
    
    if (username)
    {
        _username = username;
    }
    
    if (password) {
        _password = password;
    }
}

- (void) saveAuthentication
{
    UICKeyChainStore * keyChain = [UICKeyChainStore keyChainStoreWithService:kServericeName];
    
    [keyChain setString:_username forKey:kUsernameKey];
    [keyChain setString:_password forKey:kPasswordKey];
    
    [keyChain synchronize];
}

- (void) removeAuthentication
{
    UICKeyChainStore * keyChain = [UICKeyChainStore keyChainStoreWithService:kServericeName];
    
    [keyChain removeItemForKey:kUsernameKey];
    [keyChain removeItemForKey:kPasswordKey];
    
    [keyChain synchronize];
}

- (RACSignal *)performSignIn
{
    NSAssert(_username, @"****** username is nil");
    NSAssert(_password, @"****** password is nil");
    
    RACSignal * signal = nil;
    
    // Call Sign in API and return sign in signal for outside use.
    THAPI * api = [THAPI apiCenter];
    
    signal = [api signInWithUsername:_username password:_password];
    
    return signal;
}

@end
