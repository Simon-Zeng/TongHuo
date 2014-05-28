//
//  Sellers.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-28.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Sellers : NSManagedObject

@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSNumber * productId;
@property (nonatomic, retain) NSString * code;

@end
