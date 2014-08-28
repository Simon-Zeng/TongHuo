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
//        NSLog(@"++++++ Loaded savedOrders: %@", savedOrders);
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
        if (aorder.isInserted)
        {
            [savedOrders setObject:objectID forKey:uniqueKey];
        }
        else if (aorder.isDeleted)
        {
            [savedOrders removeObjectForKey:uniqueKey];
        }
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

+ (instancetype)orderWithId:(NSNumber *)identifier create:(BOOL)create
{
    Orders * order = nil;
    
    NSManagedObjectID * objectID = [self objectIDForIdentifier:identifier];
    
    NSManagedObjectContext * context = [THCoreDataStack defaultStack].threadManagedObjectContext;
    
    if(objectID)
    {
        order = (Orders *)[context objectWithID:objectID];
    }
    else if (create)
    {
        order = [NSEntityDescription insertNewObjectForEntityForName:[[self class] entityName]
                                              inManagedObjectContext:context];
    }
    
    return order;
}

+ (instancetype)orderWithCriteria:(NSDictionary *)criteria create:(BOOL)create
{
    NSArray * result = nil;
    
    NSManagedObjectContext * context = [THCoreDataStack defaultStack].threadManagedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSMutableArray * precidates = [[NSMutableArray alloc] init];
    
    for (NSString * key in criteria)
    {
        id value = [criteria objectForKey:@"value"];
        
        NSPredicate * precidate = [NSPredicate predicateWithFormat:@"%K = %@", key, value];
        
        [precidates addObject:precidate];
    }
    
    if (precidates.count > 0)
    {
        NSCompoundPredicate * compoundPrecidate = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType
                                                                              subpredicates:precidates];
        
        request.predicate = compoundPrecidate;
    }
    
    request.fetchBatchSize = 1;
    //    request.propertiesToFetch = @[@"id"];
    
    request.entity = [NSEntityDescription entityForName:[[self class] entityName] // Here we must use [self class]
                                 inManagedObjectContext:context];
    
    NSError * executeFetchError = nil;
    result = [context executeFetchRequest:request error:&executeFetchError];
    if (executeFetchError) {
        NSLog(@"[%@, %@] error looking Orders with error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [executeFetchError localizedDescription]);
    }
    if (result.count ==0 && create){
        Orders * anOrder = [NSEntityDescription insertNewObjectForEntityForName:[[self class] entityName]
                                                         inManagedObjectContext:context];
        result = @[anOrder];
    }
    
    return [result firstObject];
}

+ (instancetype)objectFromDictionary:(NSDictionary *)dict
{
    NSNumber * identifier = [dict objectForKey:@"id"];
    NSString * address = [dict objectForKey:@"address"];
    NSString * color = [dict objectForKey:@"color"];
    NSNumber * createtime = [dict objectForKey:@"createtime"];
    NSString * cs = [dict objectForKey:@"cs"];
    NSNumber * shopId = [dict objectForKey:@"did"];
    NSString * kno = [dict objectForKey:@"kno"];
    NSString * ktype = [dict objectForKey:@"ktype"];
    NSString * name = [dict objectForKey:@"name"];
    NSString * no = [dict objectForKey:@"no"];
    NSNumber * pid = [dict objectForKey:@"oid"];
    NSString * sf = [dict objectForKey:@"sf"];
    NSString * size = [dict objectForKey:@"size"];
    NSNumber * state = [dict objectForKey:@"state"];
    NSNumber * tb = [dict objectForKey:@"tb"];
    NSString * tel = [dict objectForKey:@"tel"];
    NSString * tno = [dict objectForKey:@"tno"];

    NSNumber * pay = [dict objectForKey:@"pay"];
    NSNumber * count = [dict objectForKey:@"count"];
    NSString * shopName = [dict objectForKey:@"dname"];
    NSString * dq = [dict objectForKey:@"dq"];
    NSString * email = [dict objectForKey:@"email"];
    NSNumber * has = [dict objectForKey:@"has"];
    NSString * note = [dict objectForKey:@"note"];
    NSNumber * type = [dict objectForKey:@"type"];
    NSNumber * uid = [dict objectForKey:@"uid"];

    if (identifier)
    {
        Orders * order = [Orders orderWithId:identifier create:NO];
        
        // Remove records with same name+cs+tel
        if (!order && name && cs && tel)
        {
            order = [Orders orderWithCriteria:(@{
                                                 @"name": name,
                                                 @"cs": cs,
                                                 @"tel": tel
                                                 })
                                       create:YES];
        }
        
        order.identifier = CNil(identifier);
        order.address = CNil(address);
        order.name = CNil(name);
        order.color = CNil(color);
        order.createtime = CNil(createtime);
        order.cs = CNil(cs);
        order.shopId = CNil(shopId);
        order.kno = CNil(kno);
        order.ktype = CNil(ktype);
        order.no = CNil(no);
        order.pid = CNil(pid);
        order.sf = CNil(sf);
        order.size = CNil(size);
        order.state = CNil(state)? CNil(state) : @0;
        order.tb = CNil(tb);
        order.tel = CNil(tel);
        order.tno = CNil(tno);
        
        order.pay = CNil(pay);
        order.count = CNil(count);
        order.shopName = CNil(shopName);
        order.dq = CNil(dq);
        order.email = CNil(email);
        order.has = CNil(has);
        order.note = CNil(note);
        order.type = CNil(type);
        order.uid = CNil(uid);
        
        return order;
    }
    
    return nil;
}

+ (void)removeAllOrders
{
    NSManagedObjectContext * context = [THCoreDataStack defaultStack].threadManagedObjectContext;
    
    
    [context performBlockAndWait:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        request.returnsObjectsAsFaults = YES;
        request.entity = [NSEntityDescription entityForName:[[self class] entityName] // Here we must use [self class]
                                     inManagedObjectContext:context];
        
        NSError * executeFetchError = nil;
        NSArray * result = [context executeFetchRequest:request error:&executeFetchError];
        if (executeFetchError) {
            NSLog(@"[%@, %@] error looking Orders with error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [executeFetchError localizedDescription]);
        }
        else
        {
            for (NSManagedObject * anObject in result)
            {
                [context deleteObject:anObject];
            }
        }
    }];
}

#pragma mark -
+ (NSArray *)getAllOrdersWithCriteria:(NSDictionary *)criteria
{
    __block NSArray * result = nil;
    
    NSManagedObjectContext * context = [THCoreDataStack defaultStack].threadManagedObjectContext;
    
    [context performBlockAndWait:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSMutableArray * precidates = [[NSMutableArray alloc] init];
        
        for (NSString * key in criteria)
        {
            id value = [criteria objectForKey:@"value"];
            
            NSPredicate * precidate = [NSPredicate predicateWithFormat:@"%K = %@", key, value];
            
            [precidates addObject:precidate];
        }
        
        if (precidates.count > 0)
        {
            NSCompoundPredicate * compoundPrecidate = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType
                                                                                  subpredicates:precidates];
            
            request.predicate = compoundPrecidate;
        }
        
        //    request.propertiesToFetch = @[@"id"];
        
        request.entity = [NSEntityDescription entityForName:[[self class] entityName] // Here we must use [self class]
                                     inManagedObjectContext:context];
        
        NSError * executeFetchError = nil;
        result = [context executeFetchRequest:request error:&executeFetchError];
        if (executeFetchError) {
            NSLog(@"[%@, %@] error looking Orders with error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [executeFetchError localizedDescription]);
        }
    }];
    
    return result;
}

- (NSDictionary *)presentAsDictionary
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    NSArray * properties = [[self entity] properties];
    
    for (NSPropertyDescription * propertyDesc in properties)
    {
        NSString * name = [propertyDesc name];
        id value = [self valueForKey:name];
        
        if (value)
        {
            if ([name isEqual:@"identifier"])
            {
                [dict setValue:value forKey:@"id"];
            }
            else if ([name isEqual:@"shopId"])
            {
                [dict setValue:value forKey:@"did"];
            }
            else if ([name isEqual:@"shopName"])
            {
                [dict setValue:value forKey:@"dname"];
            }
            else if ([name isEqual:@"pid"])
            {
                [dict setValue:value forKey:@"oid"];
            }
            else
            {
                [dict setValue:value forKey:name];
            }
        }
    }
    
    return dict;
}

@end
