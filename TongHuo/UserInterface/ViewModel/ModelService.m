//
//  ModelService.m
//  TongHuo
//
//  Created by zeng songgen on 14-8-26.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "ModelService.h"

#import "Orders+Access.h"
#import "Product+Access.h"

@implementation ModelService

+ (NSTimeInterval)timeForQuery
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSDateComponents * components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                                fromDate:[NSDate date]];
    [components setHour:13];
    [components setMinute:0];
    [components setSecond:0];
    
    NSDate * halfDate = [calendar dateFromComponents:components];
    
    return [halfDate timeIntervalSince1970];
}

+ (void)parseAndSaveOrders:(NSDictionary *)response
{
    if (response && [response isKindOfClass:[NSDictionary class]])
    {
        NSArray * ordersInfo = [response objectForKey:@"fh"];
        NSArray * productsInfo = [response objectForKey:@"pro"];
        
        
        NSMutableArray * newOrders = [NSMutableArray array];
        NSMutableDictionary * productMap = [NSMutableDictionary dictionary];
        
        for (NSDictionary * aDict1 in ordersInfo)
        {
            Orders * anOrder = [Orders objectFromDictionary:aDict1];
            
            [newOrders addObject:anOrder];
        }
        
        for (NSDictionary * aDict2 in productsInfo)
        {
            Product * aProduct = [Product objectFromDictionary:aDict2];
            [productMap setObject:aProduct forKey:aProduct.courier];
        }

        // Relationship
        for (Orders * anOrder in newOrders)
        {
            Product * aProduct = [productMap objectForKey:anOrder.tno];
            
            if (!aProduct)
            {
                aProduct = [Product productWithCourier:anOrder.tno create:NO];
            }
            
            if (aProduct)
            {
                [aProduct addOrdersObject:anOrder];
                anOrder.product = aProduct;
            }
        }
    }
    [[THCoreDataStack defaultStack] saveContext];

}

@end
