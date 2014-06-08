//
//  Platforms+Access.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-7.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "Platforms+Access.h"

@implementation Platforms (Access)

+ (instancetype)platformWithId:(NSNumber *)identifier
{
    Platforms * platform = nil;
    
    NSManagedObjectContext * context = [THCoreDataStack defaultStack].threadManagedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:[self entityName]
                                 inManagedObjectContext:context];
    
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@", identifier];
    
    NSError *executeFetchError = nil;
    platform = [[context executeFetchRequest:request error:&executeFetchError] lastObject];
    
    if (executeFetchError) {
        NSLog(@"[%@, %@] error looking up user with id: %i with error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [identifier intValue], [executeFetchError localizedDescription]);
    } else if (!platform) {
        platform = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                             inManagedObjectContext:context];
    }
    
    return platform;
}

+ (instancetype)objectFromDictionary:(NSDictionary *)dict
{
    //data: array of {
    //    "uid":18725,
    //    "logo":null,
    //    "taobao_user_nick":"micoop",
    //    "updatetime":1401272112999,
    //    "re_expires_in":"4257866",
    //    "state":1,
    //    "expires_in":"4257866",
    //    "type":0,
    //    "r1_expires_in":"4257866",
    //    "info":{},
    //    "id"1009,
    //    "taobao_user_id":"1739664677",
    //    "w2_expires_in":"1800",
    //    "w1_expires_in":"4257866",
    //    "r2_expires_in":"259200",
    //    "token_type":null,
    //    "refresh_token":"610191951ee0e994f14aa26a6d9158e985f9f03f139ed051739664677",
    //    "access_token":"6100519d183448f345455079fd01192fb76a930bb9b1fdf1739664677"
    //}
    NSNumber * identifier = [dict objectForKey:@"id"];
    NSString * name = [dict objectForKey:@"name"];
    NSString * refreshToken = [dict objectForKey:@"refresh_token"];
    NSNumber * uid = [dict objectForKey:@"uid"];
    NSString * accessToken = [dict objectForKey:@"access_token"];
    
    if (identifier && accessToken)
    {
        Platforms * platform = [Platforms platformWithId:identifier];
        
        platform.id = identifier;
        platform.name = name;
        platform.refreshToken = refreshToken;
        platform.uid = uid;
        platform.accessToken = accessToken;

        return platform;
    }
    
    return nil;
}

@end
