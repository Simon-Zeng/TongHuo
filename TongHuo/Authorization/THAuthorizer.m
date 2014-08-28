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
#define kUserIdentifier @"userIdentifier"

@interface THAuthorizer ()


@property (nonatomic, strong, readwrite) NSNumber * userIdentifier;
@property (nonatomic, strong, readwrite) NSString * username;
@property (nonatomic, strong, readwrite) NSString * password;


@property (nonatomic, readwrite) NSManagedObjectID * currentAccountID;
@property (nonatomic, strong) NSArray * platforms;

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
        _userIdentifier = nil;
        _username = nil;
        _password = nil;
        
        _autoSignInEnabled = YES;
        
        _currentAccountID = nil;
        
        [self loadAuthentication];
    }
    
    return self;
}

#pragma mark - Public

@synthesize userIdentifier = _userIdentifier;
@synthesize username = _username;
@synthesize password = _password;

@synthesize autoSignInEnabled = _autoSignInEnabled;

- (RACSignal *)signInWithUsername:(NSString *)username password:(NSString *)password
{
    RACSignal * signInSignal = [RACSignal empty];
    
    if (_userIdentifier.longLongValue == 0)
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
    
    _userIdentifier = nil;
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
    
    NSNumber * userIdentifier = @([[keyChain stringForKey:kUserIdentifier] longLongValue]);
    NSString * username = [keyChain stringForKey:kUsernameKey];
    NSString * password = [keyChain stringForKey:kPasswordKey];
    
    if (userIdentifier.longLongValue > 0)
    {
        Account * currentAccount = [Account accountWithId:userIdentifier createNewIfNotExits:NO];
        
        if (currentAccount.name)
        {
            self.currentAccountID = [currentAccount objectID];
        }
    }
    
    if (self.currentAccountID)
    {
        _userIdentifier = userIdentifier;
        _username = username;
        _password = password;
    }
    else
    {
        [self removeAuthentication];
    }
}

- (void) saveAuthentication
{
    UICKeyChainStore * keyChain = [UICKeyChainStore keyChainStoreWithService:kServericeName];
    
    if (_userIdentifier)
    {
        [keyChain setString:_userIdentifier.stringValue forKey:kUserIdentifier];
    }
    
    [keyChain setString:_username forKey:kUsernameKey];
    [keyChain setString:_password forKey:kPasswordKey];
    
    [keyChain synchronize];
}

- (void) removeAuthentication
{
    UICKeyChainStore * keyChain = [UICKeyChainStore keyChainStoreWithService:kServericeName];
    
    [keyChain removeItemForKey:kUserIdentifier];
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
    RACSignal * newSignal = [signal doNext:^(id x) {
        id responseObject = x;
        
        @strongify(self);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
             Account * currentAccount = [Account objectFromDictionary:responseObject];
            self.userIdentifier = currentAccount.identifier;
            
            [self saveAuthentication];
            
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
    [signal subscribeNext:^(id x) {
        @strongify(self);
        
        NSDictionary * response = x;
        
        if (response && [response isKindOfClass:[NSDictionary class]])
        {
            NSArray * authentications = [response objectForKey:@"data"];
            
            [[THCoreDataStack defaultStack].managedObjectContext performBlock:^{
                NSMutableArray * authens = [[NSMutableArray alloc] init];
                
                for (NSDictionary * aDict in authentications)
                {
                    Platforms * plaform = [Platforms objectFromDictionary:aDict];
                    [authens addObject:plaform];
                }
                
                NSLog(@"----- Authens: %@", authens);
                
                self.platforms = authens;
                
                [[THCoreDataStack defaultStack] saveContext];
            }];
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
