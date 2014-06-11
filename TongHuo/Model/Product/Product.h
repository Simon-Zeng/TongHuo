//
//  Product.h
//  TongHuo
//
//  Created by zeng songgen on 14-6-11.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Product : NSManagedObject

@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSNumber * createtime;
@property (nonatomic, retain) NSNumber * dates;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * no;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSNumber * auth;
@property (nonatomic, retain) NSString * buyer;
@property (nonatomic, retain) NSNumber * cid;
@property (nonatomic, retain) NSString * courier;
@property (nonatomic, retain) NSNumber * ctime;
@property (nonatomic, retain) NSNumber * shopId;
@property (nonatomic, retain) NSString * shopName;
@property (nonatomic, retain) NSNumber * isdf;
@property (nonatomic, retain) NSString * numid;
@property (nonatomic, retain) NSString * orderid;
@property (nonatomic, retain) NSNumber * pid;
@property (nonatomic, retain) NSString * pimage;
@property (nonatomic, retain) NSNumber * price1;
@property (nonatomic, retain) NSNumber * price2;
@property (nonatomic, retain) NSString * ptitle;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSNumber * uid;

@end
