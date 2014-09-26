//
//  Markets.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Goods, Shops;

#import "THBaseObject.h"

@interface Markets : THBaseObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * cityId;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *goods;
@property (nonatomic, retain) NSSet *shops;
@end

@interface Markets (CoreDataGeneratedAccessors)

- (void)addGoodsObject:(Goods *)value;
- (void)removeGoodsObject:(Goods *)value;
- (void)addGoods:(NSSet *)values;
- (void)removeGoods:(NSSet *)values;

- (void)addShopsObject:(Shops *)value;
- (void)removeShopsObject:(Shops *)value;
- (void)addShops:(NSSet *)values;
- (void)removeShops:(NSSet *)values;

@end
