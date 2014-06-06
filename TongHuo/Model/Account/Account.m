//
//  Account.m
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "Account.h"


@implementation Account

@dynamic email;
@dynamic name;
@dynamic id;
@dynamic loginname;
@dynamic type;
@dynamic typeName;

+ (instancetype)account
{
    Account * account = [NSEntityDescription insertNewObjectForEntityForName:[Account entityName]
                                                      inManagedObjectContext:[THCoreDataStack defaultStack].managedObjectContext];
    return account;
}

+ (instancetype)accountFromDictionary:(NSDictionary *)dict
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
        Account * account = [Account account];
        
        account.id = identifier;
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
