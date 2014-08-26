//
//  Orders.h
//  TongHuo
//
//  Created by zeng songgen on 14-8-26.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Product;

@interface Orders : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSNumber * createtime;
@property (nonatomic, retain) NSString * cs; // City
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * kno; // 快递号
@property (nonatomic, retain) NSString * ktype; //快递类型，圆通，中通，韵达，申通，邮
@property (nonatomic, retain) NSString * name; // User name
@property (nonatomic, retain) NSString * no; // 商家编码
@property (nonatomic, retain) NSNumber * pid; // oid:产品id
@property (nonatomic, retain) NSString * sf; // Province
@property (nonatomic, retain) NSNumber * shopId;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSNumber * pay;
@property (nonatomic, retain) NSNumber * tb; // 是否同步
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * tno; //对应product的courier或orderid
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * shopName;
@property (nonatomic, retain) NSString * dq;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * has;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSNumber * state; // 同步状态
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * uid;

@property (nonatomic, retain) Product *product;

@end
