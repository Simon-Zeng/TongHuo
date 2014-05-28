//
//  Shops.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-28.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Goods, Markets;

@interface Shops : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * marketId;
@property (nonatomic, retain) NSNumber * mobile;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * phone;
@property (nonatomic, retain) NSNumber * updateTime;
@property (nonatomic, retain) Goods *goods;
@property (nonatomic, retain) Markets *market;

@end
