//
//  Product+Access.h
//  TongHuo
//
//  Created by zeng songgen on 14-6-8.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "Product.h"

@interface Product (Access)

+ (instancetype)productWithCourier:(NSString *)courier create:(BOOL)create;

+ (instancetype)objectFromDictionary:(NSDictionary *)dict;

+ (void)removeAllProducts;

#pragma mark -
+(NSArray *)getAllOrdersWithCriteria:(NSDictionary *)criteria;

- (NSDictionary *)presentAsDictionary;

@end
