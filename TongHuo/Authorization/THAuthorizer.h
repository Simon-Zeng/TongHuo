//
//  THAuthorize.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-25.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account;
@class RACSignal;

@interface THAuthorizer : NSObject

@property (nonatomic, readonly) NSString * username;
@property (nonatomic, readonly) NSString * password;

@property (nonatomic, assign, getter = isAutoSignInEnabled) BOOL autoSignInEnabled;

@property (nonatomic, readonly) BOOL isLoggedIn;
@property (nonatomic, readonly) NSManagedObjectID * currentAccountID;
@property (nonatomic, readonly) NSArray * platforms;

@property (nonatomic, readonly) RACSignal * updateSignal;

+ (instancetype) sharedAuthorizer;

- (RACSignal *)signInWithUsername:(NSString *)username password:(NSString *)password;
- (void)logout;

- (NSNumber *)authorizenCodeFor:(NSString *)tbShopName;

@end
