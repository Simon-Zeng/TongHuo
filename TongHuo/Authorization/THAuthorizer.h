//
//  THAuthorize.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-25.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Account.h"

@interface THAuthorizer : NSObject

@property (nonatomic, readonly) NSString * username;
@property (nonatomic, readonly) NSString * password;

@property (nonatomic, assign, getter = isAutoSignInEnabled) BOOL autoSignInEnabled;

@property (nonatomic, readonly) BOOL isLoggedIn;
@property (nonatomic, readonly) Account * currentAccount;


+ (instancetype) sharedAuthorizer;

- (RACSignal *)signInWithUsername:(NSString *)username password:(NSString *)password;

@end
