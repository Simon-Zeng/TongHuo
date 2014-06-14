//
//  Orders+Access.h
//  TongHuo
//
//  Created by zeng songgen on 14-6-7.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "Orders.h"

@interface Orders (Access)

+ (instancetype)orderWithId:(NSNumber *)identifier;

+ (instancetype)objectFromDictionary:(NSDictionary *)dict;


#pragma mark -
+(NSArray *)getAllOrdersWithCriteria:(NSDictionary *)criteria;

- (NSDictionary *)presentAsDictionary;


@end
