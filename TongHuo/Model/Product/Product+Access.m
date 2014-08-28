//
//  Product+Access.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-8.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "Product+Access.h"

@implementation Product (Access)


+ (void)load
{
    NSManagedObjectContext * context = [THCoreDataStack defaultStack].threadManagedObjectContext;
    
    [context performBlock:^{
        // Load all saved record to map to fix unique issue
        NSMutableDictionary * savedProduct = [self savedProduct];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        //    request.propertiesToFetch = @[@"id"];
        
        request.entity = [NSEntityDescription entityForName:[[self class] entityName] // Here we must use [self class]
                                     inManagedObjectContext:context];
        
        NSError * executeFetchError = nil;
        NSArray * productArray = [context executeFetchRequest:request error:&executeFetchError];
        if (executeFetchError) {
            NSLog(@"[%@, %@] error looking Product with error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [executeFetchError localizedDescription]);
        } else if (productArray) {
            for (Product * aProduct in productArray)
            {
                NSManagedObjectID * objectID = [aProduct objectID];
                NSString * uniqueKey = [aProduct courier];
                
                if (uniqueKey && objectID)
                {
                    [savedProduct setObject:objectID forKey:uniqueKey];
                }
            }
        }
        
//        NSLog(@"++++++ Loaded savedProduct: %@", savedProduct);
    }];
}

+ (NSMutableDictionary *)savedProduct
{
    static NSMutableDictionary * savedProduct = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        savedProduct = [[NSMutableDictionary alloc] init];
        
        // Load from db
        
    });
    
    return savedProduct;
}

+ (void)didSaved:(Product *)aProduct
{
    NSMutableDictionary * savedProduct = [self savedProduct];
    
    NSManagedObjectID * objectID = [aProduct objectID];
    NSString * uniqueKey = [aProduct courier];
    
    if (uniqueKey && objectID)
    {
        if (aProduct.isInserted)
        {
            [savedProduct setObject:objectID forKey:uniqueKey];
        }
        else if (aProduct.isDeleted)
        {
            [savedProduct removeObjectForKey:uniqueKey];
        }
    }
}

+ (NSManagedObjectID *)objectIDForCourier:(NSString *)courier
{
    NSAssert(courier, @"The method has a logic error");
    
    NSMutableDictionary * savedProduct = [self savedProduct];
    
    return [savedProduct objectForKey:courier];
}

- (void)didSave
{
    [super didSave];
    
    [Product didSaved:self];
}


#pragma mark - Public

+ (instancetype)productWithCourier:(NSString *)courier create:(BOOL)create
{
    Product * product = nil;
    
    NSManagedObjectID * objectID = [self objectIDForCourier:courier];
    
    NSManagedObjectContext * context = [THCoreDataStack defaultStack].threadManagedObjectContext;
    
    
    if(objectID)
    {
        product = (Product *)[context objectWithID:objectID];
    }
    else if (create)
    {
        product = [NSEntityDescription insertNewObjectForEntityForName:[[self class] entityName]
                                               inManagedObjectContext:context];
    }
    
    return product;
}

+ (instancetype)objectFromDictionary:(NSDictionary *)dict
{
    NSNumber * identifier = [dict objectForKey:@"id"];
    NSString * no = [dict objectForKey:@"no"];
    NSString * image = [dict objectForKey:@"image"];
    NSNumber * count = [dict objectForKey:@"count"];
    NSNumber * state = [dict objectForKey:@"state"];
    NSNumber * dates = [dict objectForKey:@"dates"];
    NSString * color = [dict objectForKey:@"color"];
    NSString * size = [dict objectForKey:@"size"];
    NSNumber * createtime = [dict objectForKey:@"createtime"];


    NSNumber * shopId = [dict objectForKey:@"did"];
    NSNumber * pid = [dict objectForKey:@"pid"];
    NSString * tel = [dict objectForKey:@"tel"];
    
    NSNumber * auth = [dict objectForKey:@"auth"];
    NSString * buyer = [dict objectForKey:@"buyer"];
    NSString * shopName = [dict objectForKey:@"dname"];
    NSNumber * cid = [dict objectForKey:@"cid"];
    NSString * courier = [dict objectForKey:@"courier"];
    NSNumber * ctime = [dict objectForKey:@"ctime"];
    NSNumber * isdf = [dict objectForKey:@"isdf"];
    NSString * numid = [dict objectForKey:@"numid"];
    NSNumber * uid = [dict objectForKey:@"uid"];
    
    NSString * orderid = [dict objectForKey:@"orderid"];
    NSString * pimage = [dict objectForKey:@"pimage"];
    NSNumber * price1 = [dict objectForKey:@"price1"];
    NSNumber * price2 = [dict objectForKey:@"price2"];
    NSString * ptitle = [dict objectForKey:@"ptitle"];

    if (courier)
    {
        Product * product = [Product productWithCourier:courier create:YES];
        
        product.identifier = CNil(identifier);
        product.no = CNil(no);
        product.image = CNil(image);
        product.count = CNil(count);
        product.dates = CNil(dates);
        product.color = CNil(color);
        product.size = CNil(size);
        product.createtime = CNil(createtime);
        
        product.shopId = CNil(shopId);
        product.pid = CNil(pid);
        product.tel = CNil(tel);
        product.auth = CNil(auth);
        product.buyer = CNil(buyer);
        product.shopName = CNil(shopName);
        product.cid = CNil(cid);
        product.courier = CNil(courier);
        product.ctime = CNil(ctime);
        product.isdf = CNil(isdf);
        product.numid = CNil(numid);
        product.uid = CNil(uid);
        product.orderid = CNil(orderid);
        product.pimage = CNil(pimage);
        product.price1 = CNil(price1);
        product.price2 = CNil(price2);
        product.ptitle = CNil(ptitle);
        
        // Handle local state change
        if (product.state.longLongValue == 0) {
            product.state = CNil(state);
        }

        return product;
    }
    
    return nil;
}

+ (void)removeAllProducts
{
    NSManagedObjectContext * context = [THCoreDataStack defaultStack].threadManagedObjectContext;
    
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
    
    [[THCoreDataStack defaultStack] saveContext];
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
            else
            {
                [dict setValue:value forKey:name];
            }
        }
    }
    
    return dict;
}

@end

