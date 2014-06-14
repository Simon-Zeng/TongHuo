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

@property (nonatomic, readwrite) NSManagedObjectID * currentAccountID;
@property (nonatomic, strong) NSArray * platforms;

- (void) loadAuthentication;
- (void) saveAuthentication;
- (void) removeAuthentication;

- (RACSignal *)performSignIn;

- (void)refreshTBAuthenticationFor:(NSNumber *)accountUserIdentifier;

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
        
        _currentAccountID = nil;
        
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
    
    _currentAccountID = nil;
}

- (BOOL)isAutoSignInEnabled
{
    return _autoSignInEnabled;
}

- (BOOL)isLoggedIn
{
    if (_currentAccountID)
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
             Account * currentAccount = [Account objectFromDictionary:responseObject];
            [self refreshTBAuthenticationFor:currentAccount.identifier];
            
            [[THCoreDataStack defaultStack] saveContext];
            
            self.currentAccountID = [currentAccount objectID];
        }
    }];
    
    return newSignal;
}


- (RACSignal *)updateSignal
{
    RACSignal * signal = RACObserve(self, currentAccountID);
    
    return signal;
}

- (void)refreshTBAuthenticationFor:(NSNumber *)accountUserIdentifier
{
    RACSignal * signal = [RACSignal empty];
    
    THAPI * api = [THAPI apiCenter];
    
    signal = [api getTBAuthenticationFor:accountUserIdentifier];
    
    @weakify(self);
    [signal subscribeNext:^(RACTuple * x) {
        @strongify(self);
        
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
            
            self.platforms = authens;
            
            [[THCoreDataStack defaultStack] saveContext];
        }
        
    } error:^(NSError *error) {
        NSLog(@"------- Failed to refresh TBAuthentication: %@", error);
    }];
}

- (NSNumber *)authorizenCodeFor:(NSString *)tbShopName
{
    NSNumber * identifier = nil;
    
    for (Platforms * aPlatform in self.platforms)
    {
        if ([aPlatform.name isEqual:tbShopName])
        {
            identifier = aPlatform.identifier;
        }
    }
    
    return identifier;
}

@end
