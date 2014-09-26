//
//  Shops.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Goods, Markets;

#import "THBaseObject.h"

@interface Shops : THBaseObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * marketId;
@property (nonatomic, retain) NSNumber * mobile;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * phone;
@property (nonatomic, retain) NSNumber * updateTime;
@property (nonatomic, retain) NSSet *goods;
@property (nonatomic, retain) Markets *market;
@end

@interface Shops (CoreDataGeneratedAccessors)

- (void)addGoodsObject:(Goods *)value;
- (void)removeGoodsObject:(Goods *)value;
- (void)addGoods:(NSSet *)values;
- (void)removeGoods:(NSSet *)values;

@end
