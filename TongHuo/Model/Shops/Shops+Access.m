//
//  Shops+Access.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-7.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "Shops+Access.h"

@implementation Shops (Access)

+ (void)initialize
{
    // Load all saved record to map to fix unique issue
    NSMutableDictionary * savedShops = [self savedShops];
    
    NSManagedObjectContext * context = [THCoreDataStack defaultStack].threadManagedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:[[self class] entityName] // Here we must use [self class]
                                 inManagedObjectContext:context];
    
    NSError * executeFetchError = nil;
    NSArray * shopArray = [context executeFetchRequest:request error:&executeFetchError];
    if (executeFetchError) {
        NSLog(@"[%@, %@] error looking Shops with error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [executeFetchError localizedDescription]);
    } else if (!shopArray) {
        for (Shops * ashop in shopArray)
        {
            NSManagedObjectID * objectID = [ashop objectID];
            NSNumber * uniqueKey = [ashop id];
            
            if (uniqueKey && objectID)
            {
                [savedShops setObject:objectID forKey:uniqueKey];
            }
        }
    }
}

+ (NSMutableDictionary *)savedShops
{
    static NSMutableDictionary * savedShops = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        savedShops = [[NSMutableDictionary alloc] init];
        
        // Load from db
        
    });
    
    return savedShops;
}

+ (void)didSaved:(Shops *)ashop
{
    NSMutableDictionary * savedShops = [self savedShops];
    
    NSManagedObjectID * objectID = [ashop objectID];
    NSNumber * uniqueKey = [ashop id];
    
    if (uniqueKey && objectID)
    {
        [savedShops setObject:objectID forKey:uniqueKey];
    }
}

+ (NSManagedObjectID *)objectIDForIdentifier:(NSNumber *)identifier
{
    NSAssert(identifier, @"The method has a logic error");
    
    NSMutableDictionary * savedShops = [self savedShops];
    
    return [savedShops objectForKey:identifier];
}

#pragma mark - Public

+ (instancetype)shopWithId:(NSNumber *)identifier
{
    Shops * shop = nil;
    
    NSManagedObjectID * objectID = [self objectIDForIdentifier:identifier];
    
    NSManagedObjectContext * context = [THCoreDataStack defaultStack].threadManagedObjectContext;
    
    
    if(objectID)
    {
        shop = (Shops *)[context objectWithID:objectID];
    }
    else
    {
        shop = [NSEntityDescription insertNewObjectForEntityForName:[[self class] entityName]
                                             inManagedObjectContext:context];
    }
    
    return shop;
}

+ (instancetype)objectFromDictionary:(NSDictionary *)dict
{
    //    {
    //        "id":"10269",
    //        "name":"\u542f\u822a\u670d\u9970",
    //        "address":"\u5973\u4eba\u8857106",
    //        "market_id":"6",
    //        "mobile":"13602824403",
    //        "phone":"",
    //        "update_time":"1400951416"
    //    }
    NSNumber * identifier = @([[dict objectForKey:@"id"] longLongValue]);
    NSString * address = [dict objectForKey:@"address"];
    NSString * name = [dict objectForKey:@"name"];
    NSNumber * marketId = @([[dict objectForKey:@"market_id"] longLongValue]);
    NSNumber * mobile = @([[dict objectForKey:@"mobile"] longLongValue]);
    NSNumber * phone = @([[dict objectForKey:@"phone"] longLongValue]);
    NSNumber * updateTime = @([[dict objectForKey:@"update_time"] longLongValue]);
    
    if (identifier)
    {
        Shops * shop = [Shops shopWithId:identifier];
        
        shop.id = identifier;
        shop.address = address;
        shop.name = name;
        shop.marketId = marketId;
        shop.mobile = mobile;
        shop.phone = phone;
        shop.updateTime = updateTime;

        return shop;
    }
    
    return nil;
}

@end
