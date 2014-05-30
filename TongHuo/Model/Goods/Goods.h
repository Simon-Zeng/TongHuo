//
//  Goods.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Markets, Shops;

@interface Goods : NSManagedObject

@property (nonatomic, retain) NSNumber * addTime;
@property (nonatomic, retain) NSNumber * categoryId;
@property (nonatomic, retain) NSNumber * checked;
@property (nonatomic, retain) NSNumber * cityId;
@property (nonatomic, retain) NSString * diyCid;
@property (nonatomic, retain) NSNumber * goodsType;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * listTime;
@property (nonatomic, retain) NSNumber * marketId;
@property (nonatomic, retain) NSNumber * numIid;
@property (nonatomic, retain) NSString * picUrl;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * pv;
@property (nonatomic, retain) NSNumber * shopId;
@property (nonatomic, retain) NSNumber * tbPrice;
@property (nonatomic, retain) NSString * teamUrl;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * topEndTime;
@property (nonatomic, retain) NSNumber * topLevel;
@property (nonatomic, retain) NSNumber * topStartTime;
@property (nonatomic, retain) NSNumber * updateTime;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) Markets *market;
@property (nonatomic, retain) Shops *shop;

@end
