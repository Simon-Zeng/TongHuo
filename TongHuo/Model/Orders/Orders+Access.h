//
//  Orders+Access.h
//  TongHuo
//
//  Created by zeng songgen on 14-6-7.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "Orders.h"

@interface Orders (Access)

+ (instancetype)orderWithId:(NSNumber *)identifier create:(BOOL)create;

+ (instancetype)orderWithCriteria:(NSDictionary *)criteria create:(BOOL)create;

+ (instancetype)objectFromDictionary:(NSDictionary *)dict;

+ (void)removeAllOrders;

#pragma mark -
+(NSArray *)getAllOrdersWithCriteria:(NSDictionary *)criteria;

- (NSDictionary *)presentAsDictionary;


@end
