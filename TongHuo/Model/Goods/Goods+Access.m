//
//  Goods+Access.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-7.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "Goods+Access.h"

@implementation Goods (Access)


+ (void)load
{
    NSManagedObjectContext * context = [THCoreDataStack defaultStack].threadManagedObjectContext;
    
    [context performBlock:^{
        // Load all saved record to map to fix unique issue
        NSMutableDictionary * savedGoods = [self savedGoods];

        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        //    request.propertiesToFetch = @[@"id"];
        
        request.entity = [NSEntityDescription entityForName:[[self class] entityName] // Here we must use [self class]
                                     inManagedObjectContext:context];
        
        NSError * executeFetchError = nil;
        NSArray * goodArray = [context executeFetchRequest:request error:&executeFetchError];
        if (executeFetchError) {
            NSLog(@"[%@, %@] error looking Goods with error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [executeFetchError localizedDescription]);
        } else if (goodArray) {
            for (Goods * agood in goodArray)
            {
                NSManagedObjectID * objectID = [agood objectID];
                NSNumber * uniqueKey = [agood identifier];
                
                if (uniqueKey && objectID)
                {
                    [savedGoods setObject:objectID forKey:uniqueKey];
                }
            }
        }
        NSLog(@"++++++ Loaded savedGoods: %@", savedGoods);
    }];
}

+ (NSMutableDictionary *)savedGoods
{
    static NSMutableDictionary * savedGoods = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        savedGoods = [[NSMutableDictionary alloc] init];
        
        // Load from db
        
    });
    
    return savedGoods;
}

+ (void)didSaved:(Goods *)agood
{
    NSMutableDictionary * savedGoods = [self savedGoods];
    
    NSManagedObjectID * objectID = [agood objectID];
    NSNumber * uniqueKey = [agood identifier];
    
    if (uniqueKey && objectID)
    {
        [savedGoods setObject:objectID forKey:uniqueKey];
    }
}

+ (NSManagedObjectID *)objectIDForIdentifier:(NSNumber *)identifier
{
    NSAssert(identifier, @"The method has a logic error");
    
    NSMutableDictionary * savedGoods = [self savedGoods];
    
    return [savedGoods objectForKey:identifier];
}

#pragma mark - Public

+ (instancetype)goodWithId:(NSNumber *)identifier
{
    Goods * good = nil;
    
    NSManagedObjectID * objectID = [self objectIDForIdentifier:identifier];
    
    NSManagedObjectContext * context = [THCoreDataStack defaultStack].threadManagedObjectContext;
    
    
    if(objectID)
    {
        good = (Goods *)[context objectWithID:objectID];
    }
    else
    {
        good = [NSEntityDescription insertNewObjectForEntityForName:[[self class] entityName]
                                             inManagedObjectContext:context];
    }
    
    return good;
}

+ (instancetype)objectFromDictionary:(NSDictionary *)dict
{
    //{
    //    "add_time" = 1398110279;
    //    "category_id" = 50000436;
    //    checked = 1;
    //    "city_id" = 5;
    //    "diy_cid" = ",30,50000436,";
    //    "goods_type" = 0;
    //    id = 982392;
    //    "list_time" = 1401031396;
    //    "market_id" = 701;
    //    "num_iid" = 38319773892;
    //    "pic_url" = "http://img04.taobaocdn.com/bao/uploaded/i4/T1Db.vFrNcXXXXXXXX_!!0-item_pic.jpg_160x160.jpg";
    //    price = "28.00";
    //    pv = 12;
    //    "shop_id" = 16148;
    //    "tb_price" = "56.00";
    //    "team_url" = "http://item.taobao.com/item.htm?id=38319773892&spm=2014.21577410.0.0";
    //    title = "\U590f\U5b63\U65b0\U6b3e \U7537\U88c5\U4f11\U95f2\U77ed\U8896t\U6064\U7537\U58eb\U97e9\U7248\U62fc\U63a5\U5706\U9886\U6f6e\U6d41\U62fc\U8272T\U6064\U75379602";
    //    "top_end_time" = 0;
    //    "top_level" = 99999;
    //    "top_start_time" = 0;
    //    "update_time" = 1401151403;
    //    "user_id" = 0;
    //}
    NSNumber * addTime = @([[dict objectForKey:@"add_time"] longLongValue]);
    NSNumber * categoryId = @([[dict objectForKey:@"category_id"] longLongValue]);
    NSNumber * checked = @([[dict objectForKey:@"checked"] longLongValue]);
    NSNumber * cityId = @([[dict objectForKey:@"city_id"] longLongValue]);
    NSString * diyCid = [dict objectForKey:@"diy_cid"];
    NSNumber * goodsType = @([[dict objectForKey:@"goods_type"] longLongValue]);
    NSNumber * identifier = @([[dict objectForKey:@"id"] longLongValue]);
    NSNumber * listTime = @([[dict objectForKey:@"list_time"] longLongValue]);
    NSNumber * marketId = @([[dict objectForKey:@"market_id"] longLongValue]);
    NSNumber * numIid = @([[dict objectForKey:@"num_iid"] longLongValue]);
    NSString * picUrl = [dict objectForKey:@"pic_url"];
    NSNumber * price = @([[dict objectForKey:@"price"] doubleValue]);
    NSNumber * pv = @([[dict objectForKey:@"pv"] longLongValue]);
    NSNumber * shopId = @([[dict objectForKey:@"shop_id"] longLongValue]);
    NSNumber * tbPrice = @([[dict objectForKey:@"tb_price"] doubleValue]);
    NSString * teamUrl = [dict objectForKey:@"team_url"];
    NSString * title = [dict objectForKey:@"title"];
    NSNumber * topEndTime = @([[dict objectForKey:@"top_end_time"] longLongValue]);
    NSNumber * topLevel = @([[dict objectForKey:@"top_level"] longLongValue]);
    NSNumber * topStartTime = @([[dict objectForKey:@"top_start_time"] longLongValue]);
    NSNumber * updateTime = @([[dict objectForKey:@"update_time"] longLongValue]);
    NSNumber * uid = @([[dict objectForKey:@"user_id"] longLongValue]);

    
    if (identifier)
    {
        Goods * good = [Goods goodWithId:identifier];
        
        good.addTime = addTime;
        good.categoryId = categoryId;
        good.checked = checked;
        good.cityId = cityId;
        good.diyCid = diyCid;
        good.goodsType = goodsType;
        good.identifier = identifier;
        good.listTime = listTime;
        good.marketId = marketId;
        good.numIid = numIid;
        good.picUrl = picUrl;
        good.price = price;
        good.pv = pv;
        good.shopId = shopId;
        good.tbPrice = tbPrice;
        good.teamUrl = teamUrl;
        good.title = title;
        good.topEndTime = topEndTime;
        good.topLevel = topLevel;
        good.topStartTime = topStartTime;
        good.updateTime = updateTime;
        good.uid = uid;

        
        return good;
    }
    
    return nil;
}

@end
