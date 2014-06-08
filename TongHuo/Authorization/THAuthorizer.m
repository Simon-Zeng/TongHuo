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

#import "Account+Access.h"
#import "Platforms+Access.h"

#define kUsernameKey @"username"
#define kPasswordKey @"password"

@interface THAuthorizer ()

@property (nonatomic, readwrite) Account * currentAccount;

- (void) loadAuthentication;
- (void) saveAuthentication;
- (void) removeAuthentication;

- (RACSignal *)performSignIn;

- (void)refreshTBAuthentication;

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
        
        _currentAccount = nil;
        
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
    RACSignal * signInSignal = [RACSignal empty];
    
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

- (void)logout
{
    [self removeAuthentication];
    
    _username = nil;
    _password = nil;
    
    _currentAccount = nil;
}

- (BOOL)isAutoSignInEnabled
{
    return _autoSignInEnabled;
}

- (BOOL)isLoggedIn
{
    if (_currentAccount && _currentAccount.id.longLongValue > 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
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
    
    RACSignal * signal = [RACSignal empty];
    
    // Call Sign in API and return sign in signal for outside use.
    THAPI * api = [THAPI apiCenter];
    
    signal = [api signInWithUsername:_username password:_password];
    
    @weakify(self);
    RACSignal * newSignal = [signal doNext:^(RACTuple * x) {
        id responseObject = x[1];
        
        @strongify(self);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            self.currentAccount = [Account objectFromDictionary:responseObject];
            [self refreshTBAuthentication];
        }
    }];
    
    return newSignal;
}


- (RACSignal *)updateSignal
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        [subscriber sendNext:self.currentAccount];
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

- (void)refreshTBAuthentication
{
    RACSignal * signal = [RACSignal empty];
    
    THAPI * api = [THAPI apiCenter];
    
    signal = [api getTBAuthentication];
    
//    @weakify(self);
    [signal subscribeNext:^(RACTuple * x) {
        NSDictionary * response = x[1];
        
        if (response && [response isKindOfClass:[NSDictionary class]])
        {
            NSArray * authentications = [response objectForKey:@"data"];
            
            NSMutableArray * authens = [[NSMutableArray alloc] init];
            
            for (NSDictionary * aDict in authentications)
            {
                Platforms * plaform = [Platforms objectFromDictionary:aDict];
                [authens addObject:plaform];
            }
            
            NSLog(@"----- Authens: %@", authens);
            
            [[THCoreDataStack defaultStack] saveContext];
        }
        
    } error:^(NSError *error) {
        NSLog(@"------- Failed to refresh TBAuthentication: %@", error);
    }];
}

@end
