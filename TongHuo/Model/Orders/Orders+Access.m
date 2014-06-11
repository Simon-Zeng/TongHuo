//
//  Orders+Access.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-7.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "Orders+Access.h"

@implementation Orders (Access)


+ (void)load
{
    NSManagedObjectContext * context = [THCoreDataStack defaultStack].threadManagedObjectContext;
    
    [context performBlock:^{
        // Load all saved record to map to fix unique issue
        NSMutableDictionary * savedOrders = [self savedOrders];

        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        //    request.propertiesToFetch = @[@"id"];
        
        request.entity = [NSEntityDescription entityForName:[[self class] entityName] // Here we must use [self class]
                                     inManagedObjectContext:context];
        
        NSError * executeFetchError = nil;
        NSArray * orderArray = [context executeFetchRequest:request error:&executeFetchError];
        if (executeFetchError) {
            NSLog(@"[%@, %@] error looking Orders with error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [executeFetchError localizedDescription]);
        } else if (orderArray) {
            for (Orders * aorder in orderArray)
            {
                NSManagedObjectID * objectID = [aorder objectID];
                NSNumber * uniqueKey = [aorder identifier];
                
                if (uniqueKey && objectID)
                {
                    [savedOrders setObject:objectID forKey:uniqueKey];
                }
            }
        }
        NSLog(@"++++++ Loaded savedOrders: %@", savedOrders);
    }];
}

+ (NSMutableDictionary *)savedOrders
{
    static NSMutableDictionary * savedOrders = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        savedOrders = [[NSMutableDictionary alloc] init];
        
        // Load from db
        
    });
    
    return savedOrders;
}

+ (void)didSaved:(Orders *)aorder
{
    NSMutableDictionary * savedOrders = [self savedOrders];
    
    NSManagedObjectID * objectID = [aorder objectID];
    NSNumber * uniqueKey = [aorder identifier];
    
    if (uniqueKey && objectID)
    {
        [savedOrders setObject:objectID forKey:uniqueKey];
    }
}

+ (NSManagedObjectID *)objectIDForIdentifier:(NSNumber *)identifier
{
    NSAssert(identifier, @"The method has a logic error");
    
    NSMutableDictionary * savedOrders = [self savedOrders];
    
    return [savedOrders objectForKey:identifier];
}

- (void)didSave
{
    [super didSave];
    
    [Orders didSaved:self];
}


#pragma mark - Public

+ (instancetype)orderWithId:(NSNumber *)identifier
{
    Orders * order = nil;
    
    NSManagedObjectID * objectID = [self objectIDForIdentifier:identifier];
    
    NSManagedObjectContext * context = [THCoreDataStack defaultStack].threadManagedObjectContext;
    
    if(objectID)
    {
        order = (Orders *)[context objectWithID:objectID];
    }
    else
    {
        order = [NSEntityDescription insertNewObjectForEntityForName:[[self class] entityName]
                                              inManagedObjectContext:context];
    }
    
    return order;
}

+ (instancetype)objectFromDictionary:(NSDictionary *)dict
{
    NSNumber * identifier = [dict objectForKey:@"id"];
    NSString * address = [dict objectForKey:@"address"];
    NSString * name = [dict objectForKey:@"name"];
    NSString * color = [dict objectForKey:@"color"];
    NSNumber * createtime = [dict objectForKey:@"createtime"];
    NSString * cs = [dict objectForKey:@"cs"];
    NSNumber * shopId = [dict objectForKey:@"did"];
    NSString * kno = [dict objectForKey:@"kno"];
    NSString * ktype = [dict objectForKey:@"ktype"];
    NSString * no = [dict objectForKey:@"no"];
    NSNumber * pid = [dict objectForKey:@"pid"];
    NSString * sf = [dict objectForKey:@"sf"];
    NSString * size = [dict objectForKey:@"size"];
    NSNumber * state = [dict objectForKey:@"state"];
    NSNumber * tb = [dict objectForKey:@"tb"];
    NSNumber * tel = [dict objectForKey:@"tel"];

    if (identifier)
    {
        Orders * order = [Orders orderWithId:identifier];
        
        order.identifier = identifier;
        order.address = address;
        order.name = name;
        order.color = color;
        order.createtime = createtime;
        order.cs = cs;
        order.shopId = shopId;
        order.kno = kno;
        order.ktype = ktype;
        order.no = no;
        order.pid = pid;
        order.sf = sf;
        order.size = size;
        order.state = state;
        order.tb = tb;
        order.tel = tel;
        
        return order;
    }
    
    return nil;
}

@end
