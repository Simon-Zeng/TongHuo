//
//  Account+Access.h
//  TongHuo
//
//  Created by zeng songgen on 14-6-7.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "Account.h"

@interface Account (Access)

+ (instancetype)accountWithId:(NSNumber *)identifier createNewIfNotExits:(BOOL)create;

+ (instancetype)objectFromDictionary:(NSDictionary *)dict;


@end
