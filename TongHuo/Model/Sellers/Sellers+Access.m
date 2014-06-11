//
//  Sellers+Access.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-7.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "Sellers+Access.h"

@implementation Sellers (Access)


+ (void)load
{
    NSManagedObjectContext * context = [THCoreDataStack defaultStack].threadManagedObjectContext;
    
    [context performBlock:^{
        // Load all saved record to map to fix unique issue
        NSMutableDictionary * savedSellers = [self savedSellers];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        //    request.propertiesToFetch = @[@"productId"];
        
        request.entity = [NSEntityDescription entityForName:[[self class] entityName] // Here we must use [self class]
                                     inManagedObjectContext:context];
        
        NSError * executeFetchError = nil;
        NSArray * sellerArray = [context executeFetchRequest:request error:&executeFetchError];
        if (executeFetchError) {
            NSLog(@"[%@, %@] error looking Sellers with error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [executeFetchError localizedDescription]);
        } else if (sellerArray) {
            for (Sellers * aseller in sellerArray)
            {
                NSManagedObjectID * objectID = [aseller objectID];
                NSNumber * uniqueKey = [aseller productId];
                
                if (uniqueKey && objectID)
                {
                    [savedSellers setObject:objectID forKey:uniqueKey];
                }
            }
        }
        NSLog(@"++++++ Loaded savedSellers: %@", savedSellers);

    }];
}

+ (NSMutableDictionary *)savedSellers
{
    static NSMutableDictionary * savedSellers = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        savedSellers = [[NSMutableDictionary alloc] init];
        
        // Load from db
        
    });
    
    return savedSellers;
}

+ (void)didSaved:(Sellers *)aseller
{
    NSMutableDictionary * savedSellers = [self savedSellers];
    
    NSManagedObjectID * objectID = [aseller objectID];
    NSNumber * uniqueKey = [aseller productId];
    
    if (uniqueKey && objectID)
    {
        [savedSellers setObject:objectID forKey:uniqueKey];
    }
}

+ (NSManagedObjectID *)objectIDForIdentifier:(NSNumber *)identifier
{
    NSAssert(identifier, @"The method has a logic error");
    
    NSMutableDictionary * savedSellers = [self savedSellers];
    
    return [savedSellers objectForKey:identifier];
}

#pragma mark - Public

+ (instancetype)sellerWithProductId:(NSNumber *)identifier
{
    Sellers * seller = nil;
    
    NSManagedObjectID * objectID = [self objectIDForIdentifier:identifier];
    
    NSManagedObjectContext * context = [THCoreDataStack defaultStack].threadManagedObjectContext;
    
    
    if(objectID)
    {
        seller = (Sellers *)[context objectWithID:objectID];
    }
    else
    {
        seller = [NSEntityDescription insertNewObjectForEntityForName:[[self class] entityName]
                                               inManagedObjectContext:context];
    }
    
    return seller;
}

+ (instancetype)objectFromDictionary:(NSDictionary *)dict
{
    NSNumber * identifier = [dict objectForKey:@"id"];
    NSNumber * uid = [dict objectForKey:@"uid"];
    NSString * code = [dict objectForKey:@"code"];
    
    if (identifier && code)
    {
        Sellers * seller = [Sellers sellerWithProductId:identifier];
        
        seller.productId = identifier;
        seller.uid = uid;
        seller.code = code;
        
        return seller;
    }
    
    return nil;
}

@end
