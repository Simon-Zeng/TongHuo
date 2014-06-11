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
                NSNumber * uniqueKey = [aProduct identifier];
                
                if (uniqueKey && objectID)
                {
                    [savedProduct setObject:objectID forKey:uniqueKey];
                }
            }
        }
        
        NSLog(@"++++++ Loaded savedProduct: %@", savedProduct);
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
    NSNumber * uniqueKey = [aProduct identifier];
    
    if (uniqueKey && objectID)
    {
        [savedProduct setObject:objectID forKey:uniqueKey];
    }
}

+ (NSManagedObjectID *)objectIDForIdentifier:(NSNumber *)identifier
{
    NSAssert(identifier, @"The method has a logic error");
    
    NSMutableDictionary * savedProduct = [self savedProduct];
    
    return [savedProduct objectForKey:identifier];
}

- (void)didSave
{
    [super didSave];
    
    [Product didSaved:self];
}


#pragma mark - Public

+ (instancetype)productWithId:(NSNumber *)identifier
{
    Product * product = nil;
    
    NSManagedObjectID * objectID = [self objectIDForIdentifier:identifier];
    
    NSManagedObjectContext * context = [THCoreDataStack defaultStack].threadManagedObjectContext;
    
    
    if(objectID)
    {
        product = (Product *)[context objectWithID:objectID];
    }
    else
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
    NSNumber * price = [dict objectForKey:@"price"];
    NSNumber * createtime = [dict objectForKey:@"createtime"];

    if (identifier)
    {
        Product * product = [Product productWithId:identifier];
        
        product.identifier = identifier;
        product.no = no;
        product.image = image;
        product.count = count;
        product.state = state;
        product.dates = dates;
        product.color = color;
        product.size = size;
        product.price = price;
        product.createtime = createtime;

        return product;
    }
    
    return nil;
}

@end

