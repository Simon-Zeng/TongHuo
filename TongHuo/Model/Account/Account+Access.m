//
//  Account+Access.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-7.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "Account+Access.h"

@implementation Account (Access)

+ (instancetype)accountWithId:(NSNumber *)identifier
{
    Account * account = nil;
    
    NSManagedObjectContext * context = [THCoreDataStack defaultStack].threadManagedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:[self entityName]
                                 inManagedObjectContext:context];
    
    request.predicate = [NSPredicate predicateWithFormat:@"identifier = %@", identifier];
    
    NSError *executeFetchError = nil;
    account = [[context executeFetchRequest:request error:&executeFetchError] lastObject];
    
    if (executeFetchError) {
        NSLog(@"[%@, %@] error looking up user with id: %i with error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [identifier intValue], [executeFetchError localizedDescription]);
    } else if (!account) {
        account = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                inManagedObjectContext:context];
    }
    
    return account;
}

+ (instancetype)objectFromDictionary:(NSDictionary *)dict
{
    //    {
    //        address = "";
    //        aid = 0;
    //        createtime = 1398695743;
    //        domain = "";
    //        email = "miukoo@126.com";
    //        id = 18725;
    //        "image_count" = 2;
    //        leval = 0;
    //        levalName = "\U521d\U7ea7\U8ba4\U8bc1";
    //        loginname = miukoo;
    //        name = "";
    //        note = "";
    //        password = e3e9ce20536cbe2fe2063fb135cd8b2b;
    //        "phone_count" = 0;
    //        qq = "";
    //        "recomm_count" = 0;
    //        salt = f110f8;
    //        tel = "";
    //        "template_count" = 0;
    //        type = 0;
    //        typeName = "\U5206\U9500\U5546";
    //        url = "";
    //        ww = "";
    //    }
    NSNumber * identifier = [dict objectForKey:@"id"];
    NSString * email = [dict objectForKey:@"email"];
    NSString * name = [dict objectForKey:@"name"];
    NSString * loginName = [dict objectForKey:@"loginname"];
    NSNumber * type = [dict objectForKey:@"type"];
    NSString * typeName = [dict objectForKey:@"typeName"];
    
    if (identifier && email)
    {
        Account * account = [Account accountWithId:identifier];
        
        account.identifier = identifier;
        account.email = email;
        account.name = name;
        account.loginname = loginName;
        account.type = type;
        account.typeName = typeName;
        
        return account;
    }
    
    return nil;
}

@end
