//
//  Markets+Access.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-7.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "Markets+Access.h"

@implementation Markets (Access)

+ (void)load
{
    NSManagedObjectContext * context = [THCoreDataStack defaultStack].threadManagedObjectContext;
    
    [context performBlock:^{
        // Load all saved record to map to fix unique issue
        NSMutableDictionary * savedMarkets = [self savedMarkets];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        //    request.propertiesToFetch = @[@"id"];
        
        request.entity = [NSEntityDescription entityForName:[[self class] entityName] // Here we must use [self class]
                                     inManagedObjectContext:context];
        
        NSError * executeFetchError = nil;
        NSArray * markets = [context executeFetchRequest:request error:&executeFetchError];
        if (executeFetchError) {
            NSLog(@"[%@, %@] error looking markets with error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [executeFetchError localizedDescription]);
        } else if (markets) {
            for (Markets * aMarket in markets)
            {
                NSManagedObjectID * objectID = [aMarket objectID];
                NSNumber * uniqueKey = [aMarket identifier];
                
                if (uniqueKey && objectID)
                {
                    [savedMarkets setObject:objectID forKey:uniqueKey];
                }
            }
        }
        
//        NSLog(@"++++++ Loaded savedMarkets: %@", savedMarkets);
    }];
}

+ (NSMutableDictionary *)savedMarkets
{
    static NSMutableDictionary * savedMarkets = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        savedMarkets = [[NSMutableDictionary alloc] init];
        
        // Load from db
        
    });
    
    return savedMarkets;
}

+ (void)didSaved:(Markets *)aMarket
{
    NSMutableDictionary * savedMarkets = [self savedMarkets];
    
    NSManagedObjectID * objectID = [aMarket objectID];
    NSNumber * uniqueKey = [aMarket identifier];
    
    if (uniqueKey && objectID)
    {
        [savedMarkets setObject:objectID forKey:uniqueKey];
    }
}

+ (NSManagedObjectID *)objectIDForIdentifier:(NSNumber *)identifier
{
    NSAssert(identifier, @"The method has a logic error");
    
    NSMutableDictionary * savedMarkets = [self savedMarkets];
    
    return [savedMarkets objectForKey:identifier];
}

- (void)didSave
{
    [super didSave];
    
    [Markets didSaved:self];
}

#pragma mark - Public

+ (instancetype)marketWithId:(NSNumber *)identifier
{
    Markets * market = nil;
    
    NSManagedObjectID * objectID = [self objectIDForIdentifier:identifier];
    
    NSManagedObjectContext * context = [THCoreDataStack defaultStack].threadManagedObjectContext;
    
    if(objectID)
    {
        market = (Markets *)[context objectWithID:objectID];
    }
    else
    {
        market = [NSEntityDescription insertNewObjectForEntityForName:[[self class] entityName]
                                             inManagedObjectContext:context];
    }
    
    return market;
}

+ (instancetype)objectFromDictionary:(NSDictionary *)dict
{
    // @return Array of market
    //
    //    Market:
    //    {
    //        "id":"700",
    //        "name":"\u5e7f\u5dde\u65b0\u9a8a\u90fd",
    //        "city_id":"5",
    //        "address":"\u5e7f\u5dde\u5e02\u767d\u4e91\u533a"
    //    }
    NSNumber * identifier = @([[dict objectForKey:@"id"] longLongValue]);
    NSString * address = [dict objectForKey:@"address"];
    NSString * name = [dict objectForKey:@"name"];
    NSNumber * cityId = @([[dict objectForKey:@"city_id"] longLongValue]);
    
    if (identifier)
    {
        Markets * market = [Markets marketWithId:identifier];
        
        market.identifier = identifier;
        market.address = address;
        market.name = name;
        market.cityId = cityId;
        
        return market;
    }
    
    return nil;
}

@end
